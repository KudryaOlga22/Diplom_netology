import os
import datetime

archive_dir = '/home/archive/'
delete_date = datetime.datetime.now() - datetime.timedelta(days=40)
files = os.listdir(archive_dir)
for file_name in files:
       file_path = os.path.join(archive_dir, file_name)
       creation_time = datetime.datetime.fromtimestamp(os.path.getctime(file_path))
       if creation_time < delete_date:
           os.remove(file_path)
