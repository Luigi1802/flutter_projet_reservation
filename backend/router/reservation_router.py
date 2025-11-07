from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from ..database import get_db
from ..schema.schema import ConfirmReservationRequest
from ..controller.reservation_controller import ReservationController
from ..auth import get_current_user, require_admin

router = APIRouter(prefix="/reservation", tags=["Reservation"])

@router.get("/getAll/{userId}", status_code=status.HTTP_200_OK)
def get_user_reservations(
        userId: int,
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
):
    # Un utilisateur ne peut voir que ses propres réservations, sauf admin
    if current_user["role_id"] != 1 and current_user["user_id"] != userId:
        from fastapi import HTTPException
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Vous ne pouvez consulter que vos propres réservations"
        )
    return ReservationController.get_user_reservations(userId, db)

@router.get("/getAll", status_code=status.HTTP_200_OK)
def get_all_reservations(
        db: Session = Depends(get_db),
        current_user: dict = Depends(require_admin) # seulement admin
):
    return ReservationController.get_all_reservations(db)

@router.post("/manage", status_code=status.HTTP_200_OK)
def confirm_reservation(
        request: ConfirmReservationRequest,
        db: Session = Depends(get_db),
        current_user: dict = Depends(require_admin) # seulement admin
):
    return ReservationController.confirm_reservation(request, db)