#! /usr/bin/python
# -*- coding:utf-8 -*-

from flask import Blueprint
from flask import request, render_template, redirect, flash
from connexion_db import get_db

admin_declinaison_meuble = Blueprint('admin_declinaison_meuble', __name__,
                         template_folder='templates')


@admin_declinaison_meuble.route('/admin/declinaison_meuble/add')
def add_declinaison_meuble():
    id_meuble=request.args.get('id_meuble')
    mycursor = get_db().cursor()

    sql = """
        SELECT * FROM v_declinaison_meuble
        WHERE id_meuble = %s
    """
    mycursor.execute(sql, id_meuble)
    meuble = mycursor.fetchall()

    sql = """
        SELECT id_couleur, libelle_couleur AS libelle FROM couleur
    """
    mycursor.execute(sql)
    couleurs = mycursor.fetchall()

    sql = """
            SELECT id_materiau, libelle_materiau AS libelle FROM materiau
        """
    mycursor.execute(sql)
    materiaux = mycursor.fetchall()

    d_materiau_uniq=None
    d_couleur_uniq=None
    return render_template('admin/meuble/add_declinaison_meuble.html'
                           , meuble=meuble
                           , couleurs=couleurs
                           , materiaux=materiaux
                           , d_materiau_uniq=d_materiau_uniq
                           , d_couleur_uniq=d_couleur_uniq
                           )


@admin_declinaison_meuble.route('/admin/declinaison_meuble/add', methods=['POST'])
def valid_add_declinaison_meuble():
    mycursor = get_db().cursor()

    id_meuble = request.form.get('id_meuble')
    stock = request.form.get('stock')
    taille = request.form.get('taille')
    couleur = request.form.get('couleur')
    # attention au doublon
    get_db().commit()
    return redirect('/admin/meuble/edit?id_meuble=' + id_meuble)


@admin_declinaison_meuble.route('/admin/declinaison_meuble/edit', methods=['GET'])
def edit_declinaison_meuble():
    id_declinaison_meuble = request.args.get('id_declinaison_meuble')
    mycursor = get_db().cursor()
    declinaison_meuble=[]
    couleurs=None
    tailles=None
    d_taille_uniq=None
    d_couleur_uniq=None
    return render_template('admin/meuble/edit_declinaison_meuble.html'
                           , tailles=tailles
                           , couleurs=couleurs
                           , declinaison_meuble=declinaison_meuble
                           , d_taille_uniq=d_taille_uniq
                           , d_couleur_uniq=d_couleur_uniq
                           )


@admin_declinaison_meuble.route('/admin/declinaison_meuble/edit', methods=['POST'])
def valid_edit_declinaison_meuble():
    id_declinaison_meuble = request.form.get('id_declinaison_meuble','')
    id_meuble = request.form.get('id_meuble','')
    stock = request.form.get('stock','')
    taille_id = request.form.get('id_taille','')
    couleur_id = request.form.get('id_couleur','')
    mycursor = get_db().cursor()

    message = u'declinaison_meuble modifié , id:' + str(id_declinaison_meuble) + '- stock :' + str(stock) + ' - taille_id:' + str(taille_id) + ' - couleur_id:' + str(couleur_id)
    flash(message, 'alert-success')
    return redirect('/admin/meuble/edit?id_meuble=' + str(id_meuble))


@admin_declinaison_meuble.route('/admin/declinaison_meuble/delete', methods=['GET'])
def admin_delete_declinaison_meuble():
    id_declinaison_meuble = request.args.get('id_declinaison_meuble','')
    id_meuble = request.args.get('id_meuble','')

    flash(u'declinaison supprimée, id_declinaison_meuble : ' + str(id_declinaison_meuble),  'alert-success')
    return redirect('/admin/meuble/edit?id_meuble=' + str(id_meuble))
