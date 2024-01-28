DROP TABLE IF EXISTS  ligne_commande,ligne_panier, meuble, commande,etat,utilisateur,marque,fournisseur,type_meuble,materiau;

CREATE TABLE materiau (
                                        id_materiau INT AUTO_INCREMENT,
                                        libelle_materiau VARCHAR(255),
                                        PRIMARY KEY(id_materiau)
   )  DEFAULT CHARSET utf8;

CREATE TABLE type_meuble (
                                           id_type_meuble INT AUTO_INCREMENT,
                                           libelle_type_meuble VARCHAR(255),
                                           PRIMARY KEY(id_type_meuble)
   )  DEFAULT CHARSET utf8;

CREATE TABLE fournisseur (
                                           id_fournisseur INT AUTO_INCREMENT,
                                           libelle_fournisseur VARCHAR(255),
                                           PRIMARY KEY(id_fournisseur)
   )  DEFAULT CHARSET utf8;

CREATE TABLE marque (
                                      id_marque INT AUTO_INCREMENT,
                                      libelle_marque VARCHAR(255),
                                      PRIMARY KEY(id_marque)
   )  DEFAULT CHARSET utf8;

CREATE TABLE utilisateur (
                                           id_utilisateur INT AUTO_INCREMENT,
                                           login VARCHAR(255),
                                           email VARCHAR(255),
                                           nom VARCHAR(255),
                                           password VARCHAR(255) NOT NULL,
                                           role VARCHAR(255),
                                           est_actif TINYINT,
                                           PRIMARY KEY(id_utilisateur)
   )  DEFAULT CHARSET utf8;

CREATE TABLE etat (
                                    id_etat INT AUTO_INCREMENT,
                                    libelle_etat VARCHAR(255),
                                    PRIMARY KEY(id_etat)

   )  DEFAULT CHARSET utf8;


CREATE TABLE commande (
                                        id_commande INT AUTO_INCREMENT,
                                        date_achat DATE,
                                        utilisateur_id INT NOT NULL,
                                        etat_id INT,
                                        PRIMARY KEY(id_commande),
                                        CONSTRAINT fk_commande_utilisateur FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
                                        CONSTRAINT fk_commande_etat FOREIGN KEY(etat_id) REFERENCES etat(id_etat)
   )  DEFAULT CHARSET utf8;


CREATE TABLE meuble (
                                      id_meuble INT AUTO_INCREMENT,
                                      nom_meuble VARCHAR(255),
                                      largeur INT,
                                      hauteur INT,
                                      prix_meuble DECIMAL(10, 2),
                                      image_meuble VARCHAR(255),
                                      materiau_id INT,
                                      fournisseur_id INT NOT NULL,
                                      marque_id INT NOT NULL,
                                      type_id INT NOT NULL,
                                      PRIMARY KEY(id_meuble),
                                      CONSTRAINT fk_meuble_materiau FOREIGN KEY(materiau_id) REFERENCES materiau(id_materiau),
                                      CONSTRAINT fk_meuble_fournisseur FOREIGN KEY(fournisseur_id) REFERENCES fournisseur(id_fournisseur),
                                      CONSTRAINT fk_meuble_marque FOREIGN KEY(marque_id) REFERENCES marque(id_marque),
                                      CONSTRAINT fk_meuble_type_meuble FOREIGN KEY(type_id) REFERENCES type_meuble(id_type_meuble)
   )  DEFAULT CHARSET utf8;

CREATE TABLE ligne_panier (
                                            meuble_id INT,
                                            utilisateur_id INT,
                                            quantite INT,
                                            prix DECIMAL(15, 2),
                                            PRIMARY KEY(meuble_id, utilisateur_id),
                                            CONSTRAINT fk_ligne_panier_meuble FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
                                            CONSTRAINT fk_ligne_panier_utilisateur FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
   )  DEFAULT CHARSET utf8;

CREATE TABLE ligne_commande (
                                              meuble_id INT,
                                              commande_id INT,
                                              quantite INT,
                                              date_ajout DATE,
                                              PRIMARY KEY(meuble_id, commande_id),
                                              CONSTRAINT fk_ligne_commande_meuble FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
                                              CONSTRAINT fk_ligne_commande_commande FOREIGN KEY(commande_id) REFERENCES commande(id_commande)
   )  DEFAULT CHARSET utf8;

INSERT INTO utilisateur (id_utilisateur, login, email, password, role, nom, est_actif) VALUES
(1,'admin','admin@admin.fr',
    'pbkdf2:sha256:600000$828ij7RCZN24IWfq$3dbd14ea15999e9f5e340fe88278a45c1f41901ee6b2f56f320bf1fa6adb933d',
    'ROLE_admin','admin','1'),
