DROP TABLE IF EXISTS note,
ligne_panier,
ligne_commande,
facturer,
concerne,
declinaison__meuble,
liste_envie,
historique,
commentaire,
meuble,
commande,
type_meuble,
materiau,
etat,
adresse,
utilisateur;
CREATE TABLE IF NOT EXISTS utilisateur(
    id_utilisateur INT AUTO_INCREMENT,
    login VARCHAR(255),
    email VARCHAR(255),
    nom_utilisateur VARCHAR(255),
    password VARCHAR(255),
    role VARCHAR(255),
    est_actif TINYINT,
    PRIMARY KEY(id_utilisateur)
);
INSERT INTO utilisateur (
        id_utilisateur,
        login,
        email,
        password,
        role,
        nom_utilisateur,
        est_actif
    )
VALUES (
        1,
        'admin',
        'admin@admin.fr',
        'pbkdf2:sha256:600000$828ij7RCZN24IWfq$3dbd14ea15999e9f5e340fe88278a45c1f41901ee6b2f56f320bf1fa6adb933d',
        'ROLE_admin',
        'admin',
        '1'
    ),
    (
        2,
        'client',
        'client@client.fr',
        'pbkdf2:sha256:600000$ik00jnCw52CsLSlr$9ac8f694a800bca6ee25de2ea2db9e5e0dac3f8b25b47336e8f4ef9b3de189f4',
        'ROLE_client',
        'client',
        '1'
    ),
    (
        3,
        'client2',
        'client2@client2.fr',
        'pbkdf2:sha256:600000$3YgdGN0QUT1jjZVN$baa9787abd4decedc328ed56d86939ce816c756ff6d94f4e4191ffc9bf357348',
        'ROLE_client',
        'client2',
        '1'
    );
CREATE TABLE IF NOT EXISTS adresse(
    id_adresse INT AUTO_INCREMENT,
    nom_adresse VARCHAR(255),
    rue VARCHAR(255),
    code_postal VARCHAR(5),
    ville VARCHAR(255),
    valide TINYINT,
    PRIMARY KEY(id_adresse)
);
INSERT INTO adresse (nom_adresse, code_postal, ville, rue, valide)
VALUES (
        'Maison',
        '75000',
        'Paris',
        'Rue des Fleurs',
        1
    ),
    (
        'Travail',
        '06400',
        'Cannes',
        'Boulevard Carnot',
        1
    ),
    (
        'Fausse adresse',
        '06401',
        'Cdds',
        'Boulevard not',
        0
    ),
    (
        'Maison',
        '68720',
        'Zillisheim',
        'Rue du Chateau',
        1
    );
CREATE TABLE IF NOT EXISTS etat(
    id_etat INT AUTO_INCREMENT,
    libelle_etat VARCHAR(255),
    PRIMARY KEY(id_etat)
);
CREATE TABLE IF NOT EXISTS materiau(
    id_materiau INT AUTO_INCREMENT,
    libelle_materiau VARCHAR(255),
    PRIMARY KEY(id_materiau)
);
CREATE TABLE IF NOT EXISTS type_meuble(
    id_type_meuble INT AUTO_INCREMENT,
    libelle_type_meuble VARCHAR(255),
    PRIMARY KEY(id_type_meuble)
);
CREATE TABLE IF NOT EXISTS commande(
    id_commande INT AUTO_INCREMENT,
    date_achat DATETIME,
    id_etat INT NOT NULL,
    id_utilisateur INT NOT NULL,
    id_adresse INT NOT NULL,
    PRIMARY KEY(id_commande),
    FOREIGN KEY(id_etat) REFERENCES etat(id_etat),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(id_adresse) REFERENCES adresse(id_adresse)
);
CREATE TABLE IF NOT EXISTS meuble(
    id_meuble INT,
    nom_meuble VARCHAR(255),
    disponible INT,
    prix_meuble DECIMAL(15, 2),
    description_meuble VARCHAR(255),
    image_meuble VARCHAR(255),
    id_type_meuble INT NOT NULL,
    PRIMARY KEY(id_meuble),
    FOREIGN KEY(id_type_meuble) REFERENCES type_meuble(id_type_meuble)
);
CREATE TABLE IF NOT EXISTS commentaire(
    id_commentaire INT AUTO_INCREMENT,
    commentaire VARCHAR(255),
    valider INT,
    date_publication DATETIME NOT NULL,
    id_meuble INT NOT NULL,
    id_utilisateur INT NOT NULL,
    PRIMARY KEY(id_commentaire),
    FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);
CREATE TABLE IF NOT EXISTS historique(
    id_historique INT AUTO_INCREMENT,
    date_consultation DATETIME NOT NULL,
    id_meuble INT NOT NULL,
    id_utilisateur INT NOT NULL,
    PRIMARY KEY(id_historique),
    FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);
CREATE TABLE IF NOT EXISTS liste_envie(
    id_le INT AUTO_INCREMENT,
    date_update DATETIME NOT NULL,
    id_meuble INT NOT NULL,
    id_utilisateur INT NOT NULL,
    PRIMARY KEY(id_le),
    FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);
CREATE TABLE IF NOT EXISTS declinaison__meuble(
    id_declinaison_meuble INT AUTO_INCREMENT,
    stock INT,
    prix_declinaison DECIMAL(19, 4),
    image_declinaison VARCHAR(255),
    id_meuble INT NOT NULL,
    id_materiau INT NOT NULL,
    PRIMARY KEY(id_declinaison_meuble),
    FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble),
    FOREIGN KEY(id_materiau) REFERENCES materiau(id_materiau)
);
CREATE TABLE IF NOT EXISTS concerne(
    id_utilisateur INT,
    id_adresse INT,
    PRIMARY KEY(id_utilisateur, id_adresse),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(id_adresse) REFERENCES adresse(id_adresse)
);
CREATE TABLE IF NOT EXISTS facturer(
    id_utilisateur INT,
    id_adresse INT,
    PRIMARY KEY(id_utilisateur, id_adresse),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(id_adresse) REFERENCES adresse(id_adresse)
);
CREATE TABLE IF NOT EXISTS ligne_commande(
    id_commande INT,
    id_declinaison_meuble INT,
    quantite_lc INT,
    prix_lc INT,
    PRIMARY KEY(id_commande, id_declinaison_meuble),
    FOREIGN KEY(id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY(id_declinaison_meuble) REFERENCES declinaison__meuble(id_declinaison_meuble)
);
CREATE TABLE IF NOT EXISTS ligne_panier(
    id_utilisateur INT,
    id_declinaison_meuble INT,
    date_ajout INT,
    quantite_lp INT,
    PRIMARY KEY(id_utilisateur, id_declinaison_meuble),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(id_declinaison_meuble) REFERENCES declinaison__meuble(id_declinaison_meuble)
);
CREATE TABLE IF NOT EXISTS note(
    id_utilisateur INT,
    id_meuble INT,
    note DECIMAL(2, 1),
    PRIMARY KEY(id_utilisateur, id_meuble),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(id_meuble) REFERENCES meuble(id_meuble)
);
