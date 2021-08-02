# IDENTITY DEFAULT

# create all profiles
dfx identity use default
dfx canister call dfc createProfile '("thoughtfulAnonymous")'
dfx identity use user1
dfx canister call dfc createProfile '("ikigai")'
dfx identity use user2
dfx canister call dfc createProfile '("happyMe")'
dfx identity use user3
dfx canister call dfc createProfile '("justBeingHelpful")'

# flag contents
dfx identity use default
dfx canister call dfc flagContent '("1421807363359535108", 200)' # POST ID - 0
dfx canister call dfc flagContent '("1421804550948757517", 300)' # POST ID - 1
dfx canister call dfc flagContent '("1422227460284850181", 350)' # POST ID - 2
dfx canister call dfc flagContent '("1421805138105102340", 200)' # POST ID - 3

# comments for POST ID 0
dfx identity use default
dfx canister call dfc addComment '("0", "The Earth is not flat & NASA isn’t fabricating any evidence. All NASA images are authentic & vetted by independnent scientific community. Moreover, Facoault’s pendulum is direct evidence of Earth’s rotation. You can find more information abot it here - https://www.brown.edu/Departments/Italian_Studies")'
dfx identity use user1
dfx canister call dfc addComment '("0", "Another phenomenon that disproves flat earth hypothesis and proves spinning globe is the Coriolis force, which acts perpendicular to the direction of motion of a spinning mass. This force leads to cylones swirling clockwise in the southern hemisphere and counterclockwise in the northern hemisphere; through the direction of winds, it also impacts ocean currents. Long-range military snipers even have to make allowance for deflections caused by the Coriolis effect. You can read more about the force here - https://www.nationalgeographic.org/encyclopedia/coriolis-effect/")'

# comments for POST ID 1
dfx identity use user2
dfx canister call dfc addComment '("1", "The collision showed in the video is fake. Teslas don’t have a full self-driving mode. Autopilot, the automaker’s semiautonomous system, is made for highways, not the sort of private road shown in the video. You can read a detailed account of it here. Plus,video appears to show a rope snaking away from the incident—the sort that could be used, say, to pull down a robot that hadn’t been hit by a car at all  - https://www.wired.com/story/tesla-promobot-pave-self-driving-education/.")'

# comments for POST ID 2
dfx identity use default
dfx canister call dfc addComment '("2", "Its important to note that FDA requires every vaccine provider to report deaths after vaccine to VAERS. After any report is received doctors from CDC and FDA review each report very carefully. Adverse events related to vaccines are rare, since millions have received vaccination & adverse side-effects are only observed in few hundreds. Moreover, CDC is still invetigating whether these adverse eventsa are directly caused from vaccination. You can read more about it here  - https://www.cdc.gov/coronavirus/2019-ncov/vaccines/safety/adverse-events.html")'

# comments for POST ID 3
dfx identity use user1
dfx canister call dfc addComment '("3", "Even though evernyone is loving this. The footage does not show dolphins in Venice. The video was actually taken in the port of Cagliari in Sardinia, around 750 km away from Venice. Check out here - https://www.euronews.com/2020/03/20/debunked-video-does-not-show-dolphins-in-venice-s-canals-thecube for more info.")'


# RATING comments on POST ID 0
# comment 0
dfx identity use default
dfx canister call dfc addRating '("0", true)'
dfx identity use user1
dfx canister call dfc addRating '("0", true)'
dfx identity use user2
dfx canister call dfc addRating '("0", false)'
# comment 1
dfx identity use default
dfx canister call dfc addRating '("1", true)'
dfx identity use user1
dfx canister call dfc addRating '("1", false)'


# RATING comments on POST ID 1
dfx identity use default
dfx canister call dfc addRating '("2", true)'
dfx identity use user1
dfx canister call dfc addRating '("2", true)'
dfx identity use user2
dfx canister call dfc addRating '("2", false)'

# RATING comments on POST ID 2
dfx identity use default
dfx canister call dfc addRating '("3", true)'
dfx identity use user1
dfx canister call dfc addRating '("3", true)'
dfx identity use user2
dfx canister call dfc addRating '("3", true)'



# RATING comments on POST ID 3
dfx identity use default
dfx canister call dfc addRating '("4", true)'
dfx identity use user1
dfx canister call dfc addRating '("4", false)'
dfx identity use user2
dfx canister call dfc addRating '("4", true)'



#  Watch a Tesla on self driving mode run over a innocent robot. Told you self driving cars aren't good
# Comment 1 - The collision showed in the video is fake. Teslas don’t have a full self-driving mode. Autopilot, the automaker’s semiautonomous system, is made for highways, not the sort of private road shown in the video. You can read a detailed account of it here. Plus,video appears to show a rope snaking away from the incident—the sort that could be used, say, to pull down a robot that hadn’t been hit by a car at all  - https://www.wired.com/story/tesla-promobot-pave-self-driving-education/.

# The government is hiding number of deaths caused by covid-19 vaccines, claims a whistleblower. #DUMPMASKS #UNJECTED
# Comment 1 - It's important to note that FDA requires every vaccine provider to report deaths after vaccine to VAERS. After any report is received doctors from CDC and FDA review each report very carefully. Adverse events related to vaccines are rare, since millions have received vaccination & adverse side-effects are only observed in few hundreds. Moreover, CDC is still invetigating whether these adverse eventsa are directly caused from vaccination. You can read more about it here  - https://www.cdc.gov/coronavirus/2019-ncov/vaccines/safety/adverse-events.html
# Commment 2 - Over 339 million vaccine doses were given to 187 million people in the US as of July 19, 2021. Between December 2020 and July 19th, 2021, VAERS received 6,207 reports of death (0.0018% of doses) among people who got a vaccine, but this does not mean the vaccine caused these deaths. Only 3 cases of blood clost appear to have been linked to vaccines. Hence, vaccines are immensely safe. Source - https://covid-101.org/science/how-many-people-have-died-from-the-vaccine-in-the-u-s/

# Venice hasn't seen clear canal wanter in a very long time. Dolphin showing up too, nature just hit the reset button
# Comment 1 - Even though evernyone is loving this. The footage does not show dolphins in Venice. The video was actually taken in the port of Cagliari in Sardinia, around 750 km away from Venice. Check out here - https://www.euronews.com/2020/03/20/debunked-video-does-not-show-dolphins-in-venice-s-canals-thecube for more info.




# dfx canister call dfc addComment '("0", "The Earth is not flat & NASA isn’t fabricating any evidence. All NASA images are authentic & vetted by independnent scientific community. Moreover, Facoault’s pendulum is direct evidence of Earth’s rotation. You can find more information abot it here - https://www.brown.edu/Departments/Italian_Studies/n2k/visibility/Alison_Errico/Soft%20Moon/pendulum.html")'