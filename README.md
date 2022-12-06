# EC2022-Proyecto Final Housing Prices 




## Colaboradores

| Nombre                     | Clave   |
| -------------------------- | ------- |
| Fabián Orduña Ferreira.    | 159001  |
| José Avilla Nueva López    | 209776  |
| Juan Carlos Soto Hernández | 82616   |




## Dataset

Es un dataset simple se tiene la finalidad de predecir el precio de las casas basadoos en ciertos factores comoo área de la casa, número de baños, si está amueblado, o se encuentra cerca de un camino principal, etc. 

El dataset es pequeño y com'lejo ya que contiene una fuerte multicolinealidad. 

Número de registros: 545

Número de columnas: 13



* `price`: Variable a predecir, precio de la casa en dólares.

* `area`: Área de la casa

* `bedrooms`: Número de cuartos

* `bathrooms`: Número de baños

* `stories`: Número de pisos de la casa

* `mainroad`: Si está conectada a un camino principal

* `guestroom`: Si tiene cuarto de invitados

* `basement`: Si tienen sótano

* `hotwaterheating`: Si tiene calentador de agua

* `airconditioning`: Si cuenta con aire acondicionado

* `parking`: Número de lugares de estacionamiento
 
* `prefarea`: ¿Está en un área preferente?

* `furnishingstatus`: Es estatus del amueblado

## Herramientas utilizadas:

* Bash

* PostgreSQL

* Docker

* Flask

* Python

* R

* Shiny

# Pregunta a contestar

¿Podemos estimar el precio de las casas con las variables presentadas?

## Pasos para correr este proyecto:

* Clonar el repositorio

```
git clone git@github.com:FabianOrduna/EC2022-Proyecto.git
```

* Cambiar al directorio del proyecto

```
cd EC2022-Proyecto
```


* Construir las imagenes

```
docker-compose build
```

* Activa los contenedores

```
docker-compose up
```
