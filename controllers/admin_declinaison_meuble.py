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
        SELECT * FROM meuble
        WHERE id_meuble = %s
    """
    mycursor.execute(sql, id_meuble)
    meuble = mycursor.fetchone()

    sql = """
        SELECT id_couleur, libelle_couleur AS libelle FROM couleur
        ORDER BY id_couleur
    """
    mycursor.execute(sql)
    couleurs = mycursor.fetchall()

    sql = """
        SELECT id_materiau, libelle_materiau AS libelle FROM materiau
        ORDER BY id_materiau
    """
    mycursor.execute(sql)
    materiaux = mycursor.fetchall()

    sql = """
        SELECT id_couleur, id_materiau FROM v_meuble
        WHERE id_meuble = %s
        LIMIT 1;
    """
    mycursor.execute(sql, id_meuble)
    first_meuble_data = mycursor.fetchone()

    d_materiau_uniq = False
    d_couleur_uniq = False
    if first_meuble_data["id_couleur"] is not None:
        couleurs = couleurs[1:]
        materiaux = materiaux[1:]

        if first_meuble_data["id_materiau"] == 1:
            d_materiau_uniq = True

        if first_meuble_data["id_couleur"] == 1:
            d_couleur_uniq = True

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
    materiau = request.form.get('materiau')
    couleur = request.form.get('couleur')

    data = (stock, id_meuble, materiau, couleur)


    sql = """
        SELECT * FROM declinaison_meuble
        WHERE meuble_id = %s AND materiau_id = %s AND couleur_id = %s
    """
    mycursor.execute(sql, (id_meuble, materiau, couleur))

    # check doublon
    if len(mycursor.fetchall()) == 0:
        sql = """
            INSERT INTO declinaison_meuble(stock, meuble_id, materiau_id, couleur_id) 
            VALUES (%s, %s, %s, %s)
        """
        mycursor.execute(sql, data)
        flash(f"declinaison_meuble ajouté , meuble_id:{id_meuble}- stock:{stock} - couleur:{couleur} - materiau:{materiau}", 'alert-success')
    else:
        sql = """
            UPDATE declinaison_meuble SET stock = %s
            WHERE meuble_id = %s AND materiau_id = %s AND couleur_id = %s
        """
        mycursor.execute(sql, data)
        flash("doublon sur cette déclinaison, seul le stock a été mise à jour", 'alert-warning')

    get_db().commit()
    return redirect('/admin/meuble/edit?id_meuble=' + id_meuble)


@admin_declinaison_meuble.route('/admin/declinaison_meuble/edit', methods=['GET'])
def edit_declinaison_meuble():
    id_declinaison_meuble = request.args.get('id_declinaison_meuble')
    mycursor = get_db().cursor()

    sql = """
        SELECT * FROM v_declinaison_meuble
        WHERE id_declinaison_meuble = %s
    """
    mycursor.execute(sql, id_declinaison_meuble)
    declinaison_meuble = mycursor.fetchone()

    sql = """
        SELECT id_couleur, libelle_couleur AS libelle FROM couleur
        ORDER BY id_couleur
    """
    mycursor.execute(sql)
    couleurs = mycursor.fetchall()

    sql = """
        SELECT id_materiau, libelle_materiau AS libelle FROM materiau
        ORDER BY id_materiau
    """
    mycursor.execute(sql)
    materiaux = mycursor.fetchall()

    sql = """
        SELECT id_couleur, id_materiau FROM v_meuble
        WHERE id_meuble = %s
        LIMIT 1;
    """
    mycursor.execute(sql, declinaison_meuble["id_meuble"])
    first_meuble_data = mycursor.fetchone()

    d_materiau_uniq = False
    d_couleur_uniq = False
    if first_meuble_data["id_couleur"] is not None:
        couleurs = couleurs[1:]
        materiaux = materiaux[1:]

        if first_meuble_data["id_materiau"] == 1:
            d_materiau_uniq = True

        if first_meuble_data["id_couleur"] == 1:
            d_couleur_uniq = True


    return render_template('admin/meuble/edit_declinaison_meuble.html'
                           , materiaux=materiaux
                           , couleurs=couleurs
                           , declinaison_meuble=declinaison_meuble
                           , d_materiau_uniq=d_materiau_uniq
                           , d_couleur_uniq=d_couleur_uniq
                           )


@admin_declinaison_meuble.route('/admin/declinaison_meuble/edit', methods=['POST'])
def valid_edit_declinaison_meuble():
    id_declinaison_meuble = request.form.get('id_declinaison_meuble','')
    id_meuble = request.form.get('id_meuble')
    stock = request.form.get('stock')
    materiau = request.form.get('id_materiau')
    couleur = request.form.get('id_couleur')
    mycursor = get_db().cursor()


    sql = """
        SELECT id_declinaison_meuble FROM declinaison_meuble
        WHERE meuble_id = %s AND materiau_id = %s AND couleur_id = %s
    """
    mycursor.execute(sql, (id_meuble, materiau, couleur))
    all_declinaison_meuble = mycursor.fetchall()

    # check doublon
    if len(all_declinaison_meuble) == 0 or str(all_declinaison_meuble[0]["id_declinaison_meuble"]) == id_declinaison_meuble:
        sql = """
            UPDATE declinaison_meuble SET materiau_id = %s, couleur_id = %s, stock = %s
            WHERE id_declinaison_meuble = %s
        """
        mycursor.execute(sql, (materiau, couleur, stock, id_declinaison_meuble))
        get_db().commit()

        flash(
            f"declinaison_meuble modifié , meuble_id:{id_meuble} - declinaison_meuble:{id_declinaison_meuble} - stock:{stock} - couleur:{couleur} - materiau:{materiau}",
            'alert-success'
        )
    else:
        flash("Cette déclinaison existe déjà !", 'alert-warning')

    return redirect('/admin/meuble/edit?id_meuble=' + str(id_meuble))


@admin_declinaison_meuble.route('/admin/declinaison_meuble/delete', methods=['GET'])
def admin_delete_declinaison_meuble():
    id_declinaison_meuble = request.args.get('id_declinaison_meuble')
    id_meuble = request.args.get('id_meuble')
    mycursor = get_db().cursor()

    sql = """
        SELECT * FROM v_ligne_commande
        WHERE id_declinaison_meuble = %s
    """
    mycursor.execute(sql, id_declinaison_meuble)
    commandes = mycursor.fetchall()

    sql = """
            SELECT * FROM v_ligne_panier
            WHERE id_declinaison_meuble = %s
        """
    mycursor.execute(sql, id_declinaison_meuble)
    paniers = mycursor.fetchall()

    if paniers is not None and len(paniers) > 0:
        flash("il y a des exemplaires dans des paniers : vous ne pouvez pas le supprimer", 'alert-warning')
    elif commandes is not None and len(commandes) > 0:
        flash(u"il y a des exemplaires dans des commandes : vous ne pouvez pas le supprimer", 'alert-warning')
    else:
        sql = """DELETE FROM declinaison_meuble WHERE id_declinaison_meuble=%s"""
        mycursor.execute(sql, id_declinaison_meuble)
        get_db().commit()
        flash(u'declinaison supprimée, id_declinaison_meuble : ' + str(id_declinaison_meuble),  'alert-success')
    return redirect('/admin/meuble/edit?id_meuble=' + str(id_meuble))
