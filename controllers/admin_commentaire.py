#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

admin_commentaire = Blueprint('admin_commentaire', __name__,
                        template_folder='templates')


@admin_commentaire.route('/admin/meuble/commentaires', methods=['GET'])
def admin_meuble_details():
    mycursor = get_db().cursor()
    id_meuble =  request.args.get('id_meuble', None)
    sql = '''    SELECT meuble.*,c.*,u.*
FROM meuble 
JOIN commentaire c ON meuble.id_meuble = c.meuble_id
JOIN utilisateur u ON c.utilisateur_id = u.id_utilisateur
WHERE meuble.id_meuble = %s
ORDER BY c.date_publication,c.utilisateur_id DESC;'''
    mycursor.execute(sql, id_meuble)
    commentaires = mycursor.fetchall()

    sql = '''   SELECT *
FROM meuble
WHERE id_meuble=%s;  '''
    mycursor.execute(sql, id_meuble)
    meuble = mycursor.fetchone()
    print("555",commentaires)
    return render_template('admin/meuble/show_meuble_commentaires.html'
                           , commentaires=commentaires
                           , meuble=meuble
                           )

@admin_commentaire.route('/admin/meuble/commentaires/delete', methods=['POST'])
def admin_comment_delete():
    mycursor = get_db().cursor()
    id_utilisateur = request.form.get('id_utilisateur', None)
    id_meuble = request.form.get('id_meuble', None)
    date_publication = request.form.get('date_publication', None)
    sql = '''    DELETE FROM commentaire WHERE utilisateur_id = %s AND meuble_id = %s AND date_publication = %s   '''
    tuple_delete=(id_utilisateur,id_meuble,date_publication)
    mycursor.execute(sql,tuple_delete)
    get_db().commit()
    print("ouiii",id_meuble)
    return redirect('/admin/meuble/commentaires?id_meuble='+id_meuble)


@admin_commentaire.route('/admin/meuble/commentaires/repondre', methods=['POST','GET'])
def admin_comment_add():
    if request.method == 'GET':
        id_utilisateur = request.args.get('id_utilisateur', None)
        id_meuble = request.args.get('id_meuble', None)
        date_publication = request.args.get('date_publication', None)
        return render_template('admin/meuble/add_commentaire.html',id_utilisateur=id_utilisateur,id_meuble=id_meuble,date_publication=date_publication )

    mycursor = get_db().cursor()
    id_utilisateur = session['id_user']   #1 admin
    id_meuble = request.form.get('id_meuble', None)
    date_publication = request.form.get('date_publication', None)
    commentaire = request.form.get('commentaire', None)
    tuple_insert = (id_utilisateur,id_meuble,date_publication,commentaire)
    sql = '''    INSERT INTO commentaire (utilisateur_id, meuble_id, date_publication, commentaire,valider) 
VALUES (%s, %s, %s, %s,1);   '''
    mycursor.execute(sql,tuple_insert)
    commentaire = mycursor.fetchone()
    print(commentaire)
    get_db().commit()
    return redirect('/admin/meuble/commentaires?id_meuble='+id_meuble)


@admin_commentaire.route('/admin/meuble/commentaires/valider', methods=['POST','GET'])
def admin_comment_valider():
    id_meuble = request.args.get('id_meuble', None)
    mycursor = get_db().cursor()
    sql = '''   UPDATE commentaire
    SET valider = 1
    WHERE meuble_id = %s;
       '''
    mycursor.execute(sql, (id_meuble))
    get_db().commit()
    return redirect('/admin/meuble/commentaires?id_meuble='+id_meuble)