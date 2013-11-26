--RadioStation DataBase
--Beau Squires
--Edwin Lopez
--Atit Day
--Kanghyeon Bae

--NOTE: UML Diagram outlines Enumeration tables
--Due to the limited number of enums, our database
--has been altered from the UML Diagram to use the enum
--data type in place of the additional tables

DROP TABLE ArtistPerformances;
DROP TABLE SongPlayed;
DROP TABLE GuestAppearances;
DROP TABLE AiredShows;
DROP TABLE songs;
DROP TABLE Artists;
DROP TABLE spans;
DROP TABLE DJs;
DROP TABLE employees;
DROP TABLE shows;
DROP TABLE zipCodes;


CREATE TABLE zipCodes
(
    zipCode 		CHAR(5)     NOT NULL,
    city    		VARCHAR(30) NOT NULL,
    state		    VARCHAR(20) NOT NULL,
    
    CONSTRAINT  zipCode_PK PRIMARY KEY (zipCode)
);


--Zipcodes shall update automatically in the employees table
--if a change is made in the zip codes table
CREATE TABLE employees
(
    eid 		INTEGER NOT NULL AUTO_INCREMENT,
    Fname		VARCHAR(30) NOT NULL,
    Lname		VARCHAR(30) NOT NULL,
    DOB			DATE,
    Salary		FLOAT,
    Street		VARCHAR(50) NOT NULL,
    ZipCode		CHAR(5) NOT NULL,
    
    CONSTRAINT employees_PK PRIMARY KEY (eid),
    CONSTRAINT employess_zipCode_FK 
        FOREIGN KEY (ZipCode) REFERENCES zipCodes(zipCode)
	    ON UPDATE CASCADE,
    CONSTRAINT employees_CK1 UNIQUE (Fname, Lname, DOB),
    CONSTRAINT employees_CK2 UNIQUE (Fname, Lname, Street, ZipCode)
);

--eid is being set to null so we can maintain record of what DJ's hosted
--what shows assuming the actual employee leaves the station and wants
--their information removed
--No update action is taken as a an eid should remain static unless an employee
--requests their information removed from the DB entirely
CREATE TABLE DJs
(
    eid 			INTEGER,
    stageName		VARCHAR(20) NOT NULL,

    CONSTRAINT DJs_PK PRIMARY KEY (stageName),
    CONSTRAINT DJs_employees_FK 
        FOREIGN KEY (eid) REFERENCES employees(eid)
	    ON DELETE SET NULL
);

CREATE TABLE shows
(
    name 		VARCHAR(75) NOT NULL,
    description	VARCHAR(150),
    type			ENUM('Talk Show', 'Top 40', 'Morning', 'Top 5 countdown', 'Weekend Special'),
    tagline		VARCHAR(50),
    CONSTRAINT shows_PK PRIMARY KEY(name)
);

--No DELETE action is being taken on shows because there is no valid reason
--for a show to be removed from the Database. If a show is renamed, it will
--be treated as a new show so as to maintain record of the previous show which
--it replaced
CREATE TABLE AiredShows
(
    showName 		VARCHAR(30) NOT NULL,
    showDate		DATE NOT NULL,
    showTime		TIME NOT NULL,
    
    CONSTRAINT AiredShows_PK PRIMARY KEY (showDate, showTime),
    CONSTRAINT Airedshows_shows_FK 
        FOREIGN KEY (showName) REFERENCES shows(name)
);

CREATE TABLE songs
(
    sid			INTEGER NOT NULL AUTO_INCREMENT,
    title		VARCHAR(50) NOT NULL,
    yearProduced	DATE NOT NULL,
    genre		ENUM('Pop', 'Rock', 'Rap/hiphop', 'R&B', 'Country','Alternative',
					'Heavy Metal', 'Trance/Techno'),
    CONSTRAINT songs_PK PRIMARY KEY (sid),
    CONSTRAINT songs_CK UNIQUE (title, yearProduced)
);


CREATE TABLE Artists
(
    aid 			INTEGER NOT NULL AUTO_INCREMENT,
    Fname		VARCHAR(30) NOT NULL,
    Lname		VARCHAR(30) NOT NULL,
    
    CONSTRAINT Artists_PK PRIMARY KEY (aid),
    CONSTRAINT Artists_CK UNIQUE (Fname, Lname)
);

--ArtistPerformances are a record of what artist(s) performed what song(s)
--No update action is taken as both aid and sid are assumed to remain static
--The only action assumed to take place is an artist requesting their information
--or song be removed from our database
CREATE TABLE ArtistPerformances
(
    aid			INTEGER NOT NULL,
    sid			INTEGER NOT NULL,
    
    CONSTRAINT ArtistPerformances_PK PRIMARY KEY (aid, sid),
    CONSTRAINT ArtistPerformances_songs_fk 
        FOREIGN KEY (sid) REFERENCES songs(sid) 
        ON DELETE CASCADE,
    CONSTRAINT ArtistPerformances_Artists_fk 
        FOREIGN KEY(aid) REFERENCES Artists(aid) 
        ON DELETE CASCADE
);

