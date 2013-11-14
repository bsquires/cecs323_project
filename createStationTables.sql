--This file will be where the initialization
-- of our database tables will take place.

CREATE TABLE employees
{
    eid     INTEGER         NOT NULL AUTO_INCREMENT,
    eFname  VARCHAR(20)     NOT NULL,
    eLname  VARCHAR(20)     NOT NULL,
    dob     DATE            NOT NULL,
    salary  DOUBLE                  ,
}
