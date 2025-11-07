from sqlalchemy.orm import Session
from datetime import date
from ..model.slot import Slot
from ..model.reservation import Reservation
from ..schema.schema import BookingRequest
from passlib.context import CryptContext

class PlanningService:
    @staticmethod
    def get_slots_availability(db: Session, reservation_date: date):
        # Récupérer tous les créneaux
        slots = db.query(Slot).all()

        # Compter les réservations confirmées pour chaque créneau
        result = []
        for slot in slots:
            count = db.query(Reservation).filter(
                Reservation.dateReservation == reservation_date,
                Reservation.idSlot == slot.idSlot,
                Reservation.idStatus.in_([1, 2])  # En attente ou Confirmée
            ).count()

            # Limite arbitraire: 5 réservations max par créneau
            available = count < 5

            result.append({
                "idSlot": slot.idSlot,
                "slotValue": slot.slotValue,
                "available": available,
                "reservationCount": count
            })

        return result

    @staticmethod
    def create_reservation(db: Session, booking: BookingRequest):
        # Vérifier que le créneau existe
        slot = db.query(Slot).filter(Slot.idSlot == booking.idSlot).first()
        if not slot:
            raise ValueError("Créneau invalide")

        # Créer la réservation avec status "En attente" (idStatus=1)
        new_reservation = Reservation(
            dateReservation=booking.dateReservation,
            idSlot=booking.idSlot,
            nbPers=booking.nbPers,
            idStatus=1,  # En attente
            message=booking.message,
            idUser=booking.idUser
        )
        db.add(new_reservation)
        db.commit()
        db.refresh(new_reservation)
        return new_reservation