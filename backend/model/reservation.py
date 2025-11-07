from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from ..database import Base

class Reservation(Base):
    __tablename__ = "reservation"
    idResa = Column(Integer, primary_key=True, index=True)
    dateReservation = Column(Date, nullable=False)
    idSlot = Column(Integer, ForeignKey("slot.idSlot"), nullable=False)
    nbPers = Column(Integer, nullable=False)
    idStatus = Column(Integer, ForeignKey("status.idStatus"), nullable=False)
    message = Column(String(255))
    idUser = Column(Integer, ForeignKey("user.idUser"), nullable=False)
    slot = relationship("Slot", back_populates="reservations")
    status = relationship("Status", back_populates="reservations")
    user = relationship("User", back_populates="reservations")