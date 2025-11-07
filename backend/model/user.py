from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from ..database import Base

class User(Base):
    __tablename__ = "user"
    idUser = Column(Integer, primary_key=True, index=True)
    pseudo = Column(String(255), nullable=False)
    email = Column(String(255), nullable=False, unique=True)
    passwordUser = Column(String(2056), nullable=False)
    idRole = Column(Integer, ForeignKey("role.idRole"), nullable=False)
    role = relationship("Role", back_populates="users")
    reservations = relationship("Reservation", back_populates="user")