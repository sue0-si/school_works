-- CS4400: Introduction to Database Systems: Wednesday, March 8, 2023
-- Flight Management Course Project Mechanics (v1.0) STARTING SHELL
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

use flight_management;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like skids or some number
of engines.  Finally, an airplane must have a database-wide unique location if
it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_skids boolean, in ip_propellers integer,
    in ip_jet_engines integer)
sp_main: begin
	if ip_seat_capacity <= 0 and ip_speed <= 0 and ip_airlineID in(select airlineID from airline) then leave sp_main; end if;
    insert INTO airplane VALUES (ip_airlineID,ip_tail_num ,ip_seat_capacity,ip_speed ,ip_locationID ,ip_plane_type ,ip_skids ,ip_propellers , ip_jet_engines);
end //
delimiter ;



-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a database-wide unique location if it will be used to support
airplane takeoffs and landings.  An airport may have a longer, more descriptive
name.  An airport must also have a city and state designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state char(2), in ip_locationID varchar(50))
sp_main: begin
	-- INSERT INTO airport VALUES (ip_airportID,ip_airport_name,ip_city,​​ip_state,ip_locationID);
    Declare valid boolean default true;
    
    if (select count(*) from airport where airportID = ip_airportID) > 0 then
		leave sp_main;
	end if;
    
    if (select count(*) from location where locationID = ip_locationID) > 0 then 
		leave sp_main;
	end if;
    
    if ip_city = null or ip_state = null then
		leave sp_main;
	end if;
    
    insert into airport (airportID, airport_name, city, state, locationID) values 
		(ip_airportID, ip_airport_name, ip_city, ip_state, ip_locationID);
end //
delimiter ;

-- CALL
-- call add_airport('SJC', 'San Jose Mineta International Airport','San Jose', 'CA', null);

-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person may have a first and last name as well.

Also, a person can hold a pilot role, a passenger role, or both roles.  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  Also,
a pilot might be assigned to a specific airplane as part of the flight crew.  As a
passenger, a person will have some amount of frequent flyer miles. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_flying_airline varchar(50), in ip_flying_tail varchar(50),
    in ip_miles integer)
sp_main: begin
	if ip_personID = null or ip_personID in (select personID from person)
		then leave sp_main;
	end if;
    if ip_locationID = null or ip_locationID not in (select locationID from location) then
		leave sp_main;
    end if;
    if ip_first_name = null then leave sp_main; end if;
    insert into person (personID, first_name, last_name, locationID) values 
		(ip_personID, ip_first_name, ip_last_name, ip_locationID);
	if ip_taxID is not null and ip_taxID not in (select taxID from pilot) then
		if ip_flying_airline is not null and ip_flying_airline not in (select airlineID from airplane) then
			if ip_miles is not null then
				insert into passenger (personID, miles) values 
				(ip_personID, ip_miles);
			end if;
            leave sp_main;
		end if;
        if ip_flying_tail is not null and ip_flying_tail not in (select tail_num from airplane) then
			if ip_miles is not null then
				insert into passenger (personID, miles) values 
				(ip_personID, ip_miles);
			end if;
            leave sp_main;
		end if;
        insert into pilot (personID, taxID, experience, flying_airline, flying_tail) values 
		(ip_personID, ip_taxID, ip_experience, ip_flying_airline, ip_flying_tail);
        if ip_miles is not null then
			insert into passenger (personID, miles) values 
			(ip_personID, ip_miles);
		end if;
    else
		insert into passenger (personID, miles) values 
		(ip_personID, ip_miles);
	end if;
end //
delimiter ;

-- Test Cases
-- call add_person('p78', 'Sam', 'Jones', 'port_2', null, 4, 'American', 'n3300ss', 20);
-- call add_person('p100', 'Bob', 'Cat', 'plane_1', '123-45-6789', 10, 'Delta', 'n106js', 50);
-- call add_person('p200', 'John', 'C', 'port_1', '123-45-6789', 20, 'Delta', 'n110jn', 60);
-- call add_person('p300', 'Kathy', null, 'port_100', '124-45-6789', 20, 'Delta', 'n110jn', 60);
-- call add_person('p300', 'Stacey', null, 'port_1', '124-45-6789', 20, 'NOT', 'n110jn', 60);
-- call add_person('p500', 'John', 'John', 'plane_7', '124-45-6789', 30, null, 'n110jn', 70);

