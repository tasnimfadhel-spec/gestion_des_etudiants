# Contrat des services SOAP – Gestion d'étudiants et de notes

Ce fichier fixe les noms d'opérations, les champs et les erreurs.
**Toute modification doit être validée par Tasnim et Yomna** : elle casse le WSDL, le PHP et le React.

## 1. Règles communes

| Élément | Convention |
|---|---|
| Adresse des services | `http://localhost/soa/etudiants.php`, `matieres.php`, `notes.php` |
| WSDL | même adresse avec `?wsdl` (exemple : `http://localhost/soa/notes.php?wsdl`) |
| Espaces de noms | `http://localhost/soa/etudiants`, `.../matieres`, `.../notes` |
| Noms des champs | camelCase : `idEtudiant`, `idMatiere`, `valeur`, `type` |
| Types | `int` (entier), `decimal` (point décimal, 2 chiffres), `string` |
| Liste vide | une liste vide n'est **pas** une erreur |

### Format des erreurs (SOAP Fault)

| Partie du Fault | Contenu |
|---|---|
| `faultcode` | `Client` (erreur de l'appelant : codes 400, 404, 409) ou `Server` (erreur interne : code 500) |
| `faultstring` | message clair en français |
| `detail` | le code numérique : `400`, `404`, `409` ou `500` |

| Code | Signification | Exemples |
|---|---|---|
| 400 | Donnée invalide | champ manquant, email invalide, note hors de 0 à 20, type inconnu |
| 404 | Élément introuvable | étudiant ou matière inexistant |
| 409 | Conflit | email déjà utilisé, note en double, suppression impossible |
| 500 | Erreur interne | base de données inaccessible (message générique, sans détail technique) |

## 2. NotesService (Tasnim)

### ajouterNote
Entrée : `idEtudiant` (int), `idMatiere` (int), `valeur` (decimal), `type` (string : `DS`, `examen` ou `TP`)
Sortie : `Note` = `id`, `idEtudiant`, `idMatiere`, `valeur`, `type`

| Cas | Code | Message |
|---|---|---|
| Champ manquant ou `valeur` non numérique | 400 | Champ obligatoire manquant ou invalide |
| `valeur` hors de 0 à 20 | 400 | La note doit être comprise entre 0 et 20 |
| `type` différent de DS, examen, TP | 400 | Type de note invalide (DS, examen ou TP) |
| Étudiant inexistant | 404 | Étudiant introuvable |
| Matière inexistante | 404 | Matière introuvable |
| Même étudiant, matière et type déjà enregistrés | 409 | Cette note existe déjà |

### listerNotesEtudiant
Entrée : `idEtudiant` (int)
Sortie : liste de `NoteDetail` = `id`, `idMatiere`, `matiere` (intitulé), `coefficient`, `semestre`, `valeur`, `type`

| Cas | Code | Message |
|---|---|---|
| `idEtudiant` invalide | 400 | Identifiant étudiant invalide |
| Étudiant inexistant | 404 | Étudiant introuvable |
| Étudiant sans note | – | liste vide (pas d'erreur) |

### calculerMoyenne
Entrée : `idEtudiant` (int), `semestre` (int, **facultatif** : sans lui, toutes les notes sont prises en compte)
Sortie : `Resultat` = `idEtudiant`, `nom`, `prenom`, `semestre` (ou vide), `moyenneGenerale` (decimal), `mention`, `statut`, `detailMatieres` (liste de `idMatiere`, `intitule`, `coefficient`, `moyenne`)

Règles : moyenne d'une matière = moyenne de ses notes ; moyenne générale = Σ(moyenne matière × coefficient) ÷ Σ(coefficients), sur les matières notées, arrondie à 2 décimales.

| Moyenne générale | `mention` | `statut` |
|---|---|---|
| moins de 10 | Aucune | Ajourné |
| 10 à moins de 12 | Passable | Admis |
| 12 à moins de 14 | Assez bien | Admis |
| 14 à moins de 16 | Bien | Admis |
| 16 et plus | Très bien | Admis |

| Cas | Code | Message |
|---|---|---|
| `idEtudiant` invalide, ou `semestre` hors de 1 à 6 | 400 | Paramètre invalide |
| Étudiant inexistant | 404 | Étudiant introuvable |
| Aucune note (pour ce semestre) | 400 | Aucune note disponible pour cet étudiant |

Seuils et paramètre `semestre` : propositions de l'équipe, à confirmer avec l'enseignant.

## 3. EtudiantsService (Yomna – à valider)

| Opération | Entrée | Sortie |
|---|---|---|
| `ajouterEtudiant` | `nom`, `prenom`, `classe`, `email` | `Etudiant` = `id`, `nom`, `prenom`, `classe`, `email` |
| `listerEtudiants` | (aucune) | liste de `Etudiant` |
| `getEtudiant` | `id` | `Etudiant` |
| `modifierEtudiant` | `id`, `nom`, `prenom`, `classe`, `email` | `Etudiant` |
| `supprimerEtudiant` | `id` | `succes` (boolean) |

Erreurs : 400 (champ manquant, email invalide), 404 (étudiant introuvable), 409 (email déjà utilisé, ou suppression refusée car l'étudiant a des notes).

## 4. MatieresService (Yomna – à valider)

| Opération | Entrée | Sortie |
|---|---|---|
| `ajouterMatiere` | `code`, `intitule`, `coefficient`, `credits`, `semestre`, `unite`, `enseignant` (facultatif) | `Matiere` = tous les champs + `id` |
| `listerMatieres` | `semestre` (facultatif) | liste de `Matiere` |
| `getMatiere` | `id` | `Matiere` |

Erreurs : 400 (champ manquant, coefficient inférieur ou égal à 0, semestre hors de 1 à 6), 404 (matière introuvable), 409 (code ou intitulé déjà utilisé).

## 5. Historique des modifications

| Date | Modification | Validée par |
|---|---|---|
| 24/10/2026 | Version initiale | |