# Interpréteur LATSI

Ce projet est un interpréteur pour le langage de programmation LATSI, développé dans le cadre du cours de Grammaires et Analyses Syntaxique à l'Université Paris Cité. LATSI est un langage simplifié destiné à l'apprentissage des concepts de base de la programmation.

### Structure du Projet

Le projet est organisé en plusieurs répertoires principaux et sous-répertoires, chacun ayant un rôle spécifique :

- **src_default/** : Contient les fichiers pour la version de base de l'interpréteur.
    - `ast.ml` : Définit les structures de données de l'arbre de syntaxe abstraite (AST).
    - `lexer.mll` : Définit les règles de tokenisation du langage LATSI.
    - `parser.mly` : Définit les règles de grammaire du langage LATSI.
    - `main.ml` : Fichier principal qui exécute l'interpréteur et gère l'interaction avec l'utilisateur.

- **src_extensions/** : Contient les fichiers pour les extensions du langage LATSI.
    - `ast_ext.ml`, `lexer_ext.mll`, etc. : Fichiers similaires aux fichiers de base mais avec des fonctionnalités étendues.

- **test_default/** : Dossier contenant les fichiers de test pour l'interpréteur de base.

- **test_extensions1/** : Dossier contenant les fichiers de test pour l'interpréteur avec l'extension 1.

- **test_extensions2/** : Dossier contenant les fichiers de test pour l'interpréteur avec l'extension 2.

### Fonctionnalités de la Version de Base

- **Exécution Linéaire** 
    - L'exécution commence à la ligne avec le plus petit numéro et se poursuit séquentiellement, sauf si une instruction `VAVERS` redirige à une autre ligne.

- **Gestion des Doublons de Ligne**
    - Si plusieurs lignes portent le même numéro, seule la dernière ligne est retenue et utilisée durant l'exécution.

- **Structures de Données et Types Simples** : 
    - Utilisation de variables prédéfinies (26 variables de type entier).
    - Manipulation de nombres et opérations arithmétiques de base.

- **Instructions de Base**
    - **IMPRIME**: Affiche les valeurs des expressions sur la console.
    - **SI ... ALORS**: Exécute conditionnellement une instruction basée sur le résultat d'une comparaison.
    - **ENTREE**: Demande à l'utilisateur de saisir des valeurs pour les variables spécifiées.
    - **Affectation (`=`)**: Attribue la valeur d'une expression à une variable spécifiée.
    - **FIN**: Arrête l'exécution du programme.
    - **REM**: Permet d'insérer des commentaires qui n'affectent pas l'exécution du programme.
    - **NL**: Imprime un retour à la ligne sur la sortie.
    - **VAVERS**: Redirige l'exécution à une autre ligne spécifiée.

- **Gestion des Erreurs**
    - Le programme déclenche une erreur si une instruction tente de sauter à une ligne qui n'existe pas ou si le programme est vide.

### Fonctionnalités des Extensions

| Extention 1  | Extension 1 && 2 | Extension 2 |
|:-|:-:|-:|
| - **Affectation Groupée**. Supporte l'affectation simultanée de plusieurs variables avec des expressions correspondantes. Exemple : `A = 1, B = 2, C = A + B`. | | |
| | |   - **Multiples Affectations sur une même Ligne**. Permet d'effectuer plusieurs affectations en une seule ligne. Exemple : `A, B, C = 1, 2, 3`  |
| | **Instructions de Contrôle de Flux Avancées**. ***SOUSROUTINE 'ligne'*** - Permet de sauter à une ligne déterminée par l'évaluation d'une expression. ***RETOURNE*** - Renvoie l'exécution à la ligne suivant immédiatement la dernière instruction SOUSROUTINE exécutée. | |
| | **Ajout des opérations factorielles et puissance pour les expressions arithmétiques** | |
| | **Boucle TANT QUE**. Permet d'exécuter une séquence d'instructions tant qu'une condition est vraie. Exemple : `TANTQUE A < 10 FAIRE IMPRIME A, A = A + 1 FIN`. | |
| **Une variable, qu'elle soit appelée avec une lettre minuscule ou majuscule, est considérée comme étant la même variable.** | | |
| | | **Opérations arithmetiques avec des nombres flottants.** |
| | | **Possibilité d'avoir autant de variables que l'on souhaite.** |


## Installation

Pour compiler et exécuter ce projet, vous aurez besoin d'OCaml et de Menhir. Assurez-vous d'avoir installé ces outils sur votre système. 


## Compilation
Pour compiler le projet, naviguez à la racine du projet et utilisez la commande suivante :

```
dune build
```

## Utilisation
Pour exécuter un programme en LATSI utilisant la version de base, lancez :

```
_build/default/src_default/latsi_main.exe "chemin_du_fichier_latsi_programme"
```

Pour exécuter avec l'extension 1, lancez :

```
_build/default/src_extensions1/latsi_main_ext.exe "chemin_du_fichier_latsi_programme"
```

Pour exécuter avec l'extension 2, lancez :

```
_build/default/src_extensions2/latsi_main_ext.exe "chemin_du_fichier_latsi_programme"
```


## Contact
Pour toute question, veuillez contacter le responsable du projet à pmarin0202@protonmail.com .
