-- HOTEL MANAGEMENT ANALYSIS PROJECT

--CREATE DATABASE
CREATE DATABASE DB_HotelManagement;

-- CREATE TABLE dim_rooms
CREATE TABLE rooms(
	room_id varchar(10) primary key,
	room_class varchar(50)
);
-- CREATE TABLE dim_rooms
CREATE TABLE hotels(
	property_id varchar(100) primary key,
	property_name varchar(100),
	category varchar(100),
	city varchar(100)
);
-- CREATE TABLE fact_bookings
CREATE TABLE bookings(
	booking_id varchar(100) primary key,
	property_id	varchar(100),
	booking_date date,
	check_in_date date,
	checkout_date date,
	no_guests smallint,
	room_category varchar(10),
	booking_platform varchar(100),
	ratings_given float,
	booking_status varchar(50),
	revenue_generated float,
	revenue_realized float
	foreign key (property_id) references hotels(property_id),
	foreign key (room_category) references rooms(room_id)
);
-- CREATE TABLE fact_aggregated_bookings
CREATE TABLE aggregated_bookings(
	property_id	varchar(100),
	check_in_date date,
	room_category varchar(10),
	successful_bookings smallint,
	capacity smallint,
	primary key (property_id, check_in_date, room_category),
	foreign key (property_id) references hotels(property_id),
	foreign key (room_category) references rooms(room_id)
);