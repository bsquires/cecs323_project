--This file will be where the initialization
-- of our database tables will take place.

CREATE TABLE employees
(
    eid         INTEGER         NOT NULL AUTO_INCREMENT,
    fName       VARCHAR(20)     NOT NULL,
    lName       VARCHAR(20)     NOT NULL,
    dob         DATE            NOT NULL,
    salary      DOUBLE                  ,
    street      VARCHAR(30)     NOT NULL,
    zipCode     CHAR(10)        NOT NULL,
    
    CONSTRAINT  employees_PK    PRIMARY KEY (eid),
    CONSTRAINT  employees_CK    UNIQUE (fName, lName, dob),
    CONSTRAINT  employees_CK2   UNIQUE (fName, lName, street, zipCode)
);

CREATE TABLE djs
(
    stageName   VARCHAR(20)     NOT NULL,
    eid         INTEGER                 ,
    
    CONSTRAINT djs_PK PRIMARY KEY (stageName),
    CONSTRAINT djs_Employees_FK
        FOREIGN KEY (eid) REFERENCES employees(eid)
        ON DELETE SET NULL --A DJ is no longer an employee but we still want to keep record of the DJ persona
);

CREATE TABLE showTypes
(
    type      VARCHAR(15)     NOT NULL,
    
    CONSTRAINT  showTypes_PK    PRIMARY KEY (shType)
);

CREATE TABLE shows
(
    name          VARCHAR(20)   NOT NULL,
    description   VARCHAR(30)           ,
    type          VARCHAR(15)           ,
    tagline       VARCHAR(15)           ,
    
    CONSTRAINT  shows_PK    PRIMARY KEY (name),
    CONSTRAINT  shows_FK
        FOREIGN KEY (type) REFERENCES showTypes(type)
);

CREATE TABLE spans
(
    stageName       VARCHAR(20)             ,
    beginDate       DATE            NOT NULL,
    endDate         DATE                    ,
    name            VARCHAR(20)     NOT NULL,
    
    CONSTRAINT  spans_PK    PRIMARY KEY (name, beginDate),
    CONSTRAINT  spans_djs_FK
        FOREIGN KEY (stageName) REFERENCES djs(stageName),
    CONSTRAINT  spans_shows_FK
        FOREIGN KEY (name) REFERENCES shows(name)
);

CREATE TABLE airedShows
(
    showTime        TIME            NOT NULL,
    showDate        DATE            NOT NULL,
    name            VARCHAR(20)             ,
    
    CONSTRAINT  airedShows_PK   PRIMARY KEY (showTime, showDate),
    CONSTRAINT  airedShows_shows_FK
        FOREIGN KEY (name) REFERENCES shows(Name)
        ON UPDATE CASCADE --If a show changes its name, the change
                          --will ripple through
);

CREATE TABLE artists
(
    aid             INTEGER         NOT NULL    AUTO_INCREMENT  ,
    fName           VARCHAR(20)     NOT NULL                    ,
    lName           VARCHAR(20)     NOT NULL                    ,
    
    CONSTRAINT  artists_PK      PRIMARY KEY (aid),
    CONSTRAINT  artists_CK      UNIQUE (fName, lName)
);

CREATE TABLE guestAppearances
(
    showTime        TIME            NOT NULL,
    showDate        DATE            NOT NULL,
    aid             INTEGER                 ,
    
    CONSTRAINT  guestApp_PK    PRIMARY KEY (showTime, showDate, aid)
    CONSTRAINT  guestApp_airedShows_FK
        FOREIGN KEY (showTime) REFERENCES airedShows(showTime),
    CONSTRAINT  guestApp_airedShows_FK2
        FOREIGN KEY (showDate) REFERENCES airedShows(showDate),
    CONSTRAINT  guestApp_artist_FK
        FOREIGN KEY (aid) REFERENCES artists (aid)
);

CREATE TABLE musicGenres
(
    genre           VARCHAR(15)     NOT NULL,
    
    CONSTRAINT  musicGenres_PK      PRIMARY KEY (genre)
);

CREATE TABLE songs
(
    sid             INTEGER         NOT NULL    AUTO_INCREMENT  ,
    title           VARCHAR(20)     NOT NULL                    ,
    yearProduced    INTEGER         NOT NULL                    ,
    genre           VARCHAR(15)                                 ,
    
    CONSTRAINT  songs_PK        PRIMARY KEY (sid),
    CONSTRAINT  songs_CK        UNIQUE (title, yearProduced),
    CONSTRAINT  songs_genre_FK
        FOREIGN KEY (genre) REFERENCES musicGenres(genre)
);

CREATE TABLE artistPerformances
(
    aid             INTEGER         NOT NULL,
    sid             INTEGER         NOT NULL,
    
    CONSTRAINT  artistPerf_PK    PRIMARY KEY (aid, sid),
    CONSTRAINT  artistPerf_song_FK
        FOREIGN KEY (sid) REFERENCES songs(sid),
    CONSTRAINT  artistPerf_artist_FK
        FOREIGN KEY (aid) REFERENCES artist(aid)
);

CREATE TABLE songsPlayed
(
    sid             INTEGER         NOT NULL,
    showTime        TIME            NOT NULL,
    showDate        DATE            NOT NULL,
    playTime        TIME                    , -- The time length of each song
    
    CONSTRAINT  songsPlayed_PK      PRIMARY KEY (sid, showTime, showDate, playTime)
    CONSTRAINT  songsPlayed_song_FK
        FOREIGN KEY (sid) REFERENCES songs (sid),
    CONSTRAINT  songsPlayed_airedShows_FK
        FOREIGN KEY (showTime) REFERENCES airedShows (showTime),
    CONSTRAINT  songsPlayed_airedShows_FK2
        FOREIGN KEY (showDate) REFERENCES airedShows (showDate)
);
