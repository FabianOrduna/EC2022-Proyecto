import psycopg2
from flask import Flask, make_response, request
import json
from model import housesTrain, housesPredict

app = Flask(__name__)

db_name = 'postgres'
db_user = 'postgres'
db_pass = 'postgres'
db_host = 'db'
db_port = '5432'
db_schema = 'public'

def getConnectionCursor():
    connection = None
    cursor = None
    try:
        connection = psycopg2.connect(user=db_user,
                                    password= db_pass,
                                    host=db_host,
                                    port=db_port,
                                    database=db_name)
        cursor = connection.cursor()
        
    except (Exception, psycopg2.Error) as error:
        print("Error while stablishing connection")
    
    return connection, cursor

def getHouses():
    # id, price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating
    # airconditioning, parking, prefarea, furnishingstatus
    connection = None
    cursor = None
    houses = []
    try:
        connection, cursor = getConnectionCursor()
        query = "select * from house"

        cursor.execute(query)
        print("Selecting rows from mobile table using cursor.fetchall")
        houses = cursor.fetchall()        

        tmp = [ {'id':id,
        'price':price,
        'area':area,
        'bedrooms':bedrooms,
        'bathrooms':bathrooms,
        'stories':stories,
        'mainroad':mainroad,
        'guestroom':guestroom,
        'basement':basement,
        'hotwaterheating':hotwaterheating,
        'airconditioning':airconditioning,
        'parking':parking,
        'prefarea':prefarea,
        'furnishingstatus':furnishingstatus
        } for id, price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating, airconditioning, parking, prefarea, furnishingstatus  in houses ]      

        houses = tmp    


    except (Exception, psycopg2.Error) as error:
        print("Error while fetching data from PostgreSQL")

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

    return houses

def getAHouse(id):
    # id, price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating
    # airconditioning, parking, prefarea, furnishingstatus
    connection = None
    cursor = None
    houses = []
    try:
        connection, cursor = getConnectionCursor()
        query = "select * from house WHERE id = "+str(id)

        cursor.execute(query)
        print("Selecting rows from mobile table using cursor.fetchall")
        houses = cursor.fetchall()

        tmp = [ {'id':id,
        'price':price,
        'area':area,
        'bedrooms':bedrooms,
        'bathrooms':bathrooms,
        'stories':stories,
        'mainroad':mainroad,
        'guestroom':guestroom,
        'basement':basement,
        'hotwaterheating':hotwaterheating,
        'airconditioning':airconditioning,
        'parking':parking,
        'prefarea':prefarea,
        'furnishingstatus':furnishingstatus
        } for id, price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating, airconditioning, parking, prefarea, furnishingstatus  in houses ]      

        houses = tmp

    except (Exception, psycopg2.Error) as error:
        print("Error while fetching data from PostgreSQL")

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

    return houses

def createAHouse(price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating, airconditioning, parking, prefarea, furnishingstatus):

    connection = None
    cursor = None
    houses = []
    lastInserted = -1
    try:
        connection, cursor = getConnectionCursor()
        query = "insert into house (price, area, bedrooms, bathrooms, stories, mainroad, guestroom,"
        query += "basement, hotwaterheating, airconditioning, parking, prefarea, furnishingstatus) values "
        query += "("+price+","+area+","+bedrooms+","+bathrooms+","+stories+","
        query += "'"+mainroad+"','"+guestroom+"','"+basement+"','"+hotwaterheating+"','"+airconditioning+"',"+parking+",'"+prefarea+"','"+furnishingstatus+"') returning id"

        cursor.execute(query)
        lastInserted  = cursor.fetchone()[0]
        connection.commit()
    except (Exception, psycopg2.Error) as error:
        print("Error while processing data from PostgreSQL")
        lastInserted = error

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

    return lastInserted