-- [4] grant_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new pilot license.  The license must reference
a valid pilot, and must be a new/unique type of license for that pilot. */
-- -----------------------------------------------------------------------------
drop procedure if exists grant_pilot_license;
delimiter //
create procedure grant_pilot_license (in ip_personID varchar(50), in ip_license varchar(100))
sp_main: begin
	if ip_personID not in (select personID from pilot) then leave sp_main; end if;
	INSERT INTO pilot_licenses VALUES(ip_personID,ip_license);
end //
delimiter ;



-- [5] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  Once
an airplane has been assigned, we must also track where the airplane is along
the route, whether it is in flight or on the ground, and when the next action -
takeoff or landing - will occur. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_airplane_status varchar(100), in ip_next_time time)
sp_main: begin
	if ip_routeID = null or ip_routeID not in (select routeID from route) then leave sp_main; end if;
    if ip_support_tail not in (select tail_num from airplane) then leave sp_main; end if;
	if ip_support_tail is null then
		insert into flight (flightID, routeID, support_airline, support_tail, progress, airplane_status, next_time) values
        (ip_flightID, ip_routeID, null, null, null, null, null);
	else
		if ip_support_airline = null or ip_support_airline not in (select airlineID from airplane) then
			leave sp_main;
		end if;
		if ip_progress = null then
			leave sp_main;
		end if;
        if ip_airplane_status = null then
			leave sp_main;
		end if;
        if ip_next_time = null then
			leave sp_main;
		end if;
		insert into flight (flightID, routeID, support_airline, support_tail, progress, airplane_status, next_time) values
        (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail, ip_progress, ip_airplane_status, ip_next_time);
	end if;
		
end //
delimiter ;
-- call offer_flight('UN_3403', 'westbound_north_milk_run', 'American', 'n380sd', 0, 'on_ground', '15:30:00');

-- [6] purchase_ticket_and_seat()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new ticket.  The cost of the flight is optional
since it might have been a gift, purchased with frequent flyer miles, etc.  Each
flight must be tied to a valid person for a valid flight.  Also, we will make the
(hopefully simplifying) assumption that the departure airport for the ticket will
be the airport at which the traveler is currently located.  The ticket must also
explicitly list the destination airport, which can be an airport before the final
airport on the route.  Finally, the seat must be unoccupied. */
-- -----------------------------------------------------------------------------
drop procedure if exists purchase_ticket_and_seat;
delimiter //
create procedure purchase_ticket_and_seat (in ip_ticketID varchar(50), in ip_cost integer,
	in ip_carrier varchar(50), in ip_customer varchar(50), in ip_deplane_at char(3),
    in ip_seat_number varchar(50))
sp_main: begin
	if ip_customer not in (select personID from person) then leave sp_main; end if;
    if ip_deplane_at = null or ip_deplane_at not in (select airportID from airport) then leave sp_main; end if;
    if ip_carrier not in (select flightID from flight) then leave sp_main; end if;
    
    if ip_seat_number in (select seat_number from ticket_seats) then leave sp_main; end if;
    insert into ticket(ticketID, cost, carrier, customer, deplane_at) values
    (ip_ticketID, ip_cost, ip_carrier, ip_customer, ip_deplane_at);
    insert into ticket_seats(ticketID, seat_number) values
    (ip_ticketID, ip_seat_number);

end //
delimiter ;
-- call purchase_ticket_and_seat('tkt_dl_20', 450, 'DL_1174', 'p23', 'JFK', '5A');

-- [7] add_update_leg()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new leg as specified.  However, if a leg from
the departure airport to the arrival airport already exists, then don't create a
new leg - instead, update the existence of the current leg while keeping the existing
identifier.  Also, all legs must be symmetric.  If a leg in the opposite direction
exists, then update the distance to ensure that it is equivalent.   */
-- -----------------------------------------------------------------------------
drop procedure if exists add_update_leg;
delimiter //
create procedure add_update_leg (in ip_legID varchar(50), in ip_distance integer,
    in ip_departure char(3), in ip_arrival char(3))
sp_main: begin
	if (select count(*) from leg where legID = ip_legID) > 0 then
		update leg set leg.distance = ip_distance, leg.departure = ip_departure, leg.arrival = ip_arrival 
		where leg.legID = ip_legID;
	else 
		insert into leg (legID, distance, departure, arrival) values (ip_legID, ip_distance, ip_departure, ip_arrival);
	end if;
    
    if (select count(*) from leg where departure = ip_arrival and arrival = ip_departure) > 0
    then update leg set distance = ip_distance where departure = ip_arrival and arrival = ip_departure;
    end if;
    
end //
delimiter ;

