create or replace function pgr_normalroute(IN tbl character varying, 
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
	sql_node text;
	REC_ROUTE record;
	source_var integer;
	target_var integer;
	node record;
	sql_astar text;
	rec_astar record;
begin
	-- menghapus tabel sementara apabila sudah ada
	drop table if exists tmp;
	-- membuat tabel sementara
	create temporary table tmp(id integer, node_id integer, x double precision, y double precision);
	-- mendefiniskan ukuran array
	-- ($2, 1) berarti parameter kedua dan array nya merupakan array 1 dimensi
	arrayLengthHalf = (array_length($2,1))/2;
	-- Untuk perulangan sesuai dengan tabel yg dibuat, index 0 diabaikan dan dimulai dari 2[1]
	For i in 1..arrayLengthHalf Loop
		a := i*2-1;
		x1 := $2[a];
		b := a+1;
		y1 := $2[b];
		-- Memasukkan node id yang didapat dari query di bawah, ke dalam tabel sementara
		execute 'insert into tmp (id, node_id, x, y) 
			select '||i||', id, st_x(the_geom)::double precision, st_y(the_geom)::double precision
			from ways_vertices_pgr ORDER BY the_geom <-> ST_GeometryFromText(''Point('||x1||' '||y1||')'', 4326) limit 1;';		
	End Loop;
	sql_node := 'SELECT * FROM tmp';	
	-- Mengambil kolom geom dari tabel sementara
	seq := 0;
	source_var := -1;
	FOR REC_ROUTE IN EXECUTE sql_node
		LOOP
			-- Mengecek apakah parameter merupakan koordinat awal
			If (source_var = -1) Then
				execute 'select node_id from tmp where node_id = '||REC_ROUTE.node_id||'' into node;
				source_var := node.node_id;
			-- Apabila parameter merupakan koordinat tujuan
			Else
				execute 'select node_id from tmp where node_id = '||REC_ROUTE.node_id||'' into node;
				target_var := node.node_id;
				sql_astar := 'SELECT b.gid, a.cost, b.the_geom, b.name, b.source, b.target, b.x1 AS x, b.y1 AS y FROM ' ||
				'pgr_astar(''SELECT gid::integer AS id, source::integer, target::integer, ' ||
				'cost_baru::double precision AS cost, reverse_cost::double precision AS reverse_cost, x1, y1, x2, y2 FROM '
						 ||	quote_ident(tbl) || ''','
					    || source_var || ',' || target_var
						 || ', true, true) AS a LEFT JOIN ' || quote_ident(tbl) || ' AS b ON (a.id2 = b.gid) ORDER BY a.seq';
				-- Menjalankan fungsi algoritma A star pada pgrouting, dan mengembalikan hasilnya
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
			END IF;
		END LOOP;	
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