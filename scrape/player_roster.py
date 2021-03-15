from requests.api import get
import dbconnect
import requests
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup as bs
import pandas as pd
import re
from decimal import *
import os
import time
import math

conn = dbconnect.connect()
# * QUERIES
def query_club_id_from_name(club_name):
    if club_name == 'Atlanta United FC':
        club_name = (str('Atlanta United'))
    else:
        club_name = str(club_name)
    cur = conn.cursor()
    query = """
            SELECT `id`
              FROM `mls`.`clubs`
             WHERE `club_name` = %(club_name)s;
            """
    cur.execute(query, {"club_name": club_name})
    club_id = cur.fetchone()
    return club_id

def insert_player(
    club_id,
    display_name,
    jersey_num,
    player_url,
    position,
    height_inches,
    weight_lbs,
    birthdate,
    real_name,
    headshot_url
):
    cur = conn.cursor()
    query = """
            INSERT INTO `mls`.`players` (
                club_id,
                display_name,
                jersey_num,
                player_url,
                position,
                height_inches,
                weight_lbs,
                birthdate,
                real_name,
                headshot_url,
                is_active
            ) VALUES (
                %(club_id)s,
                %(display_name)s,
                %(jersey_num)s,
                %(player_url)s,
                %(position)s,
                %(height_inches)s,
                %(weight_lbs)s,
                %(birthdate)s,
                %(real_name)s,
                %(headshot_url)s,
                1
            ) ON DUPLICATE KEY UPDATE
            club_id = %(club_id)s,
            display_name = %(display_name)s,
            jersey_num = %(jersey_num)s,
            position = %(position)s,
            height_inches = %(height_inches)s,
            weight_lbs = %(weight_lbs)s,
            birthdate = %(birthdate)s,
            real_name = %(real_name)s,
            headshot_url = %(headshot_url)s,
            is_active = 1
            """
    cur.execute(query, {
        "club_id": club_id,
        "display_name": display_name,
        "jersey_num": jersey_num,
        "player_url": player_url,
        "position": position,
        "height_inches": height_inches,
        "weight_lbs": weight_lbs,
        "birthdate": birthdate,
        "real_name": real_name,
        "headshot_url": headshot_url
    })
    conn.commit()

# * FUNCTIONS
# Perform HTTP GET operation on URL
def http_get(url):
    # Attempts to get the content at 'url' by making an HTTP GET request.
    # If the content of the response is HTML or XML, return the text
    # content. Otherwise, return None
    try:
        with closing(requests.get(url, stream=True)) as resp:
            if is_good_response(resp):
                return resp.content
            else:
                return None
    except RequestException as e:
        log_error('Error during requests to {0} : {1}'.format(url, str(e)))
        return None

# Check if HTTP GET response is valid
def is_good_response(resp):
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200
            and content_type is not None
            and content_type.find('html') > -1)

# Log errors in HTTP GET requests
def log_error(e):
    print(e)

# Regex - feet and inches, date
r_feet_in = re.compile(r"([0-9]+)' ([0-9]*\.?[0-9]+)\"")
r_date = re.compile(r"(0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])[- \/.]((19|20)\d\d)")

# Format a date - iso
def format_date (d):
    m = r_date.search(d)
    if m == None:
        return Decimal('NaN')
    else:
        return m.group(3)+"-"+m.group(1)+"-"+m.group(2)

# get height in inches
def get_inches (el):
    m = r_feet_in.match(el)
    if m == None:
        return Decimal('NaN')
    else:
        return (int(m.group(1))*12 + int(m.group(2)))

# Get roster
def get_roster():
    df = pd.DataFrame(columns = ["club_id", "club_name", "club_url"])
    teams_html = http_get(rootURL + url_stub + '/' + str(year))
    html = bs(teams_html, "html.parser")
    rows = html.find_all("div",{"class":"field-items"})[0].find("ul").find_all("li")
    for row in rows:
        club_name = str(row.find("a").contents[0])
        club_dict = {
            "club_name": club_name,
            "club_id": query_club_id_from_name(club_name)[0],
            "club_url": str(row.find("a")["href"])
        }
        df = df.append(club_dict, ignore_index=True)
    time.sleep(10)
    return df.sort_values(by="club_id").reset_index(drop=True)


