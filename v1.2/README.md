Tutoriel Beeware sur windows

Création appli:

- Créer un dossier
- Créer un environement virtuel: py -m venv beeware-venv
- Activer l'environement: beeware-venv\Scripts\activate
- Installation de Beeware (attention un pip normal ne fonctionnera pas pour des raisons que je n'expliquerais pas ici): python -m pip install briefcase
- Création de notre appli: briefcase new
- On se place dedans: cd [emplacement de ton fichier]


Modification:

- tout se passe dans app.py, regarder les fonctions que vous souhaitez sur la doc de beeware et celle de toga
- si besoin d'importer module, penser à modifier les requirements du pyproject.toml
- mettre ses images, icones, polices dans dossier ressources


Build de l'appli:

- briefcase build
- briefcase run
- mettre à jour: briefcase update (briefcase update -r si on modifie pyproject.toml)

***Version dev, simple, rapide mais ce n'est qu'une preview, certaines api ne fonctionnent pas ici***
- briefcase dev

***Version windows***
- créer app windows: briefcase package

***Version android***
- créer app android: briefcase create android
- briefcase build android
- briefcase run android (briefcase va créer un émulateur, c tout simple)

***Version ios***
-flemme, regarder la doc

Voilà, voilà
