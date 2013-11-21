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
    zipCode     CHAR(10)        NOT NULL
);

CREATE TABLE djs
(
    stageName   VARCHAR(20)     NOT NULL,
    eid         INTEGER         NOT NULL,
    
    CONSTRAINT djs_PK PRIMARY KEY (stageName),
    CONSTRAINT djs_employees_FK
        FOREIGN KEY (eid) REFERENCES employees(eid)
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
    tagline       VARCHAR(15)
);

CREATE TABLE spans
(
    beginDate       DATE            NOT NULL,
    endDate         DATE                    ,
    name            VARCHAR(20)     NOT NULL,
    stageName       VARCHAR(20)             ,
);

CREATE TABLE airedShows
(
    showTime        TIME            NOT NULL,
    showDate        DATE            NOT NULL,
    name            VARCHAR(20)             ,
);

CREATE TABLE artists
(
    aid             INTEGER         NOT NULL    AUTO_INCREMENT  ,
    fName           VARCHAR(20)     NOT NULL                    ,
    lName           VARCHAR(20)     NOT NULL                    ,
);

CREATE TABLE guestApperances
(
    showTime        TIME            NOT NULL,
    showDate        DATE            NOT NULL,
    aid             INTEGER                 ,
);

CREATE TABLE musicGenres
(
    genre           VARCHAR(15)     NOT NULL,
);

CREATE TABLE songs
(
    sid             INTEGER         NOT NULL    AUTO_INCREMENT  ,
    title           VARCHAR(20)     NOT NULL                    ,
    yearProduced    INTEGER         NOT NULL                    ,
    genre           VARCHAR(15)                                 ,
);

CREATE TABLE artistPerformances
(
    aid             INTEGER         NOT NULL,
    sid             INTEGER         NOT NULL,
);

CREATE TABLE songsPlayed
(
    sid             INTEGER         NOT NULL,
    showTime        TIME            NOT NULL,
    showDate        DATE            NOT NULL,
    playTime        TIME                    , -- The time length of each song 
);
