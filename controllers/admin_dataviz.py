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
   
    datas_show2=[]
    labels2=[]
    values2=[]
    sql = '''
        SELECT COUNT(DISTINCT commande_id) as nb_commandes,
        SUM(quantite_lc) as nb_meuble,
        SUM(quantite_lc * prix_lc) AS total,
        LEFT(code_postal_fact,2) as dep,
        SUM(quantite_lc * prix_lc) / SUM(quantite_lc) as prix_moyen_meuble,
        SUM(quantite_lc) / COUNT(DISTINCT commande_id) as nb_meuble_moyen,
        SUM(quantite_lc * prix_lc) / COUNT(DISTINCT commande_id) as panier_moyen
        FROM v_ligne_commande vlc
        JOIN v_commande vc ON vlc.commande_id = vc.id_commande
        JOIN utilisateur u ON vlc.utilisateur_id = u.id_utilisateur
        GROUP BY dep
        ;
        '''
    mycursor.execute(sql)
    datas_show2 = mycursor.fetchall()
    labels2 = [str(row['dep']) for row in datas_show2]
    values2 = [int(row['panier_moyen']) for row in datas_show2]
    values2 = [int(row['total']) for row in datas_show2]
    
    sql = '''
    SELECT commande_id,
    SUM(quantite_lc) as nb_meuble,
    SUM(quantite_lc * prix_lc) AS total
    FROM v_ligne_commande vlc
    JOIN v_commande vc ON vlc.commande_id = vc.id_commande
    GROUP BY commande_id
    ;
    '''
    mycursor.execute(sql)
    datas_show3 = mycursor.fetchall()
    labels3 = [str(row['commande_id']) for row in datas_show3]
    
    values4 = ""
    for row in datas_show3:
        if values4 == "":
            values4 = ("{x: "+str(row['total']+1)+", y: "+str(row['nb_meuble'])+"},")
        else:
            values4 = values4 + ("{x: "+str(row['total']+1)+", y: "+str(row['nb_meuble'])+"},")
    values4 = values4[:-1]
    values4 = "["+values4+"]"
       
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
                           , values2=values2
                           , datas_show3=datas_show3
                           , labels2=labels2
                           , values3=values3
                           , labels3=labels3
                           , values4=values4
                           , labels1=labels1
                           , values1=values1)


# sujet 3 : adresses

@admin_dataviz.route('/admin/dataviz/etat2')
def show_dataviz_map():
    mycursor = get_db().cursor()

    #exemples de tableau "résultat" de la requête
    adresses =  [{'dep': '25', 'nombre': 1}, {'dep': '83', 'nombre': 1}, {'dep': '90', 'nombre': 3}]

    sql = '''
    SELECT LEFT(code_postal,2) as dep, COUNT(code_postal) AS nbr_dept
    FROM adresse
    GROUP BY dep
    '''
    mycursor.execute(sql)
    adresses = mycursor.fetchall()

    # recherche de la valeur maxi "nombre" dans les départements
    maxAddress = 0
    
    for element in adresses:
        if element['nbr_dept'] > maxAddress:
            maxAddress = element['nbr_dept']
    # calcul d'un coefficient de 0 à 1 pour chaque département
    if maxAddress != 0:
        for element in adresses:
            indice = element['nbr_dept'] / maxAddress
            element['indice'] = round(indice,2)

    print(maxAddress)
    print(adresses)

    return render_template('admin/dataviz/dataviz_etat_map.html'
                           , adresses=adresses
                          )


