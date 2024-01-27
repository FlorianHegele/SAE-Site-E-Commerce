#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_meuble = Blueprint('client_meuble', __name__,
                          template_folder='templates')


@client_meuble.route('/client/index')
@client_meuble.route('/client/meuble/show')  # remplace /client
def client_meuble_show():  # remplace client_index
    mycursor = get_db().cursor()
    id_client = session['id_user']

    sql = '''SELECT * FROM meuble'''
    list_param = []
    condition_and = ""
    # utilisation du filtre
    sql3 = '''requete'''
    mycursor.execute(sql)
    meubles = mycursor.fetchall()

    # pour le filtre
    sql = '''SELECT * FROM type_meuble'''
    mycursor.execute(sql)
    types_meuble = mycursor.fetchall()

    meubles_panier = []
    print(meubles_panier)

    if len(meubles_panier) >= 1:
        sql = ''' calcul du prix total du panier '''
        prix_total = None
    else:
        prix_total = None

    return render_template('client/boutique/panier_meuble.html'
                           , meubles=meubles
                           , types_meuble=types_meuble
                           , meubles_panier=meubles_panier
                           # , prix_total=prix_total
                           , items_filtre=types_meuble
                           )