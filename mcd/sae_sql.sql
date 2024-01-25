DROP TABLE IF EXISTS ligne_panier,ligne_commande,commande,meuble,type_meuble,materiau,fournisseur,marque,utilisateur;

CREATE TABLE IF NOT EXISTS materiau(
   id_materiau INT AUTO_INCREMENT,
   libelle_materiau VARCHAR(255),
   PRIMARY KEY(id_materiau)
);

CREATE TABLE IF NOT EXISTS type_meuble(
   id_type INT,
   libelle_type VARCHAR(255),
   PRIMARY KEY(id_type)
);

CREATE TABLE IF NOT EXISTS fournisseur(
   id_fournisseur INT AUTO_INCREMENT,
   libelle_fournisseur VARCHAR(255),
   PRIMARY KEY(id_fournisseur)
);

CREATE TABLE IF NOT EXISTS marque(
   id_marque INT AUTO_INCREMENT,
   libelle_marque VARCHAR(255),
   PRIMARY KEY(id_marque)
);

CREATE TABLE IF NOT EXISTS utilisateur(
   id_utilisateur INT AUTO_INCREMENT,
   login VARCHAR(255),
   email VARCHAR(255),
   nom VARCHAR(255),
   password VARCHAR(255) NOT NULL,
   role VARCHAR(255),
   est_actif TINYINT,
   PRIMARY KEY(id_utilisateur)
);

CREATE TABLE IF NOT EXISTS commande(
   id_commande INT AUTO_INCREMENT,
   date_achat DATE,
   utilisateur_id INT NOT NULL,
   PRIMARY KEY(id_commande),
   CONSTRAINT fk_commande_utilisateur FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE IF NOT EXISTS etat(
   id_etat INT AUTO_INCREMENT,
   libelle_etat VARCHAR(255),
   commande_id INT NOT NULL,
   PRIMARY KEY(id_etat),
   CONSTRAINT fk_etat_commande FOREIGN KEY(commande_id) REFERENCES commande(id_commande)
);

CREATE TABLE IF NOT EXISTS meuble(
   id_meuble INT AUTO_INCREMENT,
   nom_meuble VARCHAR(255),
   largeur INT,
   hauteur INT,
   prix_meuble DECIMAL(10,2),
   image VARCHAR(255),
   fournisseur_id INT NOT NULL,
   marque_id INT NOT NULL,
   type_id INT NOT NULL,
   PRIMARY KEY(id_meuble),
   CONSTRAINT fk_meuble_materiau FOREIGN KEY(materiau_id) REFERENCES materiau(id_materiau),
   CONSTRAINT fk_meuble_fournisseur FOREIGN KEY(fournisseur_id) REFERENCES fournisseur(id_fournisseur),
   CONSTRAINT fk_meuble_marque FOREIGN KEY(marque_id) REFERENCES marque(id_marque),
   CONSTRAINT fk_meuble_type_meuble FOREIGN KEY(type_id) REFERENCES type_meuble(id_type)
);

CREATE TABLE IF NOT EXISTS ligne_panier(
   meuble_id INT,
   utilisateur_id INT,
   quantite INT,
   prix DECIMAL(15,2),
   PRIMARY KEY(meuble_id, utilisateur_id),
   CONSTRAINT fk_ligne_panier_meuble FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
   CONSTRAINT fk_ligne_panier_utilisateur FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE IF NOT EXISTS ligne_commande(
   meuble_id INT,
   commande_id INT,
   quantite INT,
   date_ajout DATE,
   PRIMARY KEY(meuble_id, commande_id),
   CONSTRAINT fk_ligne_commande_meuble FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
   CONSTRAINT fk_ligne_commande_commande FOREIGN KEY(commande_id) REFERENCES commande(id_commande)
);
