import random
import string
import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

email = os.getenv("EMAIL")
email_password = os.getenv("PASSWORD")
dbname = os.getenv("dbname")
db_psw = os.getenv("db_password")
host = os.getenv("host")
db_user = os.getenv("db_user")

# Функция для создания случайного пароля
def generate_password(length):
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for _ in range(length))


# Роли и пользователи для создания
roles_and_users = {
    'thirdpartyservice': ['thirdpartyserviceuser1', 'thirdpartyserviceuser2'],
    'marketer': ['marketer1', 'marketer2'],
    'analyst': ['analyst1', 'analyst2'],
    'seospecialist': ['seospecialist1', 'seospecialist2'],
    'designer': ['designer1', 'designer2'],
    'engineer': ['engineer1', 'engineer2'],
    'worker': ['worker1', 'worker2']
 #   'manager': ['manager']
}

try:
    # Подключение к базе данных
    conn = psycopg2.connect(f"dbname={dbname} user={db_user} host={host} password={db_psw}")
    cursor = conn.cursor()

    # Создание ролей
    for role in roles_and_users.keys():
        cursor.execute(f'CREATE ROLE {role};')

    # Создание пользователей и присвоение ролей
    for role, users in roles_and_users.items():
        for user in users:
            # Генерация случайного пароля для пользователя
            password = generate_password(10)

            # Создание пользователя
            cursor.execute(f"CREATE USER {user} WITH PASSWORD '{password}';")

            # Присвоение роли пользователю
            cursor.execute(f"GRANT {role} TO {user};")

    # Применение изменений в базе данных
    conn.commit()
    print('Пользователи и роли успешно созданы!')

except (Exception, psycopg2.Error) as error:
    print('Ошибка при создании пользователей и ролей:', error)

finally:
    # Закрытие соединения с базой данных
    if conn:
        cursor.close()
        conn.close()