-- if the opposite direction exists -> call add_update_leg('leg_28', 2800, 'LAX', 'ATL');
-- update -> call add_update_leg('leg_10', 2800, 'DCA', 'SEA');
-- add -> call add_update_leg('leg_28', 2800, 'DCA', 'SEA');

-- [8] start_route()
-- -----------------------------------------------------------------------------
/* This stored procedure creates the first leg of a new route.  Routes in our
system must be created in the sequential order of the legs.  The first leg of
the route can be any valid leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists start_route;
delimiter //
create procedure start_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
	if exists (select * from route where routeID = ip_routeID) then leave sp_main; end if;
    if not exists (select * from leg where legID = ip_legID) then leave sp_main; end if;
    insert into route (routeID) values (ip_routeID);
	insert into route_path (routeID, legID, sequence) values (ip_routeID, ip_legID, 1);
end //
delimiter ;

-- route already exists: call start_route('eastbound_north_milk_run','leg_21');
-- call start_route('new_eastbound_west_milk_run','leg_40');

-- [9] extend_route()
-- -----------------------------------------------------------------------------
/* This stored procedure adds another leg to the end of an existing route.  Routes
in our system must be created in the sequential order of the legs, and the route
must be contiguous: the departure airport of this leg must be the same as the
arrival airport of the previous leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists extend_route;
delimiter //
create procedure extend_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
	if not exists (select * from route where routeID = ip_routeID) then leave sp_main; end if;
    if not exists (select * from leg where legID = ip_legID) then leave sp_main; end if;
    
	set @newSequence = (select max(sequence) from route_path where route_path.routeID = ip_routeID);
    set @prevleg = (select legID from route_path where @newSequence = sequence and ip_routeID = routeID);
    set @arrivalAirport = (select arrival from leg where @prevleg = legID);
    set @departureAirport = (select departure from leg where @prevleg = ip_legID);
    
    if (@arrivalAirport <> @departureAirport) then leave sp_main; end if;
    insert into route_path values (ip_routeID, ip_legID, @newSequence + 1);
    
end //
delimiter ;

-- call extend_route('local_texas', 'leg_23');
-- if the routeID DNE -> call extend_route('eastbound__milk_run', 'leg_40');

-- [10] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
	-- parameter is null
    if ip_flightID is null then leave sp_main; end if;
    -- flight not existing in table
    if not exists (select flightID from flight where flightID = ip_flightID)
		then leave sp_main; end if;
    -- no supporting airplane
    if (select support_tail from flight where flightID = ip_flightID) is null 
		then leave sp_main; end if;
	-- plane not in flight (so how could it land?)
    if (select airplane_status from flight where flightID = ip_flightID) not like 'in_flight'
		then leave sp_main; end if;
	-- next time is null
    if (select next_time from flight where flightID = ip_flightID) is null 
		then leave sp_main; end if;
	
    -- BODY --
	-- move time up one hour, change status
    set @new_time = addtime((select next_time from flight where flightID = ip_flightID), '01:00:00');
    update flight set next_time=@new_time, airplane_status='on_ground' where flightID = ip_flightID;
    
    -- increase pilot experience
    update pilot set experience=experience + 1 
	where flying_airline in (select support_airline from flight where flightID = ip_flightID) 
		and flying_tail in (select support_tail from flight where flightID = ip_flightID) ;
	
    -- increase passenger miles
    set @completed_leg = 
		(select legID from route_path 
		where routeID = (select routeID from flight where flightID = ip_flightID)
		and sequence = (select progress from flight where flightID = ip_flightID));
    
    set @completed_miles = (select distance from leg where legID = @completed_leg);
    
    update passenger set miles = miles + @completed_miles
	where personID in (select customer from ticket where carrier = ip_flightID);
    
end //
delimiter ;

-- [11] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along its route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that propeller driven planes have at least one pilot
assigned, while jets must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
	-- G U A R D S --
    -- parameter is null
    if ip_flightID is null then leave sp_main; end if;
	-- flight not existing in table
    if not exists (select flightID from flight where flightID = ip_flightID)
		then leave sp_main; end if;
    -- no supporting airplane
    if (select support_tail from flight where flightID = ip_flightID) is null 
		then leave sp_main; end if;
	-- plane not on ground (so how could it fly?)
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground'
		then leave sp_main; end if;
	-- next time is null
    if (select next_time from flight where flightID = ip_flightID) is null 
		then leave sp_main; end if;
    
    -- B O D Y --
    
	-- pilots check
    set @the_plane_type = (select plane_type from airplane 
		where airlineID in (select support_airline from flight where flightID = ip_flightID)
        and tail_num in (select support_tail from flight where flightID = ip_flightID));
    
    set @num_pilots_assigned = (select count(*) from pilot 
		where flying_airline = (select support_airline from flight where flightID = ip_flightID)
        and flying_tail = (select support_tail from flight where flightID = ip_flightID));
    
    if (@the_plane_type like 'jet' and @num_pilots_assigned < 2) or (@num_pilots_assigned < 1) then
		-- add 30 min delay
        set @delayed_time = addtime((select next_time from flight where flightID = ip_flightID), '00:30:00');
		update flight set next_time = @delayed_time where flightID = ip_flightID;
        leave sp_main;    
    end if;
    
	-- update progress and airplane_status
    update flight set progress = progress + 1, airplane_status='in_flight' where flightID = ip_flightID;
    
    -- update next_time (assuming that speed is per hour)
    set @plane_speed = (select speed from airplane 
		where airlineID = (select support_airline from flight where flightID = ip_flightID)
        and tail_num = (select support_tail from flight where flightID = ip_flightID));
	
	set @next_leg = 
		(select legID from route_path 
		where routeID = (select routeID from flight where flightID = ip_flightID)
		and sequence = (select progress from flight where flightID = ip_flightID));
    
    set @leg_distance = (select distance from leg where legID = @next_leg);
	-- -- calculate distance / speed
    set @duration = cast(cast(@leg_distance/@plane_speed as UNSIGNED) as char);

	set @new_time = addtime((select next_time from flight where flightID = ip_flightID), concat(@duration, ':00:00'));
    
    update flight set next_time = @new_time where flightID = ip_flightID;
	
    
end //
delimiter ;

-- [12] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the airport and hold a valid ticket
for the flight. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin
	declare airport_loc varchar(50);
    -- G U A R D S --
    -- parameter is null
    if ip_flightID is null then leave sp_main; end if;
	-- flight not existing in table
    if not exists (select flightID from flight where flightID = ip_flightID)
		then leave sp_main; end if;
    -- no supporting airplane
    if (select support_tail from flight where flightID = ip_flightID) is null 
		then leave sp_main; end if;
	-- plane not on ground (so how could it be boarded?)
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground'
		then leave sp_main; end if;
	
    -- B O D Y --
    set @prog = (select progress from flight where flightID = ip_flightID);
    set @plane_loc = (select locationID from airplane 
                        where airlineID = (select support_airline from flight where flightID = ip_flightID)
						and tail_num = (select support_tail from flight where flightID = ip_flightID));
    
    -- find airport location
    if @prog = 0 then
		set @leg1 = (select legID from route_path 
			where routeID = (select routeID from flight where flightID = ip_flightID)
			and sequence = @prog + 1);
            
		set airport_loc = (select locationID from airport where airportID = 
			(select departure from leg where legID = @leg1));
	else
		set @theleg = (select legID from route_path 
			where routeID = (select routeID from flight where flightID = ip_flightID)
			and sequence = @prog);
            
        set airport_loc = (select locationID from airport where airportID = 
			(select arrival from leg where legID = @theleg ));
	end if;
    
    -- update person's location if they have matching ticket, are passenger and are at matching airport 
	update person set locationID = @plane_loc where
	personID in (select customer from ticket where carrier = ip_flightID)
    and personID in (select personID from passenger)
    and locationID = airport_loc;

end //
delimiter ;

-- [13] passengers_disembark()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting off of a flight
at its current airport.  The passengers must be on that flight, and the flight must
be located at the destination airport as referenced by the ticket. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin
declare arouteID varchar(50);
declare alegID varchar(50);
declare cprogress varchar(50);
declare anairportID varchar(50);
declare location varchar(50);
if not exists(select routeID from flight where airplane_status = 'on_ground' and flightID = ip_flightID) then leave sp_main; end if;
set cprogress = (select progress from flight where flightID = ip_flightID);
set arouteID = (select routeID from flight where flightID = ip_flightID);
set alegID = (select legID from route_path where routeID = arouteID and sequence = cprogress);
set anairportID = (select arrival from leg where legID = alegID);
set location = (select locationID from airport where airportID = anairportID);

update person set locationID = location where personID in (select customer from ticket where carrier = ip_flightID and deplane_at = anairportID );
end //
delimiter ;

-- call passengers_disembark('AM_1523');
 


        
-- [14] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
airplane.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. */
-- -----------------------------------------------------------------------------
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (in ip_flightID varchar(50), ip_personID varchar(50))
sp_main: begin
	-- G U A R D S --
    -- parameter is null
    if ip_flightID is null or ip_personID is null then leave sp_main; end if;
	-- flight or pilot not existing in table
    if not exists (select flightID from flight where flightID = ip_flightID)
		or not exists (select personID from pilot where personID = ip_personID)
		then leave sp_main; end if;
    -- no supporting airplane for flight
    if (select support_tail from flight where flightID = ip_flightID) is null 
		then leave sp_main; end if;
	-- plane not on ground (so how could it be piloted?)
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground'
		then leave sp_main; end if;
	-- pilot already assigned to another airline + airplane
    if (select flying_airline from pilot where personID = ip_personID) is not null 
		or (select flying_tail from pilot where personID = ip_personID) is not null
        then leave sp_main; end if;
	
    -- pilot doesn't have the right license
    set @planetype = (select plane_type from airplane
                    where airlineID = (select support_airline from flight where flightID = ip_flightID)
						and tail_num = (select support_tail from flight where flightID = ip_flightID));

    if not exists (select license from pilot_licenses where personID = ip_personID and license like @planetype)
    then leave sp_main; end if;
    
	-- pilot not at the flight location 
    if (select locationID from person where personID = ip_personID) 
		<> (select find_flight_location(ip_flightID))
        then leave sp_main; end if;
    
    -- B O D Y 
    -- -- assign the plane to the pilot
    UPDATE pilot set flying_airline = (select support_airline from flight where flightID = ip_flightID),
					flying_tail = (select support_tail from flight where flightID = ip_flightID)
				where personID = ip_personID;
	-- --  update pilot's  location in person table
	set @planeloc = (select locationID from airplane
                    where airlineID = (select support_airline from flight where flightID = ip_flightID)
						and tail_num = (select support_tail from flight where flightID = ip_flightID));
	UPDATE person set locationID = @planeloc where personID = ip_personID;
    
