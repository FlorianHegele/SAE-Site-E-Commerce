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
SELECT dm.*, m.*, tm.*, n.note, AVG(n.note) AS moy_notes, COUNT(n.note) AS nb_notes,m.nom_meuble AS libelle,
       (SELECT COUNT(*) FROM commentaire c WHERE c.meuble_id = dm.meuble_id) AS nb_avis,
       (SELECT COUNT(commentaire.valider) FROM commentaire WHERE commentaire.meuble_id = dm.meuble_id) AS nb_commentaires_nouveaux,
       (SELECT COUNT(DISTINCT c.utilisateur_id) FROM commentaire c WHERE c.meuble_id = dm.meuble_id) AS nb_commentaires,
       (SELECT IFNULL(AVG(n.note),0) FROM note n WHERE n.meuble_id = dm.meuble_id) AS moyenne_notes,
       (SELECT COUNT(m.id_meuble) FROM meuble m WHERE m.id_meuble = dm.meuble_id) AS nbr_meubles
FROM declinaison_meuble dm
JOIN meuble m ON m.id_meuble = dm.meuble_id
JOIN type_meuble tm ON m.type_meuble_id = tm.id_type_meuble
LEFT JOIN note n ON n.meuble_id = dm.meuble_id
GROUP BY dm.meuble_id;

           '''
    mycursor.execute(sql)
    datas_show = mycursor.fetchall()
    labels = [str(row['libelle']) for row in datas_show]
    values = [int(row['moyenne_notes']) for row in datas_show]
    notes = [int(row['nb_notes']) for row in datas_show]
    comments = [int(row['nb_commentaires']) for row in datas_show]
    meubles = [int(row['nbr_meubles']) for row in datas_show]
    return render_template('admin/dataviz/dataviz_etat_1.html'
                           , datas_show=datas_show
                           , labels=labels
                           , values=values
                           , notes = notes
                           , comments = comments
                           , meubles = meubles)


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


