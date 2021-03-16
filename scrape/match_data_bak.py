from bs4 import BeautifulSoup as bs
import pandas as pd
from slimit import ast
from slimit.parser import Parser
from slimit.visitors import nodevisitor
import json
import datetime
import dbconnect
from http_get import simple_get as get
from competitions import competitions as comp
from seasons import seasons as sea
from clubs import clubs
from match_list import matches
import os


# * QUERIES
def upsert_match(match_extID, away_club_id, home_club_id,
                 match_datetime, competition_id, season_id, mlssoccer_url):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            INSERT INTO `mls`.`matches` (
                `match_extID`,
                `away_club_id`,
                `home_club_id`,
                `match_datetime`,
                `competition_id`,
                `season_id`,
                `mlssoccer_url`
            ) VALUES (
                %(match_extID)s,
                %(away_club_id)s,
                %(home_club_id)s,
                %(match_datetime)s,
                %(competition_id)s,
                %(season_id)s,
                %(mlssoccer_url)s
            ) ON DUPLICATE KEY UPDATE
            away_club_id = %(away_club_id)s,
            home_club_id = %(home_club_id)s,
            match_datetime = %(match_datetime)s,
            competition_id = %(competition_id)s,
            season_id = %(season_id)s,
            mlssoccer_url = %(mlssoccer_url)s
            """
    cur.execute(query, {
    "match_extID": match_extID,
    "away_club_id": away_club_id,
    "home_club_id": home_club_id,
    "match_datetime": match_datetime,
    "competition_id": competition_id,
    "season_id": season_id,
    "mlssoccer_url": mlssoccer_url
    })
    conn.commit()
    conn.close()

# * Create pandas dataframe to store matches before DB insert
matches_df = pd.DataFrame(columns= [
    "match_extID",
    "away_club_id",
    "home_club_id",
    "match_datetime",
    "competition_id",
    "season_id",
    "mlssoccer_url"
])
lst = []
for match in matches:

    rootURL = match
    # * Perform HTTP Get request on rootURL
    html = get.simple_get(rootURL)
    
    # * Use BeautifulSoup4 to parse the content of the site into an object,
    # * And search that object for the appropriate javascript block
    soup = bs(html, 'html.parser')
    match = str(soup.find_all("script", type="text/javascript")[3].string)
    
    # * Use slimit to parse the javascript block into a tree,
    # * traverse that tree, and store the result as JSON
    tree = Parser().parse(match)
    data = next(node.right for node in nodevisitor.visit(tree)
               if (isinstance(node, ast.Assign) and
                   node.left.to_ecma() == 'window.bootstrap'))
    match_data = json.loads(data.to_ecma())

    # * Get data for `mls`.`matches`
    match_url = rootURL
    #match_extID = match_data['match']['optaId']
    #match_away_club_id = match_data['match']['away']['optaId']
    #match_home_club_id = match_data['match']['home']['optaId']
    #match_datetime = datetime.datetime.fromtimestamp(
    #    int(match_data['match']['matchTimeStamp']) / 1000
    #).strftime('%Y-%m-%d %H:%M:%S')
    #match_competition_id = match_data['match']['competition']['optaId']
    
    # * Get competition ID for `mls`.`matches` table
    competition_abrv = match_data['match']['competition']['abbreviation']
    competition_desc = match_data['match']['competition']['name']
    competition_extID = match_data['match']['competition']['optaId']
    competition_id = comp.get_competition_id(competition_extID = competition_extID, competition_abrv = competition_abrv, competition_desc = competition_desc)
    
    # * Get Season id for matches table as above for competitions
    season_desc = match_data['match']['season']['name']
    season_extID = match_data['match']['season']['optaId']
    season_id = sea.get_season_id(season_extID = season_extID, season_desc = season_desc)
    
    # * Get id of home club for matches table as above for seasons
    club_home_name = match_data['match']['home']['name']['full']
    club_home_abrv = match_data['match']['home']['name']['abbreviation']
    club_home_extID = match_data['match']['home']['optaId']
    if len(match_data['match']['home']['colors']) >0:
        club_home_bg_color = match_data['match']['home']['colors'][0]
        club_home_accent_color_1 = None
        club_home_accent_color_2 = None
        club_home_txt_color = None
    elif len(match_data['match']['home']['colors']) >1:
        club_home_txt_color = match_data['match']['home']['colors'][-1]
        club_home_bg_color = match_data['match']['home']['colors'][0]
        club_home_accent_color_1 = None
        club_home_accent_color_2 = None
    elif len(match_data['match']['home']['colors']) >2:
        club_home_accent_color_1 = match_data['match']['home']['colors'][1]
        club_home_txt_color = match_data['match']['home']['colors'][-1]
        club_home_bg_color = match_data['match']['home']['colors'][0]
        club_home_accent_color_2 = None
    elif len(match_data['match']['home']['colors']) == 4:
        club_home_accent_color_2 = match_data['match']['home']['colors'][2]
        club_home_accent_color_1 = match_data['match']['home']['colors'][1]
        club_home_txt_color = match_data['match']['home']['colors'][-1]
        club_home_bg_color = match_data['match']['home']['colors'][0]
    else:
        club_home_accent_color_2 = None
        club_home_accent_color_1 = None
        club_home_txt_color = None
        club_home_bg_color = None
    club_home_logo_url = str(match_data['match']['home']['logo']).replace("{{width}}x{{height}}","1024x1024")
    
    home_club_id = clubs.get_club_id(
        club_name = club_home_name,
        club_abrv = club_home_abrv,
        club_extID = club_home_extID,
        bg_color = club_home_bg_color,
        accent_color_1 = club_home_accent_color_1,
        accent_color_2 = club_home_accent_color_2,
        txt_color = club_home_txt_color,
        logo_url = club_home_logo_url
    )
    
    # * Get id of away club for matches table as above for seasons
    club_away_name = match_data['match']['away']['name']['full']
    club_away_abrv = match_data['match']['away']['name']['abbreviation']
    club_away_extID = match_data['match']['away']['optaId']
    if len(match_data['match']['away']['colors']) >0:
        club_away_bg_color = match_data['match']['away']['colors'][0]
        club_away_accent_color_1 = None
        club_away_accent_color_2 = None
        club_away_txt_color = None
    elif len(match_data['match']['away']['colors']) >1:
        club_away_txt_color = match_data['match']['away']['colors'][-1]
        club_away_bg_color = match_data['match']['away']['colors'][0]
        club_away_accent_color_1 = None
        club_away_accent_color_2 = None
    elif len(match_data['match']['away']['colors']) >2:
        club_away_accent_color_1 = match_data['match']['away']['colors'][1]
        club_away_txt_color = match_data['match']['away']['colors'][-1]
        club_away_bg_color = match_data['match']['away']['colors'][0]
        club_away_accent_color_2 = None
    elif len(match_data['match']['away']['colors']) == 4:
        club_away_accent_color_2 = match_data['match']['away']['colors'][2]
        club_away_accent_color_1 = match_data['match']['away']['colors'][1]
        club_away_txt_color = match_data['match']['away']['colors'][-1]
        club_away_bg_color = match_data['match']['away']['colors'][0]
    else:
        club_away_accent_color_2 = None
        club_away_accent_color_1 = None
        club_away_txt_color = None
        club_away_bg_color = None
    club_away_logo_url = str(match_data['match']['away']['logo']).replace("{{width}}x{{height}}","1024x1024")
    
    away_club_id = clubs.get_club_id(
        club_name = club_away_name,
        club_abrv = club_away_abrv,
        club_extID = club_away_extID,
        bg_color = club_away_bg_color,
        accent_color_1 = club_away_accent_color_1,
        accent_color_2 = club_away_accent_color_2,
        txt_color = club_away_txt_color,
        logo_url = club_away_logo_url
    )
    
    match_dict = {
        "match_extID": match_data['match']['optaId'],
        "away_club_id": away_club_id,
        "home_club_id": home_club_id,
        "match_datetime": datetime.datetime.fromtimestamp(
            int(match_data['match']['matchTimeStamp']) / 1000
        ).strftime('%Y-%m-%d %H:%M:%S'),
        "competition_id": competition_id,
        "season_id": season_id,
        "mlssoccer_url": rootURL
    }
    lst.append(match_dict)

matches_df = matches_df.append(lst, ignore_index=True).sort_values(by="match_datetime").reset_index(drop=True)

i = 1

for index, row in matches_df.iterrows():
    pct_complete = "{:.2%}".format(i / len(matches_df.index))
    print("Inserting records... ", pct_complete, " complete...")
    print(row)
    upsert_match(
        match_extID=row['match_extID'],
        away_club_id=row['away_club_id'],
        home_club_id=row['home_club_id'],
        match_datetime=row['match_datetime'],
        competition_id=row['competition_id'],
        season_id=row['season_id'],
        mlssoccer_url=row['mlssoccer_url']
    )
    clear = lambda: os.system('cls')
    clear()
    i += 1