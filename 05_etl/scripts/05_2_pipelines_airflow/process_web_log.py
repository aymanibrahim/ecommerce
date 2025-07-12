# Import the libraries
from datetime import timedelta

# DAG object to instantiate a DAG
from airflow.models import DAG

# Operators to write tasks
from airflow.operators.bash_operator import BashOperator

# Scheduling 
from airflow.utils.dates import days_ago

# Define the DAG arguments
default_args = {
    'owner': 'John Doe',
    'start_date': days_ago(0),
    'email': ['john.doe@example.com'],
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

# Define the DAG
dag = DAG(
    'process_web_log',
    default_args=default_args,
    description='ETL pipeline to process web server log',
    schedule_interval=timedelta(days=1)
)

# Define base directory
base_path = '/home/project/airflow/dags/base'

# Create a task to extract data
extract_data = BashOperator(
    task_id='extract_data',
    bash_command=f'cut -d" " -f1 {base_path}/accesslog.txt > {base_path}/extracted_data.txt',
    dag=dag
)

# Create a task to transform the data in the txt file
transform_data = BashOperator(
    task_id='transform_data',
    bash_command=f'grep -v "198.46.149.143" {base_path}/extracted_data.txt > {base_path}/transformed_data.txt',
    dag=dag
)

# Create a task to load the data
load_data = BashOperator(
    task_id='load_data',
    bash_command=f'tar -cvf {base_path}/weblog.tar -C {base_path}/ transformed_data.txt',
    dag=dag
)

# Define the task pipeline
extract_data >> transform_data >> load_data

