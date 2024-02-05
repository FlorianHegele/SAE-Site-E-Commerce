SELECT date_achat,
    SUM(lc.quantite) AS nb_meubles,
    SUM(prix_meuble) AS prix_total,
    etat_id
FROM ligne_commande lc
JOIN commande c ON lc.commande_id = c.id_commande
JOIN meuble m ON lc.meuble_id = m.id_meuble
WHERE c.utilisateur_id = 1
ORDER BY etat_id,
    date_achat DESC;

-- Nombre de meubles
-- COUNT

SELECT * FROM ligne_commande
JOIN commande ON ligne_commande.commande_id = commande.id_commande
WHERE commande.utilisateur_id = 2;

        SELECT c.id_commande,
            date_achat,
            SUM(lc.quantite) AS nbr_meubles,
            lc.prix * quantite AS prix_total,
            etat_id,
            libelle_etat AS libelle
        FROM ligne_commande lc
        JOIN commande c ON lc.commande_id = c.id_commande
        JOIN meuble m ON lc.meuble_id = m.id_meuble
        JOIN etat e ON c.etat_id = e.id_etat
        WHERE c.utilisateur_id = 2
        GROUP BY c.id_commande
        ORDER BY etat_id,
            date_achat DESC;

SELECT *
        FROM ligne_commande lc
        JOIN commande c ON lc.commande_id = c.id_commande

         WHERE utilisateur_id = 2;

SELECT * from adresse;

   UPDATE adresse
    SET nom_adresse = 'fjkbesz', code_postal = '12435', ville = 'bonbah', rue = 'jsp frr'
    WHERE id_adresse = 5;

DELETE FROM adresse WHERE id_adresse = 3;