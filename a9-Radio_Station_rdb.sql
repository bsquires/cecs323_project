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
zipCode 		CHAR(5) NOT NULL,
city    		VARCHAR(30) NOT NULL,
state		VARCHAR(20) NOT NULL,
CONSTRAINT zipCode_PK PRIMARY KEY (zipCode)
);


--Zipcodes shall update automatically in the employees table
--if a change is made in the zip codes table
CREATE TABLE employees
(
eid 			INTEGER NOT NULL AUTO_INCREMENT,
Fname		VARCHAR(30) NOT NULL,
Lname		VARCHAR(30) NOT NULL,
DOB			DATE,
Salary		FLOAT,
Street		VARCHAR(50) NOT NULL,
ZipCode		CHAR(5) NOT NULL,
CONSTRAINT employees_PK PRIMARY KEY (eid),
CONSTRAINT employess_zipCode_FK FOREIGN KEY (ZipCode) REFERENCES zipCodes(zipCode)
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
eid			INTEGER,
stageName		VARCHAR(20) NOT NULL,
CONSTRAINT DJs_PK PRIMARY KEY (stageName),
CONSTRAINT DJs_CK1 UNIQUE (eid),
CONSTRAINT DJs_employees_FK FOREIGN KEY (eid) REFERENCES employees(eid)
	ON DELETE SET NULL
	ON UPDATE CASCADE
);

CREATE TABLE shows
(
shid			INTEGER NOT NULL AUTO_INCREMENT, --surrogate key
name 		VARCHAR(75) NOT NULL,
description	VARCHAR(150),
type			ENUM('Talk Show', 'Top 40', 'Morning', 'Top 5 countdown', 'Weekend Special'),
tagline		VARCHAR(50),
CONSTRAINT shows_PK PRIMARY KEY(shid)
);

--No DELETE action is being taken on shows because there is no valid reason
--for a show to be removed from the Database. If a show is renamed, it will
--be treated as a new show so as to maintain record of the previous show which
--it replaced
CREATE TABLE AiredShows
(
shid			INTEGER NOT NULL,
showDate		DATE NOT NULL,
showTime		TIME NOT NULL,
CONSTRAINT AiredShows_PK PRIMARY KEY (showDate, showTime),
CONSTRAINT Airedshows_shows_FK FOREIGN KEY (shid) REFERENCES shows(shid)
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
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
CONSTRAINT ArtistPerformances_songs_fk FOREIGN KEY (sid) REFERENCES songs(sid) ON DELETE CASCADE,
CONSTRAINT ArtistPerformances_Artists_fk FOREIGN KEY(aid) REFERENCES Artists(aid) ON DELETE CASCADE
);

--GuestAppearances is a record of when an artist appears on the show
--This is a record of the interaction taking place. Again, as this is
--a record, no update is assumed. If an artist requests their information
--deleted from the DB the station will also remove the records of their appearences
CREATE TABLE GuestAppearances
(
showTime		TIME NOT NULL,
showDate		DATE NOT NULL,
aid			INTEGER NOT NULL,
CONSTRAINT GuestAppearances_PK PRIMARY KEY (showTime, showDate, aid),
CONSTRAINT GuestAppearances_Artists_FK FOREIGN KEY (aid) REFERENCES Artists(aid) ON DELETE CASCADE,
CONSTRAINT GuestAppearances__AiredShows_FK FOREIGN KEY (showDate, showTime) 
			REFERENCES AiredShows(showDate, showTime) ON DELETE CASCADE
);

--SongPlayed is a record of when a song is aired and on what show it was aired
--the record can be removed if an artist requests. This is a historical record,
--and as a result will not be updated
CREATE TABLE songPlayed
(
sid			INTEGER NOT NULL,
showTime		TIME NOT NULL,
showDate		DATE NOT NULL,
playTime		TIME,
CONSTRAINT songPlayed_PK PRIMARY KEY (sid, showDate, showTime),
CONSTRAINT songPlayed_songs_FK FOREIGN KEY (sid) REFERENCEs songs(sid) ON DELETE CASCADE,
CONSTRAINT songPlayed_AiredShows_FK FOREIGN KEY (showDate, showTime)
				REFERENCES AiredShows(showDate, showTime) ON DELETE CASCADE
);


