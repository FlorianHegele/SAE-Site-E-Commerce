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
-- Tables
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
    (2, 419.25, '2.jpg', 2, 1),
    (3, 799, '3.jpg', 3, 1),
    (4, 976.50, '4.jpg', 12, 2),
    (4, 1427, '7.jpg', 1, 16),
    (4, 1725, '10.jpg', 6, 17),
    (5, 700, '13.jpg', 13, 3),
    (6, 345, '14.jpg', 12, 3),
    (7, 518, '15.jpg', 2, 3),
    (8, 159, '16.jpg', 2, 17),
    (8, 159.50, '17.jpg', 5, 18),
    (9, 226, '18.jpg', 3, 4),
    (10, 56, '19.jpg', 25, 5),
    (10, 56, '20.jpg', 16, 6),
    (10, 57, '21.jpg', 11, 8),
    (10, 56.99, '22.jpg', 7, 9),
    (11, 65, '23.jpg', 7, 8),
    (11, 65.20, '24.jpg', 4, 9),
    (11, 64, '25.jpg', 2, 10),
    (11, 66, '26.jpg', 1, 11),
    (11, 66, '27.jpg', 5, 12),
    (11, 65, '28.jpg', 6, 13),
    (12, 895.99, '29.jpg', 21, 17),
    (13, 950, '30.jpg', 2, 17),
    (14, 1450.25, '31.jpg', 5, 19),
    (15, 425, '32.jpg', 6, 19),
    (16, 2250, '33.jpg', 7, 20),
    (17, 1400, '34.jpg', 16, 20),
    (18, 750, '35.jpg', 23, 17),
    (18, 750, '36.jpg', 2, 17),
    (19, 76, '38.jpg', 0, 12),
    (19, 75, '39.jpg', 5, 11),
    (19, 76, '41.jpg', 6, 7),
    (19, 75, '42.jpg', 0, 9),
    (20, 151, '43.jpg', 12, 10),
    (20, 150.25, '44.jpg', 11, 9),
    (20, 152.99, '45.jpg', 8, 14),
    (20, 152.99, '46.jpg', 9, 15),
    (20, 152.99, '47.jpg', 19, 8),
    (20, 152.99, '48.jpg', 27, 6);
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
        'Administrateur',
        '1'
    ),
    (
        2,
        'client',
        'client@client.fr',
        'pbkdf2:sha256:600000$ik00jnCw52CsLSlr$9ac8f694a800bca6ee25de2ea2db9e5e0dac3f8b25b47336e8f4ef9b3de189f4',
        'ROLE_client',
        "Semih Remork",
        '1'
    ),
    (
        3,
        'client2',
        'client2@client2.fr',
        'pbkdf2:sha256:600000$3YgdGN0QUT1jjZVN$baa9787abd4decedc328ed56d86939ce816c756ff6d94f4e4191ffc9bf357348',
        'ROLE_client',
        "Jack Séparou",
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
        declinaison_meuble_id,
        commande_id,
        quantite_lc,
        prix_lc
    )
VALUES (2, 1, 1, 419),
    (1, 1, 2, 819),
    (3, 2, 3, 799),
    (1, 3, 1, 819),
    (1, 4, 11, 819),
    (2, 4, 5, 419),
    (3, 4, 4, 799),
    (4, 4, 12, 976),
    (5, 4, 6, 1427),
    (6, 4, 6, 1725),
    (7, 4, 1, 700),
    (8, 4, 2, 345),
    (9, 4, 2, 518),
    (10, 4, 6, 159),
    (11, 4, 9, 159),
    (12, 4, 13, 226),
    (13, 4, 13, 56),
    (14, 4, 12, 57),
    (15, 4, 2, 58),
    (16, 4, 2, 62),
    (17, 4, 5, 65),
    (18, 4, 3, 65.99),
    (19, 4, 25, 62),
    (20, 4, 16, 64.99),
    (21, 4, 11, 64.99),
    (22, 4, 7, 65),
    (23, 4, 7, 895.25),
    (24, 4, 4, 950),
    (25, 4, 2, 1450),
    (26, 4, 1, 425),
    (27, 4, 5, 2250),
    (28, 4, 6, 1400),
    (29, 4, 21, 750),
    (30, 4, 2, 750),
    (31, 4, 5, 75),
    (32, 4, 6, 75.45),
    (33, 4, 7, 72.10),
    (34, 4, 16, 73),
    (35, 4, 23, 150),
    (36, 4, 2, 145),
    (38, 4, 5, 145),
    (39, 4, 6, 155),
    (1, 5, 2, 819),
    (2, 5, 1, 419),
    (3, 5, 3, 799),
    (25, 5, 2, 1445),
    (34, 5, 11, 75.25);
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
CREATE TABLE IF NOT EXISTS historique(
    id_historique INT AUTO_INCREMENT,
    date_consultation DATETIME NOT NULL,
    meuble_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    PRIMARY KEY(id_historique),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);
CREATE TABLE IF NOT EXISTS liste_envie(
    id_le INT AUTO_INCREMENT,
    date_update DATETIME NOT NULL,
    meuble_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    PRIMARY KEY(id_le),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);
CREATE TABLE IF NOT EXISTS facturer(
    utilisateur_id INT,
    adresse_id INT,
    PRIMARY KEY(utilisateur_id, adresse_id),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(adresse_id) REFERENCES adresse(id_adresse)
);
CREATE TABLE IF NOT EXISTS ligne_panier(
    utilisateur_id INT,
    declinaison_meuble_id INT,
    date_ajout DATETIME,
    quantite_lp INT,
    PRIMARY KEY(utilisateur_id, declinaison_meuble_id),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(declinaison_meuble_id) REFERENCES declinaison_meuble(id_declinaison_meuble)
);
INSERT INTO ligne_panier (
        declinaison_meuble_id,
        utilisateur_id,
        quantite_lp,
        date_ajout
    )
VALUES (1, 1, 2, '2024-01-01'),
    (3, 1, 1, '2024-01-01'),
    (2, 2, 3, '2024-01-02'),
    (1, 2, 3, '2024-01-02'),
    (1, 3, 1, '2024-01-03');
CREATE TABLE IF NOT EXISTS note(
    utilisateur_id INT,
    meuble_id INT,
    note DECIMAL(2, 1),
    PRIMARY KEY(utilisateur_id, meuble_id),
    FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble)
);
-- Views
CREATE view IF NOT EXISTS v_ligne_commande AS
SELECT *
FROM ligne_commande
    JOIN declinaison_meuble ON declinaison_meuble_id = id_declinaison_meuble
    JOIN commande ON commande_id = id_commande
    JOIN utilisateur ON utilisateur_id = id_utilisateur;
CREATE view IF NOT EXISTS v_ligne_panier AS
SELECT *
FROM ligne_panier
    JOIN declinaison_meuble ON declinaison_meuble_id = id_declinaison_meuble
    JOIN utilisateur ON utilisateur_id = id_utilisateur;