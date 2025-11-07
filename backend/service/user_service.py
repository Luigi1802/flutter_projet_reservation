from sqlalchemy.orm import Session
from ..model.user import User
from ..model.role import Role
from ..schema.schema import UserRegister
from passlib.context import CryptContext
from ..auth import create_access_token

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class UserService:
    @staticmethod
    def authenticate_user(db: Session, email: str, password: str):
        user = db.query(User).filter(User.email == email).first()
        if not user:
            return None
        if user.passwordUser != password:  # Temporaire - à remplacer par hash
            return None
        return user

    @staticmethod
    def create_access_token_for_user(user: User):
        """Créer un token JWT pour un utilisateur"""
        token_data = {
            "sub": str(user.idUser),
            "role_id": user.idRole,
            "email": user.email
        }
        access_token = create_access_token(data=token_data)
        return access_token

    @staticmethod
    def create_user(db: Session, user_data: UserRegister):
        # Vérifier si l'email existe déjà
        existing_user = db.query(User).filter(User.email == user_data.email).first()
        if existing_user:
            raise ValueError("Email déjà utilisé")

        # Créer le nouvel utilisateur avec le rôle Client (idRole=2)
        new_user = User(
            pseudo=user_data.pseudo,
            email=user_data.email,
            passwordUser=user_data.password,  # À remplacer par hashed_password
            idRole=2  # Client par défaut
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        return new_user

    @staticmethod
    def get_user_with_role(db: Session, user_id: int):
        return db.query(User).filter(User.idUser == user_id).first()