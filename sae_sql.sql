DROP TABLE IF EXISTS  ligne_commande,ligne_panier, meuble, commande,etat,utilisateur,marque,fournisseur,type_meuble,materiau;

CREATE TABLE IF NOT EXISTS materiau (
                                        id_materiau INT AUTO_INCREMENT,
                                        libelle_materiau VARCHAR(255),
                                        PRIMARY KEY(id_materiau)
);

CREATE TABLE IF NOT EXISTS type_meuble (
                                           id_type INT AUTO_INCREMENT,
                                           libelle_type VARCHAR(255),
                                           PRIMARY KEY(id_type)
);

CREATE TABLE IF NOT EXISTS fournisseur (
                                           id_fournisseur INT AUTO_INCREMENT,
                                           libelle_fournisseur VARCHAR(255),
                                           PRIMARY KEY(id_fournisseur)
);

CREATE TABLE IF NOT EXISTS marque (
                                      id_marque INT AUTO_INCREMENT,
                                      libelle_marque VARCHAR(255),
                                      PRIMARY KEY(id_marque)
);

CREATE TABLE IF NOT EXISTS utilisateur (
                                           id_utilisateur INT AUTO_INCREMENT,
                                           login VARCHAR(255),
                                           email VARCHAR(255),
                                           nom VARCHAR(255),
                                           password VARCHAR(255) NOT NULL,
                                           role VARCHAR(255),
                                           est_actif TINYINT,
                                           PRIMARY KEY(id_utilisateur)
);
CREATE TABLE IF NOT EXISTS etat (
                                    id_etat INT AUTO_INCREMENT,
                                    libelle_etat VARCHAR(255),
                                    PRIMARY KEY(id_etat)

);


CREATE TABLE IF NOT EXISTS commande (
                                        id_commande INT AUTO_INCREMENT,
                                        date_achat DATE,
                                        utilisateur_id INT NOT NULL,
                                        etat_id INT,
                                        PRIMARY KEY(id_commande),
                                        CONSTRAINT fk_commande_utilisateur FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur),
                                        CONSTRAINT fk_commande_etat FOREIGN KEY(etat_id) REFERENCES etat(id_etat)
);


CREATE TABLE IF NOT EXISTS meuble (
                                      id_meuble INT AUTO_INCREMENT,
                                      nom_meuble VARCHAR(255),
                                      largeur INT,
                                      hauteur INT,
                                      prix_meuble DECIMAL(10, 2),
                                      jpg VARCHAR(255),
                                      materiau_id INT,
                                      fournisseur_id INT NOT NULL,
                                      marque_id INT NOT NULL,
                                      type_id INT NOT NULL,
                                      PRIMARY KEY(id_meuble),
                                      CONSTRAINT fk_meuble_materiau FOREIGN KEY(materiau_id) REFERENCES materiau(id_materiau),
                                      CONSTRAINT fk_meuble_fournisseur FOREIGN KEY(fournisseur_id) REFERENCES fournisseur(id_fournisseur),
                                      CONSTRAINT fk_meuble_marque FOREIGN KEY(marque_id) REFERENCES marque(id_marque),
                                      CONSTRAINT fk_meuble_type_meuble FOREIGN KEY(type_id) REFERENCES type_meuble(id_type)
);

CREATE TABLE IF NOT EXISTS ligne_panier (
                                            meuble_id INT,
                                            utilisateur_id INT,
                                            quantite INT,
                                            prix DECIMAL(15, 2),
                                            PRIMARY KEY(meuble_id, utilisateur_id),
                                            CONSTRAINT fk_ligne_panier_meuble FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
                                            CONSTRAINT fk_ligne_panier_utilisateur FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE IF NOT EXISTS ligne_commande (
                                              meuble_id INT,
                                              commande_id INT,
                                              quantite INT,
                                              date_ajout DATE,
                                              PRIMARY KEY(meuble_id, commande_id),
                                              CONSTRAINT fk_ligne_commande_meuble FOREIGN KEY(meuble_id) REFERENCES meuble(id_meuble),
                                              CONSTRAINT fk_ligne_commande_commande FOREIGN KEY(commande_id) REFERENCES commande(id_commande)
);

INSERT INTO utilisateur (login, email, nom, password, role, est_actif) VALUES
                                                                           ('admin', 'admin@admin.fr', 'admin', 'sha256$dPL3oH9ug1wjJqva$2b341da75a4257607c841eb0dbbacb76e780f4015f0499bb1a164de2a893fdbf', 'ROLE_admin', 1),
                                                                           ('client', 'client@client.fr', 'client', 'sha256$1GAmexw1DkXqlTKK$31d359e9adeea1154f24491edaa55000ee248f290b49b7420ced542c1bf4cf7d', 'ROLE_client', 1),
                                                                           ('client2', 'client2@client2.fr', 'client2', 'sha256$MjhdGuDELhI82lKY$2161be4a68a9f236a27781a7f981a531d11fdc50e4112d912a7754de2dfa0422', 'ROLE_client', 1);



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

INSERT INTO type_meuble (libelle_type) VALUES
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

INSERT INTO meuble (nom_meuble, largeur, hauteur, prix_meuble, jpg, materiau_id, fournisseur_id, marque_id, type_id) VALUES
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
                                                               ('2024-01-04', 1, 3);

INSERT INTO ligne_commande (meuble_id, commande_id, quantite, date_ajout) VALUES
                                                                              (1, 1, 2, '2024-01-01'),
                                                                              (2, 1, 1, '2024-01-01'),
                                                                              (3, 2, 3, '2024-01-02'),
                                                                              (1, 3, 1, '2024-01-03');


INSERT INTO ligne_panier (meuble_id, utilisateur_id, quantite, prix) VALUES
                                                                                     (1, 1, 2, 300.00),
                                                                                     (3, 1, 1, 800.00),
                                                                                     (2, 2, 3, 500.00),
                                                                                     (1, 3, 1, 150.00);
