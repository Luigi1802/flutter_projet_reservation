from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from ..database import Base

class Role(Base):
    __tablename__ = "role"
    idRole = Column(Integer, primary_key=True, index=True)
    descRole = Column(String(255), nullable=False)
    users = relationship("User", back_populates="role")