--DJ names are assumed to be copyrighted by the station. As a result, we assume
--that they shall not be updated or deleted for historical purposes. The same
--is true for Shows and their respective names. Hence, no update or delete action
--is defined.
CREATE TABLE spans
(
stageName 	VARCHAR(20) NOT NULL,
beginDate		DATE	NOT NULL,
endDate		DATE NOT NULL,
showName		VARCHAR(30) NOT NULL,
shid			INTEGER NOT NULL,
CONSTRAINT spans_PK PRIMARY KEY (beginDate, showName),
CONSTRAINT spans_DJs_FK FOREIGN KEY (stageName) REFERENCES DJs(stageName)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
CONSTRAINT spans_shows_FK FOREIGN KEY (shid) REFERENCES shows(shid)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
);

INSERT INTO zipCodes VALUES 
('92708', 'Fountain Valley', 'CA'),
('90445', 'Los Angeles', 'CA'),
('90210', 'Beverly Hills', 'CA'),
('11561', 'Long Beach', 'CA'),
('90620', 'Buena Park', 'CA');

INSERT INTO Employees(Fname,Lname,DOB,Salary,Street,ZipCode)
VALUES
	('Beau', 'Squires', '1984-02-23', 100000, '1234 YoMama St', '92708'),
	('David','Smith','1983-02-05',40000,'7285 Rose Blvd','90445'),
	('John','Smith','1984-06-19',38000,'7832 Rose Blvd','90445'),
	('Nancy','Adams','1988-03-27',25000,'285 Mountain Loop','90210'),
	('Diana','Maples','1973-10-29',45000,'1923 Feline Dr','90620'),
	('David','Chan','1990-12-30',20000,'73913 Main St','11561'),
	('Rocky', 'Mociano', '1912-11-14', 150000, '663 Boxer Lane', '11561'),
	('Jerry', 'Springer', '1945-04-26', 13000, '624 Scoundrel Lane', '92708');

INSERT INTO DJs(eid,StageName)
VALUES
	((SELECT eid FROM Employees WHERE Fname = 'John' AND Lname = 'Smith' AND DOB = '1984-06-19'),'Wolfman'),
	((SELECT eid FROM Employees WHERE Fname = 'David' AND Lname = 'Chan' AND DOB = '1990-12-30'),'New Kid'),
	((SELECT eid FROM Employees WHERE Fname = 'Diana' AND Lname = 'Maples' AND DOB = '1973-10-29'),'Queen B'),
	((SELECT eid FROM Employees WHERE Fname = 'David' AND Lname = 'Smith' AND DOB = '1983-02-05'),'Mix Master'),
	((SELECT eid FROM Employees WHERE Fname = 'Nancy' AND Lname = 'Adams' AND DOB = '1988-03-27'),'Lola'),
	((SELECT eid FROM Employees WHERE Fname = 'Jerry' AND Lname = 'Springer' AND DOB = '1945-04-26'), 'Dirt Bag');

INSERT INTO shows
VALUES
	(NULL, 'Afternoon Talk', 'An Afternoon talk show', 'Talk Show', 'What is on your mind?'),
	(NULL, 'Top 40 countdown', 'The top 40 songs out now.', 'Top 40', 'What is hot?!'),
	(NULL, 'The Ken and Bear show', 'A mix of talk and how music', 'Morning', 'Comin at ya in the mornin!'),
	(NULL, 'The Five at Five', 'A countdown of the top 5 on the billboard', 'Top 5 countdown', 'Music for your drive home!'),
	(NULL, 'Mystery Theatre', 'Mystery stories for your weekend delight', 'Weekend Special', 'Who dunnit?');

INSERT INTO spans
VALUES
	('Wolfman', '2008-01-01', '2012-12-31', 'Afternoon Talk', (SELECT shid FROM shows WHERE name = 'Afternoon Talk')),
	('Mix Master', '2008-06-01', '2012-12-31', 'Afternoon Talk', (SELECT shid FROM shows WHERE name = 'Afternoon Talk')),
	('Queen B', '2010-01-01', '2011-12-31', 'The Five at Five', (SELECT shid FROM shows WHERE name = 'The Five at Five')),
	('Mix Master', '2005-01-01', '2008-07-01', 'Top 40 countdown',(SELECT shid FROM shows WHERE name = 'Top 40 countdown')),
	('Lola', '2003-06-01', '2007-07-01', 'The Ken and Bear show', (SELECT shid FROM shows WHERE name = 'The Ken and Bear show')),
	('New Kid', '1994-01-01', '2020-12-31', 'Mystery Theatre', (SELECT shid FROM shows WHERE name = 'Mystery Theatre'));

