-- ----------------------------------------------------------------------------
-- create database`mls`
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `mls`
CHARACTER SET "utf8"
COLLATE "utf8_general_ci";
-- ----------------------------------------------------------------------------
-- Shift context to `mls`
-- ----------------------------------------------------------------------------
USE `mls`;

-- ----------------------------------------------------------------------------
-- Create table `mls`.`clubs`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`clubs` (
                     `id` INT          NOT NULL AUTO_INCREMENT COMMENT 'Unique club identifier', -- PK
              `club_name` VARCHAR(30)  NOT NULL COMMENT 'Name of club', -- IX
              `club_abrv` VARCHAR(3)   NOT NULL COMMENT 'Club abbreviation, as used on scoreboard',
                   `city` VARCHAR(30)  NOT NULL COMMENT 'City club is based out of',
    `country_subdivision` CHAR(2)      NOT NULL COMMENT 'ISO 3166 2 char State / Territory etc. club is based out of',
             `conference` VARCHAR(10)  NOT NULL COMMENT 'League conference team currently plays in',
             `club_extID` BIGINT       NULL     COMMENT 'Opta ID identifying club in Opta',
                `country` CHAR(3)      NULL     COMMENT 'ISO 3166-1 alpha-3 code for country club is based out of',
               `bg_color` CHAR(7)      NULL     COMMENT 'Hex code of team background color',
         `accent_color_1` CHAR(7)      NULL     COMMENT 'Hex code of team accent color 1',
         `accent_color_2` CHAR(7)      NULL     COMMENT 'Hex code of team accent color 2',
              `txt_color` CHAR(7)      NULL     COMMENT 'Hex code of team text color',
               `logo_url` VARCHAR(255) NULL     COMMENT 'URL to locate team logo image',
-- CONSTRAINTS
    CONSTRAINT `PK_clubs` PRIMARY KEY (`id`),
-- INDECIES
    INDEX `IX_clubs_club_name` (`club_name`)
) COMMENT = "Teams playing in Major League Soccer";

-- ----------------------------------------------------------------------------
-- Insert initial values into table `mls`.`clubs`
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `mls`.`clubs`
       (`id`,`club_name`,`club_abrv`,`city`,`country_subdivision`,`conference`,`club_extID`,`country`,`bg_color`,`accent_color_1`,`accent_color_2`,`txt_color`,`logo_url`)
VALUES ("1","Atlanta United","ATL","Atlanta","GA","East","11091","USA","#231f20","#80000b","#7f0009","#F5F5F5","https://img.mlsdigital.net/www.mlssoccer.com/7/image/311312/1024x1024.png"),
("2","Chicago Fire","CHI","Chicago","IL","East","1207","USA","#071D49","#A2AAAD","#909191","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/389345/1024x1024.png"),
("3","FC Cincinnati","CIN","Cincinnati","OH","East","11504","USA","#FE5000","#003087","#041E42","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/352510/1024x1024.png"),
("4","Colorado Rapids","COL","Denver","CO","West","436","USA","#862633","#8BB8E8","#333F48","#C1C6C8","https://img.mlsdigital.net/www.mlssoccer.com/7/image/355844/1024x1024.png"),
("5","Columbus Crew SC","CLB","Columbus","OH","East","454","USA","#F6E500","#000000","#FFFFFF","#000000","https://img.mlsdigital.net/www.mlssoccer.com/7/image/355845/1024x1024.png"),
("6","FC Dallas","DAL","Dallas","TX","West","1903","USA","#00205B","#BF0D3E","#C1C6C8","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/163618/1024x1024.png"),
("7","D.C. United","DC","Washington","DC","East","1326","USA","#000000","#E4002B","#FFFFFF","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/205282/1024x1024.png"),
("8","Houston Dynamo","HOU","Houston","TX","West","1897","USA","#FF6900","#101820","#8BB8E8","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/421922/1024x1024.png"),
("9","Sporting Kansas City","SKC","Kansas City","KS","West","421","USA","#0C2340","#A7BCD6","#898D8D","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/207525/1024x1024.png"),
("10","LA Galaxy","LA","Los Angeles","CA","West","1230","USA","#13294B","#004B87","#FFCD00","#EAAA00","https://img.mlsdigital.net/www.mlssoccer.com/7/image/163620/1024x1024.png"),
("11","Los Angeles Football Club","LFC","Los Angeles","CA","West","11690","USA","#000000","#C39E6D","","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/246238/1024x1024.png"),
("12","Inter Miami CF","MIA","Miami","FL","East","14880","USA","#F7B5CD","#231F20","#FFFFFF","#231F20","https://img.mlsdigital.net/www.mlssoccer.com/7/image/342476/1024x1024.png"),
("13","Minnesota United FC","MIN","Saint Paul","MN","West","6977","USA","#737B82","#000000","#8AC9ED","#C2C7CA","https://img.mlsdigital.net/www.mlssoccer.com/7/image/234567/1024x1024.png"),
("14","Montreal Impact","MTL","Montreal","QC","East","1616","CAN","#000000","#003DA5","#7C878E","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/163607/1024x1024.png"),
("15","Nashville SC","NSC","Nashville","TN","West","15154","USA","#EDE939","#1F325A","","#1F325A","https://img.mlsdigital.net/www.mlssoccer.com/7/image/355148/1024x1024.png"),
("16","New England Revolution","NE","Foxborough","MA","East","928","USA","#0C2340","#C8102E","","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/163609/1024x1024.png"),
("17","New York City FC","NYC","New York City","NY","East","9668","USA","#6CACE4","#041e42","#FE5000","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/316364/1024x1024.png"),
("18","New York Red Bulls","NY","New York City","NY","East","399","USA","#C5003E","#002554","#FFC72C","#C1C6C8","https://img.mlsdigital.net/www.mlssoccer.com/7/image/319432/1024x1024.png"),
("19","Orlando City SC","ORL","Orlando","FL","East","6900","USA","#5F259F","#EED484","","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/316359/1024x1024.png"),
("20","Portland Timbers","POR","Portland","OR","West","1581","USA","#2C5234","#C99700","#FFFFFF","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/355854/1024x1024.png"),
("21","Philadelphia Union","PHI","Philadelphia","PA","East","5513","USA","#041C2C","#418FDE","#AD841F","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/317240/200x200.png"),
("22","Real Salt Lake","RSL","Salt Lake City","UT","West","1899","USA","#9D2235","#001E62","#DAAA00","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/135746/1024x1024.png"),
("23","San Jose Earthquakes","SJ","San Jose","CA","West","1131","USA","#003DA5","#C8102E","#010101","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/207524/1024x1024.png"),
("24","Seattle Sounders FC","SEA","Seattle","WA","West","3500","USA","#658D1B","#236192","#1D252D","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/163610/1024x1024.png"),
("25","Toronto FC","TOR","Tornoto","ON","East","2077","CAN","#A6192E","#333F48","#A2AAAD","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/355870/1024x1024.png"),
("26","Vancouver Whitecaps FC","VAN","Vancouver","BC","West","1708","CAN","#13294B","#8BB8E8","#97999B","#FFFFFF","https://img.mlsdigital.net/www.mlssoccer.com/7/image/355860/1024x1024.png"),
("27","Austin FC","AUS","Austin","TX","West","15296","USA","#00B140","#000000","#FFFFFF","#000000","https://austin-mp7static.mlsdigital.net/styles/retina_desktop_logo/s3/austin_logo_300x300.png");

