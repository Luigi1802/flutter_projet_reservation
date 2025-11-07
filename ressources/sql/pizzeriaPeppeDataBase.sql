-- Création de la DB et jeu de données initial

-- Création du schéma
CREATE DATABASE  IF NOT EXISTS `pizzeriapeppe` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

-- Sélection du schéma
USE pizzeriapeppe;

-- Table ROLE
CREATE TABLE role (
    idRole INT AUTO_INCREMENT PRIMARY KEY,
    descRole VARCHAR(255) NOT NULL
);

-- Table STATUS
CREATE TABLE status (
    idStatus INT AUTO_INCREMENT PRIMARY KEY,
    descStatus VARCHAR(255) NOT NULL
);

-- Table SLOT
CREATE TABLE slot (
    idSlot INT AUTO_INCREMENT PRIMARY KEY,
    slotValue CHAR(5) NOT NULL
);

-- Table USER
CREATE TABLE user (
    idUser INT AUTO_INCREMENT PRIMARY KEY,
    pseudo VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    passwordUser VARCHAR(2056) NOT NULL,
    idRole INT NOT NULL,
    FOREIGN KEY (idRole) REFERENCES role(idRole)
);

-- Table RESERVATION
CREATE TABLE reservation (
    idResa INT AUTO_INCREMENT PRIMARY KEY,
    dateReservation DATE NOT NULL,
    idSlot INT NOT NULL,
    nbPers INT NOT NULL,
    idStatus INT NOT NULL,
    message VARCHAR(255),
    idUser INT NOT NULL,
    FOREIGN KEY (idSlot) REFERENCES slot(idSlot),
    FOREIGN KEY (idStatus) REFERENCES status(idStatus),
    FOREIGN KEY (idUser) REFERENCES user(idUser)
);

-- Datas

-- Table Role
INSERT INTO role (descRole) VALUES
('Administrateur'),
('Client');

-- Table Status
INSERT INTO status (descStatus) VALUES
('En attente'),
('Confirmée'),
('Annulée'),
('Refusé');

-- Table Slot
INSERT INTO slot (slotValue) VALUES
('18:30'),
('18:45'),
('19:00'),
('19:15'),
('19:30'),
('19:45'),
('20:00'),
('20:15'),
('20:30');

-- Table User
INSERT INTO user (pseudo, email, passwordUser, idRole) VALUES
('admin', 'aaa@aaa.fr', 'aaa', 1),
('client2', 'ccc@ccc.fr', 'ccc', 2),
('client3', 'ddd@ddd.fr', 'ddd', 2);

-- Table Reservation
INSERT INTO reservation (dateReservation, idSlot, nbPers, idStatus, message, idUser) VALUES
('2025-11-07', 1, 2, 1, 'Table près de la fenêtre si possible.', 2),
('2025-11-07', 3, 4, 2, 'Anniversaire', 3),
('2025-11-08', 2, 3, 1, NULL, 4),
('2025-11-08', 5, 5, 2, 'Besoin d’une grande table.', 3),
('2025-11-09', 4, 2, 3, 'Annulée par le client.', 4);