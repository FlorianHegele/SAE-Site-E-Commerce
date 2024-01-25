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
                                            ('bois'),
                                            ('cuir'),
                                            ('plastique');

INSERT INTO type_meuble (libelle_type) VALUES
                                           ('chaise'),
                                           ('table'),
                                           ('lit');

INSERT INTO marque (libelle_marque) VALUES
                                        ('apanyan compagnie'),
                                        ('quoicIndustry'),
                                        ('voiture');

INSERT INTO fournisseur (libelle_fournisseur) VALUES
                                                  ('amazon'),
                                                  ('aliexpress'),
                                                  ('orange');

INSERT INTO meuble (nom_meuble, largeur, hauteur, prix_meuble, materiau_id, fournisseur_id, marque_id, type_id) VALUES
                                                                                                                    ('table basse', 120.00, 60.00, 150.00, 1, 1, 1, 2),
                                                                                                                    ('canapé', 200.00, 90.00, 500.00, 2, 2, 2, 1),
                                                                                                                    ('lit double', 160.00, 200.00, 800.00, 3, 3, 3, 3);
INSERT INTO etat (libelle_etat) VALUES
                                                ('en attente'),
                                                ('expédié'),
                                                ('validé'),
                                                ('confirmé');

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