def get_players(roster, club_id):
    df = pd.DataFrame(columns=["club_id", "display_name", "jersey_num", "roster_status", "player_url"])
    roster_html = bs(http_get(str(roster)), "html.parser")
    roster_table = roster_html.find("table",{"class":"activethirty"}).find("tbody").find_all("tr")
    for player in roster_table:
        #print(player)
        if (player.find("td",{"class":"playername"})) is None:
            continue
        elif str(player.find("td",{"class","playername"}).find(text=True)).strip() == '':
            continue
        else:
            player_display_name = str(player.find("td",{"class":"playername"}).find(text=True))
            player_url = str(rootURL + str(player.find("td",{"class","playername"}).find("a")["href"]).replace(' ','-'))
            if player_url == 'https://mlssoccer.com/players/Luiz-Nascimento':
                player_url = 'https://mlssoccer.com/players/Luiz-Fernando'
            elif player_url == 'https://mlssoccer.com/players/Joe-Gyau':
                player_url = 'https://mlssoccer.com/players/joseph-claude-gyau'
            elif player_url == 'https://mlssoccer.com/players/Hassan-Fouapon':
                player_url = 'https://mlssoccer.com/players/hassan-ndam'
            elif player_url == 'https://mlssoccer.com/players/Luiz-Diaz':
                player_url = 'https://mlssoccer.com/players/Luis-Diaz'
            elif player_url == 'https://mlssoccer.com/players/Cam-Duke':
                player_url = 'https://mlssoccer.com/players/Cameron-Duke'
            elif player_url == 'https://mlssoccer.com/players/Ally-Ng':
                player_url = 'https://mlssoccer.com/players/ally-hamis-nganzi'
            elif player_url == 'https://mlssoccer.com/players/Dayne-St.-Clair':
                player_url = 'https://mlssoccer.com/players/dayne-st-clair'
            elif player_url == 'https://mlssoccer.com/players/Wilfried-Moimbe-Tahrat':
                player_url = 'https://mlssoccer.com/players/wilfried-moimbe'
            elif player_url == 'https://mlssoccer.com/players/Issac-Angking':
                player_url = 'https://mlssoccer.com/players/isaac-angking'
            elif player_url == 'https://mlssoccer.com/players/Antonio-Delamea-Mlinar':
                player_url = 'https://mlssoccer.com/players/antonio-mlinar-delamea'
            elif player_url == 'https://mlssoccer.com/players/Joshua-Sims':
                player_url = 'https://mlssoccer.com/players/josh-sims'
            elif player_url == 'https://mlssoccer.com/players/Victor-"PC"-Giro':
                player_url = 'https://mlssoccer.com/players/pc'
            elif player_url == 'https://mlssoccer.com/players/Michael-Chirinos':
                player_url = 'https://mlssoccer.com/players/michaell-chirinos'
            if str(player.find("td", {"class","jerseyNum"}).find(text=True)).replace('\xa0','') == '':
                player_jersey_num = None
            else:
                player_jersey_num = str(player.find("td",{"class","jerseyNum"}).find(text=True))
            if player_jersey_num == 'None' or player_jersey_num == None:
                player_jersey_num = None
            else:
                player_jersey_num = int(player_jersey_num)
            player_roster_status = []
            for status in player.find("td",{"class":"roster-status"}).find_all("span",{"class":"narrow"}):
                player_roster_status.append(status.find(text=True))
        player_dict = {
            "club_id": club_id,
            "display_name": player_display_name,
            "jersey_num": player_jersey_num,
            "roster_status": player_roster_status,
            "player_url": player_url   
        }
        df = df.append(player_dict, ignore_index=True)
    time.sleep(10)
    return df.sort_values(by="club_id").reset_index(drop=True)

