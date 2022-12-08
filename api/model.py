import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split

from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
# from joblib import dump, load
import re
import pickle

import psycopg2
import json
import os

# current_directory = os.getcwd()
# os.chdir(current_directory+"/api")
# print(current_directory)


def housesTrain(conn):
    df = pd.read_sql("select * from house", conn)
    df = df.drop(columns='id')
    target = 'price'
    features = [i for i in df.columns if i not in [target]]
    
    # Checking number of uniqe rows in each feature
    nu = df[features].nunique().sort_values()
    nf = []; cf = []; nnf = 0; ncf = 0; #numerical & categorical features
    for i in range(df[features].shape[1]):
        if nu.values[i]<=16:cf.append(nu.index[i])
        else: nf.append(nu.index[i])
    
    # Converting categorical Columns to Numeric
    nvc = pd.DataFrame(df.isnull().sum().sort_values(), columns=['Total Null Values'])
    nvc['Percentage'] = round(nvc['Total Null Values']/df.shape[0],3)*100
    
    df3 = df.copy()
    
    ecc = nvc[nvc['Percentage']!=0].index.values
    fcc = [i for i in cf if i not in ecc]
    
    # One-Hot Binay Encoding
    oh=True
    dm=True
    for i in fcc:
        #print(i)
        if df3[i].nunique()==2:
            if oh==True: print("\033[1mOne-Hot Encoding on features:\033[0m")
            oh=False
            df3[i]=pd.get_dummies(df3[i], drop_first=True, prefix=str(i))
        if (df3[i].nunique()>2 and df3[i].nunique()<17):
            if dm==True: print("\n\033[1mDummy Encoding on features:\033[0m")
            dm=False
            df3 = pd.concat([df3.drop([i], axis=1), pd.DataFrame(pd.get_dummies(df3[i], drop_first=True, prefix=str(i)))],axis=1)    
    
    # Removal of outlier:
    df1 = df3.copy()
    
    # features1 = [i for i in features if i not in ['CHAS','RAD']]
    features1 = nf

    for i in features1:
        Q1 = df1[i].quantile(0.25)
        Q3 = df1[i].quantile(0.75)
        IQR = Q3 - Q1
        df1 = df1[df1[i] <= (Q3+(1.5*IQR))]
        df1 = df1[df1[i] >= (Q1-(1.5*IQR))]
        df1 = df1.reset_index(drop=True)
    df = df1.copy()
    df.columns=[i.replace('-','_') for i in df.columns]
    m=[]
    for i in df.columns.values:
        m.append(i.replace(' ','_'))

    df.head
    df.columns = m
    X = df.drop([target],axis=1)
    print(X.columns)
    Y = df[target]
    Train_X, Test_X, Train_Y, Test_Y = train_test_split(X, Y, train_size=0.8, test_size=0.2, random_state=100)
    Train_X.reset_index(drop=True,inplace=True)
    MLR = LinearRegression().fit(Train_X,Train_Y)
    # joblib.dump(MLR, "model/new_model.joblib")
    pickle.dump(MLR, open('new_model.pickle', 'wb'))



def housesPredict(x):
    df = pd.DataFrame(x, columns = ['area', 'bedrooms', 'bathrooms', 'stories', 'mainroad',
       'guestroom', 'basement', 'hotwaterheating', 'airconditioning',
       'parking', 'prefarea', 'furnishingstatus'])
    
    # Necesitas preprocesar los datos como arriba
    target = 'price'
    features = [i for i in df.columns if i not in [target]]
    
    dummy_features = ['furnishingstatus', 'bathrooms', 'stories', 'parking', 'bedrooms']
    yes_no_columns = ['mainroad',
        'guestroom',
        'basement',
        'hotwaterheating',
        'airconditioning',
        'prefarea']
    original_cols = ['price', 'area', 'mainroad', 'guestroom', 'basement', 'hotwaterheating',
       'airconditioning', 'prefarea', 'furnishingstatus_semi_furnished',
       'furnishingstatus_unfurnished', 'bathrooms_2', 'bathrooms_3',
       'bathrooms_4', 'stories_2', 'stories_3', 'stories_4', 'parking_1',
       'parking_2', 'parking_3', 'bedrooms_2', 'bedrooms_3', 'bedrooms_4',
       'bedrooms_5', 'bedrooms_6']
    df_try = df.copy()
    df_try.columns
    for feat in dummy_features:
        for columns in original_cols:
            if re.search(feat, columns):
                df_try[columns] = np.where(df_try[feat].astype(str) == re.sub(".*_(.*)", "\\1", columns), 1, 0)
        df_try = df_try.drop(labels = feat, axis = 1)
    for column in yes_no_columns:
        df_try[column] = np.where(df_try[column] == "yes", 1, 0)
    print(df_try.columns)
    # Carga el modelo
    # MLR = load("model/new_model.joblib")
    MLR = pickle.load(open('new_model.pickle', 'rb'))
    prediction = MLR.predict(df_try)
    prediction