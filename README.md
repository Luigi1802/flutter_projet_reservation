Pizzaaaa


## Backend

### Installation (à faire une seule fois)

Initialiser l'environnement Python
```python -m venv .venv```

Activer l'environnement
Windows: ```.venv\Scripts\Activate.ps1```
Linux: ```source .venv/bin/activate```

Installer FastAPI
```pip install "fastapi[standard]"```


Installer les packages
```pip install fastapi uvicorn sqlalchemy pymysql python-multipart passlib[bcrypt] pydantic[email]```

Requirements.txt
depuis le dossier backend: ```pip install -r requirements.txt```

### Démarrage

Démarrer l'environnement Python
Windows: ```.venv\Scripts\Activate.ps1```
Linux: ```source .venv/bin/activate```

Démarrer l'API
depuis la racine du projet: ```uvicorn backend.main:app --reload  ```