(2,'client','client@client.fr',
    'pbkdf2:sha256:600000$ik00jnCw52CsLSlr$9ac8f694a800bca6ee25de2ea2db9e5e0dac3f8b25b47336e8f4ef9b3de189f4',
    'ROLE_client','client','1'),
(3,'client2','client2@client2.fr',
    'pbkdf2:sha256:600000$3YgdGN0QUT1jjZVN$baa9787abd4decedc328ed56d86939ce816c756ff6d94f4e4191ffc9bf357348',
    'ROLE_client','client2','1');



INSERT INTO materiau (libelle_materiau) VALUES
                                            ('Sheesham massif'),
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

INSERT INTO type_meuble (libelle_type_meuble) VALUES
                                           ('Étagère'),
                                           ('Table'),
                                           ('Buffet'),
                                           ('Bibliothèque'),
                                           ('Vitrine'),
                                           ('Chaise'),
                                           ('Pouf');

INSERT INTO marque (libelle_marque) VALUES
                                        ('Maisons du monde'),
                                        ('Ikea'),
                                        ('ManoMano'),
                                        ('magequip'),
                                        ('Pickawood');

INSERT INTO fournisseur (libelle_fournisseur) VALUES
                                                  ('Tikamoon'),
                                                  ('Ikea'),
                                                  ('NKL'),
                                                  ('Alvero');

