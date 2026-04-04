Smart City Traffic & Mobility Analytics Platform

<img width="1920" height="1080" alt="grafana" src="https://github.com/user-attachments/assets/2be5843d-016d-4e3b-b7f7-3b96cb71ed89" />

An end-to-end data engineering project designed to monitor urban traffic in real-time. This platform leverages the **PostgreSQL ecosystem** to handle massive time-series datasets and geospatial movements, optimized for performance and scalability.

---

 Live Dashboard Preview
This dashboard provides real-time visibility into traffic movement and safety violations.

(<img width="1920" height="1080" alt="grafana" src="https://github.com/user-attachments/assets/1cffad5e-d53a-4ff7-8231-d8c0b525700c" />
)

*The screenshot shows a comprehensive traffic monitoring panel, including live overspeed counts, a geospatial map, vehicle speed over time, and a detailed list of overspeed violations.*

---

##  Key Highlights (Alignment with Tiger Data/Timescale)
- **Time-Series Optimization:** Utilized **TimescaleDB Hypertables** for efficient storage and querying of millions of vehicle logs.
- **Geospatial Intelligence:** Integrated **PostGIS** for location-based tracking (using Latitude/Longitude) and mapping.
- **Real-time Monitoring & Alerting:** Built automated **Alerting Systems** in Grafana for overspeed detection (>60 km/h).
- **Performance Tuning:** Focused on SQL optimization, indexing strategies, and analyzing execution plans for complex analytical queries.

---

##  Tech Stack
| Component | Technology |
| :--- | :--- |
| **Database** | PostgreSQL + TimescaleDB |
| **Geospatial** | PostGIS |
| **Data Generation** | Python (Faker / Custom Scripts) |
| **Visualization** | Grafana |
| **Orchestration** | SQL CTEs, Window Functions, PL/pgSQL |

---

##  Dashboard Features (In Detail)

### 1. Geo-Mapping (PostGIS Integration)
The Geomap panel displays live vehicle locations.
![Geomap Panel](Smart_City_Map.png)
*(Replace this placeholder with a direct screenshot of just the map panel for a closer look)*

* Uses **PostGIS** spatial coordinates for precise mapping.
* Implemented clear color-coding (Layer legend):
    *  `< 60 km/h` (Normal speed)
    *  `60+ km/h` (Overspeed violation)

### 2. Time-Series Analysis & Alerting 
The 'Speed vs Time' graph and the 'Overspeed Details' table work together.
* **Time Series Graph:** Displays a specific vehicle's speed over the last 5 minutes.
* **Detailed Overspeed Table:** Shows a log of violations including timestamp, vehicle ID, speed (highlighted in red for speed >60 km/h), and driver ID.
* An automatic **Grafana Alert** is triggered whenever a speed data point exceeds the limit.

---

##  Database Schema & Optimization

```sql
-- Creating table for vehicle logs
CREATE TABLE vehicle_logs (
    timestamp TIMESTAMPTZ NOT NULL,
    vehicle_id TEXT NOT NULL,
    driver_id TEXT NOT NULL,
    vehicle_type TEXT,
    speed DOUBLE PRECISION,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);

-- Example of creating a hypertable for performance
SELECT create_hypertable('vehicle_logs', 'timestamp');

Partitioning: Converted the table into a TimescaleDB Hypertable for lightning-fast historical queries.

Query Focus: Used CTEs and Window functions to calculate average speeds and detect bottlenecks efficiently.

 What I Learned (Relevant to Tiger Data Role)
Database Support: Troubleshooting query performance issues on large datasets.

TimescaleDB/PostgreSQL: Direct work with hypertables, indexing, and understanding performance bottlenecks.

Full Stack Exposure: Debugging data issues across the stack—from Python data generation to Grafana visualization.