--GuestAppearances is a record of when an artist appears on the show
--This is a record of the interaction taking place. Again, as this is
--a record, no update is assumed. If an artist requests their information
--deleted from the DB the station will also remove the records of their appearences
CREATE TABLE GuestAppearances
(
    showTime		TIME NOT NULL,
    showDate		DATE NOT NULL,
    aid	    		INTEGER NOT NULL,
    
    CONSTRAINT GuestAppearances_PK PRIMARY KEY (showTime, showDate, aid),
    CONSTRAINT GuestAppearances_Artists_FK 
        FOREIGN KEY (aid) REFERENCES Artists(aid) 
        ON DELETE CASCADE,
    CONSTRAINT GuestAppearances__AiredShows_FK 
        FOREIGN KEY (showDate, showTime) REFERENCES AiredShows(showDate, showTime) 
        ON DELETE CASCADE
);

--SongPlayed is a record of when a song is aired and on what show it was aired
--the record can be removed if an artist requests. This is a historical record,
--and as a result will not be updated
CREATE TABLE songsPlayed
(
    sid 			INTEGER NOT NULL,
    showTime		TIME NOT NULL,
    showDate		DATE NOT NULL,
    playTime		TIME,
    
    CONSTRAINT songsPlayed_PK PRIMARY KEY (sid, showDate, showTime, playTime),
    CONSTRAINT songsPlayed_songs_FK
        FOREIGN KEY (sid) REFERENCEs songs(sid) 
        ON DELETE CASCADE,
    CONSTRAINT songsPlayed_AiredShows_FK 
        FOREIGN KEY (showDate, showTime) REFERENCES AiredShows(showDate, showTime)
        ON DELETE CASCADE
);


--DJ names are assumed to be copyrighted by the station. As a result, we assume
--that they shall not be updated or deleted for historical purposes. The same
--is true for Shows and their respective names. Hence, no update or delete action
--is defined.
CREATE TABLE spans
(
    stageName   	VARCHAR(20) NOT NULL,
    beginDate		DATE	NOT NULL,
    endDate 		DATE NOT NULL,
    showName		VARCHAR(30) NOT NULL,
    
    CONSTRAINT spans_PK PRIMARY KEY (beginDate, showName),
    CONSTRAINT spans_DJs_FK 
        FOREIGN KEY (stageName) REFERENCES DJs(stageName),
    CONSTRAINT spans_shows_FK 
        FOREIGN KEY (showName) REFERENCES shows(name)
);

INSERT INTO zipCodes VALUES 
('92708', 'Fountain Valley', 'CA'),
('90445', 'Los Angeles', 'CA'),
('90210', 'Beverly Hills', 'CA'),
('11561', 'Long Beach', 'CA'),
('90620', 'Buena Park', 'CA');

INSERT INTO Employees(Fname,Lname,DOB,Salary,Street,ZipCode)
VALUES
	('Beau', 'Squires', '1984-02-23', '100000', '1234 YoMama St', '92708'),
	('David','Smith','1983-02-05','40000','7285 Rose Blvd','90445'),
	('John','Smith','1984-06-19','38000','7832 Rose Blvd','90445'),
	('Nancy','Adams','1988-03-27','25000','285 Mountain Loop','90210'),
	('Diana','Maples','1973-10-29','45000','1923 Feline Dr','90620'),
	('David','Chan','1990-12-30','20000','73913 Main St','11561');

INSERT INTO DJs(eid,StageName)
VALUES
	((SELECT eid FROM Employees WHERE Fname = 'John' AND Lname = 'Smith' AND DOB = '1984-06-19'),'Wolfman'),
	((SELECT eid FROM Employees WHERE Fname = 'David' AND Lname = 'Chan' AND DOB = '1990-12-30'),'New Kid'),
	((SELECT eid FROM Employees WHERE Fname = 'Diana' AND Lname = 'Maples' AND DOB = '1973-10-29'),'Queen B'),
	((SELECT eid FROM Employees WHERE Fname = 'David' AND Lname = 'Smith' AND DOB = '1983-02-05'),'Mix Master'),
	((SELECT eid FROM Employees WHERE Fname = 'Nancy' AND Lname = 'Adams' AND DOB = '1988-03-27'),'Lola');

