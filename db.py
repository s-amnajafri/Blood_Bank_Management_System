import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Alish@1795",  # change this to YOUR password
        database="bloodbank"
    )