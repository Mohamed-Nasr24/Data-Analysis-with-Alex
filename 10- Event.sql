-- event is a Scheduled tasks that run automatically at specified intervals. <trigger by time>

select *
from employee_demographics
where year(now()) - year(birth_date) >= 60;

delimiter $$
create event delete_retirees
on schedule every 1 day
do
begin
	delete from employee_demographics
    where year(now()) - year(birth_date) >= 60;
end$$
delimiter ;

-- to show if event is on and working or off
show variables like 'event%';

-------------------- tricks --------------------
/*
1- ON SCHEDULE AT '2023-12-31 23:59:59' >> to run once
2- ON SCHEDULE EVERY 1 DAY STARTS '2023-10-01 00:00:00' >> run recurring
3- ON SCHEDULE EVERY 1 WEEK STARTS '2023-10-01 00:00:00' ENDS '2024-01-01 00:00:00' >> combine intervals

-- ALTER EVENT event_name DISABLE; >> to disable the event
-- ALTER EVENT event_name ENABLE; >> to enalbe the event

**used to handel errors and saving it**
CREATE EVENT cleanup_event
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Declare a handler for SQL exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log the error
        INSERT INTO error_log (error_message, error_time)
        VALUES ('An error occurred during cleanup', NOW());
    END;

    -- Perform the cleanup task
    DELETE FROM old_data_table
    WHERE created_at < NOW() - INTERVAL 30 DAY;
END;
/*