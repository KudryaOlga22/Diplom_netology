import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

dbname = os.getenv("dbname")
db_psw = os.getenv("db_password")
host = os.getenv("host")
db_user = os.getenv("db_user")

# Подключение к базе данных PostgreSQL
conn = psycopg2.connect(f"dbname={dbname} user={db_user} host={host} password={db_psw}")
cur = conn.cursor()

# Вызов процедуры для генерации и загрузки XML-файла
cur.callproc('generate_and_download_xml')

# Загрузка XML-файла с сервера
filename = '/tmp/products.xml'
with open(filename, 'rb') as file:
    xml_data = file.read()

# Удаление временного XML-файла
os.remove(filename)