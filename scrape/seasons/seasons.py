from scrape import dbconnect

def upsert_season(season_extID, season_desc):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            INSERT INTO `mls`.`seasons` (
                season_extID,
                season_desc
            ) VALUES (
                %(season_extID)s,
                %(season_desc)s
            ) ON DUPLICATE KEY UPDATE
            season_desc = %(season_desc)s;
            """
    cur.execute(query, {
        "season_extID": season_extID,
        "season_desc": season_desc
    })
    conn.commit()
    conn.close()

def lookup_season(season_extID):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            SELECT `id`
              FROM `mls`.`seasons`
             WHERE `season_extID` = %(season_extID)s
            """
    cur.execute(query, {"season_extID": season_extID})
    season_id = cur.fetchone()
    conn.close()
    if season_id is None:
        return season_id
    else:
        return season_id[0]

def get_season_id(season_extID, season_desc):
    season_id = lookup_season(season_extID)
    if season_id is None:
        upsert_season(
            season_extID = season_extID,
            season_desc = season_desc
        )
        season_id = lookup_season(season_extID)
        return season_id
    else:
        return season_id