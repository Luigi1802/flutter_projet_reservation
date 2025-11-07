from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..schema.schema import ConfirmReservationRequest
from ..service.reservation_service import ReservationService

class ReservationController:
    # obtenir les reservations associées à un utilisateur
    @staticmethod
    def get_user_reservations(user_id: int, db: Session = Depends(get_db)):
        reservations = ReservationService.get_user_reservations(db, user_id)
        return {"reservations": reservations}

    # obtenir toutes les réservations (administrateur only)
    @staticmethod
    def get_all_reservations(db: Session = Depends(get_db)):
        reservations = ReservationService.get_all_reservations(db)
        return {"reservations": reservations}

    # accepter ou refuser une réservation
    @staticmethod
    def confirm_reservation(request: ConfirmReservationRequest, db: Session = Depends(get_db)):
        try:
            reservation = ReservationService.confirm_reservation(db, request.idResa, request.confirm)
            status_text = "Confirmée" if request.confirm else "Refusée"
            return {
                "message": f"Réservation {status_text.lower()}",
                "idResa": reservation.idResa,
                "status": status_text
            }
        except ValueError as e:
            raise HTTPException(status_code=404, detail=str(e))