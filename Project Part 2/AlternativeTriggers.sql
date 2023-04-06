-- Contains alternative triggers

-- Alternative 1: Using BEFORE insert for all 'Sequential ID triggers' (2, 3, 1-legsRelated and 7-ReturnLegsRelated)
CREATE OR REPLACE FUNCTION check_if_leg_sequential() RETURNS TRIGGER
AS $$
DECLARE
    latest_index INTEGER;
BEGIN
    SELECT l.leg_id INTO latest_index FROM legs l WHERE l.request_id = NEW.request_id ORDER BY l.leg_id ASC LIMIT 1;

    -- For first to be inserted, no previous existing OR index is latest + 1
    IF (latest_index IS NULL OR NEW.leg_id <> latest_index + 1) THEN
        RETURN NEW;
    END IF;

    RAISE EXCEPTION 'Leg ID must be sequential!';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_if_leg_sequential_trigger
BEFORE INSERT ON legs
FOR EACH ROW 
EXCUTE FUNCTION check_if_leg_sequential();