import smtplib
import psycopg2
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from dotenv import load_dotenv
import os

load_dotenv()

email = os.getenv("EMAIL")
email_password = os.getenv("PASSWORD")
dbname = os.getenv("dbname")
db_psw = os.getenv("db_password")
host = os.getenv("host")
db_user = os.getenv("db_user")

# Подключение к базе данных PostgreSQL
conn = psycopg2.connect(f"dbname={dbname} user={db_user} host={host} password={db_psw}")
cur = conn.cursor()

# Запрос на получение списка товаров с ненулевым остатком
cur.execute("SELECT * FROM public.remaining_products where quantity_in_stock > 0")
products = cur.fetchall()

# Запрос на получение списка покупателей и их электронных адресов
cur.execute("SELECT * FROM public.customers")
customers = cur.fetchall()

# Формирование XML-файла
xml_data = '<products>'
for product in products:
    xml_data += f'<product><name>{product[1]}</name><quantity>{product[2]}</quantity></product>'
xml_data += '</products>'

# Сохранение XML-файла
filename = 'products.xml'
with open(filename, 'w') as file:
    file.write(xml_data)


# Отправка файла по электронной почте
msg = MIMEMultipart()
msg['From'] = email
msg['To'] = ', '.join([customer[2] for customer in customers])  # Электронные адреса получателей
msg['Subject'] = 'XML File'

# Добавление содержимого письма
message = 'Hello,\n\nPlease find attached the XML file with the list of products.\n\nBest regards.'
msg.attach(MIMEText(message, 'plain'))

# Добавление вложения (XML-файла)
with open(filename, 'rb') as file:
    attach = MIMEApplication(file.read(), _subtype="xml")
attach.add_header('Content-Disposition', 'attachment', filename=filename)
msg.attach(attach)

# Отправка письма
with smtplib.SMTP('smtp.gmail.com', 587) as server:
    server.starttls()
    server.login(email, email_password)
    server.sendmail(email, msg['To'].split(', '), msg.as_string())

# Удаление временного XML-файла
os.remove(filename)