end //
delimiter ;

-- ##########################################################################
-- A SMALLER FUNCTION TO FIND A FLIGHT'S LOCATION ID BASED ON PROGRESS (which airport)
drop function if exists find_flight_location;
delimiter //
create function find_flight_location (ip_flightID varchar(50))
returns varchar(50) deterministic
sp_main: begin
	declare airport_loc varchar(50);
    set @prog = (select progress from flight where flightID = ip_flightID);
    
    -- find airport location
    if @prog = 0 then
		set @leg1 = (select legID from route_path 
			where routeID = (select routeID from flight where flightID = ip_flightID)
			and sequence = @prog + 1);
            
		set airport_loc = (select locationID from airport where airportID = 
			(select departure from leg where legID = @leg1));
	else -- progress is 1+
		set @theleg = (select legID from route_path 
			where routeID = (select routeID from flight where flightID = ip_flightID)
			and sequence = @prog);
            
        set airport_loc = (select locationID from airport where airportID = 
			(select arrival from leg where legID = @theleg ));
	end if;
    
    return airport_loc;

end //
delimiter ;
-- ##########################################################################

-- [15] recycle_crew()
-- -----------------------------------------------------------------------------
/* This stored procedure releases the assignments for a given flight crew.  The
flight must have ended, and all passengers must have disembarked. */
-- -----------------------------------------------------------------------------
drop procedure if exists recycle_crew;
delimiter //
create procedure recycle_crew (in ip_flightID varchar(50))
sp_main: begin
	-- G U A R D S --
    -- parameter is null
    if ip_flightID is null then leave sp_main; end if;
	-- flight not existing in table
    if not exists (select flightID from flight where flightID = ip_flightID)
		then leave sp_main; end if;
    -- no supporting airplane
    if (select support_tail from flight where flightID = ip_flightID) is null 
		then leave sp_main; end if;
	-- plane not on ground (so how could it be unboarded?)
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground'
		then leave sp_main; end if;
	-- flight progress is 0 (never ran)
    if (select progress from flight where flightID = ip_flightID) = 0
		then leave sp_main; end if;
	-- passengers still on plane
    set @planeloc = (select locationID from airplane
                    where airlineID = (select support_airline from flight where flightID = ip_flightID)
						and tail_num = (select support_tail from flight where flightID = ip_flightID));
	if exists (select * from passenger where personID in (select personID from person where locationID = @planeloc))
		then leave sp_main; end if;
	-- flight did not end yet
    set @theRoute = (select routeID from flight where flightID = ip_flightID);
    set @maxSeq = (select max(sequence) from route_path where routeID = @theRoute);
    if (select progress from flight where flightID = ip_flightID) <> @maxSeq
		then leave sp_main; end if;
	
    -- B O D Y -- 

    -- set pilots' new location
    set @destination_loc = find_flight_location(ip_flightID);
    UPDATE person set locationID = @destination_loc where personID in 
		(select personID from pilot 
        where flying_airline = (select support_airline from flight where flightID = ip_flightID)
        and flying_tail = (select support_tail from flight where flightID = ip_flightID));
    
    -- clear out pilot assignment
    UPDATE pilot set flying_airline = null, flying_tail = null
		where flying_airline = (select support_airline from flight where flightID = ip_flightID)
        and flying_tail = (select support_tail from flight where flightID = ip_flightID);

