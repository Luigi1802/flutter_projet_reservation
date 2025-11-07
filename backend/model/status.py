from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from ..database import Base

class Status(Base):
    __tablename__ = "status"
    idStatus = Column(Integer, primary_key=True, index=True)
    descStatus = Column(String(255), nullable=False)
    reservations = relationship("Reservation", back_populates="status")