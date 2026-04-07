-- Smart City Traffic & Mobility Analytics Platform
-- queries.sql
-- Clean project queries for direct use in repo

-- =====================================================
-- 1) Basic validation queries
-- =====================================================

-- Preview latest vehicle records
SELECT "timestamp", vehicle_id, speed, status, fuel_level
FROM public.vehicle_logs
ORDER BY "timestamp" DESC
LIMIT 10;

-- Preview selected fields
SELECT "timestamp", speed, fuel_level
FROM public.vehicle_logs
LIMIT 5;


-- =====================================================
-- 2) PostGIS setup queries
-- =====================================================

-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Check PostGIS version
SELECT PostGIS_Full_Version();

-- Add spatial column for vehicle positions
ALTER TABLE public.vehicle_logs
ADD COLUMN IF NOT EXISTS geom geography(Point, 4326);

-- Populate geom using longitude and latitude
UPDATE public.vehicle_logs
SET geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
WHERE longitude IS NOT NULL
  AND latitude IS NOT NULL;

-- Create spatial index for faster geospatial queries
CREATE INDEX IF NOT EXISTS idx_vehicle_geom
ON public.vehicle_logs
USING GIST (geom);


-- =====================================================
-- 3) Spatial analytics queries
-- =====================================================

-- Top 5 congestion hotspots
-- Counts moving vehicles in 0.01° x 0.01° grids
SELECT
    ST_SnapToGrid(geom::geometry, 0.01) AS grid_geom,
    COUNT(*) AS vehicle_count
FROM public.vehicle_logs
WHERE status = 'moving'
GROUP BY grid_geom
ORDER BY vehicle_count DESC
LIMIT 5;

-- Heatmap-style hotspot query for last 1 hour
SELECT
    ST_Y(grid_geom) AS latitude,
    ST_X(grid_geom) AS longitude,
    vehicle_count
FROM (
    SELECT
        ST_SnapToGrid(geom::geometry, 0.01) AS grid_geom,
        COUNT(*) AS vehicle_count
    FROM public.vehicle_logs
    WHERE "timestamp" >= NOW() - INTERVAL '1 hour'
    GROUP BY grid_geom
) AS grids
ORDER BY vehicle_count DESC
LIMIT 100;


-- =====================================================
-- 4) Traffic analytics queries
-- =====================================================

-- Average speed by vehicle for last 10 minutes
SELECT
    vehicle_id,
    AVG(speed) AS avg_speed
FROM public.vehicle_logs
WHERE "timestamp" >= NOW() - INTERVAL '10 minutes'
GROUP BY vehicle_id
ORDER BY avg_speed DESC;

-- Peak speed by vehicle
SELECT
    vehicle_id,
    MAX(speed) AS max_speed
FROM public.vehicle_logs
GROUP BY vehicle_id
ORDER BY max_speed DESC;

-- Fuel level monitoring
SELECT
    vehicle_id,
    fuel_level,
    "timestamp"
FROM public.vehicle_logs
ORDER BY "timestamp" DESC
LIMIT 20;


-- =====================================================
-- 5) Performance / optimization proof queries
-- =====================================================

-- Execution plan for average speed query
EXPLAIN ANALYZE
SELECT
    vehicle_id,
    AVG(speed) AS avg_speed
FROM public.vehicle_logs
WHERE "timestamp" >= NOW() - INTERVAL '10 minutes'
GROUP BY vehicle_id;

-- Optional index for faster vehicle/time filtering
CREATE INDEX IF NOT EXISTS idx_vehicle_logs_vehicle_time
ON public.vehicle_logs (vehicle_id, "timestamp" DESC);

-- Re-run explain analyze after indexing
EXPLAIN ANALYZE
SELECT
    vehicle_id,
    AVG(speed) AS avg_speed
FROM public.vehicle_logs
WHERE "timestamp" >= NOW() - INTERVAL '10 minutes'
GROUP BY vehicle_id;


-- =====================================================
-- 6) Time-bucket analytics (Timescale-style)
-- =====================================================

-- Hourly average speed trend
SELECT
    time_bucket('1 hour', "timestamp") AS bucket,
    AVG(speed) AS avg_speed
FROM public.vehicle_logs
GROUP BY bucket
ORDER BY bucket DESC
LIMIT 24;
