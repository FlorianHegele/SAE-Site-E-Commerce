#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

admin_dataviz = Blueprint('admin_dataviz', __name__,
                        template_folder='templates')

@admin_dataviz.route('/admin/dataviz/etat1')
def show_type_meuble_stock():
    mycursor = get_db().cursor()
    sql = '''
        SELECT IFNULL(COUNT(id_materiau), 0) AS nbr_meubles, libelle_materiau AS libelle
        FROM v_declinaison_meuble
        GROUP BY id_materiau
    '''
    mycursor.execute(sql)
    datas_show = mycursor.fetchall()[1:]
    labels = [str(row['libelle']) for row in datas_show]
    values = [int(row['nbr_meubles']) for row in datas_show]

    sql = '''
            SELECT IFNULL(COUNT(id_couleur), 0) AS nbr_meubles, libelle_couleur AS libelle
            FROM v_declinaison_meuble
            GROUP BY id_couleur
        '''
    mycursor.execute(sql)
    datas_show1 = mycursor.fetchall()[1:]
    labels1 = [str(row['libelle']) for row in datas_show1]
    values1 = [int(row['nbr_meubles']) for row in datas_show1]

    sql = '''
            SELECT IFNULL(COUNT(id_declinaison_meuble), 0) AS nbr_meubles, id_type_meuble, libelle_type_meuble AS libelle
            FROM v_meuble
            GROUP BY id_type_meuble
        '''
    mycursor.execute(sql)
    types_meubles_nb = mycursor.fetchall()[1:]

    sql = '''
        SELECT COUNT(*) AS nbr_meubles FROM declinaison_meuble
    '''
    mycursor.execute(sql)
    nbr_meubles = mycursor.fetchone()["nbr_meubles"]

    return render_template('admin/dataviz/dataviz_etat_1.html'
                           , nbr_meubles=nbr_meubles
                           , types_meubles_nb=types_meubles_nb
                           , labels=labels
                           , values=values
                           , labels1=labels1
                           , values1=values1)


# sujet 3 : adresses


@admin_dataviz.route('/admin/dataviz/etat2')
def show_dataviz_map():
    # mycursor = get_db().cursor()
    # sql = '''    '''
    # mycursor.execute(sql)
    # adresses = mycursor.fetchall()

    #exemples de tableau "résultat" de la requête
    adresses =  [{'dep': '25', 'nombre': 1}, {'dep': '83', 'nombre': 1}, {'dep': '90', 'nombre': 3}]

    # recherche de la valeur maxi "nombre" dans les départements
    # maxAddress = 0
    # for element in adresses:
    #     if element['nbr_dept'] > maxAddress:
    #         maxAddress = element['nbr_dept']
    # calcul d'un coefficient de 0 à 1 pour chaque département
    # if maxAddress != 0:
    #     for element in adresses:
    #         indice = element['nbr_dept'] / maxAddress
    #         element['indice'] = round(indice,2)

    print(adresses)

    return render_template('admin/dataviz/dataviz_etat_map.html'
                           , adresses=adresses
                          )


