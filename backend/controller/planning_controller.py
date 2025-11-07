from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..schema.schema import (BookingRequest)
from ..service.planning_service import PlanningService
from datetime import date

class PlanningController:
    @staticmethod
    def get_reservations_by_date(reservation_date: date, db: Session = Depends(get_db)):
        slots = PlanningService.get_slots_availability(db, reservation_date)
        return {"date": reservation_date, "slots": slots}

    @staticmethod
    def book_reservation(booking: BookingRequest, db: Session = Depends(get_db)):
        try:
            reservation = PlanningService.create_reservation(db, booking)
            return {
                "message": "Réservation créée avec succès",
                "idResa": reservation.idResa,
                "status": "En attente"
            }
        except ValueError as e:
            raise HTTPException(status_code=400, detail=str(e))