end //
delimiter ;

-- [16] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route.  */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin
	If exists(
		select routeID, sequence from flight natural join route_path where airplane_status = 'on_ground' and flightID = ip_flightID 
        and (progress  = 0 or progress = sequence)
			)
	then DELETE FROM flight where flightID = ip_flightID;
    end if;
end //
delimiter ;



-- [17] remove_passenger_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the passenger role from person.  The passenger
must be on the ground at the time; and, if they are on a flight, then they must
disembark the flight at the current airport.  If the person had both a pilot role
and a passenger role, then the person and pilot role data should not be affected.
If the person only had a passenger role, then all associated person data must be
removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_passenger_role;
delimiter //
create procedure remove_passenger_role (in ip_personID varchar(50))
sp_main: begin
	-- G U A R D S --
    -- person can't be null
    if ip_personID is null then leave sp_main; end if;
	-- person should exist in person table and in passenger table
    if not exists (select personID from person where personID = ip_personID)
		or not exists (select personID from passenger where personID = ip_personID)
		then leave sp_main; end if;
	
    -- B O D Y --
    -- Handle location requirements
    set @personloc = (select locationID from person where personID = ip_personID);
    -- is person on a plane
    if exists (select locationID from airplane where locationID like @personloc) 
	then
		-- find the flight that has the same plane
        set @theflight = (select flightID from flight join airplane on support_airline = airlineID and support_tail = tail_num
							where locationID like @personloc);
        -- if plane is in-flight, leave
        if (select airplane_status from flight where flightID like @theflight) like 'in_flight' then leave sp_main; end if;
        -- disembark the passenger if they are not a pilot
        if not exists (select personID from pilot where personID like ip_personID) then
			set @airportloc = (select find_flight_location(@theflight));
			UPDATE person set locationID = @airportloc where personID like ip_personID;
        end if;
	end if;
    
    -- Delete roles
    -- people in airport (passenger or passenger+pilot), passengers who are just moved to airport, passenger+pilots on a plane
	-- if the person is pilot+passgr then we remove their name from the passnger table
    if exists (select * from pilot where personID like ip_personID) 
		then DELETE from passenger where personID like ip_personID;
    else 
    -- if the person is only passenger, then we remove them from passenger table and person table 
		DELETE from passenger where personID like ip_personID;
        -- delete ticket 
        set @theticket = (select ticketID from ticket where customer like ip_personID);
        DELETE from ticket_seats where ticketID like @theticket; 
        DELETE from ticket where customer like ip_personID;
        
        DELETE from person where personID like ip_personID;
    end if;
