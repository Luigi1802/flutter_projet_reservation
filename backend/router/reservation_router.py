from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from ..database import get_db
from ..schema.schema import ConfirmReservationRequest
from ..controller.reservation_controller import ReservationController

router = APIRouter(prefix="/reservation", tags=["Reservation"])

@router.get("/getAll/{userId}", status_code=status.HTTP_200_OK)
def get_user_reservations(userId: int, db: Session = Depends(get_db)):
    return ReservationController.get_user_reservations(userId, db)

@router.get("/getAll", status_code=status.HTTP_200_OK)
def get_all_reservations(db: Session = Depends(get_db)):
    return ReservationController.get_all_reservations(db)

@router.post("/manage", status_code=status.HTTP_200_OK)
def confirm_reservation(request: ConfirmReservationRequest, db: Session = Depends(get_db)):
    return ReservationController.confirm_reservation(request, db)