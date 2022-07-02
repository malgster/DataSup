/*                                    -----------------------------------------------------
                                                      création des tables
                                          auteures : HAYAR MALAK & DE WANCKER MADDY
                                      -----------------------------------------------------
*/    

          ----------------------------
                  --IMPORT--
          ----------------------------

    DROP DATABASE IF EXISTS SAE_4_BDD;    
    CREATE DATABASE SAE_4_BDD;

    DROP TABLE IF EXISTS import;
    CREATE TABLE import
    (n1 INTEGER, n2 CHAR(35), n3 CHAR(8),
    n4 CHAR(150), n5 CHAR(5), n6 CHAR(50),
    n7 CHAR(50), n8 CHAR(50), n9 CHAR(50),
    n10 CHAR(50), n11 CHAR(50), n12 CHAR(500),
    n13 CHAR(150), n14 CHAR(175), n15 CHAR(500),
    n16 CHAR(50), n17 INTEGER, n18 INTEGER,
    n19 INTEGER, n20 INTEGER, n21 CHAR(50), n22 INTEGER, n23 INTEGER, n24 INTEGER, n25 INTEGER,
    n26 INTEGER, n27 INTEGER, n28 INTEGER, n29 INTEGER, n30 INTEGER, n31 INTEGER, n32 INTEGER,
    n33 INTEGER, n34 INTEGER, n35 INTEGER, n36 CHAR(50), n37 CHAR(50), n38 INTEGER, n39 INTEGER,
    n40 INTEGER, n41 INTEGER, n42 INTEGER, n43 INTEGER, n44 INTEGER, n45 INTEGER, n46 INTEGER,
    n47 INTEGER, n48 INTEGER, n49 INTEGER, n50 NUMERIC, n51 NUMERIC, n52 NUMERIC, n53 CHAR(50),
    n54 INTEGER, n55 INTEGER, n56 INTEGER, n57 INTEGER, n58 INTEGER, n59 INTEGER, n60 INTEGER,
    n61 INTEGER, n62 INTEGER, n63 INTEGER, n64 INTEGER, n65 NUMERIC, n66 INTEGER, n67 INTEGER,
    n68 INTEGER, n69 CHAR(50), n70 CHAR(50), n71 INTEGER, n72 INTEGER, n73 FLOAT, n74 FLOAT,
    n75 FLOAT, n76 FLOAT, n77 FLOAT, n78 FLOAT, n79 FLOAT, n80 FLOAT, n81 FLOAT,
    n82 FLOAT, n83 FLOAT, n84 FLOAT, n85 FLOAT, n86 FLOAT, n87 FLOAT, n88 FLOAT,
    n89 FLOAT, n90 FLOAT, n91 FLOAT, n92 FLOAT, n93 FLOAT, n94 NUMERIC, n95 NUMERIC,
    n96 NUMERIC, n97 NUMERIC, n98 NUMERIC, n99 NUMERIC, n100 NUMERIC, n101 CHAR(100), n102 CHAR(50),
    N103 CHAR(50), n104 CHAR(50), n105 CHAR(50), n106 CHAR(50), n107 CHAR(50), n108 CHAR(50),
    n109 CHAR(50), n110 INTEGER, n111 CHAR(400), n112 CHAR(400), n113 CHAR(100), n114 CHAR(50),
    n115 CHAR(50), n116 CHAR(50), n117 CHAR(50), n118 CHAR(50));

\copy import FROM 'final_data.csv' DELIMITER ';' CSV;

          ----------------------------
                 --DEPARTEMENT--
          ----------------------------

drop table if exists departement, etablissement, formation, candidats CASCADE;
CREATE TABLE departement (dno, nom, region, academie) AS SELECT DISTINCT n5, n6,n7,n8 FROM import;
ALTER TABLE departement ADD PRIMARY KEY (dno);

          ----------------------------
                --ETABLISSEMENT--
          ----------------------------

CREATE TABLE etablissement (eno,dno, commune, statut, nom) AS SELECT DISTINCT n3,n5, n9, n2, n4 FROM import;
ALTER TABLE etablissement ADD PRIMARY KEY (eno);
ALTER TABLE etablissement ADD FOREIGN KEY (dno) REFERENCES departement(dno);

          ----------------------------
                 --FORMATION--
          ----------------------------

