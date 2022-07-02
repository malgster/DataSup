/*                                    -----------------------------------------------------
                                                      requêtes sur tables
                                          auteures : HAYAR MALAK & DE WANCKER MADDY
                                      -----------------------------------------------------
*/

--------------------------------------
       --Requêtes sur import-- 
--------------------------------------

--Q1 : affiche l'effectif des admis néo bacheliers (n55)

SELECT n55 FROM import;

--Q2 : recalcul et vérification l'effectif des admis néo bacheliers à partir de leur filière

SELECT n55, n56+n57+n58 AS recalcul_neo_admis FROM import;

--Q3 : affiche le pourcentage d'admis ayant reçus leurs proposition à l'ouverture de la procédure d'admission (n73)

SELECT n73 FROM import;

--Q4 : recalcul et vérification de la requête précédente à partir du nombre complet d'admis et ceux ayant reçu leurs propositions

SELECT n73, (n50/n46)*100 FROM import WHERE n46!=0;

-- NOTES : les lignes où n46 est égale à 0 sont exclues car la division par 0 est impossible

--Q5 : affiche le pourcentage de filles admises

SELECT n76, (n47*100)/n46::float FROM import WHERE n46!=0;

      -- le cast en float permet d'obtenir des resultat plus précis à une ou deux décimales près

-- Q7 : affiche le pourcentage de néo bacheliers admis 

SELECT n81, (n55*100)/n46::float FROM import WHERE n46!=0;

      -- le cast en float permet d'obtenir des resultat plus précis à une ou deux décimales près

--------------------------------------
   --Requêtes sur tables ventilées-- 
--------------------------------------

--Q6.1 : affiche l'effectif des admis néo bacheliers

SELECT neo_admis FROM candidats;  

--Q6.2 : Recalcul et vérification :

SELECT neo_admis, neo_admis_generaux+neo_admis_technologiques+neo_admis_professionnels AS recalcul_neo_admis from candidats;

--Q6.3/Q6.4 : affiche affiche le pourcentage d'admis ayant reçus leurs proposition à l'ouverture de la procédure d'admission :

SELECT (admis_proposition_principale/total_candidats_admis)*100 AS pourcentage_prop_principale from candidats WHERE admis_proposition_principale!=0;

-- NOTES : les lignes où n46 est égale à 0 sont exclues car la division par 0 est impossible

--Q8 : affiche le pourcentage de filles admises : 

SELECT (dont_candidates_admises*100)/total_candidats_admis::float FROM candidats WHERE total_candidats_admis!=0; 





