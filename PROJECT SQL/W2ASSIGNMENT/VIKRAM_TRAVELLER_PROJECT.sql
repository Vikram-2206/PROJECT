
# 1. Creating the schema and required tables using MySQL workbench
# a. Create a schema named Travego and create the tables mentioned above with the mentioned
# column names. Also, declare the relevant datatypes for each feature/column in the dataset.
# b. Insert the data in the newly created tables.

create database Travego;
use Travego;

create table Passenger (
    id int primary key,
    name  varchar(255),
    category varchar(10),
    gender char(1),
    boarding_city varchar(255),
    destination_city varchar(255),
    distance int,
    bus_type varchar(10)
);

insert into Passenger (id, name, category, gender, boarding_city, destination_city, distance, bus_type)
values
(1, 'Sejal', 'AC', 'F', 'Bengaluru', 'Chennai', 350, 'Sleeper'),
(2, 'Anmol', 'Non-AC', 'M', 'Mumbai', 'Hyderabad', 700, 'Sitting'),
(3, 'Pallavi', 'AC', 'F', 'Panaji', 'Bengaluru', 600, 'Sleeper'),
(4, 'Khusboo', 'AC', 'F', 'Chennai', 'Mumbai', 1500, 'Sleeper'),
(5, 'Udit', 'Non-AC', 'M', 'Trivandrum', 'Panaji', 1000, 'Sleeper'),
(6, 'Ankur', 'AC', 'M', 'Nagpur', 'Hyderabad', 500, 'Sitting'),
(7, 'Hemant', 'Non-AC', 'M', 'Panaji', 'Mumbai', 700, 'Sleeper'),
(8, 'Manish', 'Non-AC', 'M', 'Hyderabad', 'Bengaluru', 500, 'Sitting'),
(9, 'Piyush', 'AC', 'M', 'Pune', 'Nagpur', 700, 'Sitting');

select * from Passenger;

create table Price (
    id int primary key,
    bus_type varchar(10),
    distance int,
    price int
);
insert into Price (id, bus_type, distance, price)
values
(1, 'Sleeper', 350, 770),
(2, 'Sleeper', 500, 1100),
(3, 'Sleeper', 600, 1320),
(4, 'Sleeper', 700, 1540),
(5, 'Sleeper', 1000, 2200),
(6, 'Sleeper', 1200, 2640),
(7, 'Sleeper', 1500, 2700),
(8, 'Sitting', 500, 620),
(9, 'Sitting', 600, 744),
(10, 'Sitting', 700, 868),
(11, 'Sitting', 1000, 1240),
(12, 'Sitting', 1200, 1488),
(13, 'Sitting', 1500, 1860);

select * from Price;

# 2. (Medium) Perform read operation on the designed table created in the above task.
# a. How many female passengers traveled a minimum distance of 600 KMs?

select count(*) as FemalePassengers
from Passenger
where gender = 'F' and distance >= 600;

# b. Write a query to display the passenger details whose travel distance is greater than 500 and
# who are traveling in a sleeper bus.

select *
from Passenger
where distance > 500 and bus_type = 'Sleeper';

# c. Select passenger names whose names start with the character 'S'
select name
from Passenger
where name like 'S%';

# d. Calculate the price charged for each passenger, displaying the Passenger name, Boarding City,
# Destination City, Bus type, and Price in the output.

select
    p.name as PassengerName,
    p.boarding_city as BoardingCity,
    p.destination_city as DestinationCity,
    p.bus_type as BusType,
    pr.price as Price
from
    Passenger p
join
    Price pr on p.bus_type = pr.bus_type and p.distance = pr.distance;



#e. What are the passenger name(s) and the ticket price for those who traveled 1000 KMs Sitting in
#a bus?

select
    p.name as PassengerName,
    pr.price as TicketPrice
from
    Passenger p
JOIN
    Price pr on p.bus_type = pr.bus_type and p.distance = pr.distance
where
    p.distance > 1000 and p.bus_type = 'Sitting';
    

#f. What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji? (5
#marks

select * from Passenger where name = 'Pallavi';
   
    
# g. Alter the column category with the value "Non-AC" where the Bus_Type is sleeper

update Passenger
set category = 'Non-AC'
where bus_type = 'Sleeper';

# h. Delete an entry from the table where the passenger name is Piyush and commit this change in
# the database.

-- Delete the entry
delete from Passenger
where name = 'Piyush';

-- Commit the change
commit;

# i. Truncate the table passenger and comment on the number of rows in the table (explain if
# required). 

-- Truncate the table
truncate table Passenger;

-- Optional: Comment on the number of rows
-- The number of rows in  table  0 after truncate.

# j. Delete the table passenger from the database.


drop table Passenger;



