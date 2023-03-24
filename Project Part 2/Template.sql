-----------------------------------------------------------------------------------------------------------------------------------
-- 
CREATE OR REPLACE FUNCTION () RETURNS TRIGGER
AS $$
DECLARE
BEGIN

  IF () THEN
    RAISE EXCEPTION '!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER 
BEFORE INSERT ON 
FOR EACH ROW
EXECUTE FUNCTION ();