-- ----------------------------------------------------------------------------
-- Create table `mls`.`players`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`players` (
               `id` INT          NOT NULL AUTO_INCREMENT COMMENT 'Unique player identifier', -- PK
     `display_name` VARCHAR(110) NOT NULL COMMENT 'Name player is known by', 
        `real_name` VARCHAR(110) NOT NULL COMMENT 'Legal full name of player',
       `first_name` VARCHAR(50)  NULL     COMMENT 'Legal first name of player, if available',
        `last_name` VARCHAR(50)  NULL     COMMENT 'Legal last name of player, if available',
       `player_url` VARCHAR(255) NOT NULL COMMENT 'URL of player''s league page', -- UQ
       `jersey_num` INT          NULL     COMMENT 'Most recent jersey number',
    `height_inches` INT          NULL     COMMENT 'Player height in whole inches',
       `weight_lbs` INT          NULL     COMMENT 'Player weight in whole pounds',
        `birthdate` DATE         NULL     COMMENT 'Date of player''s birth', -- IX
        `is_active` TINYINT(1)   NOT NULL COMMENT 'Boolean - is player currently active in league' DEFAULT 0,
     `player_extID` INT          NULL     COMMENT 'ID used by Opta to identify player', -- UQ
        `home_city` VARCHAR(50)  NULL     COMMENT 'Home city of player',
       `home_state` CHAR(2)      NULL     COMMENT 'ISO 3166-2 code for state / territory etc player is from',
     `home_country` CHAR(2)      NULL     COMMENT 'ISO 3166-1 alpha-3 code for country player is from',
         `position` VARCHAR(3)   NULL     COMMENT 'Position(s) player normally plays in',
     `headshot_url` VARCHAR(255) NULL     COMMENT 'URL of player''s headshot image',
          `club_id` INT          NULL     COMMENT 'FOREIGN KEY - References `clubs`.`id`', -- FK
-- PRIMARY KEY
    CONSTRAINT `PK_players` PRIMARY KEY (`id`),
-- INDEXES
    UNIQUE INDEX `UQ_players_player_url` (`player_url`),
    UNIQUE INDEX `UQ_players_player_extID` (`player_extID`),
    INDEX `IX_players_birthdate` (`birthdate`),
    INDEX `IX_players_club_id` (`club_id`),
-- FOREIGN KEYS
    CONSTRAINT `FK_players_clubs`
    FOREIGN KEY (`club_id`)
     REFERENCES `mls`.`clubs` (`id`)
      ON DELETE SET NULL
      ON UPDATE CASCADE
) COMMENT = "Players, current and former, playing in Major League Soccer";

-- ----------------------------------------------------------------------------
-- Create table `mls`.`seasons`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`seasons` (
              `id` INT NOT NULL AUTO_INCREMENT COMMENT 'Unique season identifier', -- PK
    `season_extID` INT NOT NULL COMMENT 'ID used by Opta to identify season', -- UQ
     `season_desc` VARCHAR(50)  COMMENT 'Human-readable description of season',
-- PRIMARY KEY 
    CONSTRAINT `PK_seasons` PRIMARY KEY (`id`),
-- INDEXES
    UNIQUE INDEX `UQ_seasons_season_extID` (`season_extID`)
) COMMENT = "MLS Seasons";

-- ----------------------------------------------------------------------------
-- Insert initial values into table `mls`.`seasons`
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `mls`.`seasons` (`id`,`season_extID`, `season_desc`)
VALUES (1,2020, "Season 2020/2021");

