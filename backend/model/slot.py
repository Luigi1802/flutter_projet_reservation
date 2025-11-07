from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from ..database import Base

class Slot(Base):
    __tablename__ = "slot"
    idSlot = Column(Integer, primary_key=True, index=True)
    slotValue = Column(String(5), nullable=False)
    reservations = relationship("Reservation", back_populates="slot")