end //
delimiter ;

-- [18] remove_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the pilot role from person.  The pilot must not
be assigned to a flight; or, if they are assigned to a flight, then that flight
must either be at the start or end of its route.  If the person had both a pilot
role and a passenger role, then the person and passenger role data should not be
affected.  If the person only had a pilot role, then all associated person data
must be removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_pilot_role;
delimiter //
create procedure remove_pilot_role (in ip_personID varchar(50))
sp_main: begin
	-- 1. pilot is on the ground or not 
    -- 2. not on the ground -> leave main
	if exists (select pilot.personID from pilot where flying_tail in (select support_tail from flight where airplane_status = 'in_flight') and pilot.personID = ip_personID)
    then leave sp_main; end if;
    
    if exists (select pilot.personID from pilot join flight on flying_tail = support_tail where ip_personID = pilot.personID and 
    progress in (select progress from flight where progress > 0 and progress < 
    (select max(sequence) from route_path join flight on flight.routeID = route_path.routeID group by route_path.routeID)))
    then leave sp_main; end if;
    
    -- pilot is also a passenger
    if exists (select pilot.personID from pilot join passenger where pilot.personID = passenger.personID and pilot.personID = ip_personID)
    then 
    delete from pilot_licenses where personID = ip_personID;
    delete from pilot where personID = ip_personID; 
    leave sp_main; end if;
    
    delete pl from pilot_licenses pl where pl.personID = ip_personID;
	delete p from pilot p where p.personID = ip_personID;
    delete from person where person.personID = ip_personID;
    
    -- 3. pilot is not assigned or pilot is "in flight" which is either start or end 
    -- 3.2. pilot is assinged -> check wheter pilot is at the start or the end 
    -- 4. check person has both a pilot or passenger
    