def updateAHouse(id, price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating, airconditioning, parking, prefarea, furnishingstatus):

    connection = None
    cursor = None
    houses = []
    lastUpdated = -1
    try:
        connection, cursor = getConnectionCursor()
        query = "update house set price = "+price+", area = "+area+", bedrooms = "+bedrooms+", bathrooms = "+bathrooms+", stories = "+stories+", mainroad = '"+mainroad+"',"
        query += "guestroom = '"+guestroom+"', basement = '"+basement+"', hotwaterheating = '"+hotwaterheating+"', airconditioning = '"+airconditioning+"',"
        query += "parking = "+parking+", prefarea = '"+prefarea+"', furnishingstatus = '"+furnishingstatus+"' where id = "+id+" returning id"

        cursor.execute(query)
        lastUpdated  = cursor.rowcount
        connection.commit()
    except (Exception, psycopg2.Error) as error:
        print("Error while processing data from PostgreSQL")
        lastUpdated = error

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

    return lastUpdated

def deleteAHouse(id):
    # id, price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating
    # airconditioning, parking, prefarea, furnishingstatus
    connection = None
    cursor = None
    houses = []
    totalDeleted = 0
    try:
        connection, cursor = getConnectionCursor()
        query = "delete from house WHERE id = "+str(id)
        cursor.execute(query)
        totalDeleted = cursor.rowcount
        connection.commit()

    except (Exception, psycopg2.Error) as error:
        print("Error while fetching data from PostgreSQL")

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

    return totalDeleted



@app.route('/')
def hello_world():
    menu = "<div><h1>Houses API</h1><p>Puedes procesar información de casas con esta api</p></div>"
    menu += "<div>"
    menu += "<table border=1>"
    menu += "<tr><th>Método</th><th>Endpoint</th><th>Parámetros</th><th>Cuerpo</th><th>Resultado</th></tr>"
    menu += "<tr><td>POST</td><td>/houses</td><td>NA</td><td>price: Variable a predecir, precio de la casa en dólares.<br/>"
    menu += "area: Área de la casa<br/>"
    menu += "bedrooms: Número de cuartos<br/>"
    menu += "bathrooms: Número de baños<br/>"
    menu += "stories: Número de pisos de la casa<br/>"
    menu += "mainroad: Si está conectada a un camino principal<br/>"
    menu += "guestroom: Si tiene cuarto de invitados<br/>"
    menu += "basement: Si tienen sótano<br/>"
    menu += "hotwaterheating: Si tiene calentador de agua<br/>"
    menu += "airconditioning: Si cuenta con aire acondicionado<br/>"
    menu += "parking: Número de lugares de estacionamiento<br/>"
    menu += "prefarea: ¿Está en un área preferente?<br/>"
    menu += "furnishingstatus: Es estatus del amueblado</td><td>Regresa el objeto creado con su id</td></tr>"
    menu += "<tr><td>GET</td><td>/houses</td><td>NA</td><td>NA</td><td>Regresa la lista de casas</td></tr>"
    menu += "<tr><td>GET</td><td>/houses/id</td><td>id: el identificador de la casa a buscar</td><td>NA</td><td>Regresa una casa</td></tr>"
    menu += "<tr><td>PUT</td><td>/houses/id</td><td>id: el identificador de la casa a actualizar</td><td>price: Variable a predecir, precio de la casa en dólares.<br/>"
    menu += "area: Área de la casa<br/>"
    menu += "bedrooms: Número de cuartos<br/>"
    menu += "bathrooms: Número de baños<br/>"
    menu += "stories: Número de pisos de la casa<br/>"
    menu += "mainroad: Si está conectada a un camino principal<br/>"
    menu += "guestroom: Si tiene cuarto de invitados<br/>"
    menu += "basement: Si tienen sótano<br/>"
    menu += "hotwaterheating: Si tiene calentador de agua<br/>"
    menu += "airconditioning: Si cuenta con aire acondicionado<br/>"
    menu += "parking: Número de lugares de estacionamiento<br/>"
    menu += "prefarea: ¿Está en un área preferente?<br/>"
    menu += "furnishingstatus: Es estatus del amueblado</td><td>Regresa el registgro actualizado</td></tr>"
    menu += "<tr><td>DELETE</td><td>/houses/id</td><td>id: el identificador de la casa a borrar</td><td>NA</td><td>Regresa vacío</td></tr>"
    menu += "</table>"
    menu += "</div>"
    menu += "<div>"
    menu += "<p>Además, puedes re-entrenar un modelo de predicción de precios con base en los datos que se encuentren en la base.</p>"
    menu += "<table border=1>"
    menu += "<tr><th>Método</th><th>Endpoint</th><th>Parámetros</th><th>Cuerpo</th><th>Resultado</th></tr>"
    menu += "<tr><td>POST</td><td>/houses/train</td><td>NA</td><td>NA</td><td>Regresa que la operación ha concluido</td></tr>"
    menu += "<tr><td>POST</td><td>/houses/predict</td><td>NA</td><td>area: Área de la casa<br/>"
    menu += "bedrooms: Número de cuartos<br/>"
    menu += "bathrooms: Número de baños<br/>"
    menu += "stories: Número de pisos de la casa<br/>"
    menu += "mainroad: Si está conectada a un camino principal<br/>"
    menu += "guestroom: Si tiene cuarto de invitados<br/>"
    menu += "basement: Si tienen sótano<br/>"
    menu += "hotwaterheating: Si tiene calentador de agua<br/>"
    menu += "airconditioning: Si cuenta con aire acondicionado<br/>"
    menu += "parking: Número de lugares de estacionamiento<br/>"
    menu += "prefarea: ¿Está en un área preferente?<br/>"
    menu += "furnishingstatus: Es estatus del amueblado</td><td>Regresa que la operación ha concluido</td></tr>"
    menu += "</table>"
    menu += "<div>"

    return menu

