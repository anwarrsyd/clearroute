
-- get total route with name
SELECT SUM(route.cost) AS cost FROM (SELECT a.seq AS seq, b.gid AS gid, b.name AS name, a.cost AS cost, b.the_geom AS geom, b.source, b.target, b.x1 AS x, b.y1 AS y FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost_s::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM ways',
    116452, 60644, true, true) AS a LEFT JOIN ways AS b ON (a.id2 = b.gid) ORDER BY a.seq) AS route;
    
SELECT a.seq AS seq, b.gid AS gid, b.name AS name, a.cost AS cost, b.the_geom AS geom, b.source, b.target, b.x1 AS x, b.y1 AS y FROM pgr_dijkstra('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost_s::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM ways',
    116452, 60644, true, false) AS a LEFT JOIN ways AS b ON (a.id2 = b.gid) ORDER BY a.seq;
    
SELECT * FROM pgr_aStarFromAtoBviaC_line('ways', 112.79729, -7.27957, 112.77756551751, -7.2951527067072, 112.76056, -7.27066);
SELECT * FROM pgr_aStarFromAtoBviaC_line('ways', 112.79729, -7.27957, 112.780335265,-7.2540394, 112.76056, -7.27066);
    
    
-- get total route without name
SELECT a.seq, a.id1 AS node, a.id2 AS edge, a.cost FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         length::double precision AS cost,
         x1, y1, x2, y2
        FROM ways',
    22477, 13493, false, false) AS a;
    
-- get vertex id with long lat (tc)
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79729 -7.27957)',4326) 
    LIMIT 1;

SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.780335265 -7.2540394)',4326) 
    LIMIT 1;

-- get vertex id with long lat (wapo)   
SELECT * FROM ways 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.76056 -7.27066)',4326) 
    LIMIT 1;

-- get vertex id with long lat (jurusan kimia)
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79340 -7.31093)',4326) 
    LIMIT 1;
    
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.7858 -7.3746)',4326) 
    LIMIT 1;
    
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.73864 -7.26004)',4326) 
    LIMIT 1;


SELECT b.gid, b.the_geom, b.name, a.cost, b.source, b.target, 
						ST_Reverse(the_geom) AS flip_geom FROM pgr_astar('SELECT gid::integer as id, 
						source::integer, target::integer, 
						length::double precision AS cost, 
						reverse_cost::double precision, 
						x1, y1, x2, y2 FROM ways', 22160, 8202, true, true) AS a , ways AS b WHERE a.id2 = b.gid ORDER BY a.seq;
						
insert into matrix(id, node_id, x, y) select 3, id, st_x(the_geom)::double precision, st_y(the_geom)::double precision
			from ways_vertices_pgr ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.7858 -7.3746)', 4326) limit 1;
			
create temporary table matrix(id integer, node_id integer, x double precision, y double precision);
			
select * from matrix;

drop table matrix;

select seq, id1, id2, round(cost::numeric, 5) AS cost from
			pgr_tsp('select id, x, y from matrix', 1, 6);
			
select count(id) from ways_vertices_pgr;

select * from matrix;

select node_id from matrix where id = 1;

SELECT ST_AsText(the_geom) 
       FROM ways WHERE gid = 231627;
       
SELECT ROUND(CAST(ST_DISTANCE_SPHERE(ST_GeometryFromText('POINT(112.79729 -7.27957)',4326), ST_GeometryFromText('POINT(112.7858 -7.3746)',4326)) AS NUMERIC),2);

SELECT * FROM pgr_normalroute('ways', 112.79729, -7.27957, 112.7858, -7.3746);

create temporary table tmp(id integer, node_id integer, x double precision, y double precision);

drop table tmp;

insert into tmp (id, node_id, x, y) 
			select 1, id, st_x(the_geom)::double precision, st_y(the_geom)::double precision
			from ways_vertices_pgr ORDER BY the_geom <-> ST_GeometryFromText('Point(112.7858 -7.3746)', 4326) limit 1;
			
select * from tmp;

SELECT to_json(name) FROM (SELECT b.name AS name, b.the_geom AS geom FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) ORDER BY a.seq) AS route;
    
SELECT jsonb_build_object(
    'type',       'Feature',
    'properties', '{}',
    'geometry',   ST_AsGeoJSON(geom)::jsonb
) AS json FROM (SELECT b.gid AS gid, b.the_geom AS geom FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) ORDER BY a.seq) AS row;
    
SELECT jsonb_build_object(
    'type',       'Feature',
    'properties', '{}',
    'geometry',   ST_AsGeoJSON(geom)::jsonb
) AS json FROM (SELECT * FROM pgr_aStarFromAtoBviaC_line('ways', 112.79729, -7.27957, 112.77756551751, -7.2951527067072, 112.76056, -7.27066)) row;

SELECT cost, CASE
	WHEN cost >= 0.5
		THEN cost * -1
		ELSE cost = cost
	END AS cost
	FROM backup_ways
	WHERE cost = 0.5;
   
