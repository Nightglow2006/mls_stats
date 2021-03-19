from scrape.connect import dbconnect
import math

# Select player by external ID (Opta ID)
def lookup_player_extID(player_extID):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            SELECT `id`
              FROM `mls`.`players`
             WHERE `player_extID` = %(player_extID)s;
            """
    cur.execute(query, {"player_extID": player_extID})
    player_id = cur.fetchone()
    conn.close
    if player_id is None:
        return player_id
    else:
        return player_id[0]

# Select player from mlssoccer.com player url
def lookup_player_url(player_url):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            SELECT `id`
              FROM `mls`.`players`
             WHERE `player_url` = %(player_url)s;
            """
    cur.execute(query, {"player_url": player_url})
    player_id = cur.fetchone()
    conn.close()
    if player_id is None:
        return player_id
    else:
        return player_id[0]

# Lookup player from mls.players table.
# Tries optaID first, then mlssoccer.com player url
def lookup_player(player_url, player_extID):
    player_id = lookup_player_extID(player_extID)
    if player_id is None:
        player_id = lookup_player_url(player_url)
        if player_id is None:
            return None
        else:
            return player_id
    else:
        return player_id

def upsert_match_player(
    player_extID,
    player_first_name,
    player_last_name,
    player_jersey_num,
    player_weight_lbs,
    player_birthdate,
    player_home_city,
    player_home_state,
    player_home_country,
    player_headshot_url,
    player_url,
    player_club_id,
    player_display_name,
    player_position):
    if math.isnan(player_jersey_num):
        player_jersey_num = None
    if math.isnan(player_weight_lbs):
        player_weight_lbs = None
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            INSERT INTO `mls`.`players` (
                `display_name`,
                `real_name`,
                `first_name`,
                `last_name`,
                `player_url`,
                `jersey_num`,
                `weight_lbs`,
                `birthdate`,
                `player_extID`,
                `home_city`,
                `home_state`,
                `home_country`,
                `position`,
                `headshot_url`,
                `club_id`
            ) VALUES (
                %(player_display_name)s,
                CONCAT_WS(' ',%(player_first_name)s, %(player_last_name)s),
                %(player_first_name)s,
                %(player_last_name)s,
                %(player_url)s,
                %(player_jersey_num)s,
                %(player_weight_lbs)s,
                %(player_birthdate)s,
                %(player_extID)s,
                %(player_home_city)s,
                %(player_home_state)s,
                %(player_home_country)s,
                %(player_position)s,
                %(player_headshot_url)s,
                %(player_club_id)s
            ) ON DUPLICATE KEY UPDATE
            `display_name` = %(player_display_name)s,
            `first_name` = %(player_first_name)s,
            `last_name` = %(player_last_name)s,
            `jersey_num` = %(player_jersey_num)s,
            `weight_lbs` = %(player_weight_lbs)s,
            `birthdate` = %(player_birthdate)s,
            `player_extID` = %(player_extID)s,
            `player_url` = %(player_url)s,
            `headshot_url` = %(player_headshot_url)s,
            `home_city` = %(player_home_city)s,
            `home_state` = %(player_home_state)s,
            `home_country` = %(player_home_country)s,
            `club_id` = %(player_club_id)s,
            `position` = %(player_position)s
            """
    cur.execute(
        query,
        {
            "player_display_name": player_display_name,
            "player_first_name": player_first_name,
            "player_last_name": player_last_name,
            "player_url": player_url,
            "player_jersey_num": player_jersey_num,
            "player_weight_lbs": player_weight_lbs,
            "player_birthdate": player_birthdate,
            "player_extID": player_extID,
            "player_home_city": player_home_city,
            "player_home_state": player_home_state,
            "player_home_country": player_home_country,
            "player_position": player_position,
            "player_headshot_url": player_headshot_url,
            "player_club_id": player_club_id
        }
    )
    conn.commit()
    conn.close()

