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
    sql = ''' selection des meubles d'un panier 
    '''
    meubles_panier = []
    if len(meubles_panier) >= 1:
        sql = ''' calcul du prix total du panier '''
        prix_total = None
    else:
        prix_total = None
    # etape 2 : selection des adresses
    return render_template('client/boutique/panier_validation_adresses.html'
                           #, adresses=adresses
                           , meubles_panier=meubles_panier
                           , prix_total= prix_total
                           , validation=1
                           #, id_adresse_fav=id_adresse_fav
                           )


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()

    # choix de(s) (l')adresse(s)

    id_client = session['id_user']
    sql = ''' selection du contenu du panier de l'utilisateur '''
    items_ligne_panier = []
    # if items_ligne_panier is None or len(items_ligne_panier) < 1:
    #     flash(u'Pas d\'meubles dans le ligne_panier', 'alert-warning')
    #     return redirect('/client/meuble/show')
                                           # https://pynative.com/python-mysql-transaction-management-using-commit-rollback/
    #a = datetime.strptime('my date', "%b %d %Y %H:%M")

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
            SUM(lc.prix) AS prix_total,
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

