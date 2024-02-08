#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


# validation de la commande : partie 2 -- vue pour choisir les adresses (livraision et facturation)
@client_commande.route('/client/commande/valide', methods=['POST'])
def client_commande_valide():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''
        SELECT * FROM ligne_panier
        WHERE utilisateur_id = %s;
    '''
    meubles_panier = []
    if len(meubles_panier) >= 1:
        sql = '''
            SELECT SUM(prix * quantite) AS prix_total
            FROM ligne_panier
            WHERE utilisateur_id = %s;
        '''
        mycursor.execute(sql, id_client)
        prix_total = mycursor.fetchone()
    else:
        prix_total = None
    # etape 2 : selection des adresses
    sql = '''
        SELECT * FROM adresse
        JOIN habite ON adresse.id_adresse = habite.adresse_id
        WHERE utilisateur_id = %s;
    '''
    mycursor.execute(sql, id_client)
    adresses = mycursor.fetchall()
    return render_template('client/boutique/panier_validation_adresses.html'
                           , adresses=adresses
                           , meubles_panier=meubles_panier
                           , prix_total= prix_total
                           , validation=1
                           #, id_adresse_fav=id_adresse_fav 
                           )


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()

    id_client = session['id_user']
    sql = '''
        SELECT * FROM ligne_panier
        WHERE utilisateur_id = %s;
    '''
    mycursor.execute(sql, id_client)
    items_ligne_panier = mycursor.fetchall()
    if items_ligne_panier is None or len(items_ligne_panier) < 1:
        flash(u'Pas de meubles dans le panier', 'alert-warning')
        return redirect('/client/meuble/show')
                                        #    https://pynative.com/python-mysql-transaction-management-using-commit-rollback/
    mydate = datetime.now()
    print(mydate)
    a = datetime.strptime('my date', "%b %d %Y %H:%M")

    sql = ''' creation de la commande '''

    sql = '''SELECT last_insert_id() as last_insert_id'''
    # numéro de la dernière commande
    for item in items_ligne_panier:
        sql = ''' suppression d'une ligne de panier '''
        sql = "  ajout d'une ligne de commande'"

    get_db().commit()
    flash(u'Commande ajoutée','alert-success')
    return redirect('/client/meuble/show')




@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    print("id_client : " + str(id_client))
    sql = '''
        SELECT c.id_commande,
            date_achat,
            SUM(lc.quantite) AS nbr_meubles,
            SUM(lc.prix * lc.quantite) AS prix_total,
            etat_id,
            libelle_etat AS libelle
        FROM ligne_commande lc
        JOIN commande c ON lc.commande_id = c.id_commande
        JOIN meuble m ON lc.meuble_id = m.id_meuble
        JOIN etat e ON c.etat_id = e.id_etat
        WHERE c.utilisateur_id = %s
        GROUP BY c.id_commande, c.date_achat, c.etat_id, e.libelle_etat
        ORDER BY etat_id,
            date_achat DESC;
    '''
    mycursor.execute(sql, str(id_client))
    commandes = mycursor.fetchall()
    
    meubles_commande = None
    commande_adresses = None
    id_commande = request.args.get('id_commande', None)
    if id_commande != None:
        print("id_commande : " + id_commande)
        sql = '''
            SELECT lc.quantite,
                lc.prix,
                m.nom_meuble AS nom,
                m.prix_meuble AS prix,
                lc.prix * lc.quantite AS prix_ligne
            FROM ligne_commande lc
                JOIN meuble m ON lc.meuble_id = m.id_meuble
            WHERE lc.commande_id = %s;
        '''
        mycursor.execute(sql, str(id_commande))
        meubles_commande = mycursor.fetchall()

        # partie 2 : selection de l'adresse de livraison et de facturation de la commande selectionnée
        sql = ''' selection des adressses '''

    return render_template('client/commandes/show.html'
                           , commandes=commandes
                           , meubles_commande=meubles_commande
                           , commande_adresses=commande_adresses
                           )

@client_commande.route('/client/commande/confirm', methods=['POST'])
def client_commande_confirm():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''
        SELECT * FROM ligne_panier
        WHERE id_utilisateur = %s;
    '''

    sql = '''
        INSERT INTO ligne_commande(id_meuble, id_commande, quantite, prix)
        FROM ligne_panier
        WHERE id_commande = id_utilisateur
        '''

    if len(ligne_commande)>0:
        sql = '''
        INSERT INTO commande(id_commande, date_achat, id_etat, id_utilisateur)
        FROM ligne_commande
        WHERE id_utilisateur = id_commande
        '''

