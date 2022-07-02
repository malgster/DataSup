
/*                                         ---------------------------------------------------
                                             Etude statistiques (Région nouvelle-Acquitaine)
                                                        auteures : malak & Maddy
                                           ---------------------------------------------------


                    Ce fichier contient toutes les requêtes nécéssaires pour l'étude statique de notre base de données.
                    Tout Les résultats de cette étude se trouvent dans le rapport de statistique joint dans le dossier.


*/  


/*
---------------------------------------------------
Les filles n'aiment pas les études scientifiques ?
---------------------------------------------------
*/

-- 1 - Selection des filières scientifiques :

SELECT DISTINCT f.filiere
FROM etablissement e join candidats c on e.eno = c.eno join formation f on f.fno = c.fno
WHERE e.dno IN (SELECT * FROM departement_na)
ORDER BY f.filiere;

-- 2 - Regroupement des différentes filières en une seule table :

CREATE TABLE filieres_scientifiques (filiere TEXT);

INSERT INTO filieres_scientifiques  ('BUT - Production'),
                                    ('BUT - Service'),
                                    ('Classe préparatoire aux études supérieures'),
                                    ('Classe préparatoire scientifique'),
                                    ('C.M.I - Cursus Master en Ingénierie'),
                                    ('Formations des écoles d''ingénieurs'),
                                    ('Licence - Sciences - technologies - santé'),
                                    ('Licence - STAPS');

-- 3 - Récupération des données sur les candidats et candidates en Nouvelle-Aquitaine :

CREATE TABLE etude_cand_h_f (filiere TEXT, cand_h INT, cand_f INT);

INSERT INTO etude_cand_h_f(cand_h,cand_f)
SELECT sum(c.effectif_total-c.dont_effectif_candidates), sum(c.dont_effectif_candidates)
FROM etablissement e join candidats c on e.eno = c.eno join formation f on f.fno = c.fno
WHERE e.dno IN (SELECT * FROM departement_na)
AND f.filiere IN (SELECT * FROM filieres_scientifiques);

UPDATE etude_cand_h_f SET filiere = 'Scientifique';

INSERT INTO etude_cand_h_f(cand_h,cand_f)
SELECT sum(c.effectif_total-c.dont_effectif_candidates), sum(c.dont_effectif_candidates)
FROM etablissement e join candidats c on e.eno = c.eno join formation f on f.fno = c.fno
WHERE e.dno IN (SELECT * FROM departement_na)
AND f.filiere NOT IN (SELECT * FROM filieres_scientifiques);

UPDATE etude_cand_h_f SET filiere = 'Autres' WHERE filiere IS NULL;

-- 4 - Exportation des données afin de les traiter :

\copy etude_cand_h_f TO etude_cand_h_f.csv CSV HEADER;



/*
--------------------------------------------------------------------------------------------------
Les bacs techno ont plus de chances que les bacs généraux d'être acceptés en filières sélectives ?
--------------------------------------------------------------------------------------------------
*/

-- Récupération des données sur les admis et non admis ayant obtenu un bac général ou un bac technologique

\copy (
SELECT sum(neo_admis_generaux) AS admis_generaux, sum(neo_generaux_principal+neo_generaux_complementaire-neo_admis_generaux) AS non_admis_generaux,
sum(neo_admis_technologiques) AS admis_techno, sum(neo_technologiques_principal+neo_technologique_complementaire-neo_admis_technologiques) AS non_admis_techno
FROM etablissement e join candidats c on e.eno = c.eno join formation f on f.fno = c.fno
WHERE e.dno IN (SELECT * FROM departement_na)
AND f.selectivite = 'formation sélective'
) TO etude_gen_techno.csv CSV HEADER;


/*

------------------------------------------------
Les boursiers préfèrent-ils les études courtes ?
------------------------------------------------

*/

-- 1 - Séléction des filières courtes (moins de 3ans) :

CREATE TABLE filieres_courtes (filiere TEXT);

INSERT INTO filieres_courtes VALUES('BPJEPS'),
                                    ('BTS - Agricole'),
                                    ('BTS - Maritime'),
                                    ('BTS - Production'),
                                    ('BTS - Service'),
                                    ('BUT - Production'),
                                    ('BUT - Service'),
                                    ('DCG'),
                                    ('D.E secteur sanitaire'),
                                    ('D.E secteur social'),
                                    ('DEUST'),
                                    ('Diplôme d''Etablissement'),
                                    ('Diplôme d''Université'),
                                    ('DN MADE'),
                                    ('Licence - Arts-lettres-langues'),
                                    ('Licence - Droit-économie-gestion'),
                                    ('Licence - Sciences humaines et sociales'),
                                    ('Licence - Sciences - technologies - santé'),
                                    ('Licence - STAPS'),('Mention complémentaire');

-- 2 - Récupération des données sur les candidats boursiers ou non boursiers :

CREATE TABLE etude_cand_bourse (duree TEXT, boursiers INT, non_boursiers INT);

INSERT INTO etude_cand_bourse(boursiers,non_boursiers)
SELECT sum(c.neo_generaux_boursier_principal+c.neo_technologiques_boursiers_principal+c.neo_professionnels_boursiers_principal),
sum(c.total_candidats_phase_principale-(c.neo_generaux_boursier_principal+c.neo_technologiques_boursiers_principal+c.neo_professionnels_boursiers_principal))
FROM etablissement e join candidats c on e.eno = c.eno join formation f on f.fno = c.fno
WHERE e.dno IN (SELECT * FROM departement_na)
AND f.filiere IN (SELECT * FROM filieres_courtes);

UPDATE etude_cand_bourse SET duree = 'Courtes';

INSERT INTO etude_cand_bourse(boursiers,non_boursiers)
SELECT sum(c.neo_generaux_boursier_principal+c.neo_technologiques_boursiers_principal+c.neo_professionnels_boursiers_principal),
sum(c.total_candidats_phase_principale-(c.neo_generaux_boursier_principal+c.neo_technologiques_boursiers_principal+c.neo_professionnels_boursiers_principal))
FROM etablissement e join candidats c on e.eno = c.eno join formation f on f.fno = c.fno
WHERE e.dno IN (SELECT * FROM departement_na)
AND f.filiere NOT IN (SELECT * FROM filieres_courtes);

UPDATE etude_cand_bourse SET duree = 'Longues' WHERE duree IS NULL;


