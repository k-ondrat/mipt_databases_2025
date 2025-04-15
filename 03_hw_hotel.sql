CREATE TABLE cd.members(
    memid          INTEGER                NOT NULL,
    surname        CHARACTER VARYING(200) NOT NULL,
    firstname      CHARACTER VARYING(200) NOT NULL,
    address        CHARACTER VARYING(300) NOT NULL,
    zipcode        INTEGER                NOT NULL,
    telephone      CHARACTER VARYING(20)  NOT NULL,
    recommendedby  INTEGER,
    joindate       TIMESTAMP              NOT NULL,
    
    CONSTRAINT members_pk PRIMARY KEY (memid),
    
    CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
        REFERENCES cd.members(memid) ON DELETE SET NULL
);

CREATE TABLE cd.facilities(
   facid               INTEGER                NOT NULL, 
   name                CHARACTER VARYING(100) NOT NULL, 
   membercost          NUMERIC                NOT NULL, 
   guestcost           NUMERIC                NOT NULL, 
   initialoutlay       NUMERIC                NOT NULL, 
   monthlymaintenance  NUMERIC                NOT NULL, 
   
   CONSTRAINT facilities_pk PRIMARY KEY (facid)
);

CREATE TABLE cd.bookings(
   bookid     INTEGER   NOT NULL, 
   facid      INTEGER   NOT NULL, 
   memid      INTEGER   NOT NULL, 
   starttime  TIMESTAMP NOT NULL,
   slots      INTEGER   NOT NULL,
   
   CONSTRAINT bookings_pk PRIMARY KEY (bookid),
   
   CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
   
   CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
);

-- Заполнение таблицы members
INSERT INTO cd.members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) VALUES
(0, 'GUEST', 'GUEST', 'GUEST', 0, '0000000000', NULL, '2012-07-01 00:00:00'),
(1, 'Smith', 'John', '123 Main St', 12345, '555-1234', NULL, '2012-07-02 12:02:05'),
(2, 'Johnson', 'Mary', '456 Oak Ave', 23456, '555-2345', 1, '2012-07-03 10:15:30'),
(3, 'Williams', 'David', '789 Pine Rd', 34567, '555-3456', 1, '2012-07-04 14:45:00'),
(4, 'Brown', 'Sarah', '321 Elm St', 45678, '555-4567', 2, '2012-07-05 09:30:15'),
(5, 'Jones', 'Michael', '654 Maple Dr', 56789, '555-5678', 2, '2012-07-06 11:20:45'),
(6, 'Garcia', 'Emily', '987 Cedar Ln', 67890, '555-6789', 3, '2012-07-07 16:10:00'),
(7, 'Miller', 'Robert', '135 Birch Blvd', 78901, '555-7890', 4, '2012-07-08 13:25:30'),
(8, 'Davis', 'Jennifer', '246 Spruce Way', 89012, '555-8901', 5, '2012-07-09 15:40:15'),
(9, 'Rodriguez', 'Thomas', '369 Willow Ct', 90123, '555-9012', 6, '2012-07-10 10:05:45'),
(10, 'Martinez', 'Lisa', '482 Aspen Pl', 01234, '555-0123', 7, '2012-07-11 17:30:00');

-- Заполнение таблицы facilities
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) VALUES
(0, 'Tennis Court 1', 5, 25, 10000, 200),
(1, 'Tennis Court 2', 5, 25, 8000, 200),
(2, 'Badminton Court', 0, 15.5, 4000, 50),
(3, 'Table Tennis', 0, 5, 320, 10),
(4, 'Massage Room 1', 35, 80, 4000, 3000),
(5, 'Massage Room 2', 35, 80, 4000, 3000),
(6, 'Squash Court', 3.5, 17.5, 5000, 80),
(7, 'Snooker Table', 0, 5, 450, 15),
(8, 'Pool Table', 0, 5, 400, 15);