end //
delimiter ;

-- pilot is 'in_flight': call remove_pilot_role('p10');
-- pilot is not assigned and not a passenger: call remove_pilot_role('p20'); -> last paragraph
-- pilot is assigned and at the middle of route: call remove_pilot_role('p12');
-- pilot is not assigned and also a passenger : call remove_pilot_role('p21');
-- pilot is assigned and also a passenger: this case doesn't exist in the database
-- pilot is assigned and at the start and not a passenger -> call remove_pilot_role('p6');

-- [19] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air (departing_from, arriving_at, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as
   --  select null, null, 0, null, null, null, null;
	select l.departure, l.arrival, count(*) as num_flights, f.flightID, min(f.next_time), max(f.next_time), a.locationID  
	from flight as f inner join route_path as r inner join leg as l inner join airplane as a
	on f.routeID = r.routeID and f.progress = r.sequence and l.legID = r.legID and a.tail_num = f.support_tail
	where airplane_status = 'in_flight' 
	group by l.departure, l.arrival, f.flightID, a.locationID
	order by l.departure, l.arrival;


-- [20] flights_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_on_the_ground (departing_from, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as 
-- select null, 0, null, null, null, null;
	(select l.arrival, count(*) as num_flights, f.flightID, min(f.next_time), max(f.next_time), a.locationID 
	from flight as f inner join route_path as r inner join leg as l inner join airplane as a
	on f.routeID = r.routeID and r.legID = l.legID and a.tail_num = f.support_tail
	where f.airplane_status = 'on_ground' and f.progress = r.sequence
	group by l.arrival, f.flightID, a.locationID)
    
    union
    
    (select l.departure, count(*) as num_flights, f.flightID, min(f.next_time), max(f.next_time), a.locationID 
	from flight as f inner join route_path as r inner join leg as l inner join airplane as a
	on f.routeID = r.routeID and r.legID = l.legID and a.tail_num = f.support_tail
	where f.airplane_status = 'on_ground' and f.progress = 0 and r.sequence = 1
	group by l.departure, f.flightID, a.locationID);
    

-- [21] people_in_the_air()
/* This view describes where flights that are currently airborne are located. We need to display
what airports these flights are departing from, what airports they are arriving at, the number of
flights that are flying between the departure and arrival airport, the list of those flights, the
earliest and latest arrival times for the destinations and the list of planes (by the location id)
flying these flights. */
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently airborne are located. */
/* This view describes where people who are currently airborne are located. We need to display
what airports these people are departing from, what airports they are arriving at, the list of
planes (by the location id) flying these people, the list of flights these people are on, the earliest
and latest arrival times of these people, the number of these people that are pilots, the number
of these people that are passengers, the number of people on the airplane, and the list of these
people by their person id */
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (departing_from, arriving_at, num_airplanes,
	airplane_list, flight_list, earliest_arrival, latest_arrival, num_pilots,
	num_passengers, joint_pilots_passengers, person_list) as
-- select null, null, 0, null, null, null, null, 0, 0, null, null;
select departure, arrival,
count(distinct airplane.locationID) as num_airplanes, 
group_concat(distinct airplane.locationID) as airplane_list, 
group_concat(distinct flight.flightID) as flight_list, 
min(next_time) as earliest_arrival, 
max(next_time) as latest_arrival, 
count(distinct taxID) as num_pilots, 
count(distinct miles) as num_passengers, 
count(distinct person.personID) as joint_pilots_passengers, 
group_concat(distinct person.personID) as person_list
from
airplane 
join flight on flight.support_tail = airplane.tail_num and flight.support_airline = airplane.airlineID
join route_path on flight.routeID = route_path.routeID and route_path.sequence = flight.progress
join leg on route_path.legID = leg.legID
join person on person.locationID = airplane.locationID
left join passenger on person.personID = passenger.personID
left join pilot on person.personID = pilot.personID
where airplane_status = 'in_flight'
group by departure, arrival;


-- [22] people_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently on the ground are located. */
/*This view describes where people who are currently on the ground are located. We need to
display what airports these people are departing from by airport id, location id, and airport
name, the city and state of these airports, the number of these people that are pilots, the
number of these people that are passengers, the number people at the airport, and the list of
these people by their person id.*/
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (departing_from, airport, airport_name,
	city, state, num_pilots, num_passengers, joint_pilots_passengers, person_list) as
-- select null, null, null, null, null, 0, 0, null, null;
select group_concat(distinct airportID) as departing_from, 
group_concat(distinct airport.locationID) as airport, 
airport_name, city, state,
count(distinct taxID) as num_pilots, 
count(distinct miles) as num_passengers, 
count(distinct person.personID) as joint_pilots_passengers,
group_concat(distinct person.personID) as person_list
from 
airport join person on person.locationID = airport.locationID
left join passenger on person.personID = passenger.personID
left join pilot on person.personID = pilot.personID
group by airport_name, city, state;


-- [23] route_summary()
-- -----------------------------------------------------------------------------
/* This view describes how the routes are being utilized by different flights. */
/* This view will give a summary of every route. This will include the routeID, the number of legs
per route, the legs of the route in sequence, the total distance of the route, the number of
flights on this route, the flightIDs of those flights, and the sequence of airports visited by the
route. */
-- -----------------------------------------------------------------------------
create or replace view route_summary (route, num_legs, leg_sequence, route_length,
	num_flights, flight_list, airport_sequence) as
-- select null, 0, null, 0, 0, null, null;

select
    route_path.routeID as route, 
    count(distinct leg.legID) as num_legs,
    group_concat(distinct leg.legID order by route_path.sequence) as leg_sequence,
    if ((count(distinct flight.flightID) > 1), sum(leg.distance) div count(distinct flight.flightID), sum(leg.distance)) as route_length,
    -- sum(leg.distance) div count(distinct flight.flightID) as route_length,
    count(distinct flight.flightID) as num_flights,
    group_concat(distinct flight.flightID) as flight_list,
    group_concat(distinct leg.departure, '->', leg.arrival order by route_path.sequence separator ', ') as airport_sequence
from 
    route_path join leg on route_path.legID = leg.legID 
    left join flight on route_path.routeID = flight.routeID
group by route_path.routeID;


-- [24] alternative_airports()
-- -----------------------------------------------------------------------------
/* This view displays airports that share the same city and state. */
-- -----------------------------------------------------------------------------
create or replace view alternative_airports (city, state, num_airports,
	airport_code_list, airport_name_list) as
    
	select city, state, count(state) as num_airports, group_concat(airportID order by airportID asc) as airport_code_list, 
    group_concat(airport_name order by airportID asc) as airport_name_list
    from airport
    group by city, state having count(state) > 1; 
    
-- select * from alternative_airports;

-- [25] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle.  The flight
with the smallest next time in chronological order must be identified and selected.
If multiple flights have the same time, then flights that are landing should be
preferred over flights that are taking off.  Similarly, flights with the lowest
identifier in alphabetical order should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed
to land, passengers allowed to disembark, and the time advanced by one hour until
the next takeoff to allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should
be allowed to board, and the time should be advanced to represent when the airplane
will land at its next location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the
flight crew should be recycled to allow rest, and the flight itself should be
retired from the system. */
-- -----------------------------------------------------------------------------
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle () 
sp_main: begin
	create or replace view smallest as 
    select * from flight where next_time is not null order by 
    flight.next_time asc, airplane_status asc, flightID asc limit 1; 
    
    -- case1: flight is in-flight
	-- set @flight1 = (select flightID from smallest where airplane_status = 'in_flight');
    set @smallestID = (select flightID from smallest);
    if exists (select flightID from smallest where airplane_status = 'in_flight')
		then 
        -- update flight set airplane_status = 'on_ground' where flightID = @smallestID;
		call flight_landing(@smallestID);
		call passengers_disembark(@smallestID);
    leave sp_main;
    end if;
    
    set @newSequence = (select max(sequence) from route_path 
    where route_path.routeID = (select smallest.routeID from smallest) group by routeID);
    -- set @flight3 = (select flightID from smallest where airplane_status = 'on_ground' and progress in (@newSequence));
    -- group by routeID on route_path and do max(sequence)
    if exists (select flightID from smallest where airplane_status = 'on_ground' and progress in (@newSequence)) then 
		call recycle_crew(@smallestID);
		call retire_flight(@smallestID);
		leave sp_main;
    end if;
    
    -- set @flight2 = (select flightID from smallest where airplane_status = 'on_ground');
    if exists (select flightID from smallest where airplane_status = 'on_ground') 
		then 
		-- update flight set progress = progress + 1 where flightID = @smallestID;
		call passengers_board(@smallestID);
		call flight_takeoff(@smallestID);
		leave sp_main;
    end if;
    
end //
delimiter ;

-- call simulation_cycle();