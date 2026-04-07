import psycopg2
import random
from datetime import datetime, timedelta

# 🔹 DB Config
DB_CONFIG = {
    "host": "localhost",
    "database": "traffic_db",  # ✅ apna real project DB
    "user": "postgres",
    "password": "your_password",
    "port": "5432"
}

# 🔹 Connection
def get_connection():
    return psycopg2.connect(**DB_CONFIG)

# 🔹 Fixed vehicles (identity same rahegi)
vehicles = []
for i in range(1, 101):
    vehicles.append({
        "vehicle_id": f"V{i}",
        "driver_id": f"D{i}",
        "vehicle_type": random.choice(["car", "bus", "truck", "bike"]),
        "route_id": f"R{random.randint(1,5)}",
        "fuel_level": random.uniform(60, 100),
        "latitude": 20.50 + random.random(),
        "longitude": 78.90 + random.random()
    })

current_time = datetime.now()

# 🔹 Generate one row
def generate_row(vehicle):
    global current_time

    status = random.choice(["moving", "idle", "stopped"])

    if status == "moving":
        speed = random.randint(20, 80)
        engine_temp = random.randint(90, 120)
        vehicle["latitude"] += random.uniform(0.0005, 0.002)
        vehicle["longitude"] += random.uniform(0.0005, 0.002)

    elif status == "idle":
        speed = random.randint(0, 10)
        engine_temp = random.randint(70, 90)

    else:  # stopped
        speed = 0
        engine_temp = random.randint(70, 80)

    vehicle["fuel_level"] -= random.uniform(0.1, 0.5)
    if vehicle["fuel_level"] < 0:
        vehicle["fuel_level"] = random.uniform(10, 20)  # refill

    row = (
        vehicle["vehicle_id"],
        current_time,
        round(vehicle["latitude"], 6),
        round(vehicle["longitude"], 6),
        speed,
        vehicle["route_id"],
        vehicle["vehicle_type"],
        vehicle["driver_id"],
        status,
        round(vehicle["fuel_level"], 2),
        engine_temp
    )

    current_time += timedelta(seconds=1)
    return row

# 🔹 Insert batch
def insert_batch(rows):
    conn = get_connection()
    cursor = conn.cursor()

    query = """
    INSERT INTO public.vehicle_logs (
        vehicle_id, timestamp, latitude, longitude, speed,
        route_id, vehicle_type, driver_id, status,
        fuel_level, engine_temp
    ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """  # ✅ public schema fix

    cursor.executemany(query, rows)
    conn.commit()
    cursor.close()
    conn.close()

# 🔹 MAIN LOOP
while True:
    user_input = input("Kitne rows chahiye? (multiple of 10000, ya 'exit'): ")

    if user_input.lower() == "exit":
        break

    total_rows = int(user_input)
    batch_size = 10000

    for _ in range(total_rows // batch_size):
        batch = []
        for _ in range(batch_size):
            vehicle = random.choice(vehicles)
            batch.append(generate_row(vehicle))

        insert_batch(batch)
        print(f"✅ {batch_size} rows inserted...")

    print(f"🔥 Total {total_rows} rows inserted successfully!\n")