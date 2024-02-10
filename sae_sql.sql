DROP TABLE IF EXISTS note,
ligne_panier,
ligne_commande,
facturer,
liste_envie,
historique,
commentaire,
commande,
etat,
concerne,
adresse,
utilisateur,
declinaison_meuble,
meuble,
type_meuble,
materiau;
-- MATERIAU
CREATE TABLE IF NOT EXISTS materiau(
    id_materiau INT AUTO_INCREMENT,
    libelle_materiau VARCHAR(255),
    PRIMARY KEY(id_materiau)
);
INSERT INTO materiau (libelle_materiau)
VALUES ('Sheesham massif'),
    ('Mélaminé blanc'),
    ('Verre'),
    ('Rotin'),
    ('Violet'),
    ('Rose'),
    ('Rouge'),
    ('Gris'),
    ('Vert'),
    ('Blanc'),
    ('Orange'),
    ('Noir'),
    ('Bleu'),
    ('Bleu foncé'),
    ('Bleu clair'),
    ('Hêtre massif'),
    ('Chêne massif'),
    ('Noyer massif'),
    ('Pin massif'),
    ('Eucalyptus'),
    ('Chêne clair'),
    ('Chêne foncé');
-- TYPE_MEUBLE
CREATE TABLE IF NOT EXISTS type_meuble(
    id_type_meuble INT AUTO_INCREMENT,
    libelle_type_meuble VARCHAR(255),
    PRIMARY KEY(id_type_meuble)
);
INSERT INTO type_meuble (libelle_type_meuble)
VALUES ('Étagère'),
    ('Table'),
    ('Buffet'),
    ('Bibliothèque'),
    ('Vitrine'),
    ('Chaise'),
    ('Pouf');
-- MEUBLE
CREATE TABLE IF NOT EXISTS meuble(
    id_meuble INT AUTO_INCREMENT,
    nom_meuble VARCHAR(255),
    disponible INT,
    prix_meuble DECIMAL(15, 2),
    description_meuble VARCHAR(255),
    image_meuble VARCHAR(255),
    type_meuble_id INT NOT NULL,
    PRIMARY KEY(id_meuble),
    FOREIGN KEY(type_meuble_id) REFERENCES type_meuble(id_type_meuble)
);
INSERT INTO meuble (
        nom_meuble,
        disponible,
        prix_meuble,
        description_meuble,
        image_meuble,
        type_meuble_id
    )
VALUES (
        'Etagère déstructuré',
        1,
        819,
        "Une étagère fort sympathique.",
        '1.jpg',
        1
    ),
    (
        'Table en sheesham',
        1,
        419,
        "C'est une table... et elle est en sheesham...",
        '2.jpg',
        2
    ),
    (
        'Buffet 2 portes 3 tiroirs',
        1,
        799,
        "Plus de porte que dans une voiture familiale.",
        '3.jpg',
        3
    ),
    (
        'Bibliothèque personnalisable',
        1,
        976,
        "On sait que vous ne lirez pas ce qu'il y a dedans.",
        '4.jpg',
        4
    ),
    (
        'Vitrine en verre',
        1,
        700,
        "Parce qu'on ne voyait pas à travers celle en bois.",
        '13.jpg',
        5
    ),
    (
        'Banc TV',
        1,
        345,
        "C'est pour la télé pas pour vous ! Enfin je crois...",
        '14.jpg',
        2
    ),
    (
        'Vitrine figurine',
        1,
        518,
        "En voilà un qui a un hobbie qui ne plait pas à sa femme.",
        '15.jpg',
        5
    ),
    (
        'Chaise Venus',
        1,
        159,
        "On voulait l'appeler Uranus mais ça sonnait pas aussi sérieux...",
        '16.jpg',
        6
    ),
    (
        'Chaise en rotin',
        1,
        226,
        "Et pas en pétin, ahahah...",
        '18.jpg',
        6
    ),
    (
        'Chaise simple',
        1,
        56,
        "Il faut vraiment que j'explique ce que c'est ?",
        '19.jpg',
        6
    ),
    (
        'Chaise jardin',
        1,
        65,
        "Une chaise mais à mettre dans le jardin... Ou pas, je m'en fiche",
        '23.jpg',
        6
    ),
    (
        'Table longue',
        1,
        895,
        "Vous pouvez surement vous allongez dessus aussi",
        '29.jpg',
        2
    ),
    (
        'Table à manger',
        1,
        950,
        "Cette table là, c'est uniquement pour manger !",
        '30.jpg',
        2
    ),
    (
        'Table rustique',
        1,
        1450,
        "Elle est vieille mais rustique c'est plus vendeur.",
        '31.jpg',
        2
    ),
    (
        'Table ronde',
        1,
        425,
        "Mais toujours pas de trace du graal... Quelqu'un a vu Perceval ?",
        '32.jpg',
        2
    ),
    (
        'Table en dur',
        1,
        2250,
        "Parce que les tables molles tiennent pas aussi bien.",
        '33.jpg',
        2
    ),
    (
        'Table bar',
        1,
        1400,
        "Pour un bon ricard !",
        '34.jpg',
        2
    ),
    (
        'Bibliothèque escalier',
        1,
        750,
        "Je crois qu'on peut monter dessus, j'ai juste pas d'étage chez moi",
        '35.jpg',
        4
    ),
    (
        'Pouf plastique',
        1,
        75,
        "Et non une femme de petite vertue ayant fait de la chirurgie esthétique",
        '38.jpg',
        7
    ),
    (
        'Pouf Velour',
        1,
        150,
        "C'est tout doux !",
        '43.jpg',
        7
    );