-- Заполнение таблицы bookings
INSERT INTO cd.bookings (bookid, facid, memid, starttime, slots) VALUES
(0, 0, 1, '2012-07-03 09:00:00', 2),
(1, 0, 2, '2012-07-03 10:00:00', 2),
(2, 1, 3, '2012-07-03 11:00:00', 2),
(3, 1, 4, '2012-07-03 12:00:00', 2),
(4, 2, 5, '2012-07-03 13:00:00', 1),
(5, 2, 6, '2012-07-03 14:00:00', 1),
(6, 3, 7, '2012-07-03 15:00:00', 1),
(7, 3, 8, '2012-07-03 16:00:00', 1),
(8, 4, 9, '2012-07-03 17:00:00', 2),
(9, 4, 10, '2012-07-03 18:00:00', 2),
(10, 5, 1, '2012-07-04 09:00:00', 2),
(11, 5, 2, '2012-07-04 10:00:00', 2),
(12, 6, 3, '2012-07-04 11:00:00', 2),
(13, 6, 4, '2012-07-04 12:00:00', 2),
(14, 7, 5, '2012-07-04 13:00:00', 1),
(15, 7, 6, '2012-07-04 14:00:00', 1),
(16, 8, 7, '2012-07-04 15:00:00', 1),
(17, 8, 8, '2012-07-04 16:00:00', 1),
(18, 0, 9, '2012-07-04 17:00:00', 2),
(19, 0, 10, '2012-07-04 18:00:00', 2);

select count(*) over (),
	firstname, surname 
from cd.members
order by joindate 

select
    m.firstname,
    m.surname,
    COALESCE(ROUND(SUM(b.slots) * 0.5 / 10) * 10, 0) AS hours,
    DENSE_RANK() over (order by ROUND(SUM(b.slots) * 0.5 / 10) * 10 desc) as rank
from
    cd.members m
left join
    cd.bookings b on m.memid = b.memid
group by
    m.memid, m.firstname, m.surname
order by 
    rank, m.surname, m.firstname;

SELECT 
    f.name,
    CASE 
        WHEN NTILE(3) OVER (ORDER BY 
            SUM(CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
                    ELSE f.membercost * b.slots
               END) DESC) = 1 THEN 'high'
        WHEN NTILE(3) OVER (ORDER BY 
            SUM(CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
                    ELSE f.membercost * b.slots
               END) DESC) = 2 THEN 'average'
        ELSE 'low'
    END AS revenue
FROM 
    cd.facilities f
LEFT JOIN 
    cd.bookings b ON f.facid = b.facid
GROUP BY 
    f.name
ORDER BY 
    revenue,  -- Сначала high, потом average, потом low
    f.name;   -- Затем по названию объекта
    
select
    COALESCE(m.firstname, 'GUEST') as  firstname,
    COALESCE(m.surname, 'GUEST') as  surname,
    ROUND(SUM(b.slots) * 0.5, -1) as  hours,
    RANK() over  (order  by  ROUND(SUM(b.slots) * 0.5, -1) desc ) as  rank
from 
    cd.bookings b
    left  join cd.members m ON b.memid = m.memid
group  by 
    m.firstname,
    m.surname
order  by 
    rank,
    surname,
    firstname;

select 
    f.name,
    case NTILE(3) over (order by SUM(b.slots * f.membercost) desc)
        when 1 then 'high'
        when 2 then 'average'
        when 3 then 'low'
    end as revenue
from
    cd.facilities f
    join cd.bookings b on f.facid = b.facid
group by
	f.name
order  by 
    case NTILE(3) over (order by SUM(b.slots * f.membercost) desc)
        when 1 then 1
        when 2 then 2
        when 3 then 3
    end,
    f.name;

select name,
    rank
from (select
        f.name,
        RANK() over (order by SUM(b.slots * f.membercost) desc) as rank
    from
        cd.facilities f
        join cd.bookings b on f.facid = b.facid
    group by
        f.facid, f.name
) ranked
where rank <= 3
order by rank,
    name;



with facility_stats as (
    select 
        f.name,
        sum(
            case when b.memid = 0 then f.guestcost * b.slots
                 else f.membercost * b.slots
            end
        ) as total_revenue
    from 
        cd.facilities f
    left join 
        cd.bookings b on f.facid = b.facid
    group by 
        f.name
),
ranked_facilities as (
    select 
        name,
        total_revenue,
        ntile(3) over (order by total_revenue desc) as revenue_group
    from 
        facility_stats
)
select 
    name,
    case revenue_group
        when 1 then 'high'
        when 2 then 'average'
        when 3 then 'low'
    end as revenue
from 
    ranked_facilities
order by 
    revenue_group,
    name

    
select 
    f.name,
    rank() over (order by sum(
        case when b.memid = 0 then f.guestcost * b.slots
             else f.membercost * b.slots
        end
    ) desc) as rank
from 
    cd.facilities f
join 
    cd.bookings b on f.facid = b.facid
group by 
    f.name
order by 
    rank,
    f.name
limit 3;