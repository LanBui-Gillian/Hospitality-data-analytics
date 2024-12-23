CREATE PROCEDURE usp_MergeBookings
AS
BEGIN
    SET NOCOUNT ON;

    MERGE bookings AS Target
    USING source_table_bookings AS Source
    ON Target.booking_id = Source.booking_id

    WHEN MATCHED 
        THEN UPDATE SET 
            Target.property_id = Source.property_id,
            Target.booking_date = Source.booking_date,
            Target.check_in_date = Source.check_in_date,
            Target.checkout_date = Source.checkout_date,
            Target.no_guests = Source.no_guests,
            Target.room_category = Source.room_category,
            Target.booking_platform = Source.booking_platform,
            Target.ratings_given = Source.ratings_given,
            Target.booking_status = Source.booking_status,
            Target.revenue_generated = Source.revenue_generated,
            Target.revenue_realized = Source.revenue_realized

    WHEN NOT MATCHED BY TARGET
        THEN INSERT (
            booking_id,
            property_id,
            booking_date,
            check_in_date,
            checkout_date,
            no_guests,
            room_category,
            booking_platform,
            ratings_given,
            booking_status,
            revenue_generated,
            revenue_realized
        )
        VALUES (
            Source.booking_id,
            Source.property_id,
            Source.booking_date,
            Source.check_in_date,
            Source.checkout_date,
            Source.no_guests,
            Source.room_category,
            Source.booking_platform,
            Source.ratings_given,
            Source.booking_status,
            Source.revenue_generated,
            Source.revenue_realized
        );

    -- Optional: Add error handling here if needed
END;

-------------------------------

CREATE PROCEDURE GetTotalSuccessfulBooking
AS
BEGIN
	SET NOCOUNT ON;

	MERGE aggregated_bookings as Target
	USING (	select property_id,
			check_in_date,
			room_category,
			count(booking_id) as successful_bookings
			from bookings
			group by property_id, check_in_date, room_category) as Source
	ON Source.property_id = Target.property_id
		AND Source.check_in_date = Target.check_in_date
		AND Source.room_category = Target.room_category

	WHEN MATCHED
		THEN UPDATE SET
			Target.property_id = Source.property_id,
			Target.check_in_date = Source.check_in_date,
			Target.room_category = Source.room_category,
			Target.successful_bookings = Source.successful_bookings
	WHEN NOT MATCHED BY TARGET
		THEN INSERT 
		VALUES 
			(Source.property_id,
			Source.check_in_date,
			Source.room_category,
			Source.successful_bookings);

END

--------------------------------------

CREATE PROCEDURE GetRevenue
	@StartDate date,
	@EndDatae date
AS
BEGIN
	Select city
			, sum(revenue_realized) as sum_rev_per_city
	from bookings b
	join hotels h on b.property_id = h.property_id
	where check_in_date between @StartDate and @EndDatae
	group by city
END;

-----------------------------

select * from source_table_bookings
select * from bookings


