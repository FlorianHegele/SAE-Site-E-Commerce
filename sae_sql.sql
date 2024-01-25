DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS meuble;
DROP TABLE IF EXISTS type_meuble;
DROP TABLE IF EXISTS materiau;
DROP TABLE IF EXISTS utilisateur;

CREATE TABLE utilisateur (
                             id_utilisateur INT NOT NULL AUTO_INCREMENT,
                             login VARCHAR(255),
                             email VARCHAR(255),
                             password VARCHAR(255),
                             role VARCHAR(255),
                             nom VARCHAR(255),
                             est_actif TINYINT,

                             PRIMARY KEY (id_utilisateur)
);

CREATE TABLE etat (
                      id_etat INT PRIMARY KEY,
                      libelle VARCHAR(255)
);

CREATE TABLE materiau (
                          id_materiau INT PRIMARY KEY,
                          libelle_materiau VARCHAR(255)
);

CREATE TABLE type_meuble (
                             id_type INT PRIMARY KEY,
                             libelle_type VARCHAR(255)
);

CREATE TABLE meuble (
                        id_meuble INT PRIMARY KEY,
                        nom_meuble VARCHAR(255),
                        largeur DECIMAL(10, 2),
                        hauteur DECIMAL(10, 2),
                        prix_meuble DECIMAL(10, 2),
                        materiau_id INT,
                        type_meuble_id INT,
                        fournisseur VARCHAR(255),
                        marque VARCHAR(255),
                        FOREIGN KEY (materiau_id) REFERENCES materiau(id_materiau),
                        FOREIGN KEY (type_meuble_id) REFERENCES type_meuble(id_type)
);

CREATE TABLE commande (
                          id_commande INT PRIMARY KEY,
                          date_achat DATE,
                          utilisateur_id INT,
                          etat_id INT,
                          FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id_utilisateur),
                          FOREIGN KEY (etat_id) REFERENCES etat(id_etat)
);

CREATE TABLE ligne_commande (
                                commande_id INT,
                                meuble_id INT,
                                prix DECIMAL(10, 2),
                                quantite INT,
                                FOREIGN KEY (commande_id) REFERENCES commande(id_commande),
                                FOREIGN KEY (meuble_id) REFERENCES meuble(id_meuble)
);

CREATE TABLE ligne_panier (
                              utilisateur_id INT,
                              meuble_id INT,
                              quantite INT,
                              date_ajout DATE,
                              FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id_utilisateur),
                              FOREIGN KEY (meuble_id) REFERENCES meuble(id_meuble)
);

INSERT INTO utilisateur(id_utilisateur,login,email,password,role,nom,est_actif) VALUES
                                                                                    (1,'admin','admin@admin.fr',
                                                                                     'sha256$dPL3oH9ug1wjJqva$2b341da75a4257607c841eb0dbbacb76e780f4015f0499bb1a164de2a893fdbf',
                                                                                     'ROLE_admin','admin','1'),
                                                                                    (2,'client','client@client.fr',
                                                                                     'sha256$1GAmexw1DkXqlTKK$31d359e9adeea1154f24491edaa55000ee248f290b49b7420ced542c1bf4cf7d',
                                                                                     'ROLE_client','client','1'),
                                                                                    (3,'client2','client2@client2.fr',
                                                                                     'sha256$MjhdGuDELhI82lKY$2161be4a68a9f236a27781a7f981a531d11fdc50e4112d912a7754de2dfa0422',
                                                                                     'ROLE_client','client2','1');

INSERT INTO etat (id_etat, libelle)
VALUES
    (1, 'En cours'),
    (2, 'Livré'),
    (3, 'Annulé');

INSERT INTO materiau (id_materiau, libelle_materiau)
VALUES
    (1, 'Bois'),
    (2, 'Cuir'),
    (3, 'Métal');

INSERT INTO type_meuble (id_type, libelle_type)
VALUES
    (1, 'Table'),
    (2, 'Canapé'),
    (3, 'Lit');

INSERT INTO meuble (id_meuble, nom_meuble, largeur, hauteur, prix_meuble, materiau_id, type_meuble_id, fournisseur, marque)
VALUES
    (1, 'Table basse', 120.00, 60.00, 150.00, 1, 1, 'Meubles & Co', 'ABC Furnitures'),
    (2, 'Canapé', 200.00, 90.00, 500.00, 2, 2, 'Comfort Sofas', 'XYZ Furnishings'),
    (3, 'Lit double', 160.00, 200.00, 800.00, 3, 3, 'Dream Beds', 'Dreamy Designs');

INSERT INTO commande (id_commande, date_achat, utilisateur_id, etat_id)
VALUES
    (1, '2024-01-01', 1, 1),
    (2, '2024-01-02', 2, 1),
    (3, '2024-01-03', 3, 2),
    (4, '2024-01-04', 1, 3);

INSERT INTO ligne_commande (commande_id, meuble_id, prix, quantite)
VALUES
    (1, 1, 50.00, 2),
    (1, 2, 100.00, 1),
    (2, 3, 75.00, 3),
    (3, 1, 50.00, 1);

INSERT INTO ligne_panier (utilisateur_id, meuble_id, quantite, date_ajout)
VALUES
    (1, 1, 2, '2024-01-01'),
    (1, 3, 1, '2024-01-02'),
    (2, 2, 3, '2024-01-03'),
    (3, 1, 1, '2024-01-04');
