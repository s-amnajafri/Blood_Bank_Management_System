import pandas as pd
from db import get_connection

def get_donor_summary():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM DonorSummary")
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def get_units_by_blood_group():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT bloodGroup, COUNT(*) AS TotalUnits
        FROM BloodUnit
        GROUP BY bloodGroup
        ORDER BY TotalUnits DESC
    """)
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def get_monthly_report(year, month):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.callproc("GenerateMonthlyDonationReport", [year, month])
    for result in cursor.stored_results():
        rows = result.fetchall()
        cols = [desc[0] for desc in result.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def get_discard_report():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.callproc("GetDiscardReport", [])
    for result in cursor.stored_results():
        rows = result.fetchall()
        cols = [desc[0] for desc in result.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def get_requests_by_status():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT status, COUNT(*) AS `Count`
        FROM BloodRequest
        GROUP BY status
    """)
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)