
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
    
SELECT a.seq AS seq, b.gid AS gid, b.name AS name, a.cost AS cost, b.the_geom AS geom, b.source, b.target, b.x1 AS x, b.y1 AS y FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost_clearroute::double precision AS cost,
         reverse_cost::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways',
    116452, 148471, true, true) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) ORDER BY a.seq;
    
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

-- kosong rute
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.75994 -7.270502)',4326) 
    LIMIT 1;


-- get vertex id with long lat (wapo)   
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.76056 -7.27066)',4326) 
    LIMIT 1;
    
SELECT * FROM backup_ways WHERE gid = 60644;

-- get vertex id with long lat (jurusan kimia)
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79340 -7.31093)',4326) 
    LIMIT 1;
    
-- juanda    
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.7858 -7.3746)',4326) 
    LIMIT 1;
    
-- tp    
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.73864 -7.26004)',4326) 
    LIMIT 1;
    
-- unesa    
SELECT * FROM ways_vertices_pgr 
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.6691293 -7.301802)',4326) 
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
) AS json FROM (SELECT * FROM pgr_aStarFromAtoBviaC_line('backup_ways', 112.79729, -7.27957, 112.77756551751, -7.2951527067072, 112.76056, -7.27066)) row;

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

SELECT UpdateCostClearroute(1);

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

UPDATE backup_ways SET cost_fix = -1 WHERE gid = xxx;

SELECT * from backup_ways where cost = 0.5;

UPDATE backup_ways SET cost_fix = cost_baru;

SELECT cost_baru FROM backup_ways LIMIT 10;

SELECT updatecostfix(1);

SELECT * FROM backup_ways WHERE cost = 0.5;

UPDATE backup_ways SET cost_fix = -1 WHERE gid IN (SELECT gid FROM backup_ways WHERE cost = 0.5);

-- coba 1
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79463 -7.27543)',4326) 
    LIMIT 1;
    
-- coba 2
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79504 -7.27589)',4326) 
    LIMIT 1;

-- coba 3
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79783 -7.28179)',4326) 
    LIMIT 1;
    
-- coba 4
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79763 -7.28575)',4326) 
    LIMIT 1;
    
-- coba 5
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79553 -7.28609)',4326) 
    LIMIT 1;
    
-- coba 5
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79553 -7.28609)',4326) 
    LIMIT 1;
    
-- coba 6
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79357 -7.28636)',4326) 
    LIMIT 1;
    
-- coba 7
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79553 -7.28609)',4326) 
    LIMIT 1;
    
-- coba 8
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79485 -7.2862)',4326) 
    LIMIT 1;
    
-- coba 5
SELECT * FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_GeometryFromText('POINT(112.79553 -7.28609)',4326) 
    LIMIT 1;
    
SELECT pgr_analyzeGraph('ways',0.001, id:='gid');

SELECT pgr_normalroute('backup_ways', 112.79773200611186, -7.279894518746661, 112.75994, -7.270502);

ALTER TABLE backup_ways ADD cost_fix DOUBLE PRECISION;

SELECT MAX(cost_fix) FROM backup_ways;

SELECT cost_fix FROM backup_ways ORDER BY cost_fix DESC LIMIT 1;

SELECT cost FROM ways WHERE gid = 110342;

UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158311;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 145607;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 146074;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 146075;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 147378;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 147395;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 155236;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 157855;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158822;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185658;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 229627;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 239984;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2416;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 108457;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 117667;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 160323;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186080;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 234143;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 733;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2697;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 110342;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 125569;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158616;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158648;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158657;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158677;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158681;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158842;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 159868;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 161555;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 161556;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 161622;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 162223;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 162224;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 163013;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 177887;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 183541;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 183542;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 183544;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 1607;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 183726;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 184450;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 184502;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 184543;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 184559;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 1687;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 184562;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185308;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185358;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185437;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185418;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185422;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185444;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 160645;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185675;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185947;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186059;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186078;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186079;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186226;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186238;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186239;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186268;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186274;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187043;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187098;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187148;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187476;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187552;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187554;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187555;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 1938;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2027;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 187562;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 194342;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 195329;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 223427;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 227796;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 228143;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 228147;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 229541;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 186121;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 195676;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 229624;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 231193;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 231424;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 231579;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 231705;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 231706;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 231822;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 232065;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 232182;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 232709;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 232816;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 232834;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 232835;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 232836;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 1262;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 233811;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 233814;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 234792;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 235680;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 235723;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 235724;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 235794;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 235799;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 236258;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 236268;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 236269;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 239985;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 242018;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 244480;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 245001;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 245002;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 240;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 245;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 418;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 571;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 583;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 584;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 585;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 724;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 740;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 741;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 1467;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2028;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2070;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2092;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2210;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2230;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 1404;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2503;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2504;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2546;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 113084;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 2670;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 4461;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 4472;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 4730;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 4779;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 4801;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 9492;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 9493;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 10119;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 10120;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 10160;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 46714;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 102623;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 113086;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 113105;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 113106;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 107347;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 107351;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 5101;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 10154;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 49017;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 53850;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 54965;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 107169;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 108459;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 108677;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 108774;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 109767;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 109771;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 110400;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 110626;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 110747;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 111345;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 111450;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 112892;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 114191;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 114194;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 114839;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 115511;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 115534;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 115535;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 115764;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 116415;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 117154;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 117158;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 116908;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 119964;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 119995;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 120877;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 125608;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 125609;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 125610;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 125628;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 127008;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 127022;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 185256;
UPDATE backup_ways SET cost_fix = 50 WHERE gid = 158299;

SELECT gid, name,  x1, y1 FROM backup_ways WHERE cost_fix = 50 LIMIT 10;

SELECT cost_s FROM backup_ways LIMIT 15;

SELECT cost_fix FROM backup_ways WHERE gid = 114576;
SELECT cost_fix FROM backup_ways WHERE gid = 112041;
SELECT cost_fix FROM backup_ways WHERE gid = 112042;
SELECT cost_fix FROM backup_ways WHERE gid = 112043;
SELECT cost_fix FROM backup_ways WHERE gid = 112044;
SELECT cost_fix FROM backup_ways WHERE gid = 10422;
SELECT cost_fix FROM backup_ways WHERE gid = 10423;
SELECT cost_fix FROM backup_ways WHERE gid = 10424;
SELECT cost_fix FROM backup_ways WHERE gid = 10425;
SELECT cost_fix FROM backup_ways WHERE gid = 10426;
SELECT cost_fix FROM backup_ways WHERE gid = 820;
SELECT cost_fix FROM backup_ways WHERE gid = 113089;
SELECT cost_fix FROM backup_ways WHERE gid = 113090;
SELECT cost_fix FROM backup_ways WHERE gid = 118358;
SELECT cost_fix FROM backup_ways WHERE gid = 108682;
SELECT cost_fix FROM backup_ways WHERE gid = 115517;
SELECT cost_fix FROM backup_ways WHERE gid = 113091;
SELECT cost_fix FROM backup_ways WHERE gid = 110752;
SELECT cost_fix FROM backup_ways WHERE gid = 147223;
SELECT cost_fix FROM backup_ways WHERE gid = 115518;
SELECT cost_fix FROM backup_ways WHERE gid = 113092;
SELECT cost_fix FROM backup_ways WHERE gid = 113093;
SELECT cost_fix FROM backup_ways WHERE gid = 113094;
SELECT cost_fix FROM backup_ways WHERE gid = 232834;
SELECT cost_fix FROM backup_ways WHERE gid = 113086;
SELECT cost_fix FROM backup_ways WHERE gid = 118355;
SELECT cost_fix FROM backup_ways WHERE gid = 115514;
SELECT cost_fix FROM backup_ways WHERE gid = 113087;
SELECT cost_fix FROM backup_ways WHERE gid = 113088;
SELECT cost_fix FROM backup_ways WHERE gid = 118356;
SELECT cost_fix FROM backup_ways WHERE gid = 108678;
SELECT cost_fix FROM backup_ways WHERE gid = 108679;
SELECT cost_fix FROM backup_ways WHERE gid = 108680;
SELECT cost_fix FROM backup_ways WHERE gid = 115515;
SELECT cost_fix FROM backup_ways WHERE gid = 2422;
SELECT cost_fix FROM backup_ways WHERE gid = 2423;
SELECT cost_fix FROM backup_ways WHERE gid = 2424;
SELECT cost_fix FROM backup_ways WHERE gid = 2425;
SELECT cost_fix FROM backup_ways WHERE gid = 2426;
SELECT cost_fix FROM backup_ways WHERE gid = 158616;
SELECT cost_fix FROM backup_ways WHERE gid = 114194;
SELECT cost_fix FROM backup_ways WHERE gid = 158670;
SELECT cost_fix FROM backup_ways WHERE gid = 158671;
SELECT cost_fix FROM backup_ways WHERE gid = 102334;
SELECT cost_fix FROM backup_ways WHERE gid = 45624;
SELECT cost_fix FROM backup_ways WHERE gid = 45625;
SELECT cost_fix FROM backup_ways WHERE gid = 45626;
SELECT cost_fix FROM backup_ways WHERE gid = 45627;
SELECT cost_fix FROM backup_ways WHERE gid = 48066;
SELECT cost_fix FROM backup_ways WHERE gid = 50591;