-- DECLINAISON_MEUBLE
CREATE TABLE IF NOT EXISTS declinaison_meuble(
    id_declinaison_meuble INT AUTO_INCREMENT,
    stock INT,
    prix_declinaison DECIMAL(19, 4),
    image_declinaison VARCHAR(255),
    meuble_id INT NOT NULL,
    materiau_id INT NOT NULL,
    PRIMARY KEY(id_declinaison_meuble),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
    FOREIGN KEY(materiau_id) REFERENCES materiau(id_materiau)
);
INSERT INTO declinaison_meuble (
        meuble_id,
        prix_declinaison,
        image_declinaison,
        stock,
        materiau_id
    )
VALUES (1, 819, '1.jpg', 8, 1),
    (2, 419, '2.jpg', 2, 1),
    (3, 799, '3.jpg', 3, 1),
    (4, 976, '4.jpg', 12, 2),
    (4, 1427, '7.jpg', 1, 16),
    (4, 1725, '10.jpg', 6, 17),
    (5, 700, '13.jpg', 13, 3),
    (6, 345, '14.jpg', 12, 3),
    (7, 518, '15.jpg', 2, 3),
    (8, 159, '16.jpg', 2, 17),
    (8, 159, '17.jpg', 5, 18),
    (9, 226, '18.jpg', 3, 4),
    (10, 56, '19.jpg', 25, 5),
    (10, 56, '20.jpg', 16, 6),
    (10, 56, '21.jpg', 11, 8),
    (10, 56, '22.jpg', 7, 9),
    (11, 65, '23.jpg', 7, 8),
    (11, 65, '24.jpg', 4, 9),
    (11, 65, '25.jpg', 2, 10),
    (11, 65, '26.jpg', 1, 11),
    (11, 65, '27.jpg', 5, 12),
    (11, 65, '28.jpg', 6, 13),
    (12, 895, '29.jpg', 21, 17),
    (13, 950, '30.jpg', 2, 17),
    (14, 1450, '31.jpg', 5, 19),
    (15, 425, '32.jpg', 6, 19),
    (16, 2250, '33.jpg', 7, 20),
    (17, 1400, '34.jpg', 16, 20),
    (18, 750, '35.jpg', 23, 17),
    (18, 750, '36.jpg', 2, 17),
    (19, 75, '38.jpg', 0, 12),
    (19, 75, '39.jpg', 5, 11),
    (19, 75, '41.jpg', 6, 7),
    (19, 75, '42.jpg', 0, 9),
    (20, 150, '43.jpg', 12, 10),
    (20, 150, '44.jpg', 11, 9),
    (20, 150, '45.jpg', 8, 14),
    (20, 150, '46.jpg', 9, 15),
    (20, 150, '47.jpg', 19, 8),
    (20, 150, '48.jpg', 27, 6);
-- UTILISATEUR
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
-- ADRESSE
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
        'Crêperie les Tonnelles',
        '92210',
        'Saint-Cloud',
        '101 Av. du Maréchal Foch',
        1
    ),
    (
        'Residhome Paris Issy-les-Moulineaux',
        '92130',
        'Issy-les-Moulineaux',
        '22-24 Rue du Passeur de Boulogne',
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
        'DSI Group',
        '92350',
        'Le Plessis-Robinson',
        '41 Av. du Général Leclerc',
        1
    );
-- CONCERNE
CREATE TABLE IF NOT EXISTS concerne(
    utilisateur_id INT,
    adresse_id INT,
    PRIMARY KEY(utilisateur_id, adresse_id),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(adresse_id) REFERENCES adresse(id_adresse)
);
INSERT INTO concerne (utilisateur_id, adresse_id)
VALUES (1, 1),
    (2, 2),
    (2, 3),
    (3, 4);
-- ETAT
CREATE TABLE IF NOT EXISTS etat(
    id_etat INT AUTO_INCREMENT,
    libelle_etat VARCHAR(255),
    PRIMARY KEY(id_etat)
);
INSERT INTO etat (libelle_etat)
VALUES ('En attente'),
    ('Expédié'),
    ('Validé'),
    ('Confirmé');