INSERT INTO AiredShows (shid, showTime, showDate)
VALUES
	((SELECT shid FROM shows WHERE name = 'The Five at Five'),'18:00:00','2013-11-15'),
	((SELECT shid FROM shows WHERE name = 'Afternoon Talk'),'20:00:00','2013-11-16'),
	((SELECT shid FROM shows WHERE name = 'Mystery Theatre'),'23:00:00','2013-11-19'),
	((SELECT shid FROM shows WHERE name = 'Top 40 countdown'),'07:00:00','2013-11-19'),
	((SELECT shid FROM shows WHERE name = 'Top 40 countdown'),'09:00:00','2013-11-22'),
	((SELECT shid FROM shows WHERE name = 'The Ken and Bear show'),'12:00:00','2013-11-11'),
	((SELECT shid FROM shows WHERE name = 'The Ken and Bear show'),'12:00:00','2013-12-11');


INSERT INTO artists(fName,lName)
VALUES
('Michael','Jackson'),
('Katy','Perry'),
('Jason','Mraz'),
('Tupac', 'Shakur'),
('Justin','Timberlake'),
('Curt', 'Cobain'),
('Bob', ' Dillain'),
('Freddy', 'Mercury'),
('Jimmy', 'Hendrix');

INSERT INTO songs(title,yearProduced,genre)
VALUES
('Beat it', '1982-01-01','Rock'),
('Life Goes On', '1996-02-15', 'Rap/Hiphop'),
('Cry Me A River', '2002-04-23', 'Pop'),
('I''m Yours','2008-04-15','Pop'),
('California Gurls','2010-04-22','Pop'),
('Crosstown Traffic', '1968-04-16','Rock'),
('The Wind Cries Mary', '1967-05-15', 'Rock');

INSERT INTO GuestAppearances(showTime,showDate,aid)
VALUES
('12:00:00','2013-11-11', (SELECT aid FROM artists WHERE fName = 'Justin' AND lName = 'Timberlake')),
('07:00:00','2013-11-19', (SELECT aid FROM artists WHERE fName = 'Jason' AND lName = 'Mraz')),
('23:00:00','2013-11-19', (SELECT aid FROM artists WHERE fName = 'Jason' AND lName = 'Mraz')),
('18:00:00','2013-11-15', (SELECT aid FROM artists WHERE fName = 'Katy' AND lName = 'Perry')),
('20:00:00','2013-11-16', (SELECT aid FROM artists WHERE fName = 'Katy' AND lName = 'Perry'));

INSERT INTO songPlayed(sid,showTime,showDate,playTime)
VALUES
((SELECT sid FROM songs WHERE title = 'Life Goes On' AND yearProduced =  '1996-02-15'), '12:00:00','2013-12-11', '00:02:30'),
((SELECT sid FROM songs WHERE title = 'Beat it' AND yearProduced = '1982-01-01'), '12:00:00','2013-12-11', '00:03:30'),
((SELECT sid FROM songs WHERE title = 'Beat it' AND yearProduced = '1982-01-01'), '07:00:00','2013-11-19', '00:03:30'),
((SELECT sid FROM songs WHERE title = 'California Gurls' AND yearProduced = '2010-04-22'), '18:00:00', '2013-11-15', '00:04:00'),
((SELECT sid FROM songs WHERE title = 'Beat it' AND yearProduced = '1982-01-01'), '12:00:00', '2013-11-11', '00:03:30'),
((SELECT sid FROM songs WHERE title = 'Cry Me A River' AND yearProduced = '2002-04-23'), '20:00:00', '2013-11-16', '00:03:00'),
((SELECT sid FROM songs WHERE title = 'Life Goes On' AND yearProduced =  '1996-02-15'), '07:00:00','2013-11-19', '00:02:30');