-- ----------------------------------------------------------------------------
-- Create table `mls`.`competitions`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`competitions` (
                   `id` INT         NOT NULL AUTO_INCREMENT COMMENT 'Unique competition ID', -- PK
    `competition_extID` INT         NULL     COMMENT 'ID used by Opta to identify competition', -- UQ
     `competition_desc` VARCHAR(50) NOT NULL COMMENT 'Long description or name of competition',
     `competition_abrv` VARCHAR(45) NOT NULL COMMENT 'Short description or name of competition',
-- PRIMARY KEY
    CONSTRAINT `PK_competitions` PRIMARY KEY (`id`),
-- INDEXES
    UNIQUE INDEX `UQ_competitions_competition_extID` (`competition_extID`)
) COMMENT = "MLS Competitions, such as regular season, playoffs, or Open Cup";

-- ----------------------------------------------------------------------------
-- Insert initial values into table `mls`.`competitions`
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `mls`.`competitions` (`id`, `competition_extID`,`competition_desc`, `competition_abrv`)
VALUES (1, 98, "MLS", "Regular Season"),
       (2, 99999, "MLS Playoffs", "MLS Playoffs"),
       (3, 1097, "MLS is Back Tournament Final Pres. by Wells Fargo", "MLS is Back");

-- ----------------------------------------------------------------------------
-- Create table `mls`.`competitions`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`matches` (
                `id` INT      NOT NULL AUTO_INCREMENT COMMENT 'Unique match ID', -- PK
       `match_extID` INT      NULL     COMMENT 'ID used by Opta to identify match', -- UQ
      `away_club_id` INT      NOT NULL COMMENT 'Foreign Key - References `clubs`.`id`', -- FK
      `home_club_id` INT      NOT NULL COMMENT 'Foreign Key - References `clubs`.`id`', -- FK
    `match_datetime` DATETIME NOT NULL COMMENT 'Date and time match took place',
        `match_week` INT      NULL     COMMENT 'Match week of season, if applicable',
    `competition_id` INT      NULL     COMMENT 'Foreign Key - References `competitions`.`id`', -- FK
         `season_id` INT      NULL     COMMENT 'Foreign Key - References `seasons`.`id`', -- FK
-- PRIMARY KEY
    CONSTRAINT `PK_matches` PRIMARY KEY (`id`),
-- INDEXES
    UNIQUE INDEX `UQ_matches_match_extID` (`match_extID`),
    INDEX `IX_matches_away_club_id` (`away_club_id`),
    INDEX `IX_matches_home_club_id` (`home_club_id`),
    INDEX `IX_matches_competition_id` (`competition_id`),
    INDEX `IX_matches_season_id` (`season_id`),
-- FOREIGN KEYS
    CONSTRAINT `FK_matches_clubs_home`
               FOREIGN KEY (`home_club_id`)
                REFERENCES `mls`.`clubs` (`id`)
                 ON DELETE NO ACTION
                 ON UPDATE CASCADE,
    CONSTRAINT `FK_matches_clubs_away`
               FOREIGN KEY (`away_club_id`)
                REFERENCES `mls`.`clubs` (`id`)
                 ON DELETE NO ACTION
                 ON UPDATE CASCADE,
    CONSTRAINT `FK_matches_competitions`
               FOREIGN KEY (`competition_id`)
                REFERENCES `mls`.`competitions` (`id`)
                 ON DELETE NO ACTION
                 ON UPDATE CASCADE ,
    CONSTRAINT `FK_matches_seasons`
               FOREIGN KEY (`season_id`)
                REFERENCES `mls`.`seasons` (`id`)
                 ON DELETE NO ACTION
                 ON UPDATE CASCADE
) COMMENT = "Games played between teams in Major League Soccer";

-- ----------------------------------------------------------------------------
-- Create table `mls`.`match_event_types`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`match_event_types` (
                       `id` INT          NOT NULL COMMENT 'Unique event type identifier', -- PK
    `event_type_short_desc` VARCHAR(30)  NOT NULL COMMENT 'Common name of event type', -- IX
     `event_type_long_desc` VARCHAR(255) NOT NULL COMMENT 'Long description of event type',
-- PRIMARY KEY
    CONSTRAINT `PK_match_event_types` PRIMARY KEY (`id`),
-- INDEXES
    INDEX `IX_match_event_types_event_type_short_desc` (`event_type_short_desc`)
) COMMENT = "Names and descriptions of match events. A dimension of `mls`.`match_events`";

