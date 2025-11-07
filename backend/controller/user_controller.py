from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..schema.schema import UserLogin, UserRegister, UserResponse
from ..service.user_service import UserService

class UserController:
    @staticmethod
    def login(credentials: UserLogin, db: Session = Depends(get_db)):
        user = UserService.authenticate_user(db, credentials.email, credentials.password)
        if not user:
            raise HTTPException(status_code=401, detail="Email ou mot de passe incorrect")

        access_token = UserService.create_access_token_for_user(user)

        return {
            "message": "Connexion réussie",
            "access_token": access_token,
            "user": {
                "idUser": user.idUser,
                "pseudo": user.pseudo,
                "email": user.email,
                "idRole": user.role.idRole,
                "role": user.role.descRole
            }
        }

    @staticmethod
    def register(user_data: UserRegister, db: Session = Depends(get_db)):
        try:
            user = UserService.create_user(db, user_data)
            return {
                "message": "Inscription réussie",
                "user": {
                    "idUser": user.idUser,
                    "pseudo": user.pseudo,
                    "email": user.email
                }
            }
        except ValueError as e:
            raise HTTPException(status_code=400, detail=str(e))