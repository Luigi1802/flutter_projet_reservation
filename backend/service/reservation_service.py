from sqlalchemy.orm import Session
from ..model.reservation import Reservation
from ..model.user import  User
from ..model.slot import  Slot
from ..model.status import  Status

class ReservationService:
    @staticmethod
    def get_user_reservations(db: Session, user_id: int):
        reservations = db.query(Reservation).filter(
            Reservation.idUser == user_id
        ).all()

        result = []
        for resa in reservations:
            result.append({
                "idResa": resa.idResa,
                "dateReservation": resa.dateReservation,
                "slotValue": resa.slot.slotValue,
                "nbPers": resa.nbPers,
                "status": resa.status.descStatus,
                "message": resa.message,
                "pseudo": resa.user.pseudo
            })
        return result

    @staticmethod
    def get_all_reservations(db: Session):
        reservations = db.query(Reservation).all()

        result = []
        for resa in reservations:
            result.append({
                "idResa": resa.idResa,
                "dateReservation": resa.dateReservation,
                "slotValue": resa.slot.slotValue,
                "nbPers": resa.nbPers,
                "status": resa.status.descStatus,
                "message": resa.message,
                "pseudo": resa.user.pseudo
            })
        return result

    @staticmethod
    def confirm_reservation(db: Session, id_resa: int, confirm: bool):
        reservation = db.query(Reservation).filter(
            Reservation.idResa == id_resa
        ).first()
        if not reservation:
            raise ValueError("Réservation introuvable")

        # Si confirm=True -> Confirmée (2), sinon -> Refusé (4)
        reservation.idStatus = 2 if confirm else 4
        db.commit()
        db.refresh(reservation)
        return reservation