#! /usr/bin/python
# -*- coding:utf-8 -*-
import time

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
    quantite = int(request.form.get('quantite'))
    # ---------
    # id_declinaison_meuble=request.form.get('id_declinaison_meuble',None)
    # id_declinaison_meuble = 1

    sql = """
        SELECT stock_meuble as quantite FROM meuble
        where id_meuble = %s
    """
    mycursor.execute(sql, id_meuble)

    # check si la quantite est bonne
    if quantite >= 1 or quantite <= mycursor.fetchone()['quantite']:
        sql = """
            SELECT * FROM ligne_panier
            WHERE utilisateur_id = %s AND meuble_id = %s
        """

        mycursor.execute(sql, (id_client, id_meuble))
        ligne_panier = mycursor.fetchone()

        if ligne_panier is not None:
            sql = """
                UPDATE ligne_panier SET quantite = quantite + %s
                WHERE meuble_id = %s AND utilisateur_id = %s
            """
            mycursor.execute(sql, (quantite, id_meuble, id_client))
        else:
            sql = """
                INSERT INTO ligne_panier (meuble_id, utilisateur_id, quantite, prix, date_ajout) 
                VALUE (%s, %s, %s, (SELECT prix_meuble FROM meuble WHERE id_meuble = ligne_panier.meuble_id) , CURRENT_DATE)
            """

            mycursor.execute(sql, (id_meuble, id_client, quantite))

        sql = """
            UPDATE meuble SET stock_meuble = stock_meuble - %s
        """

        mycursor.execute(sql, quantite)
    else:
        print("no quantite")
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
    get_db().commit()
    return redirect('/client/meuble/show')


@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_meuble = request.form.get('id_meuble', '')

    # ---------
    # partie 2 : on supprime une déclinaison de l'meuble
    # id_declinaison_meuble = request.form.get('id_declinaison_meuble', None)

    sql = '''
    SELECT * FROM ligne_panier
    WHERE meuble_id = %s AND utilisateur_id = %s
    '''
    mycursor.execute(sql, (id_meuble, id_client))
    meuble_panier = mycursor.fetchone()

    quantite = meuble_panier['quantite']

    if not (meuble_panier is None) and quantite > 1:
        sql = '''
        UPDATE ligne_panier SET quantite = quantite - 1
        WHERE meuble_id = %s AND utilisateur_id = %s
        '''

        quantite = 1
    else:
        sql = '''
        DELETE FROM ligne_panier
        WHERE meuble_id = %s AND utilisateur_id = %s
        '''

    mycursor.execute(sql, (id_meuble, id_client))

    # mise à jour du stock de l'meuble disponible

    sql2 = '''UPDATE meuble SET stock_meuble = stock_meuble + %s WHERE id_meuble = %s '''
    mycursor.execute(sql2, (quantite, id_meuble))

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

        sql2 = ''' mise à jour du stock de l'meuble : stock = stock + qté de la ligne pour l'meuble'''
        get_db().commit()
    return redirect('/client/meuble/show')


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_meuble = request.form.get('id_meuble', '')
    data = (id_meuble, id_client)

    # id_declinaison_meuble = request.form.get('id_declinaison_meuble')

    sql = '''
        SELECT quantite FROM ligne_panier
        WHERE meuble_id = %s AND utilisateur_id = %s
    '''

    mycursor.execute(sql, data)
    quantite = mycursor.fetchone()['quantite']

    sql = '''
        DELETE FROM ligne_panier
        WHERE meuble_id = %s AND utilisateur_id = %s
    '''

    mycursor.execute(sql, (id_meuble, id_client))

    sql2 = '''UPDATE meuble SET stock_meuble = stock_meuble + %s WHERE id_meuble = %s '''
    mycursor.execute(sql2, (quantite, id_meuble))

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

    if filter_word or filter_word == '':
        if len(filter_word) > 1:
            if filter_word.isalpha():
                session['filter_word'] = filter_word
            else:
                flash('Le mot doit être composé de lettres uniquement')
        else:
            if len(filter_word) == 1:
                flash('Le mot doit contenir au moins 2 lettres')
            else:
                session.pop('filter_word', None)

    if filter_prix_min or filter_prix_max:
        if filter_prix_min.isdecimal() and filter_prix_max.isdecimal():
            if int(filter_prix_min) < int(filter_prix_max):
                session['filter_prix_min'] = filter_prix_min
                session['filter_prix_max'] = filter_prix_max
            else:
                flash('Le prix minimum doit être inférieur au prix maximum')
        else:
            flash('Les prix doivent être des nombres entiers')
    if filter_types and filter_types != []:
        session['filter_types'] = filter_types

    print(session)
    return redirect('/client/meuble/show')


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    # suppression  des variables en session
    session.pop('filter_word', None)
    session.pop('filter_types', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    print("suppr filtre")
    return redirect('/client/meuble/show')
