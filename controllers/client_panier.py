#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_panier = Blueprint('client_panier', __name__,
                        template_folder='templates')


@client_panier.route('/client/panier/add', methods=['POST'])
def client_panier_add():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_meuble = request.form.get('id_meuble')
    quantite = request.form.get('quantite')
    # ---------
    #id_declinaison_meuble=request.form.get('id_declinaison_meuble',None)
    id_declinaison_meuble = 1

# ajout dans le panier d'une déclinaison d'un meuble (si 1 declinaison : immédiat sinon => vu pour faire un choix
    # sql = '''    '''
    # mycursor.execute(sql, (id_meuble))
    # declinaisons = mycursor.fetchall()
    # if len(declinaisons) == 1:
    #     id_declinaison_meuble = declinaisons[0]['id_declinaison_meuble']
    # elif len(declinaisons) == 0:
    #     abort("pb nb de declinaison")
    # else:
    #     sql = '''   '''
    #     mycursor.execute(sql, (id_meuble))
    #     meuble = mycursor.fetchone()
    #     return render_template('client/boutique/declinaison_meuble.html'
    #                                , declinaisons=declinaisons
    #                                , quantite=quantite
    #                                , meuble=meuble)

# ajout dans le panier d'un meuble


    return redirect('/client/meuble/show')

@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_meuble = request.form.get('id_meuble','')
    quantite = 1

    # ---------
    # partie 2 : on supprime une déclinaison de l'meuble
    # id_declinaison_meuble = request.form.get('id_declinaison_meuble', None)

    sql = ''' selection de la ligne du panier pour l'meuble et l'utilisateur connecté'''
    meuble_panier=[]

    if not(meuble_panier is None) and meuble_panier['quantite'] > 1:
        sql = ''' mise à jour de la quantité dans le panier => -1 meuble '''
    else:
        sql = ''' suppression de la ligne de panier'''

    # mise à jour du stock de l'meuble disponible
    get_db().commit()
    return redirect('/client/meuble/show')





@client_panier.route('/client/panier/vider', methods=['POST'])
def client_panier_vider():
    mycursor = get_db().cursor()
    client_id = session['id_user']
    sql = ''' sélection des lignes de panier'''
    items_panier = []
    for item in items_panier:
        sql = ''' suppression de la ligne de panier de l'meuble pour l'utilisateur connecté'''

        sql2=''' mise à jour du stock de l'meuble : stock = stock + qté de la ligne pour l'meuble'''
        get_db().commit()
    return redirect('/client/meuble/show')


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    #id_declinaison_meuble = request.form.get('id_declinaison_meuble')

    sql = ''' selection de ligne du panier '''

    sql = ''' suppression de la ligne du panier '''
    sql2=''' mise à jour du stock de l'meuble : stock = stock + qté de la ligne pour l'meuble'''

    get_db().commit()
    return redirect('/client/meuble/show')


@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)
    # test des variables puis
    # mise en session des variables
    return redirect('/client/meuble/show')


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    # suppression  des variables en session
    print("suppr filtre")
    return redirect('/client/meuble/show')
