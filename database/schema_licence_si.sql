-- =====================================================================
-- Projet SOA : Gestion d'étudiants et de notes
-- Base gestion_etudiants (MySQL / MariaDB, XAMPP)
-- Matières de la Licence Sciences de l'Informatique (Génie Logiciel et
-- Système d'Information), FST Sidi Bouzid : semestres 1 à 6 (1re à 3e année).
-- Chaque matière = un élément d'enseignement (code EE) avec son coefficient.
-- Relancer ce script remet la base à zéro (tables supprimées puis recréées).
-- =====================================================================

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS gestion_etudiants
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE gestion_etudiants;

DROP TABLE IF EXISTS notes;
DROP TABLE IF EXISTS matieres;
DROP TABLE IF EXISTS etudiants;

-- ---------------------------------------------------------------------
-- Table etudiants
-- ---------------------------------------------------------------------
CREATE TABLE etudiants (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nom        VARCHAR(60)  NOT NULL,
  prenom     VARCHAR(60)  NOT NULL,
  classe     VARCHAR(30)  NOT NULL,
  email      VARCHAR(150) NOT NULL,
  created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_etudiants_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Table matieres
-- Colonnes du sujet : id, intitule, coefficient (+ enseignant).
-- Colonnes ajoutées : code, credits, semestre, unite (UE de rattachement).
-- ---------------------------------------------------------------------
CREATE TABLE matieres (
  id          INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  code        VARCHAR(15)   NOT NULL,
  intitule    VARCHAR(100)  NOT NULL,
  coefficient DECIMAL(3,1)  NOT NULL,
  credits     TINYINT UNSIGNED NOT NULL,
  semestre    TINYINT UNSIGNED NOT NULL,
  unite       VARCHAR(120)  NOT NULL,
  enseignant  VARCHAR(100)  NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_matieres_code (code),
  UNIQUE KEY uq_matieres_intitule (intitule),
  KEY idx_matieres_semestre (semestre),
  CONSTRAINT ck_matieres_coefficient CHECK (coefficient > 0),
  CONSTRAINT ck_matieres_semestre CHECK (semestre BETWEEN 1 AND 6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Table notes
-- ---------------------------------------------------------------------
CREATE TABLE notes (
  id          INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  id_etudiant INT UNSIGNED  NOT NULL,
  id_matiere  INT UNSIGNED  NOT NULL,
  valeur      DECIMAL(4,2)  NOT NULL,
  type        ENUM('DS','examen','TP') NOT NULL,
  created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_notes_etudiant_matiere_type (id_etudiant, id_matiere, type),
  CONSTRAINT ck_notes_valeur CHECK (valeur BETWEEN 0 AND 20),
  CONSTRAINT fk_notes_etudiant FOREIGN KEY (id_etudiant)
    REFERENCES etudiants (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_notes_matiere FOREIGN KEY (id_matiere)
    REFERENCES matieres (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Matières : semestres 1 à 6 (57 éléments d'enseignement)
-- ---------------------------------------------------------------------
INSERT INTO matieres (code, intitule, coefficient, credits, semestre, unite, enseignant) VALUES
  ('573105121', 'Algorithmique et structure de données', 2.0, 4, 1, '573105120 - Algorithmique et Programmation 1', NULL),
  ('573105122', 'Atelier programmation 1', 1.5, 3, 1, '573105120 - Algorithmique et Programmation 1', NULL),
  ('573105112', 'Analyse 1', 1.5, 3, 1, '573105110 - Mathématiques 1', NULL),
  ('573105111', 'Algèbre 1', 1.5, 3, 1, '573105110 - Mathématiques 1', NULL),
  ('573105141', 'Logique formelle', 1.5, 3, 1, '573105140 - Logique et Multimédia', NULL),
  ('573105142', 'Technologies Multimédias', 1.5, 3, 1, '573105140 - Logique et Multimédia', NULL),
  ('573105132', 'Systèmes Logiques et architecture des ordinateurs', 2.0, 4, 1, '573105130 - Système d''exploitation et architecture', NULL),
  ('573105131', 'Système d''exploitation 1', 1.5, 3, 1, '573105130 - Système d''exploitation et architecture', NULL),
  ('573105151', 'Anglais 1', 1.0, 2, 1, '573105150 - Langue et communication', NULL),
  ('573105152', 'Techniques de communication 1', 1.0, 2, 1, '573105150 - Langue et communication', NULL),
  ('573105223', 'Programmation Python', 1.0, 2, 2, '573105220 - Algorithmique et Programmation 2', NULL),
  ('573105221', 'Algorithmique et structure de données et complexité', 1.5, 3, 2, '573105220 - Algorithmique et Programmation 2', NULL),
  ('573105222', 'Atelier de programmation 2', 1.0, 2, 2, '573105220 - Algorithmique et Programmation 2', NULL),
  ('573105231', 'Système d''exploitation 2', 1.5, 3, 2, '573105230 - Système d''exploitation et réseaux', NULL),
  ('573105232', 'Fondements des réseaux', 2.0, 4, 2, '573105230 - Système d''exploitation et réseaux', NULL),
  ('573105212', 'Analyse 2', 1.5, 3, 2, '573105210 - Mathématiques 2', NULL),
  ('573105211', 'Algèbre 2', 1.5, 3, 2, '573105210 - Mathématiques 2', NULL),
  ('573105251', 'Fondements des bases de données', 2.0, 4, 2, '573105250 - Bases de données', NULL),
  ('573110211', 'Langue et compétence numérique', 1.0, 2, 2, '573110210 - Langue et Culture numérique', NULL),
  ('573110212', 'Anglais 2', 2.0, 2, 2, '573110210 - Langue et Culture numérique', NULL),
  ('573110213', 'Techniques de communication 2', 1.0, 2, 2, '573110210 - Langue et Culture numérique', NULL),
  ('573105321', 'Théorie des langages et des automates', 1.0, 2, 3, '573105320 - Automates et optimisation', NULL),
  ('573105322', 'Graphes et optimisation', 1.0, 2, 3, '573105320 - Automates et optimisation', NULL),
  ('573105341', 'Ingénierie des Bases de Données', 1.5, 3, 3, '573105340 - Bases de données et Réseaux', NULL),
  ('573105342', 'Services des réseaux', 1.0, 2, 3, '573105340 - Bases de données et Réseaux', NULL),
  ('573105331', 'Conception des systèmes d''information', 1.5, 3, 3, '573105330 - CPOO', NULL),
  ('573105332', 'Programmation Java', 2.0, 4, 3, '573105330 - CPOO', NULL),
  ('573105311', 'Probabilité et statistique', 2.0, 4, 3, '573105310 - Probabilité', NULL),
  ('573105351', 'Anglais 3', 1.0, 2, 3, '573105350 - Langue et culture d''entreprise', NULL),
  ('573105352', 'Gestion d''entreprise', 1.0, 2, 3, '573105350 - Langue et culture d''entreprise', NULL),
  ('169926083', 'JEE', 1.5, 3, 3, '9999877784 - UEO3', NULL),
  ('169926082', 'Développement Mobile et préparation à la certification', 1.5, 3, 3, '9999877784 - UEO3', NULL),
  ('573105412', 'Administration des bases de données', 1.0, 2, 4, '573105410 - Bases de données', NULL),
  ('573105411', 'Entrepôts de données', 1.0, 2, 4, '573105410 - Bases de données', NULL),
  ('573105431', 'Techniques de compilation', 1.5, 3, 4, '573105430 - Compilation et tests', NULL),
  ('573105432', 'Tests des logiciels (certification ISTQB)', 1.0, 2, 4, '573105430 - Compilation et tests', NULL),
  ('573105422', 'Technologies et programmation web', 1.5, 3, 4, '573105420 - Indexation et Web', NULL),
  ('573105421', 'Techniques d''indexation et recherche multimédia', 1.0, 2, 4, '573105420 - Indexation et Web', NULL),
  ('573105451', 'Fondement de l''intelligence artificielle (Programmation IA)', 2.0, 4, 4, '573105450 - Intelligence Artificielle', NULL),
  ('573105441', 'Anglais 4', 1.0, 2, 4, '573105440 - Langue et éthique', NULL),
  ('573105442', 'Droit informatique, protection des données et éthique', 1.0, 2, 4, '573105440 - Langue et éthique', NULL),
  ('573105443', 'Projet fédéré (méthode Agile)', 1.0, 2, 4, '573105440 - Langue et éthique', NULL),
  ('169926085', 'Programmation Python 2', 1.5, 3, 4, '9999877785 - UEO4', NULL),
  ('169926084', 'Programmation des systèmes numériques', 1.5, 3, 4, '9999877785 - UEO4', NULL),
  ('573105541', 'Architecture SOA et services Web', 2.0, 4, 5, '573105540 - Architecture SOA et services Web', NULL),
  ('573105531', 'Machine Learning', 1.0, 2, 5, '573105530 - Machine learning et sécurité', NULL),
  ('573105532', 'Sécurité informatique', 1.0, 2, 5, '573105530 - Machine learning et sécurité', NULL),
  ('573105521', 'Développement Mobile', 1.0, 2, 5, '573105520 - Développement d''applications', NULL),
  ('573105522', 'Développement d''applications réparties', 1.5, 3, 5, '573105520 - Développement d''applications', NULL),
  ('573105511', 'Framework et technologies Big Data', 1.0, 2, 5, '573105510 - Développement d''application', NULL),
  ('573105512', 'Virtualisation et Cloud', 1.5, 3, 5, '573105510 - Développement d''application', NULL),
  ('573105551', 'Anglais 5', 1.0, 2, 5, '57310550 - Langue et partenariat', NULL),
  ('573105552', 'Entrepreneuriat', 1.0, 2, 5, '57310550 - Langue et partenariat', NULL),
  ('573105553', 'Préparation à l''environnement professionnel', 1.0, 2, 5, '57310550 - Langue et partenariat', NULL),
  ('169926528', 'Initiation aux systèmes d''aide à la décision', 1.5, 3, 5, '9999878041 - UEO5', NULL),
  ('169926527', 'Gestion de projets', 1.5, 3, 5, '9999878041 - UEO5', NULL),
  ('573705611', 'PFE', 15.0, 30, 6, '573105610 - Projet de fin d''études', NULL);

-- ---------------------------------------------------------------------
-- Étudiants de test (à modifier librement)
-- ---------------------------------------------------------------------
INSERT INTO etudiants (id, nom, prenom, classe, email) VALUES
  (1, 'Ben Salah', 'Amel',    'SI3-Gr1', 'amel.bensalah@example.com'),
  (2, 'Trabelsi',  'Yassine', 'SI3-Gr1', 'yassine.trabelsi@example.com'),
  (3, 'Gharbi',    'Meriem',  'SI3-Gr1', 'meriem.gharbi@example.com'),
  (4, 'Jlassi',    'Omar',    'SI3-Gr1', 'omar.jlassi@example.com'),
  (5, 'Hammami',   'Sarra',   'SI3-Gr1', 'sarra.hammami@example.com');

-- ---------------------------------------------------------------------
-- Notes de test (semestre 1) : Algorithmique (coef 2), Analyse 1 (coef 1.5),
-- Anglais 1 (coef 1). Sarra n'a aucune note.
-- ---------------------------------------------------------------------
INSERT INTO notes (id_etudiant, id_matiere, valeur, type) VALUES
  -- Amel : 13 ; 15 ; 16  -> moyenne générale 14.33
  (1, (SELECT id FROM matieres WHERE code='573105121'), 12.00, 'DS'),
  (1, (SELECT id FROM matieres WHERE code='573105121'), 14.00, 'examen'),
  (1, (SELECT id FROM matieres WHERE code='573105112'), 15.00, 'examen'),
  (1, (SELECT id FROM matieres WHERE code='573105151'), 16.00, 'DS'),
  -- Yassine : 8.5 ; 10 ; 12 -> 9.78
  (2, (SELECT id FROM matieres WHERE code='573105121'),  8.00, 'DS'),
  (2, (SELECT id FROM matieres WHERE code='573105121'),  9.00, 'examen'),
  (2, (SELECT id FROM matieres WHERE code='573105112'), 10.00, 'examen'),
  (2, (SELECT id FROM matieres WHERE code='573105151'), 12.00, 'DS'),
  -- Meriem : 16.5 ; 18 ; 17 -> 17.11
  (3, (SELECT id FROM matieres WHERE code='573105121'), 16.00, 'DS'),
  (3, (SELECT id FROM matieres WHERE code='573105121'), 17.00, 'examen'),
  (3, (SELECT id FROM matieres WHERE code='573105112'), 18.00, 'examen'),
  (3, (SELECT id FROM matieres WHERE code='573105151'), 17.00, 'DS'),
  -- Omar : 10.5 ; 11 ; 12 -> 11.00
  (4, (SELECT id FROM matieres WHERE code='573105121'), 10.00, 'DS'),
  (4, (SELECT id FROM matieres WHERE code='573105121'), 11.00, 'examen'),
  (4, (SELECT id FROM matieres WHERE code='573105112'), 11.00, 'examen'),
  (4, (SELECT id FROM matieres WHERE code='573105151'), 12.00, 'DS');

-- ---------------------------------------------------------------------
-- Vérification : moyenne générale pondérée de chaque étudiant
-- (à exécuter dans phpMyAdmin, onglet SQL, pour comparer avec le service)
-- ---------------------------------------------------------------------
-- SELECT e.id, e.nom, e.prenom,
--        ROUND(SUM(t.moy_matiere * m.coefficient) / SUM(m.coefficient), 2) AS moyenne_generale
-- FROM (SELECT id_etudiant, id_matiere, AVG(valeur) AS moy_matiere
--       FROM notes GROUP BY id_etudiant, id_matiere) t
-- JOIN matieres  m ON m.id = t.id_matiere
-- JOIN etudiants e ON e.id = t.id_etudiant
-- GROUP BY e.id, e.nom, e.prenom;
