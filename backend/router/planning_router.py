from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from ..database import get_db
from ..schema.schema import BookingRequest
from ..controller.planning_controller import PlanningController
from datetime import date
from ..auth import get_current_user

router = APIRouter(prefix="/planning", tags=["Planning"])

@router.get("/reservations/{date}", status_code=status.HTTP_200_OK)
def get_reservations_by_date(
        date: date,
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
):
    return PlanningController.get_reservations_by_date(date, db)

@router.post("/book", status_code=status.HTTP_201_CREATED)
def book_reservation(
        booking: BookingRequest,
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
):
    return PlanningController.book_reservation(booking, db)