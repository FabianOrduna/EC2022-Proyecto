import psycopg2
from flask import Flask
app = Flask(__name__)

from sqlalchemy import create_engine
from sqlalchemy import Table, Column, MetaData, Integer, Computed, Identity, String

db_name = 'postgres'
db_user = 'postgres'
db_pass = 'postgres'
db_host = '0.0.0.0'
db_port = '5432'
db_schema = 'public'


def connectSqlAlchemy():
    # Connecto to the database
    db_string = 'postgresql://{}:{}@{}:{}/{}'.format(db_user, db_pass, db_host, db_port, db_name)
    
    valido=0
    db = None
    try:
        db = create_engine(db_string)
        valido = 1
    except Error:
        valido = 0
    
    return db, valido


def initialDBSetup():

    engine, valido = connectSqlAlchemy()

    if(valido == 0):
        return "Algo salió mal con la conexion"
    
    return "conexion valida"

def get_schema(table_name, conn):
    metadata = MetaData(bind=None)
    return Table(table_name, metadata, autoload=True, autoload_with=conn)

@app.route('/')
def hello_world():
    return 'Hello world del proyecto. Ir a la de test <a href=test>Test page</a>'

@app.route("/test")
def api():
    return "este es un test"
 
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0') # This statement starts the server on your local machine.
