DROP TABLE IF EXISTS liste_envie,
historique,
commentaire,
note,
ligne_panier,
ligne_commande,
concerne,
declinaison_meuble,
meuble,
commande,
type_meuble,
materiau,
etat,
adresse,
utilisateur;

CREATE TABLE utilisateur(
   id_utilisateur INT AUTO_INCREMENT,
   login VARCHAR(255),
   email VARCHAR(255),
   nom_utilisateur VARCHAR(255),
   password VARCHAR(255),
   role VARCHAR(255),
   est_actif TINYINT,
   PRIMARY KEY(id_utilisateur)
);

CREATE TABLE adresse(
   id_adresse INT AUTO_INCREMENT,
   nom_adresse VARCHAR(255),
   rue VARCHAR(255),
   code_postal VARCHAR(5),
   ville VARCHAR(255),
   valide TINYINT,
   PRIMARY KEY(id_adresse)
);

CREATE TABLE etat(
   id_etat INT AUTO_INCREMENT,
   libelle_etat VARCHAR(255),
   PRIMARY KEY(id_etat)
);

CREATE TABLE materiau(
   id_materiau INT AUTO_INCREMENT,
   libelle_materiau VARCHAR(255),
   PRIMARY KEY(id_materiau)
);

CREATE TABLE type_meuble(
   id_type_meuble INT AUTO_INCREMENT,
   libelle_type_meuble VARCHAR(255),
   PRIMARY KEY(id_type_meuble)
);

CREATE TABLE commande(
   id_commande INT AUTO_INCREMENT,
   date_achat DATETIME,
   id_adresse INT NOT NULL,
   id_etat INT NOT NULL,
   id_utilisateur INT NOT NULL,
   id_adresse_1 INT NOT NULL,
   PRIMARY KEY(id_commande),
   FOREIGN KEY(id_adresse) REFERENCES adresse(id_adresse),
   FOREIGN KEY(id_etat) REFERENCES etat(id_etat),
   FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
   FOREIGN KEY(id_adresse_1) REFERENCES adresse(id_adresse)
);

CREATE TABLE meuble(
   id_meuble INT AUTO_INCREMENT,
   nom_meuble VARCHAR(255),
   disponible INT,
   prix_meuble DECIMAL(19,4),
   description_meuble VARCHAR(255),
   image_meuble VARCHAR(255),
   id_type_meuble INT NOT NULL,
   PRIMARY KEY(id_meuble),
   FOREIGN KEY(id_type_meuble) REFERENCES type_meuble(id_type_meuble)
);

CREATE TABLE declinaison_meuble(
   id_declinaison_meuble INT AUTO_INCREMENT,
   stock INT,
   prix_declinaison DECIMAL(19,4),
   image_declinaison VARCHAR(255),
   id_meuble INT NOT NULL,
   id_materiau INT NOT NULL,
   PRIMARY KEY(id_declinaison_meuble),
   FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble),
   FOREIGN KEY(id_materiau) REFERENCES materiau(id_materiau)
);

CREATE TABLE concerne(
   id_utilisateur INT,
   id_adresse INT,
   PRIMARY KEY(id_utilisateur, id_adresse),
   FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
   FOREIGN KEY(id_adresse) REFERENCES adresse(id_adresse)
);

CREATE TABLE ligne_commande(
   id_commande INT,
   id_declinaison_meuble INT,
   quantite_lc INT,
   prix_lc DECIMAL(19,4),
   PRIMARY KEY(id_commande, id_declinaison_meuble),
   FOREIGN KEY(id_commande) REFERENCES commande(id_commande),
   FOREIGN KEY(id_declinaison_meuble) REFERENCES declinaison_meuble(id_declinaison_meuble)
);

CREATE TABLE ligne_panier(
   id_utilisateur INT,
   id_declinaison_meuble INT,
   date_ajout DATETIME,
   quantite_lp INT,
   PRIMARY KEY(id_utilisateur, id_declinaison_meuble),
   FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
   FOREIGN KEY(id_declinaison_meuble) REFERENCES declinaison_meuble(id_declinaison_meuble)
);

CREATE TABLE note(
   id_utilisateur INT,
   id_meuble INT,
   note DECIMAL(2,1),
   PRIMARY KEY(id_utilisateur, id_meuble),
   FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
   FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble)
);

CREATE TABLE commentaire(
   id_utilisateur INT,
   id_meuble INT,
   date_publication DATETIME,
   commentaire VARCHAR(255),
   valider INT,
   PRIMARY KEY(id_utilisateur, id_meuble, date_publication),
   FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
   FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble)
);

CREATE TABLE historique(
   id_utilisateur INT,
   id_meuble INT,
   date_consultation DATETIME,
   PRIMARY KEY(id_utilisateur, id_meuble, date_consultation),
   FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
   FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble)
);

CREATE TABLE liste_envie(
   id_utilisateur INT,
   id_meuble INT,
   date_update DATETIME,
   PRIMARY KEY(id_utilisateur, id_meuble, date_update),
   FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
   FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble)
);
