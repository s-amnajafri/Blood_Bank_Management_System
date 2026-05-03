import pandas as pd
from db import get_connection

def get_available_stock():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM AvailableBloodStock")
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def get_expired_units():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM ExpiredBloodUnits")
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def check_availability(blood_group):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.callproc("CheckBloodAvailability", [blood_group])
    for result in cursor.stored_results():
        rows = result.fetchall()
        cols = [desc[0] for desc in result.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)