from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from ..database import get_db
from ..schema.schema import UserLogin, UserRegister
from ..controller.user_controller import UserController

router = APIRouter(prefix="/user", tags=["User"])

@router.post("/login", status_code=status.HTTP_200_OK)
def login(credentials: UserLogin, db: Session = Depends(get_db)):
    return UserController.login(credentials, db)

@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(user_data: UserRegister, db: Session = Depends(get_db)):
    return UserController.register(user_data, db)