def get_player_data(url):
    html = bs(http_get(str(url)), "html.parser")
    player_data = html.find("div",{"class","player_container"})
    headshot_url = str(player_data.find("img", {"class","headshot_image"})['src'])
    display_name = str(player_data.find("div",{"class","title"}).find(text=True))
    position = str(player_data.find("span",{"class","position"}).find(text=True))
    player_stats = player_data.find_all("span",{"class","stat"})
    player_height = None
    player_weight = None
    for stat in player_stats:
        if (stat.find(text=True).find("\'") != -1):
            player_height = int(get_inches(str(stat.find(text=True))))
        else:
            player_weight = int((stat.find(text=True)))
    print(player_weight)
    player_birthdate = format_date(str(player_data.find_all("div",{"class":"age"})[0]).replace("\n",""))
    player_name_html = str(player_data.find("div",{"class":"name"})).replace("\n","")
    soup = bs(player_name_html, 'html.parser')
    for content in soup.find_all("div",{"class":"name"}):
        content.span.decompose()
        player_real_name = str(content.text)
    class player_info:
        def __init__(self):
            self.display_name = display_name
            self.position = position
            self.player_height = player_height
            self.player_weight = player_weight
            self.player_birthdate = player_birthdate
            self.player_real_name = player_real_name
            self.player_headshot_url = headshot_url
    time.sleep(10)
    return player_info()

# * CONFIG
rootURL = 'https://mlssoccer.com'
url_stub = '/rosters/'
year = 2019

# * GET TEAMS FROM ROSTER LIST
clubs = get_roster()

# * GET PLAYERS FROM CLUB ROSTER PAGE
club_count = len(clubs.index)
i = 1
players_df = pd.DataFrame(columns=["club_id", "display_name", "jersey_num", "roster_status", "player_url"])
for row in clubs.itertuples(index=True, name='Pandas'):
    print("Getting players from club ", i, " of ", club_count, ": ", getattr(row, "club_name"))
    club_id = getattr(row, "club_id")
    club_name = getattr(row, "club_name")
    club_url = getattr(row, "club_url")
    players_df = pd.concat([players_df, get_players(rootURL + club_url, club_id)])
    i += 1
    os.system('clear')

# * SORT DATAFRAME BY CLUB ID
players_df = players_df.sort_values(by="club_id").reset_index(drop=True)

# * GET PLAYER DETAILED INFO FROM PLAYER PAGE
players_len = len(players_df.index)
i = 1
for row in players_df.itertuples(index=True, name='Pandas'):
#    print(type(row), row)
    pct_complete = "{:.2%}".format(i / players_len)
    print("Getting player data... ", pct_complete, " complete...")
    print("Current player: ", getattr(row, "display_name"))
    idx = getattr(row, "Index")
    player_url = getattr(row, "player_url")
    print(player_url)
    p = get_player_data(player_url)
    players_df.loc[idx, 'display_name'] = p.display_name
    players_df.loc[idx, 'position'] = p.position
    players_df.loc[idx, 'height_inches'] = p.player_height
    players_df.loc[idx, 'weight_lbs'] = p.player_weight
    players_df.loc[idx, 'birthdate'] = p.player_birthdate,
    players_df.loc[idx, 'real_name'] = p.player_real_name
    players_df.loc[idx, 'headshot_url'] = p.player_headshot_url
    i += 1
    os.system('clear')

# * INSERT PLAYERS INTO `mls`.`players`
# * DUPLICATE RECORDS (by `player_url`) ARE UPDATED

players_df.to_csv('players_df.csv', encoding='utf-8')
players_df = players_df.where(pd.notnull(players_df), None)
i = 1
for index, row in players_df.iterrows():
    pct_complete = "{:.2%}".format(i / players_len)
    print("Inserting records... ", pct_complete, " complete...")
    print(row)
    insert_player(
        club_id=row['club_id'],
        display_name=row['display_name'],
        jersey_num=row['jersey_num'],
        player_url=row['player_url'],
        position=row['position'],
        height_inches=row['height_inches'],
        weight_lbs=row['weight_lbs'],
        birthdate=row['birthdate'],
        real_name=row['real_name'],
        headshot_url=row['headshot_url']
    )
    i += 1
    os.system('clear')
conn.close()