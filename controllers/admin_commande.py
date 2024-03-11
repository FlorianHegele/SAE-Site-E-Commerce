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


@admin_commande.route('/admin/commande/show', methods=['get', 'post'])
def admin_commande_show():
    mycursor = get_db().cursor()
    admin_id = session['id_user']  # FIXME variable inutilisé

    id_commande = request.args.get('id_commande', None)
    commande_adresses = None
    meubles_commande = None

    sql = '''
    SELECT id_commande, etat_id, login, date_achat, libelle_etat AS libelle,
    SUM(quantite_lc) AS nbr_meubles, SUM(prix_lc * quantite_lc) AS prix_total
    FROM v_ligne_commande
    JOIN etat ON v_ligne_commande.etat_id = etat.id_etat
    JOIN utilisateur ON utilisateur_id = utilisateur.id_utilisateur
    GROUP BY id_commande
    '''

    mycursor.execute(sql)
    commandes = mycursor.fetchall()

    if id_commande is not None:
        sql = '''
            SELECT vd.nom_meuble AS nom,
            vl.prix_lc AS prix,
            vl.quantite_lc as quantite,
            prix_lc * quantite_lc AS prix_ligne,
            IFNULL((
                SELECT COUNT(vde.id_meuble)
                FROM v_declinaison_meuble AS vde
                WHERE vde.id_meuble = vd.id_meuble
                GROUP BY vde.id_meuble
            ), 0) AS nb_declinaisons,
            vd.id_couleur, vd.libelle_couleur, vd.id_materiau, vd.libelle_materiau
            FROM v_ligne_commande vl
            JOIN v_declinaison_meuble vd ON vl.declinaison_meuble_id = vd.id_declinaison_meuble
            WHERE id_commande = %s
        '''

        mycursor.execute(sql, (id_commande,))
        meubles_commande = mycursor.fetchall()

        sql_commande_details = '''SELECT * FROM commande WHERE id_commande = %s'''
        mycursor.execute(sql_commande_details, (id_commande,))
        commande_adresses = mycursor.fetchall()

    return render_template('admin/commandes/show.html',
                           commandes=commandes,
                           meubles_commande=meubles_commande,
                           commande_adresses=commande_adresses)


@admin_commande.route('/admin/commande/valider', methods=['get', 'post'])
def admin_commande_valider():
    mycursor = get_db().cursor()
    commande_id = request.form.get('id_commande', None)
    if commande_id is not None:
        print(commande_id)
        sql = '''UPDATE commande SET etat_id = 3 WHERE id_commande = %s'''
        mycursor.execute(sql, (commande_id,))
        get_db().commit()
    return redirect('/admin/commande/show')
