This repository contains the code and data used to create one of my blog posts titled "Amen, Brother". You can see the posts and more at jarvmiller.github.io.

Here is a quick tour of the code

- scrape_sample_songs.ipynb
    - Mostly uses `urllib.request` and `BeautifulSoup` to scrape the title, artist, year of creation, and sampled instrument from each song that sampled "Amen, Brother".
    - Follow this link to see the site. https://www.whosampled.com/The-Winstons/Amen,-Brother/sampled/

- spotify_data.ipynb
    - Mostly uses `requests_oauthlib` and `requests` to search for audio data for each scraped song. Each request was made to Spotify's Web API. Look at this  notebook for a way to create oAuth2 sessions. 
    - Sadly, less than 40% of the songs were retrieved. This might be due to the true/desired song not being within the first 20 results or bc of issues matching the Artist due to naming issues (e.g Beyoncè vs Beyonce or Diddy vs P.Diddy vs Puff Daddy)

- songs_viz.R
    - Uses ggplot2 to create all the visualizations. This was the most fun part :) I miss R a lot and finally took the time to explore manual colors instead of using the default palette ggplot2 uses.