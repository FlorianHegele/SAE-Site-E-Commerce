#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, flash, session

from connexion_db import get_db

admin_commande = Blueprint('admin_commande', __name__,
                        template_folder='templates')

@admin_commande.route('/admin')
@admin_commande.route('/admin/commande/index')
def admin_index():
    return render_template('admin/layout_admin.html')


@admin_commande.route('/admin/commande/show', methods=['get','post'])
def admin_commande_show():
    mycursor = get_db().cursor()
    admin_id = session['id_user'] # FIXME variable inutilisé
    sql = '''SELECT commande.id_commande,utilisateur.login,commande.date_achat,COUNT(ligne_commande.meuble_id) AS nbr_meubles,
    SUM(meuble.prix_meuble * ligne_commande.quantite) AS prix_total,
    etat.libelle_etat AS libelle
    FROM commande
    JOIN utilisateur ON commande.utilisateur_id = utilisateur.id_utilisateur
    JOIN etat ON commande.etat_id = etat.id_etat
    LEFT JOIN ligne_commande ON commande.id_commande = ligne_commande.commande_id
    LEFT JOIN meuble ON ligne_commande.meuble_id = meuble.id_meuble
    GROUP BY commande.id_commande;
 '''
    mycursor.execute(sql)
    commandes = mycursor.fetchall()
    mycursor = get_db().cursor()
    commande_id = request.form.get('id_commande', None)
    # Récupération de toutes les informations de la table meuble et commande
    sql = '''
        SELECT meuble.id_meuble, meuble.nom_meuble AS nom, meuble.largeur, meuble.hauteur, meuble.prix_meuble AS prix, meuble.image_meuble, meuble.stock_meuble, meuble.materiau_id, meuble.fournisseur_id, meuble.marque_id, meuble.type_id, commande.id_commande, commande.date_achat, commande.utilisateur_id, commande.etat_id
        FROM meuble 
        JOIN ligne_commande LC ON meuble.id_meuble = LC.meuble_id
        JOIN commande ON LC.commande_id = commande.id_commande
        WHERE commande.id_commande = %s
    '''
    id_commande = request.args.get('id_commande', None)
    mycursor.execute(sql, (id_commande,))
    meubles_commande = mycursor.fetchall()
    print(meubles_commande,'AKSAOS')
    commande_adresses = None

    print(id_commande,229)
    if id_commande != None:
        sql_commande_details = '''SELECT * FROM commande WHERE id_commande = %s'''
        mycursor.execute(sql_commande_details, (id_commande,))
        commande_adresses = mycursor.fetchall()
        print(commande_adresses,1515)
    else:
        print("voiture",commandes)
        commande_adresses = []

    return render_template('admin/commandes/show.html', commandes=commandes, meubles_commande=meubles_commande,
                           commande_adresses=commande_adresses)


@admin_commande.route('/admin/commande/valider', methods=['get','post'])
def admin_commande_valider():
    mycursor = get_db().cursor()
    commande_id = request.form.get('id_commande', None)
    print('CACA',commande_id,"oui")
    if commande_id != None:
        print(commande_id)
        sql = '''UPDATE commande SET etat_id = 3 WHERE id_commande = %s'''
        mycursor.execute(sql, (commande_id,))
        get_db().commit()
    return redirect('/admin/commande/show')
