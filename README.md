# Pizzeria Peppe

Ce projet est une application mobile pour le restaurant Pizzeria Peppe. L'application présente la carte du restaurant et permet de faire une réservation pour le clients, une gestion des réservation pour le restaurateur.

## Instruction de lancement Frontend

Cloner le repo, ouvrez le depuis Android Studio et lancer l'emulateur mobile.


## Instructions de lancement Backend

### Installation des packages (à faire une seule fois)

depuis le dossier backend: ```pip install -r requirements.txt```

### Creation de la base de données
> base de donnée avec jeu de données initial

Dans une instance mysql, exécutez le script de création **pizzeriaPeppeDataBase.sql**. Ce fichier se trouve dans **ressources>sql>pizzeriaPeppeDataBase.sql**

### Creation du fichier .env

Dupliquer le fichier **.env.template** et renommez le **.env**

remplacez la valeur de {utilisateur}:{motDePasse} par le nom d'utilisateur et le mot de passe de votre instance mysql
> veillez au préalable d'avoir un utilisateur qui a les droits de lecture et écriture sur la base de données **pizzeriapeppe**

exemple: pour l'utilisateur **clientA** avec le mot de passe **aaa**, la valeur de **DATABASE_URL**
> DATABASE_URL=mysql+pymysql://clientA:aaa@localhost/pizzeriapeppe


### Démarrage

Démarrer l'API
depuis la racine du projet: ```uvicorn backend.main:app --reload```

### Documentation API

l'API doit être démarrée au préalable.

http://localhost:8000/docs

## Connexion de test

compte administrateur:
- email: admin@peppe.fr
- mot de passe: admin

compte client 1:
- email: luigi.a@gmail.com
- mot de passe: luigi

compte client 2:
- email: ph.d@gmail.com
- mot de passe: ph

## Résumé des fonctionalités

- écran d'accueil
- visualisaiton de la carte (formules, plats, desserts, boissons)
- créer un compte client
- se connecter avec un compte administrateur (compte fourni)
- se connecter avec un compte client (compte fourni ou compte créé)
- visualiser toutes les réservations (vue administrateur)
- visualiser les réservations pour le client connecté
- faire une réservation
- accepter ou refuser une réservation (compte administrateur)

Pour un même créneau (date et heure), 5 réservations sont faisable avant que le créneau passe indisponible. Elles doivent être confirmées pour ça