INSERT INTO meuble (nom_meuble, largeur, hauteur, prix_meuble, image_meuble, materiau_id, fournisseur_id, marque_id, type_id) VALUES
                                                                                                                            ('Etagère déstructuré',110,195,819,'1.jpg',1,1,1,1),
                                                                                                                            ('Table en sheesham',130,78,419,'2.jpg',1,1,1,2),
                                                                                                                            ('Buffet 2 portes 3 tiroirs',160,85,799,'3.jpg',1,1,1,3),
                                                                                                                            ('Bibliothèque personnalisable',138,138,976,'4.jpg',2,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',172,138,1182,'5.jpg',2,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',206,138,1389,'6.jpg',2,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',138,138,1427,'7.jpg',16,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',172,138,1737,'8.jpg',16,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',206,138,2047,'9.jpg',16,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',138,138,1725,'10.jpg',17,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',172,138,2104,'11.jpg',17,2,2,4),
                                                                                                                            ('Bibliothèque personnalisable',206,138,2485,'12.jpg',17,2,2,4),
                                                                                                                            ('Vitrine en verre',95,72,700,'13.jpg',3,2,2,5),
                                                                                                                            ('Banc TV',80,40,345,'14.jpg',3,2,2,2),
                                                                                                                            ('Vitrine figurine',62,200,518,'15.jpg',3,2,2,5),
                                                                                                                            ('Chaise Venus',58,76,159,'16.jpg',17,1,3,6),
                                                                                                                            ('Chaise Venus',58,76,159,'17.jpg',18,1,3,6),
                                                                                                                            ('Chaise en rotin',70,72,226,'18.jpg',4,1,3,6),
                                                                                                                            ('Chaise simple',52,79,56,'19.jpg',5,1,3,6),
                                                                                                                            ('Chaise simple',52,79,56,'20.jpg',6,1,3,6),
                                                                                                                            ('Chaise simple',52,79,56,'21.jpg',8,1,3,6),
                                                                                                                            ('Chaise simple',52,79,56,'22.jpg',9,1,3,6),
                                                                                                                            ('Chaise jardin',55,75,65,'23.jpg',8,1,3,6),
                                                                                                                            ('Chaise jardin',55,75,65,'24.jpg',9,1,3,6),
                                                                                                                            ('Chaise jardin',55,75,65,'25.jpg',10,1,3,6),
                                                                                                                            ('Chaise jardin',55,75,65,'26.jpg',11,1,3,6),
                                                                                                                            ('Chaise jardin',55,75,65,'27.jpg',12,1,3,6),
                                                                                                                            ('Chaise jardin',55,75,65,'28.jpg',13,1,3,6),
                                                                                                                            ('Table longue',240,135,895,'29.jpg',17,1,3,2),
                                                                                                                            ('Table à manger',210,70,950,'30.jpg',17,1,3,2),
                                                                                                                            ('Table rustique',220,70,1450,'31.jpg',19,1,3,2),
                                                                                                                            ('Table ronde',110,110,425,'32.jpg',19,3,4,2),
                                                                                                                            ('Table en dur',250,60,2250,'33.jpg',20,3,4,2),
                                                                                                                            ('Table bar',100,100,1400,'34.jpg',20,3,4,2),
                                                                                                                            ('Bibliothèque escalier',150,130,750,'35.jpg',17,3,4,4),
                                                                                                                            ('Bibliothèque escalier',150,130,750,'36.jpg',17,3,4,4),
                                                                                                                            ('Pouf plastique',50,50,75,'38.jpg',12,4,5,7),
                                                                                                                            ('Pouf plastique',50,50,75,'39.jpg',11,4,5,7),
                                                                                                                            ('Pouf plastique',50,50,75,'41.jpg',7,4,5,7),
                                                                                                                            ('Pouf plastique',50,50,75,'42.jpg',9,4,5,7),
                                                                                                                            ('Pouf Velour',60,60,150,'43.jpg',10,4,5,7),
                                                                                                                            ('Pouf Velour',60,60,150,'44.jpg',9,4,5,7),
                                                                                                                            ('Pouf Velour',60,60,150,'45.jpg',14,4,5,7),
                                                                                                                            ('Pouf Velour',60,60,150,'46.jpg',15,4,5,7),
                                                                                                                            ('Pouf Velour',60,60,150,'47.jpg',8,4,5,7),
                                                                                                                            ('Pouf Velour',60,60,150,'48.jpg',6,4,5,7);

INSERT INTO etat (libelle_etat) VALUES
                                                ('En attente'),
                                                ('Expédié'),
                                                ('Validé'),
                                                ('Confirmé');

INSERT INTO commande (date_achat, utilisateur_id, etat_id) VALUES
                                                            ('2024-01-01', 1, 1),
                                                            ('2024-01-02', 2, 1),
                                                            ('2024-01-03', 3, 2),
                                                            ('2024-01-04', 1, 4),
                                                            ('2024-01-04', 1, 3);

INSERT INTO ligne_commande (meuble_id, commande_id, quantite, date_ajout) VALUES
                                                                            (1, 1, 2, '2024-01-01'),
                                                                            (2, 1, 1, '2024-01-01'),
                                                                            (3, 2, 3, '2024-01-02'),
                                                                            (1, 3, 1, '2024-01-03'),
                                                                            (1, 4, 11, '2024-01-04'),
                                                                            (2, 4, 5, '2024-01-04'),
                                                                            (3, 4, 4, '2024-01-04'),
                                                                            (4, 4, 12, '2024-01-04'),
                                                                            (5, 4, 6, '2024-01-04'),
                                                                            (6, 4, 6, '2024-01-04'),
                                                                            (7, 4, 1, '2024-01-04'),
                                                                            (8, 4, 2, '2024-01-04'),
                                                                            (9, 4, 2, '2024-01-04'),
                                                                            (10, 4, 6, '2024-01-04'),
                                                                            (11, 4, 9, '2024-01-04'),
                                                                            (12, 4, 13, '2024-01-04'),
                                                                            (13, 4, 13, '2024-01-04'),
                                                                            (14, 4, 12, '2024-01-04'),
                                                                            (15, 4, 2, '2024-01-04'),
                                                                            (16, 4, 2, '2024-01-04'),
                                                                            (17, 4, 5, '2024-01-04'),
                                                                            (18, 4, 3, '2024-01-04'),
                                                                            (19, 4, 25, '2024-01-04'),
                                                                            (20, 4, 16, '2024-01-04'),
                                                                            (21, 4, 11, '2024-01-04'),
                                                                            (22, 4, 7, '2024-01-04'),
                                                                            (23, 4, 7, '2024-01-04'),
                                                                            (24, 4, 4, '2024-01-04'),
                                                                            (25, 4, 2, '2024-01-04'),
                                                                            (26, 4, 1, '2024-01-04'),
                                                                            (27, 4, 5, '2024-01-04'),
                                                                            (28, 4, 6, '2024-01-04'),
                                                                            (29, 4, 21, '2024-01-04'),
                                                                            (30, 4, 2, '2024-01-04'),
                                                                            (31, 4, 5, '2024-01-04'),
                                                                            (32, 4, 6, '2024-01-04'),
                                                                            (33, 4, 7, '2024-01-04'),
                                                                            (34, 4, 16, '2024-01-04'),
                                                                            (35, 4, 23, '2024-01-04'),
                                                                            (36, 4, 2, '2024-01-04'),
                                                                            (38, 4, 5, '2024-01-04'),
                                                                            (39, 4, 6, '2024-01-04'),
                                                                            (41, 4, 12, '2024-01-04'),
                                                                            (42, 4, 11, '2024-01-04'),
                                                                            (43, 4, 8, '2024-01-04'),
                                                                            (44, 4, 9, '2024-01-04'),
                                                                            (45, 4, 19, '2024-01-04'),
                                                                            (46, 4, 27, '2024-01-04');


INSERT INTO ligne_panier (meuble_id, utilisateur_id, quantite, prix) VALUES
                                                                                    (1, 1, 2, 300.00),
                                                                                    (3, 1, 1, 800.00),
                                                                                    (2, 2, 3, 500.00),
                                                                                    (1, 3, 1, 150.00);
