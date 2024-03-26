#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

from controllers.client_liste_envies import client_historique_add

client_commentaire = Blueprint('client_commentaire', __name__,
                        template_folder='templates')


@client_commentaire.route('/client/meuble/details', methods=['GET'])
def client_meuble_details():
    mycursor = get_db().cursor()
    id_meuble = request.args.get('id_declinaison_meuble', None)
    print("voitur1",id_meuble)
    id_client = session['id_user']
    ## partie 4
    # client_historique_add(id_meuble, id_client)

    sql = '''SELECT 
        meuble.id_meuble,
        meuble.nom_meuble AS nom_meuble,
        meuble.prix_meuble AS prix,
        meuble.image_meuble AS image_meuble,
        meuble.description_meuble AS description,
        AVG(note.note) AS moyenne_notes,
        COUNT(note.note) AS nb_notes
    FROM meuble 
    INNER JOIN declinaison_meuble ON meuble.id_meuble = declinaison_meuble.meuble_id
    LEFT JOIN note ON meuble.id_meuble = note.meuble_id
    WHERE declinaison_meuble.id_declinaison_meuble = %s
    '''
    mycursor.execute(sql, (id_meuble,))
    meuble = mycursor.fetchone()
    print("AAA", meuble,"AAAAAApps",id_meuble)
    sql = '''SELECT commentaire.*, commentaire.utilisateur_id AS id_utilisateur, utilisateur.nom_utilisateur AS nom
FROM commentaire
INNER JOIN utilisateur ON commentaire.utilisateur_id = utilisateur.id_utilisateur
WHERE commentaire.meuble_id = %s;
'''
    mycursor.execute(sql, (id_meuble,))
    commentaires = mycursor.fetchall()
    sql = '''SELECT * ,quantite_lc AS nb_commandes_meuble FROM ligne_commande 
             WHERE declinaison_meuble_id = %s 
             AND commande_id IN (SELECT id_commande FROM commande WHERE utilisateur_id = %s)'''
    mycursor.execute(sql, (id_meuble, id_client))
    commandes_meubles = mycursor.fetchone()
    sql = '''SELECT note FROM note WHERE meuble_id = %s AND utilisateur_id = %s'''
    mycursor.execute(sql, (id_meuble, id_client))
    note = mycursor.fetchone()
    sql = '''SELECT COUNT(*) AS nb_commentaires FROM commentaire WHERE meuble_id = %s'''
    mycursor.execute(sql, (id_meuble,))
    nb_commentaires = mycursor.fetchone()['nb_commentaires']
    print(1,commentaires)
    print(2,commandes_meubles)
    print(3,note)
    print(4,nb_commentaires)
    return render_template('client/meuble_info/meuble_details.html',
                           meuble=meuble,
                           commentaires=commentaires,
                           commandes_meubles=commandes_meubles,
                           note=note,
                           nb_commentaires=nb_commentaires)


@client_commentaire.route('/client/commentaire/add', methods=['POST'])
def client_comment_add():
    mycursor = get_db().cursor()
    commentaire = request.form.get('commentaire', None)
    id_client = session['id_user']
    id_meuble = request.form.get('id_meuble', None)
    print("voitur",id_meuble)
    if commentaire == '':
        flash(u'Commentaire non prise en compte')
        return redirect('/client/meuble/details?id_declinaison_meuble='+id_meuble)
    if commentaire != None and len(commentaire)>0 and len(commentaire) <3 :
        flash(u'Commentaire avec plus de 2 caractères','alert-warning')
        return redirect('/client/meuble/details?id_declinaison_meuble='+id_meuble)
    mycursor.execute("SELECT COUNT(*) FROM commentaire WHERE utilisateur_id = %s AND commentaire.meuble_id = %s ", (id_client,id_meuble))
    nb_commentaires = mycursor.fetchone().get('COUNT(*)')
    print(nb_commentaires,"ouais")
    if nb_commentaires >= 3:
        flash(u'Vous avez déjà posté le maximum de commentaires autorisés.', 'alert-warning')
        return redirect('/client/meuble/details?id_declinaison_meuble=' + id_meuble)

    tuple_insert = (commentaire, id_client, id_meuble)
    print(tuple_insert,"ok")
    sql = ''' INSERT INTO commentaire (commentaire,utilisateur_id, meuble_id, date_publication, valider) 
VALUES (%s, %s, %s, NOW(),1);
   '''
    mycursor.execute(sql, tuple_insert)
    get_db().commit()
    return redirect('/client/meuble/details?id_declinaison_meuble='+id_meuble)


@client_commentaire.route('/client/commentaire/delete', methods=['POST'])
def client_comment_detete():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_meuble = request.form.get('id_meuble', None)
    date_publication = request.form.get('date_publication', None)
    sql = '''DELETE FROM commentaire 
             WHERE utilisateur_id = %s 
             AND meuble_id = %s 
             AND date_publication = %s'''
    tuple_delete=(id_client,id_meuble,date_publication)
    mycursor.execute(sql, tuple_delete)
    get_db().commit()
    print("Oui",id_meuble,"OKok")
    return redirect('/client/meuble/details?id_declinaison_meuble='+id_meuble)

@client_commentaire.route('/client/note/add', methods=['POST'])
def client_note_add():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    note = request.form.get('note', None)
    id_meuble = request.form.get('id_meuble', None)
    tuple_insert = (note, id_client, id_meuble)
    print(tuple_insert)
    sql = ''' INSERT INTO note (note, utilisateur_id, meuble_id)
             VALUES (%s, %s, %s)'''
    mycursor.execute(sql, tuple_insert)
    get_db().commit()
    return redirect('/client/meuble/details?id_declinaison_meuble='+id_meuble)


@client_commentaire.route('/client/note/edit', methods=['POST'])
def client_note_edit():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    note = request.form.get('note', None)
    id_meuble = request.form.get('id_meuble', None)
    tuple_update = (note, id_client, id_meuble)

    sql = ''' 
    INSERT INTO note (note, utilisateur_id, meuble_id)
    VALUES (%s, %s, %s)
    ON DUPLICATE KEY UPDATE note = VALUES(note)
    '''
    mycursor.execute(sql, tuple_update)
    get_db().commit()
    return redirect('/client/meuble/details?id_meuble=' + id_meuble)


@client_commentaire.route('/client/note/delete', methods=['POST'])
def client_note_delete():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_meuble = request.form.get('id_meuble', None)
    tuple_delete = (id_client, id_meuble)
    print(tuple_delete)
    sql = '''  '''
    mycursor.execute(sql, tuple_delete)
    get_db().commit()
    return redirect('/client/meuble/details?id_meuble='+id_meuble)
