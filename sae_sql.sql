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
                                article_id INT,
                                prix DECIMAL(10, 2),
                                quantite INT,
                                FOREIGN KEY (commande_id) REFERENCES commande(id_commande),
                                FOREIGN KEY (article_id) REFERENCES article(id_article)
);

CREATE TABLE ligne_panier (
                              utilisateur_id INT,
                              article_id INT,
                              quantite INT,
                              date_ajout DATE,
                              FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id_utilisateur),
                              FOREIGN KEY (article_id) REFERENCES article(id_article)
);

CREATE TABLE etat (
                      id_etat INT PRIMARY KEY,
                      libelle VARCHAR(255)
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

CREATE TABLE materiau (
                          id_materiau INT PRIMARY KEY,
                          libelle_materiau VARCHAR(255)
);

CREATE TABLE type_meuble (
                             id_type INT PRIMARY KEY,
                             libelle_type VARCHAR(255)
);