# CREATE
@app.route("/houses", methods=['POST'])
def houseCreation():
    # se jala del body, si esta bien se procesa... sino se regresa error
    data = request.form
    
    createdId = createAHouse(data["price"],
    data["area"],
    data["bedrooms"],
    data["bathrooms"],
    data["stories"],
    data["mainroad"],
    data["guestroom"],
    data["basement"],
    data["hotwaterheating"],
    data["airconditioning"],
    data["parking"],
    data["prefarea"],
    data["furnishingstatus"])

    if createdId > -1:
        house = getAHouse(createdId)
        response = make_response(json.dumps(house),201)
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response
    else:
        response = make_response(json.dumps({"error":"could not insert the house"}),400)
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response


# READ ALL
@app.route("/houses")
def houses():
    houses = getHouses()
    response = make_response(json.dumps(houses))                                           
    response.headers['Content-Type'] = 'application/json; charset=utf-8'            
    return response

# READ
@app.route("/houses/<id>", methods=['GET'])
def house(id):
    house = getAHouse(id)
    if len(house) == 1:
        response = make_response(json.dumps(house[0]),200)                                           
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response
    else:
        response = make_response(json.dumps([]), 404)                                           
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response

# UPDATE
@app.route("/houses/<id>", methods=['PUT'])
def houseUpdate(id):
    # aqui se hace el update y se jala del cuerpo

    data = request.form
    
    totalUpdates = updateAHouse(id, data["price"],
    data["area"],
    data["bedrooms"],
    data["bathrooms"],
    data["stories"],
    data["mainroad"],
    data["guestroom"],
    data["basement"],
    data["hotwaterheating"],
    data["airconditioning"],
    data["parking"],
    data["prefarea"],
    data["furnishingstatus"])

    if totalUpdates == 1:
        house = getAHouse(id)
        response = make_response(json.dumps(house),200)
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response
    else:
        response = make_response(json.dumps({"error":"could not update the house"}),400)
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response


# DELETE
@app.route("/houses/<id>", methods=['DELETE'])
def houseDelete(id):
    house = getAHouse(id)
    if len(house) == 1:
        resp = deleteAHouse(id)
        response = make_response(json.dumps(resp),204)
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response
    else:
        response = make_response(json.dumps([]), 404)                                           
        response.headers['Content-Type'] = 'application/json; charset=utf-8'            
        return response

# UPDATE MODEL
@app.route("/houses/train", methods=['POST'])
def housesTrain():
    con, cursor = getConnectionCursor()
    housesTrain(con)
    return True

# EVAL MODEL
@app.route("/houses/predict", methods=['POST'])
def housesPredict(json):
    con, cursor = getConnectionCursor()
    housesPredict(con)
    return(prediction)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0') # This statement starts the server on your local machine.
