from pydantic import BaseModel, EmailStr
from datetime import date
from typing import Optional

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserRegister(BaseModel):
    pseudo: str
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    idUser: int
    pseudo: str
    email: str
    idRole: int
    role: str

    class Config:
        from_attributes = True

class SlotAvailability(BaseModel):
    idSlot: int
    slotValue: str
    available: bool
    reservationCount: int

class BookingRequest(BaseModel):
    dateReservation: date
    idSlot: int
    nbPers: int
    message: Optional[str] = None
    idUser: int

class ReservationResponse(BaseModel):
    idResa: int
    dateReservation: date
    slotValue: str
    nbPers: int
    status: str
    message: Optional[str]
    pseudo: str

    class Config:
        from_attributes = True

class ConfirmReservationRequest(BaseModel):
    idResa: int
    confirm: bool