INSERT INTO shows
VALUES
	('Afternoon Talk', 'An Afternoon talk show', 'Talk Show', 'What is on your mind?'),
	('Top 40 countdown', 'The top 40 songs out now.', 'Top 40', 'What is hot?!'),
	('The Ken and Bear show', 'A mix of talk and how music', 'Morning', 'Comin at ya in the mornin!'),
	('The Five at Five', 'A countdown of the top 5 on the billboard', 'Top 5 countdown', 'Music for your drive home!'),
	('Mystery Theatre', 'Mystery stories for your weekend delight', 'Weekend Special', 'Who dunnit?');

INSERT INTO spans
VALUES
	('Wolfman', '2008-01-01', '2012-12-31', 'Afternoon Talk'),
	('Queen B', '2010-01-01', '2011-12-31', 'The Five at Five'),
	('Mix Master', '2005-01-01', '2008-07-01', 'Top 40 countdown'),
	('Lola', '2003-06-01', '2007-07-01', 'The Ken and Bear show'),
	('New Kid', '1994-01-01', '2020-12-31', 'Mystery Theatre');

INSERT INTO AiredShows (showName, showTime, showDate)
VALUES
	('The Five at Five', '18:00:00','2013-11-15'),
	('Afternoon Talk', '20:00:00','2013-11-16'),
	('Mystery Theatre', '23:00:00','2013-11-19'),
	('Top 40 countdown', '07:00:00','2013-11-19'),
	('The Ken and Bear show', '12:00:00','2013-11-11');


INSERT INTO artists(fName,lName)
VALUES
('Michael','Jackson'),
('Katy','Perry'),
('Jason','Mraz'),
('Tupac', 'Shakur'),
('Justin','Timberlake');

INSERT INTO songs(title,yearProduced,genre)
VALUES
('Beat it', '1982-01-01','Rock'),
('Life Goes On', '1996-02-15', 'Rap/Hiphop'),
('Cry Me A River', '2002-04-23', 'Pop'),
('I''m Yours','2008-04-15','Pop'),
('California Gurls','2010-04-22','Pop');

INSERT INTO GuestAppearances(showTime,showDate,aid)
VALUES
('12:00:00','2013-11-11', (SELECT aid FROM artists WHERE fName = 'Justin' AND lName = 'Timberlake')),
('07:00:00','2013-11-19', (SELECT aid FROM artists WHERE fName = 'Jason' AND lName = 'Mraz')),
('23:00:00','2013-11-19', (SELECT aid FROM artists WHERE fName = 'Jason' AND lName = 'Mraz')),
('18:00:00','2013-11-15', (SELECT aid FROM artists WHERE fName = 'Katy' AND lName = 'Perry')),
('20:00:00','2013-11-16', (SELECT aid FROM artists WHERE fName = 'Katy' AND lName = 'Perry'));

INSERT INTO songsPlayed(sid,showTime,showDate,playTime)
VALUES
((SELECT sid FROM songs WHERE title = 'Beat it' AND yearProduced = '1982-01-01'), '18:00:00', '2013-11-15', '00:03:30'),
((SELECT sid FROM songs WHERE title = 'California Gurls' AND yearProduced = '2010-04-22'), '18:00:00', '2013-11-15', '00:04:00'),
((SELECT sid FROM songs WHERE title = 'Beat it' AND yearProduced = '1982-01-01'), '12:00:00', '2013-11-11', '00:03:30'),
((SELECT sid FROM songs WHERE title = 'Cry Me A River' AND yearProduced = '2002-04-23'), '20:00:00', '2013-11-16', '00:03:00'),
((SELECT sid FROM songs WHERE title = 'Life Goes On' AND yearProduced =  '1996-02-15'), '07:00:00', '2013-11-19', '00:02:30');

INSERT INTO ArtistPerformances (sid, aid)
VALUES
((SELECT sid FROM songs WHERE title = 'Beat it' AND yearProduced = '1982-01-01'), (SELECT aid FROM Artists WHERE Fname = 'Michael' AND Lname = 'Jackson')),
((SELECT sid FROM songs WHERE title = 'California Gurls' AND yearProduced = '2010-04-22'), (SELECT aid FROM Artists WHERE Fname = 'Justin' AND Lname = 'Timberlake')),
((SELECT sid FROM songs WHERE title = 'I''m Yours' AND yearProduced = '2008-04-15'), (SELECT aid FROM Artists WHERE Fname = 'Jason' AND Lname = 'Mraz')),
((SELECT sid FROM songs WHERE title = 'Cry Me A River' AND yearProduced = '2002-04-23'),(SELECT aid FROM Artists WHERE Fname = 'Katy' AND Lname = 'Perry')),
((SELECT sid FROM songs WHERE title = 'Life Goes On' AND yearProduced =  '1996-02-15'),(SELECT aid FROM Artists WHERE Fname = 'Tupac' AND Lname = 'Shakur'));