-- ----------------------------------------------------------------------------
-- Insert default values into `mls`.`match_event_types`
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `mls`.`match_event_types` (`id`, `event_type_short_desc`, `event_type_long_desc`)
VALUES (1, 'Pass', 'Any pass attempted from one player to another - free kicks, corners, throw-ins, goal kicks, and goal assists.'),
       (2, 'Offside Pass', 'Attempted pass made to a player who is in an offside position.'),
       (3, 'Take On', 'Attempted dribble past an opponent.'),
       (4, 'Foul', 'A foul is committed resulting in a free kick.'),
       (5, 'Out', 'Shown each time the ball goes out of play for a throw-in or goal kick.'),
       (6, 'Corner Awarded', 'Ball goes out of play for a corner kick.'),
       (7, 'Tackle', 'Tackle: dispossesses an opponent of the ball - Outcome 1: win and retain possession or out of play, 0: win tackle but not posession.'),
       (8, 'Interception', 'When a player intercepts any pass event between opposition players and prevents the ball reaching its target. Cannot be a clearance.'),
       (9, 'Turnover', 'Unforced error / loss of posession - i.e. bad control of ball -- NO LONGER USED (Replaced with Unsuccessful Touch + Overrun)'),
       (10, 'Save', 'Goalkeeper event; saving a shot on goal. Can also be an outfield player event with qualifier 94 for blocked shot.'),
       (11, 'Claim', 'Goalkeeper event; catching a crossed ball.'),
       (12, 'Clearance', 'Player under pressure hits the ball clear of the defensive zone and / or out of play'),
       (13, 'Miss', 'Any shot on goal which goes wide or over the goal'),
       (14, 'Post', 'Whenver the ball hits the frame of the goal'),
       (15, 'Attempt Saved', 'Shot saved - this event is for the player who made the shot. Qualifier 82 can be added for blocked shot'),
       (16, 'Goal', 'All goals'),
       (17, 'Card', 'Bookingsl will have red, yellow, or 2nd yellow qualifier plus a reason'),
       (18, 'Player off', 'Player is substituted off'),
       (19, 'Player on', 'Player comes on as a substitute'),
       (20, 'Player retired', 'Player is forced to leave pitch due to injury and the team have no substitutions left'),
       (21, 'Player returns', 'Player comes back on the pitch'),
       (22, 'Player becomes goalkeeper', 'When an outfield player has to replace the goalkeeper'),
       (23, 'Goalkeeper becomes player', 'If goalkeeper becomes an outfield player'),
       (24, 'Condition change', 'Change in playing conditions'),
       (25, 'Official change', 'Referee or linesman is replaced'),
       (27, 'Start delay', 'Used when there is a stoppage in play such as a player injury'), 
       (28, 'End delay', 'Used when the stoppage ends and play resumes'),
       (30, 'End', 'End of a match period'), 
       (32, 'Start', 'Start of a match period'),
       (34, 'Team set up', 'Team line up; qualifiers 30, 44, 130, 131 will show player line up and formation.'),
       (35, 'Player changed position', 'Player moved to a different position but the team formation remained the same'),
       (36, 'Player changed jersey number', 'Player is forced to change jersey number, qualifier will show the new number'),
       (37, 'Collection End', 'Event 30 signals end of half. This signals end of the match and thus data collection'),
       (38, 'Temp_Goal', 'Goal has occurred but it is pending additional detail qualifiers from Opta. Will change to event 16'),
       (39, 'Temp_Attempt', 'Shot on goal has occurred but is pending additional detail qualifiers from Opta. Will change to event 15.'),
       (40, 'Formation change', 'Club alters its formation'),
       (41, 'Punch', 'Goalkeeper event; ball is punched clear'),
       (42, 'Good Skill', 'A player shows a good piece of skill on the ball - such as a step over or turn on the ball - NO LONGER USED'),
       (43, 'Deleted Event', 'Event has been deleted - the event will remain as it was originally with the same ID but will resent with the type altered to 43.'),
       (44, 'Aerial', 'Aerial duel - 50/50 when the ball is in the air - outcome will represent whether the duel was won or lost.'),
       (45, 'Challenge', 'When a player fails to win the ball as an opponent successfully dribbles past them'),
       (47, 'Rescinded card', 'This can occur post match if the referee rescinds a card they have awarded'),
       (49, 'Ball recovery', 'Team wins the possession of the ball and successfully keeps possession for at least two passes or an attacking play'),
       (50, 'Dispossessed', 'Player is successfully tackled and loses possession of the ball'),
       (51, 'Error', 'Mistake by player losing the ball. Leads to a shot or goals as described with qualifier 169 or 170'),
       (52, 'Keeper pick-up', 'Goalkeeper event; picks up the ball'),
       (53, 'Cross not claimed', 'Goalkeeper event; cross not successfully caught'),
       (54, 'Smother', 'Goalkeeper event; comes out and covers the ball in the box, winning possession'),
       (55, 'Offside provoked', 'Awarded to the last defender when an offside decision is given against an attacker'),
       (56, 'Shield ball opp', 'Defender uses their body to shield the ball from an opponent as it rolls out of play'),
       (57, 'Foul throw-in', 'A throw-in not taken correctly resulting in the throw being awarded to the opposing team'),
       (58, 'Penalty faced', 'Goalkeeper event; penalty by opposition team'),
       (59, 'Keeper Sweeper', 'When the keeper comes off their line and / or out of their box to clear the ball'),
       (60, 'Chance missed', 'Used when a player does not actually make a shot on goal but was in a good position to score and only just missed receiving a pass'),
       (61, 'Ball touch', 'Used when a player makes a bad touch on the ball and loses posession. Outcome 1 - ball simply hit the player unintentionally. Outecome 0 - Player unsuccessfully controlled the ball'),
       (63, 'Temp_Save', 'An event indicating a save has occurred but without full details. Event 10 will follwo shortly afterwards with full details.'),
       (64, 'Resume Match', 'Resumes on a new date after being abandoned mid game.'),
       (65, 'Contentious Referee Decision', 'Any major talking point or error made by the referee - decision will be assigned to the relevan team');

