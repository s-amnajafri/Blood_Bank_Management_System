import pandas as pd
from db import get_connection

def get_all_donors():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT p.name AS DonorName, d.bloodGroup,
               p.age, p.gender, p.contact
        FROM Person p
        JOIN Donor d ON p.personID = d.personID
    """)
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)

def add_donor(name, gender, age, contact, blood_group):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO Person (name, gender, age, contact)
            VALUES (%s, %s, %s, %s)
        """, (name, gender, age, contact))
        person_id = cursor.lastrowid
        cursor.execute("""
            INSERT INTO Donor (personID, bloodGroup)
            VALUES (%s, %s)
        """, (person_id, blood_group))
        conn.commit()
        return True, "Donor added successfully!"
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        conn.close()

def search_donor(blood_group):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT p.name AS DonorName, d.bloodGroup,
               p.age, p.contact
        FROM Person p
        JOIN Donor d ON p.personID = d.personID
        WHERE d.bloodGroup = %s
    """, (blood_group,))
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    conn.close()
    return pd.DataFrame(rows, columns=cols)