INSERT INTO ArtistPerformances (sid, aid)
VALUES
((SELECT sid FROM songs WHERE title = 'Beat it' AND yearProduced = '1982-01-01'), (SELECT aid FROM Artists WHERE Fname = 'Michael' AND Lname = 'Jackson')),
((SELECT sid FROM songs WHERE title = 'California Gurls' AND yearProduced = '2010-04-22'), (SELECT aid FROM Artists WHERE Fname = 'Justin' AND Lname = 'Timberlake')),
((SELECT sid FROM songs WHERE title = 'I''m Yours' AND yearProduced = '2008-04-15'), (SELECT aid FROM Artists WHERE Fname = 'Jason' AND Lname = 'Mraz')),
((SELECT sid FROM songs WHERE title = 'Cry Me A River' AND yearProduced = '2002-04-23'),(SELECT aid FROM Artists WHERE Fname = 'Katy' AND Lname = 'Perry')),
((SELECT sid FROM songs WHERE title = 'Life Goes On' AND yearProduced =  '1996-02-15'),(SELECT aid FROM Artists WHERE Fname = 'Tupac' AND Lname = 'Shakur')),
((SELECT sid FROM songs WHERE title = 'Crosstown Traffic' AND yearProduced = '1968-04-16'),(SELECT aid FROM Artists WHERE Fname = 'Jimmy' AND Lname = 'Hendrix')),
((SELECT sid FROM songs WHERE title = 'The Wind Cries Mary' AND yearProduced = '1967-05-15'),(SELECT aid FROM Artists WHERE Fname = 'Jimmy' AND Lname = 'Hendrix'));


SELECT * FROM employees;

INSERT INTO employees VALUES
(NULL, 'Jerry', 'Springer', '1945-04-26', 13000, '624 Scoundrel Lane', '92708');

--1 Name the songs and the performing artist of those songs of the genre that gets played on the air the most
SELECT s.title AS 'Song Title', CONCAT(A.fname,' ',A.lname) AS 'Performer', s.genre
FROM songs s NATURAL JOIN ArtistPerformances ap NATURAL JOIN Artists a
WHERE genre = (SELECT genre
				FROM songs NATURAL JOIN songPlayed
					GROUP BY genre
					HAVING COUNT(sid) >= ALL (SELECT COUNT(sid) 
											FROM songs NATURAL JOIN songPlayed
											GROUP BY genre));

--2 list artists that have songs played, but never been a guest
SELECT CONCAT(A.fname, ' ', A.lname) AS 'Artist'
FROM ARTISTS A 
WHERE A.aid IN (SELECT aid FROM ArtistPerformances)
	AND A.aid NOT IN (SELECT aid FROM GuestAppearances);
--equivolent
SELECT CONCAT(A.fname, ' ', A.lname) AS 'Artist'
FROM ARTISTS A 
WHERE EXISTS (SELECT * FROM ArtistPerformances AP WHERE ap.aid=A.aid)
	AND NOT EXISTS (SELECT * FROM GuestAppearances G where G.aid = A.aid);
	
--3 List all employees who make more then $15,000. If they are DJ's, include
-- their DJ name and the number of shows they have ever hosted.

SELECT CONCAT(e.fname, ' ',e.lname) AS 'Employee', d.StageName AS 'DJ name',  salary, COUNT(sh.name) as 'Number of Shows'
FROM employees e LEFT OUTER JOIN DJs d ON e.eid = d.eid
			  LEFT OUTER JOIN spans sp on d.StageName = sp.StageName
			  LEFT OUTER JOIN shows sh on sh.shid = sp.shid
			WHERE e.salary >= 15000
			GROUP BY CONCAT(e.fname, ' ',e.lname)

--4 List all the songs that the radio station plays

---- 2.NAME THE SHOW THAT HAS THE MOST GUEST APPEARANCES AND LIST THOSE ARTISTS
SELECT name, fName, lName 
FROM Shows INNER JOIN AiredShows ON Shows.name = AiredShows.showName
NATURAL JOIN GuestAppearances
NATURAL JOIN ARTISTS
GROUP BY name

------------5.NAME THE OLDEST DJ THAT HOSTED THE LONGEST RUNNING SHOW AND DISPLAY THE SHOW NAME
SELECT fName, lName, name
FROM Employess NATURAL JOIN DJs NATURAL JOIN Spans NATURAL JOIN SHOWS
GROUP BY SHOWS.name
HAVING MAX (SELECT COUNT(SELECT DATEDIFF(endDate, beginDate))