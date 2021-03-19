from scrape.connect import dbconnect

def upsert_club(club_name, club_abrv, 
                club_extID, bg_color,
                accent_color_1, accent_color_2, txt_color, logo_url):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            INSERT INTO `mls`.`clubs` (
                `club_name`,
                `club_abrv`,
                `club_extID`,
                `bg_color`,
                `accent_color_1`,
                `accent_color_2`,
                `txt_color`,
                `logo_url`
            ) VALUES (
                %(club_name)s,
                %(club_abrv)s,
                %(club_extID)s,
                %(bg_color)s,
                %(accent_color_1)s,
                %(accent_color_2)s,
                %(txt_color)s,
                %(logo_url)s,
            ) ON DUPLICATE KEY UPDATE
            `club_name` = %(club_name)s,
            `club_abrv` = %(club_abrv)s,
            `club_extID` = %(club_extID)s,
            `bg_color` = %(bg_color)s,
            `accent_color_1` = %(accent_color_1)s,
            `accent_color_2` = %(accent_color_2)s,
            `txt_color` = %(txt_color)s,
            `logo_url` = %(logo_url)s;
            """
    cur.execute(query, {
        "club_name": club_name,
        "club_abrv": club_abrv,
        "club_extID": club_extID,
        "bg_color": bg_color,
        "accent_color_1": accent_color_1,
        "accent_color_2": accent_color_2,
        "txt_color": txt_color,
        "logo_url": logo_url
    })
    conn.commit()
    conn.close()

def lookup_club(club_extID):
    conn = dbconnect.connect()
    cur = conn.cursor()
    query = """
            SELECT `id`
              FROM `mls`.`clubs`
             WHERE `club_extID` = %(club_extID)s
            """
    cur.execute(query, {"club_extID": club_extID})
    club_id = cur.fetchone()
    conn.close()
    if club_id is None:
        return club_id
    else:
        return club_id[0]

def get_club_id(club_name, club_abrv, club_extID, bg_color,
                accent_color_1, accent_color_2, txt_color, logo_url):
    club_id = lookup_club(club_extID)
    if club_id is None:
        upsert_club(
            club_name = club_name,
            club_abrv = club_abrv,
            club_extID = club_extID,
            bg_color = bg_color,
            accent_color_1 = accent_color_1,
            accent_color_2 = accent_color_2,
            txt_color = txt_color,
            logo_url = logo_url
        )
        club_id = lookup_club(club_extID)
        return club_id
    else:
        return club_id