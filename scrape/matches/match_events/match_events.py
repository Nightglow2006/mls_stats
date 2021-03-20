from scrape.matches import match_data
from scrape.matches import upload_matches
from scrape.clubs.clubs import lookup_club
import pandas as pd

url = 'https://matchcenter.mlssoccer.com/matchcenter/2020-03-01-portland-timbers-vs-minnesota-united-fc/feed'

def upload_match_events(url):
    detailed_event_lst = []
    detailed_events_df = pd.DataFrame(columns= [
        "match_id",
        "match_event_extID",
        "match_event_type_id",
        "event_period_id",
        "club_id",
        "event_x_coordiate",
        "event_y_coordinate"
    ])

    timeline_events_df = pd.DataFrame(columns=[
        "match_event_extID",
        "player_id",
        "minute",
        "second"
    ])

    event_qualifiers = pd.DataFrame(columns=[
        "match_event_extID",
        "qualifier_id",
        "qualifier_value"
    ])

    # get match data in json
    data = match_data.get_match_data(url)
    # query db for internal match id
    match_id = upload_matches.get_match(data['match']['optaId'])
    # if no match, upsert match to db, then get id
    if match_id is None:
        upload_matches.upload_match(
            match_data = data,
            match_url = url
        )
        match_id = upload_matches.get_match(data['match']['optaId'])
    
    for event in data['detailedEvents']:
        match_event_dict = {
            "match_id": match_id,
            "match_event_extID": event['id'],
            "match_event_type_id": event['type_id'],
            "event_period_id": event['period_id'],
            "club_id": lookup_club(event['team_id']),
            "event_x_coordiate": event['x'],
            "event_y_coordinate": event['y']
        }
        detailed_event_lst.append(match_event_dict)
    detailed_events_df = detailed_events_df.append(detailed_event_lst, ignore_index=True).sort_values(by="match_event_extID")
    print(detailed_events_df)
upload_match_events(url)

