import pandas as pd
from db import get_connection

def get_pending_requests():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM PendingRequests")
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def get_all_requests():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT br.requestID, p.name AS PatientName,
               h.name AS HospitalName, br.bloodGroup,
               br.status, br.unitsRequired, br.requestDate
        FROM BloodRequest br
        JOIN Patient pa  ON br.patientID  = pa.patientID
        JOIN Person  p   ON pa.personID   = p.personID
        JOIN Hospital h  ON br.hospitalID = h.hospitalID
        ORDER BY br.requestDate DESC
    """)
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def approve_request(request_id):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.callproc("ApproveBloodRequest", [request_id])
        conn.commit()
        return True, f"Request {request_id} approved!"
    except Exception as e:
        return False, str(e)
    finally:
        conn.close()