CREATE TABLE formation (fno,selectivite,filiere) AS SELECT DISTINCT n110,n10,n13 from import;
ALTER TABLE "formation" ADD PRIMARY KEY (fno);


          ----------------------------
                 --CANDIDATS--
          ----------------------------

CREATE TABLE candidats (
  eno, 
  fno, 
  capacite_etablissement,
  effectif_total,
  dont_effectif_candidates,
  total_candidats_phase_principale,
  neo_generaux_principal,
  neo_generaux_boursier_principal,
  neo_technologiques_principal,
  neo_technologiques_boursiers_principal,
  neo_professionnels_principal,
  neo_professionnels_boursiers_principal,
  autre_candidats_principal,
  total_candidats_complementaire,
  neo_generaux_complementaire,
  neo_technologique_complementaire,
  neo_professionnels_complementaire, 
  autre_candidats_complementaires, 
  total_candidats_admis,
  dont_candidates_admises, 
  admis_principal, 
  admis_complementaire, 
  admis_proposition_principale, 
  neo_admis,
  neo_boursiers_admis, 
  neo_admis_generaux, 
  neo_admis_technologiques, 
  neo_admis_professionnels,
  admis_autres)
    AS SELECT DISTINCT n3, n110, n17, n18, n19, n20, n22, n23, n24, n25,n26, n27,n28, n29,
    n30, n31, n32, n33, n46, n47, n48, n49, n50, n55, n54, n56, n57, n58, n59 from import;

ALTER TABLE "candidats" ADD FOREIGN KEY (eno) REFERENCES etablissement(eno);
ALTER TABLE "candidats" ADD FOREIGN KEY (fno) REFERENCES formation(fno);
ALTER TABLE "candidats" ADD PRIMARY KEY (eno, fno);

------------------------------------------------------------------------
            --Quelques vues utiles sur la table "candidats"--
------------------------------------------------------------------------

DROP VIEW IF EXISTS ratio_fille_garcon, boursiers, liste_principale, liste_complementaire,admis CASCADE;
create view ratio_fille_garcon AS SELECT fno, effectif_total, dont_effectif_candidates, total_candidats_admis, dont_candidates_admises from candidats;
--select * from ratio_fille_garcon;

create view boursiers AS SELECT neo_generaux_boursier_principal, neo_technologiques_boursiers_principal, neo_professionnels_boursiers_principal, neo_boursiers_admis from candidats;
--select * from boursiers;

create view liste_principale AS SELECT eno, fno, neo_generaux_principal,neo_technologiques_principal,neo_professionnels_principal,autre_candidats_principal from candidats;
--select * from liste_principale

create view liste_complementaire AS SELECT total_candidats_complementaire, neo_generaux_complementaire, neo_technologique_complementaire, neo_professionnels_complementaire, autre_candidats_complementaires from candidats;
--select * from liste_complementaire

create view admis AS SELECT total_candidats_admis, admis_principal dont_candidates_admises, admis_principal, admis_complementaire, neo_admis,neo_boursiers_admis, neo_admis_generaux, neo_admis_technologiques, neo_admis_professionnels, admis_autres from candidats;
--select * from admis;


/*     
                            ------------------------------------------------------
                             commandes pour exporter les différente tables en CSV 
                                 (chemins relatifs à changer si ré-éxecution)
                            ------------------------------------------------------
                            
COPY import TO '/mnt/c/Users/malak/OneDrive/Bureau/SAE24_BDD/import.csv' DELIMITER ',' CSV HEADER;
COPY departement TO '/mnt/c/Users/malak/OneDrive/Bureau/SAE24_BDD/departement.csv' DELIMITER ',' CSV HEADER;
COPY candidats TO '/mnt/c/Users/malak/OneDrive/Bureau/SAE24_BDD/candidats.csv' DELIMITER ',' CSV HEADER;
COPY formation TO '/mnt/c/Users/malak/OneDrive/Bureau/SAE24_BDD/formation.csv' DELIMITER ',' CSV HEADER;
COPY etablissement TO '/mnt/c/Users/malak/OneDrive/Bureau/SAE24_BDD/etablissement.csv' DELIMITER ',' CSV HEADER;


*/
