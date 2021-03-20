from scrape.matches import upload_matches
from scrape.matches import match_list
from scrape.matches import match_data
from scrape.matches.players import match_players
import os
match_urls = match_list.matches

i = 1
max = len(match_urls)
#    pct_complete = "{:.2%}".format(i / len(matches_df.index))
#    print("Inserting records... ", pct_complete, " complete...")
#    print(row)

for url in match_urls:
    pct_complete = "{:.2%}".format(i / max)
    os.system('cls')
    print("Scraping... ", pct_complete, " complete.")
    print("Fetching next match: ", url)
    data = match_data.get_match_data(url)
    upload_matches.upload_match(
        match_data = data,
        match_url = url
    )
    match_players.load_players(data)
    i += 1