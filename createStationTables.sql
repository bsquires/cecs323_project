--This file will be where the initialization
-- of our database tables will take place.

CREATE TABLE employees
(
    eid         INTEGER         NOT NULL AUTO_INCREMENT,
    eFname      VARCHAR(20)     NOT NULL,
    eLname      VARCHAR(20)     NOT NULL,
    dob         DATE            NOT NULL,
    salary      DOUBLE                  ,
    eStreet     VARCHAR(30)     NOT NULL,
    eCity       VARCHAR(20)     NOT NULL,
    eState      CHAR(20)        NOT NULL,
    eZipCode    CHAR(10)        NOT NULL
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
    shType      VARCHAR(15)     NOT NULL,
    
    CONSTRAINT  showTypes_PK    PRIMARY KEY (shType)
);

CREATE TABLE shows
(
    shName          VARCHAR(20) NOT NULL
    shDescription   VARCHAR(30),
    shType          VARCHAR(15),
    shTagline       VARCHAR(15)
);

CREATE TABLE spans
(
);