-- ----------------------------------------------------------------------------
-- Create table `mls`.`match_events`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`match_events` (
                     `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Unique match event identifier', -- PK
      `match_event_extID` INT    NOT NULL COMMENT 'ID used by Opta to identify match event', -- UQ
    `match_event_type_id` INT    NOT NULL COMMENT 'FOREIGN KEY - References `mls`.`match_event_types`', -- FK
              `period_id` INT    NULL     COMMENT 'Match period event took place in',
                 `minute` INT    NOT NULL COMMENT 'Match minute event took place in',
                 `second` INT    NULL     COMMENT 'Combines with `match_events`.`minute` to give minute and second event took place in',
                `club_id` INT    NULL     COMMENT 'FOREIGN KEY - References `mls`.`clubs`', -- FK
              `player_id` INT    NULL     COMMENT 'FOREIGN KEY - References `mls`.`players`', -- FK
           `extra_minute` INT    NULL     COMMENT 'Extra time minute',
           `x_coordinate` INT    NULL     COMMENT 'X coordinate on field where event took place, from 0 to 100',
           `y_coordinate` INT    NULL     COMMENT 'Y coordinate on field where event took place, from 0 to 100',
-- PRIMARY KEY 
    CONSTRAINT `PK_match_events` PRIMARY KEY (`id`),
-- INDEXES
    UNIQUE INDEX `UQ_match_events_match_event_extID` (`match_event_extID`),
    INDEX `IX_match_events_match_event_type_id` (`match_event_type_id`),
    INDEX `IX_match_events_club_id` (`club_id`),
    INDEX `IX_match_events_player_id` (`player_id`),
-- FOREIGN KEYS
    CONSTRAINT `FK_match_events_match_event_types`
               FOREIGN KEY (`match_event_type_id`)
                REFERENCES `mls`.`match_event_types` (`id`)
                 ON DELETE NO ACTION
                 ON UPDATE CASCADE,
    CONSTRAINT `FK_match_events_clubs`
               FOREIGN KEY (`club_id`)
                REFERENCES `mls`.`clubs` (`id`)
                 ON DELETE NO ACTION
                 ON UPDATE CASCADE,
    CONSTRAINT `FK_match_events_players`
               FOREIGN KEY (`player_id`)
                REFERENCES `mls`.`players` (`id`)
                 ON DELETE NO ACTION
                 ON UPDATE CASCADE
) COMMENT = "Events, like shots and passes, that take place during a match";

-- ----------------------------------------------------------------------------
-- Create table `mls`.`qualifiers`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`qualifiers` (
                      `id` INT          NOT NULL COMMENT 'Opta ID for event qualifier', -- PK Natural key
          `event_category` VARCHAR(30)  NOT NULL COMMENT 'Event category qualifier can be used to qualify', -- IX
    `qualifier_short_desc` VARCHAR(45)  NOT NULL COMMENT 'Short name of event qualifier',
     `qualifier_long_desc` VARCHAR(255) NOT NULL COMMENT 'Long description of event qualifier',
-- PRIMARY KEY
    CONSTRAINT `PKqualifiers` PRIMARY KEY (`id`),
-- INDEXES
    INDEX `IX_qualifiers_event_categories` (`event_category`)
) COMMENT = "Qualifiers used to add detail to match events. ";

-- ----------------------------------------------------------------------------
-- Insert default values into `mls`.`qualifiers`
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `mls`.`qualifiers` (`id`, `event_category`, `qualifier_short_desc`, `qualifier_long_desc`)
VALUES 
-- * PASS EVENTS
       (1, 'Pass event', 'Long ball', 'Long pass over 35 yards'),
       (2, 'Pass event', 'Cross', 'A ball played in from wide areas into the box'),
       (3, 'Pass event', 'Head Pass', 'Pass made with a player''s head'),
       (4, 'Pass event', 'Through Ball', 'Ball played through for player making an attacking run to create a chance on goal'),
       (5, 'Pass event', 'Free Kick Yaken', 'Any free kick; direct or indirect'),
       (6, 'Pass event', 'Corner Taken', 'All corners. Look for qualifier 6 but excluding qualifier 2 for short corners'),
       (7, 'Pass event', 'Players Caught Offside', 'Player who was in an offside position when pass was made'),
       (8, 'Pass event', 'Goal Disallowed', 'Pass led to a goal disallowed for a foul or offside'),
       (106, 'Pass event', 'Attacking Pass', 'A pass in the opposition''s half of the pitch'),
       (107, 'Pass event', 'Throw-in', 'Throw-in taken'),
       (140, 'Pass event', 'Pass End X', 'The x pitch coordinate for the end point of a pass'),
       (141, 'Pass event', 'Pass End Y', 'The y pitch coordinate for the end point of a pass'),
       (155, 'Pass event', 'Chipped', 'Pass which was chipped into the air'),
       (156, 'Pass event', 'Lay-off', 'Pass where player laid the ball into the path of a teamates'' run'),
       (157, 'Pass event', 'Launch', 'Pass played from a player''s own half up towards front players. Aimed to hit a zone rather than a specific player'),
       (168, 'Pass event', 'Flick-on', 'Pass where a player has "flicked" the ball using their head'),
       (195, 'Pass event', 'Pull Back', 'Player in opposition''s penalty box reaches the by-line and passes (cuts) the ball backwards to a teammate'),
       (196, 'Pass event', 'Switch of play', 'Any pass which crosses the centre zone of thepitch and in length is greater than 60 on the y axis of the pitch'),
       (210, 'Pass event', 'Assist', 'The pass was an assist for a shot. The type of shot then dictates whether it was a goal assist or just a key pass'),
       (212, 'Pass event', 'Length', 'The estimated length the ball has travelled during the associated event'),
       (213, 'Pass event', 'Angle', 'The angle the ball travels at during an event relative to the directionj of play. Shown in radians'),
       (218, 'Pass event', 'Second Assist', 'Pass was deemd a 2nd assist - created the opportunity for another player to assist a goal'),
       (219, 'Pass event', 'Players on both posts', 'Assigned to event 6 indicating there were defensive players on both posts when a corner was taken'),
       (220, 'Pass event', 'Player on near post', 'Assigned to event 6 indicating there was a defensive player on only the near post when a corner was taken'),
       (221, 'Pass event', 'Player on far post', 'Assigned to event 6 indicating there was a defensive player on only the far post when a corner was taken'),
       (222, 'Pass event', 'No players on posts', 'Assigned to event 6 indicating there were no defensive players on either post when a corner was taken'),
       (223, 'Pass event', 'In-swinger', 'Corner was crossed into the box swerving towards the goal'),
       (224, 'Pass evnet', 'Out-swinger', 'Corner was crossed into the box swerving away from the goal'),
       (225, 'Pass event', 'Straight', 'Corner was crossed into the box with a straight ball flight'),
-- * BODY PARTS
       (15, 'Body part', 'Head', 'Any event where the player used their head such as a shot or a clearance'),
       (72, 'Body part', 'Left Footed', 'Player shot with their left foot'),
       (20, 'Body part', 'Right Footed', 'Player shot with their right foot'),
       (21, 'Body part', 'Other Body Part', 'Shot was neither via a player''s head or foot - for example knee or chest'),
-- * SHOTS - PATTERN OF PLAY
       (22, 'Shot - Pattern of Play', 'Regular Play', 'Shot during open play as oppposed to from a set play'),
       (23, 'Shot - Pattern of Play', 'Fast Break', 'Shot occurred following a fast break situation'),
       (24, 'Shot - Pattern of Play', 'Set Piece', 'Shot occurred from a crossed free kick'),
       (25, 'Shot - Pattern of Play', 'From Corner', 'Shot occurred from a corner'),
       (26, 'Shot - Pattern of Play', 'Free Kick', 'Shot occurred directly from a free kick'),
       (96, 'Shot - Pattern of Play', 'Corner Situation', 'Pass or shot event in corner situation. 25 is used when the goal is direct from corner, 96 relates to 2nd phase attack'),
       (97, 'Shot - Pattern of Play', 'Direct Free Kick', '26 will be used for shot directly from a free kick. 97 only used with Opta GoalData (game system 4) but not with full data'),
       (112, 'Shot - Pattern of Play', 'Scramble', 'Goals where there was a scramble for possession of the ball and the defence had an opportunityt to clear'),
       (160, 'Shot - Pattern of Play', 'Throw-in set piece', 'Shot came from a throw-in set piece'),
       (29, 'Shot - Pattern of Play', 'Assisted', 'Indicates that there was a pas (assist from another player to set up the goal opportunity'),
       (154, 'Shot - Pattern of Play', 'Intentional Assist', 'Shot from an intentional assist i.e. the assisting player intended the pass, no deflection etc'),
       (55, 'Shot - Pattern of Play', 'Related Event ID', 'This will appear for goals or shots, the related event_id will be that of the assist and thus show the assisting player ID'),
       (216, 'Shot - Pattern of Play', '2nd Related Event ID', 'If there was a 2nd assist i.e. a pass to create the opportunity for the player making the assist. MLS and German Bundesliga 1 & 2'),
-- * SHOTS - SHOT DESCRIPTOR
       (9, 'Shot - Shot Descriptor', 'Penalty', 'When attempt on goal was a penalty kick. Also used on Event Type 4 to indicate a penalty was awarded'),
       (28, 'Shot - Shot Descriptor', 'Own Goal', 'Own Goal. Note: Use the inverse coordinates of the goal location'),
       (113, 'Shot - Shot Descriptor', 'Strong', 'Shot was subjectively classified as strong'),
       (114, 'Shot - Shot Descriptor', 'Weak', 'Shot was subjectively classified as weak'),
       (115, 'Shot - Shot Descriptor', 'Rising', 'Shot was rising in the air'),
       (116, 'Shot - Shot Descriptor', 'Dipping', 'Shot was dipping toward the ground'),
       (117, 'Shot - Shot Descriptor', 'Lob', 'Shot was an attempt by the attacker to player the ball over the goalkeeper and into the goal'),
       (120, 'Shot - Shot Descriptor', 'Swerve Left' ,'Shot which swerves to the left - from attacker''s perspective'),
       (121, 'Shot - Shot Descriptor', 'Swerve Right', 'Shot which swerves to the right - from attacker''s perspective'),
       (122, 'Shot - Shot Descriptor', 'Swerve Moving', 'Shot which swerves in several directions'),
       (133, 'Shot - Shot Descriptor', 'Deflection', 'Shot deflected off another player'),
       (136, 'Shot - Shot Descriptor', 'Keeper Touched', 'Goal where the goalkeeper got a touch on the ball as it went in'),
       (137, 'Shot - Shot Descriptor', 'Keeper Saved', 'Shot going wide over the goal but still collected / saved by the goalkeeper with event type 15'),
       (138, 'Shot - Shot Descriptor', 'Hit Woodwork', 'Any shot which hits the goal or crossbar'),
       (153, 'Shot - Shot Descriptor', 'Not Past Goal Line', 'Shot missed which does not pass the goal line'),
       (214, 'Shot - Shot Descriptor', 'Big Chance', 'Shot was deemed by Opta analysts to be an excellent opportunity to score - clear cut chance e.g. one-on-one.'),
       (215, 'Shot - Shot Descriptor', 'Individual Play', 'Player created the chance to shoot by themselves, not assisted. For example, they dribbled to create space for themselves and shot'),
       (217, 'Shot - Shot Descriptor', 'Second Assisted', 'Indicates that this shot had a significant pass to create the opporunity for the pass which led to a goal'),
       (228, 'Shot - Shot Descriptor', 'Own Shot Blocked', 'Player blocks an attacking shot unintentionally from their teammate'),
-- * SHOTS - SHOT LOCATIONS       
       (16, 'Shot - Shot Location', 'Small Box - Center', 'Area of pitch (54.8 >= Y >= 45.2, 100 >= X >= 94.2)'),
       (17, 'Shot - Shot Location', 'Box-Center', 'Area of pitch (63.2 >= Y >= 36.8, 94.2 >= X >= 83)'),
       (18, 'Shot - Shot Location', 'Out of Box - Center', 'Area of pitch (78.9 >= Y >= 21.1, 83 >= X >= 70.835)'),
       (19, 'Shot - Shot Location', '35+ Center', 'Area of pitch (78.9 >= Y >= 21.1, 70.835 >= X >= 0)'),
       (60, 'Shot - Shot Location', 'Small Box - Right', 'Area of pitch (44.2 >= Y >= 36.8, 100 >= X > = 94.2)'),
       (61, 'Shot - Shot Location', 'Small Box - Left', 'Area of pitch (63.2 >= Y >= 55.8, 100 >= X >= 94.2)'),
       (62, 'Shot - Shot Location', 'Box - Deep Right', 'Area of pitch (36.8 >= Y >= 21.1, 100 >= X >= 94.2)'),
       (63, 'Shot - Shot Location', 'Box - Right', 'Area of pitch (36.8 >= Y >= 21.1, 100 >= X >= 94.2)'),
       (64, 'Shot - Shot Location', 'Box - Left', 'Area of pitch (78.9 >= Y >= 94.2 >= X >= 83)'),
       (65, 'Shot - Shot Location', 'Box - Deep Left', 'Area of pitch (78.9 >= Y >= 63.2, 100 >= X >= 94.2)'),
       (66, 'Shot - Shot Location', 'Out of Box - Deep Right', 'Area of pitch (21.1 >= Y >= 0, 83 >= X >= 100)'),
       (67, 'Shot - Shot Location', 'Out of Box - Right', 'Area of pitch (21.1 >= Y >= 0, 83 >= X >= 70.835)'),
       (68, 'Shot - Shot Location', 'Out of Box - Left', 'Area of pitch (100 >= Y >= 78.9, 83 >= X >= 70.835)'),
       (69, 'Shot - Shot Location', 'Out of Box - Deep Left', 'Area of pitch (100 >= Y >= 78.9, 100 >= X >= 83)'),
       (70, 'Shot - Shot Location', '35+ Right', 'Area of pitch (21.1 >= Y >= 0, 94.2 >= X >= 83)'),
       (71, 'Shot - Shot Location', '35+ Left', 'Area of pitch (100 >= Y >= 78.9, 70.835 >= X >= 0)'),
       (73, 'Shot - Shot Location', 'Left', 'Hit the left post or missed left'),
       (74, 'Shot - Shot Location', 'High', 'Hit crossbar or missed over'),
       (75, 'Shot - Shot Location', 'Right', 'Hit crossbar or missed right'), 
       (76, 'Shot - Shot Location', 'Low Left', 'Zone of goalmouth (54.8 >= Y >51.8, 21 >= Z >= 0)'),
       (77, 'Shot - Shot Location', 'High Left', 'Zone of goalmouth (54.8 >= Y >= 51.8, 38 >= Z >= 21)'),
       (78, 'Shot - Shot Location', 'Low Center', 'Zone of goalmouth (51.8 >= Y >= 48.2, 20 >= Z >= 0)'),
       (79, 'Shot - Shot Location', 'High Center', 'Zone of goalmouth (51.8 >= Y >= 48.2, 38 >= Z >= 20)'),
       (80, 'Shot - Shot Location', 'Low Right', 'Zone of goalmouth (48.2 >= Y >= 45.2, 20 >= Z >= 0)'),
       (81, 'Shot - Shot Location', 'High Right', 'Zone of goalmouth (48.2 >= Y >= 45.2, 38 >= Z >= 20)'),
       (82, 'Shot - Shot Location', 'Blocked', 'Blocked Shot'),
       (83, 'Shot - Shot Location', 'Close Left', 'Zone of goalmouth (59.3 >= Y >= 55.8, 40 >= Z >= 0)'),
       (84, 'Shot - Shot Location', 'Close Right', 'Zone of goalmouth (44.2 >= Y >= 40.7, 40 >= Z >= 0)'),
       (85, 'Shot - Shot Location', 'Close High', 'Zone of goalmouth (55.8 >= Y >= 44.2, 60 >= Z >= 42)'),
       (86, 'Shot - Shot Location', 'Close Left And High', 'Zone of goalmouth (59.3 >= Y >= 55.8, 60 >= Z >= 40)'),
       (87, 'Shot - Shot Location', 'Close Right and High', 'Zone of goalmouth (44.2 >= Y >= 40.7, 60 >= Z >= 40)'),
       (100, 'Shot - Shot Location', 'Six Yard Blocked', 'Shot blocked on the 6 yard line'),
       (101, 'Shot - Shot Location', 'Saved Off Line', 'Shot saved on the goal line'),
       (102, 'Shot - Shot Location', 'Goal Mouth Y Coordinate', 'Y Coordinate of where a shot crossed the goal line'),
       (103, 'Shot - Shot Location', 'Goal Mouth Z Coordinate', 'Z Coordinate of where a shot crossed the goal line'),
       (146, 'Shot - Shot Location', 'Blocked X Coordinate', 'X Coordinate on pitch for where a shot was blocked'),
       (147, 'Shot - Shot Location', 'Blocked Y Coordinate', 'Y Coordinate on pitch for where a shot was blocked'),
-- * FOULS AND CARDS
       (10, 'Foul or Card', 'Hand', 'Handball'),
       (11, 'Foul or Card', '6-Seconds Violation', 'Goalkeeper held onto the ball longer than 6 seconds, resulting in a free kick'),
       (12, 'Foul or Card', 'Dangerous Play', 'A foul due to dangerous play'),
       (13, 'Foul or Card', 'Foul', 'All Fouls'),
       (31, 'Foul or Card', 'Yellow Card', 'Player shown a yellow card'),
       (32, 'Foul or Card', 'Second Yellow', 'Player receives a second yellow card, which automatically results in a red card'),
       (33, 'Foul or Card', 'Red Card', 'Player shown a straight red card'),
       (34, 'Foul or Card', 'Referee Abuse','Card shown to a player because of abuse to the referee'),
       (35, 'Foul or Card', 'Argument', 'Card shown to a player because of an argument'),
       (36, 'Foul or Card', 'Fight', 'Card shown to a player because of their involvement in a fight'),
       (37, 'Foul or Card', 'Time Wasting','Card shown to a player for time wasting'),
       (38, 'Foul or Card', 'Excessive Celebration', 'Card shown to a player for excessively celebrating a goal'),
       (39, 'Foul or Card', 'Crowd Interaction', 'Card shown to a player because of contact or communication with the crowd'),
       (40, 'Foul or Card', 'Unknown Reason', 'Card shown for unknown reason'),
       (95, 'Foul or Card', 'Back Pass', 'Free kick given for an illegal pass to the goalkeeper which was collected by their hands or picked up'),
       (132, 'Foul or Card', 'Dive', 'Free kick or card event; Player penalized for simulation'),
       (158, 'Foul or Card', 'Persistent Infringement', 'Card shown to player for persistent fouls'),
       (159, 'Foul or Card', 'Foul and Abusive Language', 'Card shown for player using foul language'),
       (161, 'Foul or Card', 'Encroachment', 'Card shown for player who moves within 10 yards of an opponant''s free kick'),
       (162, 'Foul or Card', 'Leaving Field','Card shown for player leaving field without permission'),
       (163, 'Foul or Card', 'Entering Field', 'Card shown for player entering field during play without referee''s permission'),
       (164, 'Foul or Card', 'Spitting', 'Card shown for spitting'),
       (165, 'Foul or Card', 'Professional Foul', 'Card shown for deliberate tactical foul'),
       (166, 'Foul or Card', 'Handling on the Line', 'Card shown to an outfield player for using their hand to keep the ball out of the goal'),
       (171, 'Foul or Card', 'Rescinded Card', 'Referee rescind card post-match'),
       (172, 'Foul or Card', 'No Impact on Timing', 'Player booked on bench but who hasn''t played any minutes in the match'),
       (184, 'Foul or Card', 'Dissent', 'Card shown when a player does not obey referee instructions'),
       (191, 'Foul or Card', 'Off the Ball Foul', 'Foul committed by and on a player who is not in posession of the ball'),
       (192, 'Foul or Card', 'Block by Hand', 'Outfield player blocks a shot with their hand');
-- TODO: Add qualifiers for goalkeeper events, defensive events, lineup / sub / formation, referee, and stoppage

-- ----------------------------------------------------------------------------
-- Create table `mls`.`match_events_qualifiers`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mls`.`match_events_qualifiers` (
       `match_event_id` BIGINT      NOT NULL COMMENT 'FOREIGN KEY - References `mls`.`match_events`. Part of composite PK with qualifier_id',
         `qualifier_id` INT         NOT NULL COMMENT 'FOREIGN KEY - References `mls`.`qualifiers`. Part of composite PK with match_event_id',
      `qualifier_value` VARCHAR(50) NULL COMMENT 'Value of qualifier, if present (i.e. coordinate value for blocked shots)',
-- PRIMARY KEY
    CONSTRAINT `PK_match_events_qualifiers` PRIMARY KEY (`match_event_id`, `qualifier_id`),
-- FOREIGN KEYS
    CONSTRAINT `FK_match_events_qualifiers_match_event_id`
               FOREIGN KEY (`match_event_id`)
                REFERENCES `mls`.`match_events` (`id`)
                 ON DELETE CASCADE
                 ON UPDATE CASCADE,
    CONSTRAINT `FK_match_events_qualifiers_qualifiers`
               FOREIGN KEY (`qualifier_id`)
                REFERENCES `mls`.`qualifiers` (`id`)
                 ON DELETE CASCADE
                 ON UPDATE CASCADE
) COMMENT = "Junction table between match events and qualifiers. Also contains qualifier values"

