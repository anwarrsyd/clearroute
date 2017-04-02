CREATE OR REPLACE FUNCTION updateCost(i INTEGER) RETURNS INTEGER AS $$

DECLARE
	sql_gid text;
	rec record;

BEGIN
	sql_gid := 'SELECT * FROM backup_ways';
	FOR rec IN EXECUTE sql_gid
		LOOP	
			EXECUTE 'UPDATE backup_ways SET cost_baru = (SELECT (cost + cost_s) FROM backup_ways WHERE gid = '||rec.gid||') WHERE gid = '||rec.gid||'';
		END LOOP;
		
	RETURN i+1;
	
END;
$$
language plpgsql volatile STRICT;