-- Clean schema for Smart City Traffic & Mobility Analytics Platform
-- Focused for portfolio / GitHub presentation

CREATE EXTENSION IF NOT EXISTS timescaledb;
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE IF NOT EXISTS public.vehicle_logs (
    vehicle_id TEXT,
    "timestamp" TIMESTAMP NOT NULL,
    latitude NUMERIC,
    longitude NUMERIC,
    speed NUMERIC,
    route_id TEXT,
    vehicle_type TEXT,
    driver_id TEXT,
    status TEXT,
    fuel_level NUMERIC,
    engine_temp NUMERIC,
    geom GEOGRAPHY(Point, 4326)
);

SELECT create_hypertable('public.vehicle_logs', 'timestamp', if_not_exists => TRUE);

CREATE INDEX IF NOT EXISTS idx_vehicle_id ON public.vehicle_logs (vehicle_id);
CREATE INDEX IF NOT EXISTS idx_timestamp ON public.vehicle_logs ("timestamp");
CREATE INDEX IF NOT EXISTS idx_route_id ON public.vehicle_logs (route_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_geom ON public.vehicle_logs USING GIST (geom);

CREATE MATERIALIZED VIEW IF NOT EXISTS public.vehicle_logs_hourly
WITH (timescaledb.continuous) AS
SELECT
    time_bucket(INTERVAL '1 hour', "timestamp") AS hour,
    route_id,
    COUNT(*) AS total_trips,
    AVG(speed) AS avg_speed,
    AVG(fuel_level) AS avg_fuel
FROM public.vehicle_logs
GROUP BY hour, route_id
WITH NO DATA;

CREATE INDEX IF NOT EXISTS idx_vehicle_logs_hourly_hour
ON public.vehicle_logs_hourly (hour DESC);

CREATE INDEX IF NOT EXISTS idx_vehicle_logs_hourly_route_hour
ON public.vehicle_logs_hourly (route_id, hour DESC);
