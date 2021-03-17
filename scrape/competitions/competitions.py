from scrape import dbconnect


def upsert_competition(competition_extID, competition_desc, competition_abrv):
    conn = dbconnect.connect()
    cur = conn.cursor()
    if int(competition_extID) == 1097:
        competition_desc = "MLS is Back Tournament Final Pres. by Wells Fargo"
        competition_abrv = "MLS is Back"
    if str(competition_desc) == "MLS Cup":
        competition_extID = 99999
        competition_desc = "MLS Playoffs"
        competition_abrv = "MLS Playoffs"
    query = """
            INSERT INTO `mls`.`competitions` (
                competition_extID,
                competition_desc,
                competition_abrv
            ) VALUES (
                %(competition_extID)s,
                %(competition_desc)s,
                %(competition_abrv)s
            ) ON DUPLICATE KEY UPDATE
            competition_extID = %(competition_extID)s,
            competition_desc = %(competition_desc)s,
            competition_abrv = %(competition_abrv)s;
            """
    cur.execute(query, {
        "competition_extID": competition_extID,
        "competition_desc": competition_desc,
        "competition_abrv": competition_abrv
    })
    conn.commit()
    conn.close()

def lookup_competition(competition_extID):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            SELECT `id`
              FROM `mls`.`competitions`
             WHERE `competition_extID` = %(competition_extID)s;
            """
    cur.execute(query, {"competition_extID": competition_extID})
    competition_id = cur.fetchone()
    conn.close()
    if competition_id is None:
        return competition_id
    else:
        return competition_id[0]
    

def get_competition_id(competition_extID, competition_desc, competition_abrv):
    if competition_desc == 'MLS Playoffs':
        competition_extID = 99999
    # FOR TESTING ONLY - LEAVE BELOW LINE COMMENTED OUT
    # competition_extID = 42
    competition_id = lookup_competition(competition_extID)
    if competition_id is None:
        upsert_competition(
            competition_extID = competition_extID,
            competition_desc = competition_desc,
            competition_abrv = competition_abrv
        )
        competition_id = lookup_competition(competition_extID)
        return competition_id
    else:
        return competition_id