-- COMMANDE
CREATE TABLE IF NOT EXISTS commande(
    id_commande INT AUTO_INCREMENT,
    date_achat DATETIME,
    etat_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    adresse_id INT NOT NULL,
    PRIMARY KEY(id_commande),
    FOREIGN KEY(etat_id) REFERENCES etat(id_etat),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(adresse_id) REFERENCES adresse(id_adresse)
);
INSERT INTO commande (date_achat, utilisateur_id, etat_id, adresse_id)
VALUES ('2024-01-01', 2, 1, 2),
    ('2024-01-02', 2, 1, 2),
    ('2024-01-03', 3, 2, 4),
    ('2024-01-04', 3, 3, 4),
    ('2023-03-03', 2, 4, 2);
-- LIGNE_COMMANDE
CREATE TABLE IF NOT EXISTS ligne_commande(
    commande_id INT,
    declinaison_meuble_id INT,
    quantite_lc INT,
    prix_lc INT,
    PRIMARY KEY(commande_id, declinaison_meuble_id),
    FOREIGN KEY(commande_id) REFERENCES commande(id_commande),
    FOREIGN KEY(declinaison_meuble_id) REFERENCES declinaison_meuble(id_declinaison_meuble)
);
INSERT INTO ligne_commande (
        commande_id,
        declinaison_meuble_id,
        quantite_lc,
        prix_lc
    )
INSERT INTO ligne_commande (declinaison_meuble_id, commande_id, quantite_lc, prix_lc)
VALUES (2, 1, 1, ),
       (1, 1, 2,),
       (3, 2, 3,),
       (1, 3, 1,),
       (1, 4, 11,),
       (2, 4, 5,),
       (3, 4, 4,),
       (4, 4, 12,),
       (5, 4, 6,),
       (6, 4, 6,),
       (7, 4, 1,),
       (8, 4, 2,),
       (9, 4, 2,),
       (10, 4, 6,),
       (11, 4, 9,),
       (12, 4, 13,),
       (13, 4, 13,),
       (14, 4, 12,),
       (15, 4, 2,),
       (16, 4, 2,),
       (17, 4, 5,),
       (18, 4, 3,),
       (19, 4, 25,),
       (20, 4, 16,),
       (21, 4, 11,),
       (22, 4, 7,),
       (23, 4, 7,),
       (24, 4, 4,),
       (25, 4, 2,),
       (26, 4, 1,),
       (27, 4, 5,),
       (28, 4, 6,),
       (29, 4, 21,),
       (30, 4, 2,),
       (31, 4, 5,),
       (32, 4, 6,),
       (33, 4, 7,),
       (34, 4, 16,),
       (35, 4, 23,),
       (36, 4, 2,),
       (38, 4, 5,),
       (39, 4, 6,),
       (41, 4, 12,),
       (42, 4, 11,),
       (43, 4, 8,),
       (44, 4, 9,),
       (45, 4, 19,),
       (46, 4, 27,),
       (1, 5, 2,),
       (2, 5, 1,),
       (3, 5, 3,);


UPDATE ligne_commande
SET prix = (SELECT prix_meuble FROM meuble WHERE meuble.id_meuble = ligne_commande.meuble_id);
-- COMMENTAIRE
CREATE TABLE IF NOT EXISTS commentaire(
    id_commentaire INT AUTO_INCREMENT,
    commentaire VARCHAR(255),
    valider INT,
    date_publication DATETIME NOT NULL,
    meuble_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    PRIMARY KEY(id_commentaire),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);
-- HISTORIQUE
CREATE TABLE IF NOT EXISTS historique(
    id_historique INT AUTO_INCREMENT,
    date_consultation DATETIME NOT NULL,
    meuble_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    PRIMARY KEY(id_historique),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);
-- LISTE_ENVIE
CREATE TABLE IF NOT EXISTS liste_envie(
    id_le INT AUTO_INCREMENT,
    date_update DATETIME NOT NULL,
    meuble_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    PRIMARY KEY(id_le),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);
-- FACTURER
CREATE TABLE IF NOT EXISTS facturer(
    utilisateur_id INT,
    adresse_id INT,
    PRIMARY KEY(utilisateur_id, adresse_id),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(adresse_id) REFERENCES adresse(id_adresse)
);
-- LIGNE_PANIER
CREATE TABLE IF NOT EXISTS ligne_panier(
    utilisateur_id INT,
    declinaison_meuble_id INT,
    date_ajout INT,
    quantite_lp INT,
    PRIMARY KEY(utilisateur_id, declinaison_meuble_id),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(declinaison_meuble_id) REFERENCES declinaison_meuble(id_declinaison_meuble)
);
-- NOTE
CREATE TABLE IF NOT EXISTS note(
    utilisateur_id INT,
    meuble_id INT,
    note DECIMAL(2, 1),
    PRIMARY KEY(utilisateur_id, meuble_id),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble)
);