create temporary table tmp_ways(gid BIGINT, class_id INTEGER, length double precision, length_m double precision, name text, source bigint, target bigint,
											x1 double precision, y1 double precision, x2 double precision, y2 double precision, cost double precision, reverse_cost double precision,
											cost_s double precision, reverse_cost_s double precision, rule text, one_way integer, maxspeed_forward integer, maxspeed_backward integer,
											osm_id bigint, source_osm bigint, target_osm bigint, priority double precision, the_geom unknown);
											
-- get distance in meter between 2 point
select round(cast(st_distance_sphere(ST_GeomFromText('POINT(112.79729 -7.27957)',4326), ST_GeomFromText('POINT(112.76056 -7.27066)',4326)) as numeric));
    
-- count array
SELECT cardinality(hasil) FROM (SELECT ARRAY(SELECT a.seq || ' ' || b.gid FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq) AS hasil) AS hasil;
    
-- get array origin and destination
SELECT (ARRAY(SELECT b.x1 || ' ' || b.y1  FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq));

-- get centroid   
SELECT ST_Centroid(hasil) FROM (SELECT ST_GeometryFromText('MULTIPOINT('|| hasil[1] ||','|| hasil[85] ||')', 4326) AS hasil FROM (SELECT (ARRAY(SELECT b.x1 || ' ' || b.y1  FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq)) AS hasil) AS hasil) AS hasil;

-- dapat titik tengah
SELECT * FROM ways 
    ORDER BY the_geom <-> (SELECT ST_Centroid(hasil) FROM (SELECT ST_GeometryFromText('MULTIPOINT('|| hasil[1] ||','|| hasil[85] ||')', 4326) AS hasil FROM (SELECT (ARRAY(SELECT b.x1 || ' ' || b.y1  FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq)) AS hasil) AS hasil) AS hasil)
    LIMIT 1;

-- geometry center
SELECT ST_GeometryFromText('MULTIPOINT('|| hasil[1] ||','|| hasil[85] ||')', 4326) FROM (SELECT (ARRAY(SELECT b.x1 || ' ' || b.y1  FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq)) AS hasil) AS hasil;

-- get centered point
SELECT ST_AsText(hasil) FROM (SELECT ST_Centroid(hasil) AS hasil FROM (SELECT ST_GeometryFromText('MULTIPOINT('|| hasil[1] ||','|| hasil[85] ||')', 4326) AS hasil FROM (SELECT (ARRAY(SELECT b.x1 || ' ' || b.y1  FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq)) AS hasil) AS hasil) AS hasil) AS hasil;
    
SELECT * FROM ways WHERE ST_Distance_Sphere(the_geom, (SELECT ST_GeometryFromText('MULTIPOINT('|| hasil[1] ||','|| hasil[85] ||')', 4326) FROM (SELECT (ARRAY(SELECT b.x1 || ' ' || b.y1  FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq)) AS hasil) AS hasil)) <= 4171;
    
SELECT * FROM ways WHERE ST_Dwithin((SELECT ST_GeometryFromText('MULTIPOINT('|| hasil[1] ||','|| hasil[85] ||')', 4326) FROM (SELECT (ARRAY(SELECT b.x1 || ' ' || b.y1  FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 60644, true, false) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) WHERE gid IS NOT NULL ORDER BY a.seq)) AS hasil) AS hasil), the_geom, 4171/2);
    
SELECT * FROM backup_ways WHERE gid = 106365;
SELECT * FROM backup_ways WHERE maxspeed_forward > 1 AND maxspeed_forward < 4 LIMIT 5;

SELECT (length_m / (maxspeed_forward * 5/18)) FROM backup_ways WHERE gid = 106365;
SELECT ST_Length(the_geom) FROM backup_ways WHERE gid = 99283;

SELECT UpdateCostWaktu(1);

SELECT * FROM backup_ways WHERE maxspeed_forward = 0 LIMIT 10;

UPDATE backup_ways SET cost_waktu = (SELECT (length_m / (maxspeed_forward * 5/18)) FROM backup_ways WHERE gid = 114576) WHERE gid = 114576;

SELECT * FROM ways WHERE ST_Distance_Sphere(the_geom, ST_GeometryFromText('POINT(112.776453 -7.282266)',4326)) <= 1000 and (class_id = 108 or class_id = 109) LIMIT 20;

SELECT * FROM backup_ways WHERE cost = 0.5;

UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 186121;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 195676;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 234143;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 236258;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 236268;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 236269;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 733;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 1404;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 2697;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 5101;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 10154;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 49017;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 53850;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 54965;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 107169;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 110342;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 116908;
UPDATE backup_ways SET reverse_cost = 0.5 WHERE gid = 125569;

SELECT * from backup_ways where cost = 0.5;

UPDATE backup_ways SET cost_fix = cost_baru;

SELECT cost_baru FROM backup_ways LIMIT 10;

SELECT updatecostfix(1);

SELECT * FROM backup_ways WHERE cost = 0.5;

UPDATE backup_ways SET cost_fix = -1 WHERE gid IN (SELECT gid FROM backup_ways WHERE cost = 0.5);