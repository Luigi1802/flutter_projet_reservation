Pizzaaaa


## Backend

### Installation des packages (à faire une seule fois)

depuis le dossier backend: ```pip install -r requirements.txt```

### Creation de la base de données
> base de donnée avec jeu de données initial

Dans une instance mysql, exécutez le script de création **pizzeriaPeppeDataBase.sql**. Ce fichier se trouve dans **ressources>sql>pizzeriaPeppeDataBase.sql**

### Démarrage

Démarrer l'API
depuis la racine du projet: ```uvicorn backend.main:app --reload```