ALTER TABLE osm_way_classes ADD COLUMN penalty FLOAT;

SELECT * FROM osm_way_classes ORDER BY type_id;

UPDATE osm_way_classes SET penalty=1;

UPDATE osm_way_classes SET penalty=2.0 WHERE class_id = 112;
UPDATE osm_way_classes SET penalty=2.0 WHERE class_id = 110;
UPDATE osm_way_classes SET penalty=0.8 WHERE class_id = 109;
UPDATE osm_way_classes SET penalty=0.3 WHERE class_id = 124;
UPDATE osm_way_classes SET penalty=0.3 WHERE class_id = 108;

UPDATE osm_way_classes SET penalty=2.0 WHERE class_id = 112;
UPDATE osm_way_classes SET penalty=1.5 WHERE class_id = 110;
UPDATE osm_way_classes SET penalty=0.8 WHERE class_id = 109;
UPDATE osm_way_classes SET penalty=0.5 WHERE class_id = 124;
UPDATE osm_way_classes SET penalty=0.5 WHERE class_id = 108;

SELECT a.seq AS seq, b.gid AS gid, b.name AS name, a.cost AS cost, b.the_geom AS geom, b.source, b.target, b.x1 AS x, b.y1 AS y FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost_fix * penalty AS cost,
         reverse_cost * penalty AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways JOIN osm_way_classes USING (class_id)',
    116452, 60644, true, true) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) ORDER BY a.seq;
    
SELECT SUM(route.cost) AS cost FROM (SELECT a.seq AS seq, b.gid AS gid, b.name AS name, a.cost AS cost, b.the_geom AS geom, b.source, b.target, b.x1 AS x, b.y1 AS y FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost_s AS cost,
         reverse_cost AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways JOIN osm_way_classes USING (class_id)',
    116452, 60644, true, true) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) ORDER BY a.seq) AS route;
    
SELECT * FROM backup_ways WHERE gid = 159919;
SELECT * FROM backup_ways WHERE gid = 2423;

CREATE INDEX percepat_akses ON backup_ways (gid, source, target);

SELECT cost_fix FROM backup_ways WHERE gid = 184502;

UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158311;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 145607;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 146074;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 146075;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 147378;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 147395;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 155236;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 157855;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158822;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185658;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 229627;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 239984;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2416;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 108457;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 117667;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 160323;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186080;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 234143;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 733;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2697;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 110342;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 125569;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158616;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158648;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158657;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158677;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158681;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158842;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 159868;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 161555;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 161556;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 161622;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 162223;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 162224;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 163013;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 177887;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 183541;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 183542;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 183544;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1607;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 183726;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1844150;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1841502;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 184543;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 184559;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1687;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 184562;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185308;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185358;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185437;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185418;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185422;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185444;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 160645;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185675;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185947;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186059;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186078;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186079;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186226;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186238;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186239;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186268;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186274;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187043;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187098;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187148;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187476;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187552;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187554;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187555;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1938;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2027;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 187562;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 194342;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 195329;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 223427;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 227796;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 228143;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 228147;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 229541;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 186121;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 195676;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 229624;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 231193;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 231424;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 231579;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 231705;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 231706;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 231822;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 232065;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 232182;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 232709;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 232816;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 232834;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 232835;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 232836;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1262;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 233811;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 233814;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 234792;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 235680;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 235723;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 235724;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 235794;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 235799;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 236258;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 236268;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 236269;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 239985;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 242018;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 244480;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2415001;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2415002;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 240;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 245;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 418;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 571;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 583;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 584;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 585;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 724;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 740;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 741;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1467;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2028;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2070;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2092;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2210;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2230;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1404;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 21503;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 21504;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2546;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 113084;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2670;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 4461;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 4472;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 4730;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 4779;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 4801;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 9492;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 9493;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 10119;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 10120;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 10160;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 46714;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 102623;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 113086;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 113105;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 113106;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 107347;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 107351;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 5101;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 10154;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 49017;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 538150;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 54965;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 107169;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 108459;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 108677;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 108774;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 109767;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 109771;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 110400;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 110626;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 110747;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 111345;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 1114150;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 112892;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 114191;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 114194;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 114839;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 115511;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 115534;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 115535;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 115764;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 116415;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 117154;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 117158;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 116908;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 119964;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 119995;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 120877;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 125608;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 125609;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 125610;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 125628;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 127008;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 127022;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 185256;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 158299;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 2426;
UPDATE backup_ways SET cost_clearroute = 150 WHERE gid = 113094;

ALTER TABLE backup_ways ADD cost_clearroute DOUBLE PRECISION;

SELECT a.seq AS seq, b.gid AS gid, b.name AS name, a.cost AS cost, b.the_geom AS geom, b.source, b.target, b.x1 AS x, b.y1 AS y FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         cost_clearroute * penalty::double precision AS cost,
         reverse_cost * penalty::double precision AS reverse_cost,
         x1, y1, x2, y2
        FROM backup_ways AS r JOIN osm_way_classes USING (class_id), (SELECT ST_Expand(ST_Extent(the_geom),0.1) as box FROM backup_ways as l1 WHERE l1.source = 116452 OR l1.target = 148471) as box
            WHERE r.the_geom && box.box',
    116452, 148471, true, true) AS a LEFT JOIN backup_ways AS b ON (a.id2 = b.gid) ORDER BY a.seq;
    
SELECT b.gid, a.cost, b.the_geom, b.name, b.source, b.target, b.x1 AS x, b.y1 AS y FROM ' ||
				'pgr_astar(''SELECT gid::integer AS id, source::integer, target::integer, ' ||
				'cost_clearroute * penalty::double precision AS cost, reverse_cost_s * penalty::double precision AS reverse_cost, x1, y1, x2, y2 FROM '
						 ||	quote_ident(tbl) AS r || ' JOIN osm_way_classes USING (class_id), (SELECT ST_Expand(ST_Extent(the_geom),0.1) as box FROM backup_ways as l1 WHERE l1.source = ' || source_var || ' OR l1.target = ' || target_var || ') as box
            WHERE r.the_geom && box.box'','
					    || source_var || ',' || target_var
						 || ', true, true) AS a LEFT JOIN ' || quote_ident(tbl) || ' AS b ON (a.id2 = b.gid) ORDER BY a.seq
						 
SELECT b.gid, a.cost, b.the_geom, b.name, b.source, b.target, b.x1 AS x, b.y1 AS y FROM ' ||
				'pgr_astar(''SELECT gid::integer AS id, source::integer, target::integer, ' ||
				'cost_clearroute * penalty::double precision AS cost, reverse_cost_s * penalty::double precision AS reverse_cost, x1, y1, x2, y2 FROM '
						 ||	quote_ident(tbl) || ' AS r JOIN osm_way_classes USING (class_id), (SELECT ST_Expand(ST_Extent(the_geom),0.1) as box FROM backup_ways as l1 WHERE l1.source = ' || source_var || ' OR l1.target = ' || target_var || ') as box 
				WHERE r.the_geom && box.box'','
					    || source_var || ',' || target_var
						 || ', true, true) AS a LEFT JOIN ' || quote_ident(tbl) || ' AS b ON (a.id2 = b.gid) ORDER BY a.seq