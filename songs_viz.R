library(tidyverse)
library(forcats)
songs <- read_csv("~/school/self_study/amen_brother/songs.csv")

# Will influence x axis
year_breaks <- seq(1985, 2015, 5)

# Number of samples over time
songs %>% 
  group_by(Year) %>%
  count() %>%
ggplot(aes(x=Year, y=n)) + 
  geom_bar(stat='identity') + 
  scale_x_continuous(breaks=year_breaks) + 
  labs(title="Samples of 'Amen, Brother' peaked mid 90s",
       subtitle="Number of songs that sampled over time",
       y="Number of samples") +
  theme_bw()
  
# Number of samples by genre

songs %>%
  group_by(Genre) %>%
  count(sort = T)

# lets squash everything w/ 5 or less counts into Other

songs <- songs %>%
  mutate(Genre = fct_collapse(Genre, Other = c("Other","World", "Jazz / Blues",
                                              "Reggae", "Spoken Word", "Easy Listening")))

# reorder factors
songs <- songs %>% mutate(Genre = fct_rev(fct_infreq(.$Genre)))

# # Color scheme for each genre
color_scheme <- c("#F0E442", "#0072B2", "#CC79A7","#E69F00", "#999999")
 

# Songs that samples over time by genre
songs %>% 
  ggplot() + geom_area(aes(Year, fill=Genre),
                       stat = 'bin',
                       bins=30) + 
  scale_fill_manual(values=color_scheme) +
  scale_x_continuous(breaks=year_breaks) + 
  labs(title="Hip hop caught the wave first, followed by EDM, then others",
       subtitle="Songs that sampled over time by genre",
       y="Number of samples") +
  theme_bw()

# songs %>% filter(Genre == "Hip-Hop / Rap / R&B") %>%
#   ggplot() + geom_bar(aes(Year)) +
#   scale_x_continuous(breaks=year_breaks) +
#   labs(title="Number of songs that sampled over time",
#        subtitle = "Hip-Hop / Rap / R&B",
#        y="Count") +
# theme_bw()
# 
# songs %>% filter(Genre == "Electronic / Dance") %>%
#   ggplot() + geom_bar(aes(Year)) +
#   scale_x_continuous(breaks=year_breaks) +
#   labs(title="Number of songs that sampled over time",
#        subtitle = "Electronic / Dance",
#        y="Count") +
#   theme_bw()

# Hip Hop caught the wave a couple years earlier but Electronic/dance 
# kept it alive longerish

songs %>% filter(Genre %in% c("Hip-Hop / Rap / R&B", "Electronic / Dance")) %>%
  ggplot() + geom_density(aes(Year, fill=Genre), alpha =.75) + 
  scale_fill_manual(values=color_scheme[4:5]) +
  scale_x_continuous(breaks=year_breaks) + 
  labs(title="EDM had more 'bursts' of interest in Amen, Brother",
       subtitle="Density of songs that sampled over time",
       y="Count") +
theme_bw()

# Which samples were soundtracks
songs %>% 
  select(Artist, Title, Genre) %>% 
  filter(Genre=='Soundtrack')

# Which instruments?
songs %>%
  group_by(Instrument) %>%
  count(sort = T)

# Now looking into the songs that we have track info for

tracks <- songs %>% filter(!is.na(Valence))
# View(tracks)

# boxplot of valence
tracks %>%
ggplot(aes(Genre, Valence)) +
  geom_boxplot(aes(fill=Genre), fatten=4, alpha=.75) +
  geom_dotplot(binaxis='y',
               stackdir='center',
               dotsize = .3,
               fill="red",
               binwidth = 1/40) + 
  scale_fill_manual(values=color_scheme[c(1,3,4,5)]) +
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
  coord_flip() + theme_bw() +
  labs(title="EDM and Rock slightly less positive sounding",
       subtitle="Song valence by genre")


# tracks %>% filter(Genre != "World") %>%
#   ggplot(aes(Genre, Danceability)) +
#   geom_boxplot(fill="#56B4E9", fatten=4) +
#   geom_dotplot(binaxis='y',
#                stackdir='center',
#                dotsize = .275,
#                fill="#E69F00",
#                binwidth = 1/45) + 
#   theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
#   coord_flip() + theme_bw() +
#   labs(title="Danceability of songs by genre")

# hip hop more danceable which is lowkey funny
tracks %>%
  ggplot(aes(Danceability)) +
  geom_histogram(aes(y = ..density..), color = "black", fill = "white",
                 binwidth = 1/30) + 
  geom_density(aes(fill=Genre), alpha=.45) + 
  scale_fill_manual(values=color_scheme[c(1,3,4,5)]) + 
  facet_grid(Genre ~.) +
  theme_bw() + 
  theme(strip.background = element_blank(),
        strip.text.y = element_blank()) +
  labs(title="Only Hip-Hop generally more danceable",
    subtitle="Song danceability by genre")

tracks %>%
  ggplot(aes(Tempo)) +
  geom_histogram(aes(y = ..density..),color = "black", fill = "white",
                 bins=25) + 
  geom_density(aes(fill=Genre), alpha=.45) + 
  facet_grid(Genre ~.) +
  scale_fill_manual(values=color_scheme[c(1,3,4,5)]) +
  theme_bw() + 
  theme(strip.background = element_blank(),
        strip.text.y = element_blank()) +
  labs(title = "Hip-Hop has much slower tempo than EDM",
    subtitle="Song tempo (beats/min) by genre")



tracks %>%
  ggplot(aes(Energy)) +
  geom_histogram(aes(y = ..density..),color = "black", fill = "white") + 
  geom_density(aes(fill=Genre), alpha=.45,
               bins=35) + 
  facet_grid(Genre ~.) +
  scale_fill_manual(values=color_scheme[c(1,3,4,5)]) +
  theme_bw() + 
  theme(strip.background = element_blank(),
        strip.text.y = element_blank()) +
  labs(title = "Hip-Hop slightly less energetic",
       subtitle="Song energy by genre")

