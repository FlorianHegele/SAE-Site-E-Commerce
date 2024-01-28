#! /usr/bin/python
# -*- coding:utf-8 -*-
import math
import os.path
from random import random

from flask import Blueprint
from flask import request, render_template, redirect, flash, session
#from werkzeug.utils import secure_filename

from connexion_db import get_db

admin_meuble = Blueprint('admin_meuble', __name__,
                          template_folder='templates')


@admin_meuble.route('/admin/meuble/show')
def show_meuble():
    mycursor = get_db().cursor()
    id_admin = session['id_user']

    sql = '''SELECT * FROM meuble'''
    list_param = []
    condition_and = ""
    if "filter_word" in session or  "filter_prix_min" in session or "filter_prix_max" in session or "filter_types" in session:
        sql = sql + " WHERE "
    if 'filter_word' in session:
        sql = sql + " nom_meuble Like %s "
        recherche = "%" + session['filter_word'] + "%"
        list_param.append(recherche)
        condition_and = " AND "
    if 'filter_prix_min' in session or 'filter_prix_max' in session:
        sql = sql + condition_and + 'prix_meuble BETWEEN %s AND %s'
        list_param.append(session['filter_prix_min'])
        list_param.append(session['filter_prix_max'])
        condition_and = " AND "
    if 'filter_types' in session:
        sql = sql + condition_and + "("
        last_item = session['filter_types'][-1]
        for item in session['filter_types']:
            sql = sql + "type_id=%s"
            if item != last_item:
                sql = sql + " OR "
            list_param.append(item)
        sql = sql + ")"
    tuple_sql = tuple(list_param)
    print(sql)
    mycursor.execute(sql, tuple_sql)
    print(tuple_sql)
    meubles = mycursor.fetchall()

    return render_template('admin/meuble/show_meuble.html', meubles=meubles)


@admin_meuble.route('/admin/meuble/add', methods=['GET'])
def add_meuble():
    mycursor = get_db().cursor()

    return render_template('admin/meuble/add_meuble.html'
                           #,types_meuble=type_meuble,
                           #,couleurs=colors
                           #,tailles=tailles
                            )


@admin_meuble.route('/admin/meuble/add', methods=['POST'])
def valid_add_meuble():
    mycursor = get_db().cursor()

    nom = request.form.get('nom', '')
    type_meuble_id = request.form.get('type_meuble_id', '')
    prix = request.form.get('prix', '')
    description = request.form.get('description', '')
    image = request.files.get('image', '')

    if image:
        filename = 'img_upload'+ str(int(2147483647 * random())) + '.png'
        image.save(os.path.join('static/images/', filename))
    else:
        print("erreur")
        filename=None

    sql = '''  requête admin_meuble_2 '''

    tuple_add = (nom, filename, prix, type_meuble_id, description)
    print(tuple_add)
    mycursor.execute(sql, tuple_add)
    get_db().commit()

    print(u'meuble ajouté , nom: ', nom, ' - type_meuble:', type_meuble_id, ' - prix:', prix,
          ' - description:', description, ' - image:', image)
    message = u'meuble ajouté , nom:' + nom + '- type_meuble:' + type_meuble_id + ' - prix:' + prix + ' - description:' + description + ' - image:' + str(
        image)
    flash(message, 'alert-success')
    return redirect('/admin/meuble/show')


@admin_meuble.route('/admin/meuble/delete', methods=['GET'])
def delete_meuble():
    id_meuble=request.args.get('id_meuble')
    mycursor = get_db().cursor()
    sql = ''' requête admin_meuble_3 '''
    mycursor.execute(sql, id_meuble)
    nb_declinaison = mycursor.fetchone()
    if nb_declinaison['nb_declinaison'] > 0:
        message= u'il y a des declinaisons dans cet meuble : vous ne pouvez pas le supprimer'
        flash(message, 'alert-warning')
    else:
        sql = ''' requête admin_meuble_4 '''
        mycursor.execute(sql, id_meuble)
        meuble = mycursor.fetchone()
        print(meuble)
        image = meuble['image']

        sql = ''' requête admin_meuble_5  '''
        mycursor.execute(sql, id_meuble)
        get_db().commit()
        if image != None:
            os.remove('static/images/' + image)

        print("un meuble supprimé, id :", id_meuble)
        message = u'un meuble supprimé, id : ' + id_meuble
        flash(message, 'alert-success')

    return redirect('/admin/meuble/show')


@admin_meuble.route('/admin/meuble/edit', methods=['GET'])
def edit_meuble():
    id_meuble=request.args.get('id_meuble')
    mycursor = get_db().cursor()
    sql = '''
    requête admin_meuble_6    
    '''
    mycursor.execute(sql, id_meuble)
    meuble = mycursor.fetchone()
    print(meuble)
    sql = '''
    requête admin_meuble_7
    '''
    mycursor.execute(sql)
    types_meuble = mycursor.fetchall()

    # sql = '''
    # requête admin_meuble_6
    # '''
    # mycursor.execute(sql, id_meuble)
    # declinaisons_meuble = mycursor.fetchall()

    return render_template('admin/meuble/edit_meuble.html'
                           ,meuble=meuble
                           ,types_meuble=types_meuble
                         #  ,declinaisons_meuble=declinaisons_meuble
                           )


@admin_meuble.route('/admin/meuble/edit', methods=['POST'])
def valid_edit_meuble():
    mycursor = get_db().cursor()
    nom = request.form.get('nom')
    id_meuble = request.form.get('id_meuble')
    image = request.files.get('image', '')
    type_meuble_id = request.form.get('type_meuble_id', '')
    prix = request.form.get('prix', '')
    description = request.form.get('description')
    sql = '''
       requête admin_meuble_8
       '''
    mycursor.execute(sql, id_meuble)
    image_nom = mycursor.fetchone()
    image_nom = image_nom['image']
    if image:
        if image_nom != "" and image_nom is not None and os.path.exists(
                os.path.join(os.getcwd() + "/static/images/", image_nom)):
            os.remove(os.path.join(os.getcwd() + "/static/images/", image_nom))
        # filename = secure_filename(image.filename)
        if image:
            filename = 'img_upload_' + str(int(2147483647 * random())) + '.png'
            image.save(os.path.join('static/images/', filename))
            image_nom = filename

    sql = '''  requête admin_meuble_9 '''
    mycursor.execute(sql, (nom, image_nom, prix, type_meuble_id, description, id_meuble))

    get_db().commit()
    if image_nom is None:
        image_nom = ''
    message = u'meuble modifié , nom:' + nom + '- type_meuble :' + type_meuble_id + ' - prix:' + prix  + ' - image:' + image_nom + ' - description: ' + description
    flash(message, 'alert-success')
    return redirect('/admin/meuble/show')







@admin_meuble.route('/admin/meuble/avis/<int:id>', methods=['GET'])
def admin_avis(id):
    mycursor = get_db().cursor()
    meuble=[]
    commentaires = {}
    return render_template('admin/meuble/show_avis.html'
                           , meuble=meuble
                           , commentaires=commentaires
                           )


@admin_meuble.route('/admin/comment/delete', methods=['POST'])
def admin_avis_delete():
    mycursor = get_db().cursor()
    meuble_id = request.form.get('idmeuble', None)
    userId = request.form.get('idUser', None)

    return admin_avis(meuble_id)
