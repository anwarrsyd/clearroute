-- THE FOLLOWING PROCEDURAL FUNCTION WILL GIVE US THE LINE CONNECTING DESTINATION POINTS --
-- The point procedural function is not necessary as starting and ending point will be shown in different colors --
-- and the intermediate in different, so there shouldn't be any confusion --
-- Enter the variadic coordinates in the order "start", "via" etc etc, "end" --

create or replace function pgr_aStarFromAtoBviaC_line(IN tbl character varying, 
variadic double precision[],
OUT seq integer, 
OUT gid integer, 
OUT name text,
OUT cost double precision,
OUT geom geometry,
OUT x double precision,
OUT y double precision)
RETURNS SETOF record AS
$body$
declare
	arrayLengthHalf integer;
	a integer;
	x1 double precision;
	b integer;
	y1 double precision;
	sql_tsp text;
	rec_tsp record;
	source_var integer;
	target_var integer;
	node record;
	sql_astar text;
	rec_astar record;
begin
	drop table if exists matrix;
	-- We will create a temporary table which will hold all the required field values i.e. node_id, closest point's X coord, closest point's Y coord --
	create temporary table matrix(id integer, node_id integer, x double precision, y double precision);
	-- Array Length of above defined variadic function --
	-- ($2, 1) means that the 2nd argument and the array is of dimension one --
	arrayLengthHalf = (array_length($2,1))/2;
	-- For Loop to feed our above declared table, index number 0 is nothing, means first array value is $2[1] --
	For i in 1..arrayLengthHalf Loop
		a := i*2-1;
		x1 := $2[a];
		b := a+1;
		y1 := $2[b];
		--Use the execute statement
		execute 'insert into matrix (id, node_id, x, y) 
			select '||i||', id, st_x(the_geom)::double precision, st_y(the_geom)::double precision
			from ways_vertices_pgr ORDER BY the_geom <-> ST_GeometryFromText(''Point('||x1||' '||y1||')'', 4326) limit 1;';		
	End Loop;
	-- TSP nodes order calculation --
	sql_tsp := 'select seq, id1, id2, round(cost::numeric, 5) AS cost from
			pgr_tsp(''select id, x, y from matrix order by id'', 1, '||arrayLengthHalf||')';
	-- Extracting the geom values row by row --
	seq := 0;
	source_var := -1;
	FOR rec_tsp IN EXECUTE sql_tsp
		LOOP
			If (source_var = -1) Then
				execute 'select node_id from matrix where id = '||rec_tsp.id2||'' into node;
				source_var := node.node_id;
			Else
				execute 'select node_id from matrix where id = '||rec_tsp.id2||'' into node;
				target_var := node.node_id;
				sql_astar := 'SELECT b.gid, a.cost, b.the_geom, b.name, b.source, b.target, b.x1 AS x, b.y1 AS y,  
				ST_Reverse(b.the_geom) AS flip_geom FROM ' ||
				'pgr_astar(''SELECT gid::integer AS id, source::integer, target::integer, ' ||
				'cost_baru::double precision AS cost, reverse_cost::double precision AS reverse_cost, x1, y1, x2, y2 FROM '
						 ||	quote_ident(tbl) || ''','
					    || source_var || ',' || target_var
						 || ', true, true) AS a LEFT JOIN ' || quote_ident(tbl) || ' AS b ON (a.id2 = b.gid) ORDER BY a.seq';
				For rec_astar in execute sql_astar
					Loop
						seq := seq +1 ;
						gid := rec_astar.gid;
						name := rec_astar.name;
						cost := rec_astar.cost;
						geom := rec_astar.the_geom;
						x := rec_astar.x;
						y := rec_astar.y;
						RETURN NEXT;
					End Loop;
				source_var := target_var;
			END IF;
		END LOOP;	
	-- Drop the temporary table, otherwise the next time you will run the query it will show that the matrix table already exists --
	
	return;
	
	
	--EXCEPTION
		--WHEN internal_error THEN
			--seq := seq +1 ;
			--gid := rec_astar.gid;
			--name := rec_astar.name;
			--cost := 9999.9999;
			--geom := rec_astar.the_geom;

end;
$body$
language plpgsql volatile STRICT;

-- In order to use this function --
-- Enter the variadic coordinates in the order "start", "via" etc etc, "end" --
-- SELECT geom FROM pgr_aStarFromAtoBviaC_line('ways', 28.231233, 41.324324, 29.432432, 42.423542, 30.234342, 43.234543, 28.443234, 42.454355) --
-- SELECT cost FROM pgr_aStarFromAtoBviaC_line('ways', 28.231233, 41.324324, 29.432432, 42.423542, 30.234342, 43.234543, 28.443234, 42.454355) --
-- etc etc --
-- In GeoServer, we make an SQL View like the following --
-- SELECT geom FROM pgr_aStarFromAtoBviaC_line('ways', %variadicArray%) ORDER BY seq --
-- and give the default values this 28.94603,41.00764,28.95402,41.01789,28.96145,41.00522,28.96650,41.01191 --
-- But still have to figure out how to build a request from the OpenLayers3? --
-- For time being, make different SQL Views for different possibilities (4pt, 5pt, 6pt etc)
