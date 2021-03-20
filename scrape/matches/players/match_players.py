from scrape.clubs import clubs
from scrape.matches.players import get_players
from scrape.geo_lookup import state_abrv
import pandas as pd
import os
from progress.bar import IncrementalBar

def load_players(match_data):
    player_match_lst = []
    player_lineup_lst = []
    sides = ['home', 'away']
    lineup = ['bench', 'lineup']
    # * Define dataframes
    # * Dataframe for match_data['match'][<home / away>]['players']
    match_players_df = pd.DataFrame(columns = [
        "player_extID",
        "player_first_name",
        "player_last_name",
        "player_jersey_num",
        "player_weight_lbs",
        "player_birthdate",
        "player_home_city",
        "player_home_state",
        "player_home_country",
        "player_headshot_url",
        "player_url",
        "player_club_id"
    ])
    
    # * Dataframe for match_data[<home / away>Lineup][bench / lineup]['player']
    lineup_players_df = pd.DataFrame(columns=[
        "player_extID",
        "player_display_name",
        "player_position"
    ])
    
    # // DEPRECATED - HTML GET
    # // # HTTP GET request against rootURL
    # // html = get.simple_get(rootURL)
    # // # Parse webpage markup into navgibale object
    # // soup = bs(html, 'html.parser')
    # // # Locate the 4th script tag in the object
    # // # * Should begin with value "window.bootstrap =..."
    # // match = str(soup.find_all("script", type="text/javascript")[3].string)
    # // # Use Slimit to turn script block (json object) into a python dict
    # // tree = Parser().parse(match)
    # // data = next(node.right for node in nodevisitor.visit(tree)
    # //            if (isinstance(node, ast.Assign) and
    # //                node.left.to_ecma() == 'window.bootstrap'))
    # // match_data = json.loads(data.to_ecma())
    
    # * PLAYERS* 
    # Iterate over home / away
    for side in sides:
        # Iterate through players in match.side.players dict
        for id, player in match_data['match'][side]['players'].items():
            # Grab relevant player data from dict, assign to vars as needed
            player_extID = player['optaId']
            player_first_name = player['name']['first']
            player_last_name = player['name']['last']
            player_jersey_num = player['jerseyNumber']
            player_weight_lbs = player['weight']
            player_birthdate = player['birth']['date']
            player_home_city = player['birth']['city']
            player_home_state = player['birth']['state']
            if player_home_state is None:
                player_home_state = None
            elif state_abrv.check_valid_abbreviation(player_home_state) == False:
                if state_abrv.check_valid_state(player_home_state) == True:
                    player_home_state = state_abrv.get_abrv_from_state(player_home_state)
                else:
                    player_home_state = None
            player_home_country = player['birth']['countryAbbr']
            player_headshot_url = str(player['headshot']).replace("{{width}}x{{height}}","1024x1024")
            player_url = str(player['slug']).replace("http://","https://").lower().replace("https://www.mlssoccer","https://mlssoccer")
            player_club_id = clubs.lookup_club(match_data['match'][side]['optaId'])
            # Populate dict for player
            match_players_dict = {
                "player_extID": player_extID,
                "player_first_name": player_first_name,
                "player_last_name": player_last_name,
                "player_jersey_num": player_jersey_num,
                "player_weight_lbs": player_weight_lbs,
                "player_birthdate": player_birthdate,
                "player_home_city": player_home_city,
                "player_home_state": player_home_state,
                "player_home_country": player_home_country,
                "player_headshot_url": player_headshot_url,
                "player_url": player_url,
                "player_club_id": player_club_id
            }
            # add dict to players list
            player_match_lst.append(match_players_dict)
    # convert list of dicts to dataframe
    match_players_df = match_players_df.append(player_match_lst, ignore_index=True).set_index('player_extID').sort_values(by="player_extID")
    
    bar = IncrementalBar('Importing Players', max=len(match_players_df), suffix='%(percent)d%%')
    
    # for each of home and away
    for side in sides:
        # for each of bench / lineup
        for section in lineup:
            # iterate over players
            for player in match_data[side + 'Lineup'][section]:
                # Grab relevant data in match_data[<homeLineup / awayLineup>][<bench / lineup>]
                # and assign to vars
                player_extID = player['player']['optaId']
                player_display_name = player['player']['displayName']
                player_position = player['position']
                # populate dict for player
                lineup_player_dict = {
                    "player_extID": player_extID,
                    "player_display_name": player_display_name,
                    "player_position": player_position
                }
                # append dict to list
                player_lineup_lst.append(lineup_player_dict)
    # convert list of dicts to dataframe
    lineup_players_df = lineup_players_df.append(player_lineup_lst, ignore_index=True).set_index('player_extID').sort_values(by="player_extID")
    
    # join dataframes
    players_df = match_players_df.join(
        other = lineup_players_df,
        how='inner').sort_values(by="player_extID").reset_index(drop=False)
    # Upsert players into database
    for index, row in players_df.iterrows():
        bar.next()
        get_players.upsert_match_player(
            player_extID = row['player_extID'],
            player_first_name = row['player_first_name'],
            player_last_name = row['player_last_name'],
            player_jersey_num = row['player_jersey_num'],
            player_weight_lbs = row['player_weight_lbs'],
            player_birthdate = row['player_birthdate'],
            player_home_city = row['player_home_city'],
            player_home_state = row['player_home_state'],
            player_home_country = row['player_home_country'],
            player_url = row['player_url'],
            player_club_id = row['player_club_id'],
            player_display_name = row['player_display_name'],
            player_headshot_url = row['player_headshot_url'],
            player_position = row['player_position'],
        )
    bar.finish()