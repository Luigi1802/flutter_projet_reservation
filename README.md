Pizzaaaa


## Backend

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

http://localhost:8000/docs