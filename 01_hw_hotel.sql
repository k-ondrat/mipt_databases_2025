CREATE TABLE facilities(
   facid               INTEGER                NOT NULL, 
   name                CHARACTER VARYING(100) NOT NULL, 
   membercost          NUMERIC                NOT NULL, 
   guestcost           NUMERIC                NOT NULL, 
   initialoutlay       NUMERIC                NOT NULL, 
   monthlymaintenance  NUMERIC                NOT NULL
);

INSERT INTO facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES
    (0, 'Tennis Court 1', 5, 25, 10000, 200),
    (1, 'Tennis Court 2', 5, 25, 10000, 200),
    (2, 'Badminton Court', 3, 15, 5000, 100),
    (3, 'Squash Court', 4, 20, 8000, 150),
    (4, 'Swimming Pool', 2, 10, 15000, 300),
    (5, 'Gym', 10, 30, 20000, 500),
    (6, 'Table Tennis', 1, 5, 1000, 50),
    (7, 'Massage Room 1', 20, 50, 3000, 100),
    (8, 'Massage Room 2', 20, 50, 3000, 100),
    (9, 'Sauna', 5, 15, 2000, 75);

select name,
    CASE
        WHEN monthlymaintenance > 100 THEN 'expensive'
        ELSE 'cheap'
    END AS cost
FROM cd.facilities
