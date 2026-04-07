Smart City Traffic & Mobility Analytics Platform
---
A real-time traffic analytics platform handling time-series and geospatial data with optimized SQL queries and execution-plan based performance tuning.

<img width="1920" height="1080" alt="grafana" src="https://github.com/user-attachments/assets/2be5843d-016d-4e3b-b7f7-3b96cb71ed89" />

A real-time traffic and mobility analytics platform built using PostgreSQL, TimescaleDB, and PostGIS to simulate, store, analyze, and visualize vehicle telemetry data at scale.

## Overview

This project is designed to demonstrate practical database engineering skills for time-series and geospatial workloads. It simulates live vehicle data, stores it in PostgreSQL/TimescaleDB, performs traffic analytics using SQL and PostGIS, and supports performance analysis with indexing and execution-plan inspection.

The system focuses on:

- real-time vehicle telemetry ingestion  
- time-series analytics using TimescaleDB  
- spatial analytics using PostGIS  
- query optimization using indexes and `EXPLAIN ANALYZE`  
- dashboard-friendly query outputs for visualization tools like Grafana  

## Tech Stack

- PostgreSQL
- TimescaleDB
- PostGIS
- Python
- psycopg2
- Grafana

## Project Structure

```text
sql/
  schema.sql
  queries.sql

data_ingestion/
  generator.py

Core Features
Real-Time Data Ingestion

A Python-based generator simulates live traffic data for multiple vehicles and inserts records into PostgreSQL in batches.

Generated fields include:

vehicle_id
timestamp
latitude
longitude
speed
route_id
vehicle_type
driver_id
status
fuel_level
engine_temp

Time-Series Data Management

Vehicle telemetry is stored in TimescaleDB for efficient handling of time-based data. The schema supports time-oriented querying and aggregation for traffic analysis.

Geospatial Analytics

PostGIS is used to enrich vehicle logs with spatial points derived from latitude and longitude. This enables hotspot detection and location-based traffic analysis.

Query Optimization

The project includes indexed queries, spatial indexing, and EXPLAIN ANALYZE to demonstrate practical SQL performance analysis.

Database Design Highlights
vehicle_logs stores vehicle telemetry data
PostGIS geom column is used for geospatial analysis
GIST spatial index improves spatial query performance
TimescaleDB functions such as time_bucket() support time-based analytics
Key SQL Use Cases

The project includes queries for:

latest vehicle activity
average speed by vehicle
peak speed analysis
fuel monitoring
congestion hotspot detection
hourly traffic trends
execution-plan analysis using EXPLAIN ANALYZE
Example Analytics
Congestion Hotspot Detection

Vehicle positions are snapped to a grid using ST_SnapToGrid() to identify high-density traffic zones.

Hourly Traffic Trend

time_bucket('1 hour', timestamp) is used to group traffic data into hourly windows for trend analysis.

Performance Inspection

Selected analytical queries are tested with EXPLAIN ANALYZE and optimized using indexes.

How to Run
1. Set up PostgreSQL with Extensions

Enable required extensions:
CREATE EXTENSION IF NOT EXISTS timescaledb;
CREATE EXTENSION IF NOT EXISTS postgis;

Create Schema

Run:
sql/schema.sql

Run Queries

Use:
sql/queries.sql

Start Data Generator

Run:
python data_ingestion/generator.py

Before running, update your database connection values inside generator.py.

Grafana Dashboard

Explain Analyze Output

Congestion Hotspot Query Result

What This Project Demonstrates

This project demonstrates:

practical PostgreSQL usage
TimescaleDB-based time-series handling
PostGIS-based spatial querying
real-time batch ingestion with Python
SQL analytics for mobility data
indexing and execution-plan based query optimization
Resume-Friendly Summary

Built a real-time traffic and mobility analytics platform using PostgreSQL, TimescaleDB, PostGIS, and Python. Simulated vehicle telemetry ingestion, implemented geospatial hotspot analysis, and optimized analytical queries using indexes and execution-plan analysis.

Future Improvements
live API layer using FastAPI
Docker-based local deployment
alerting for overspeed or congestion spikes
dashboard export integration with Grafana


## Key Achievements

- Optimized analytical query latency using indexing and execution plan analysis
- Implemented geospatial hotspot detection using PostGIS grid-based aggregation
- Simulated real-time ingestion of large-scale vehicle telemetry data using batch inserts
- Built time-series analytics using TimescaleDB hypertables and time_bucket()








