import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// --- Modèles ---
class Slot {
  final int idSlot;
  final String slotValue;
  final bool available;
  final int reservationCount;

  Slot({
    required this.idSlot,
    required this.slotValue,
    required this.available,
    required this.reservationCount,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      idSlot: json['idSlot'],
      slotValue: json['slotValue'],
      available: json['available'],
      reservationCount: json['reservationCount'],
    );
  }
}

class Reservation {
  final int idResa;
  final String dateReservation; // "dd/MM/yyyy"
  final String slotValue;
  final int nbPers;
  String status; // "En attente", "Confirmée", "Annulée"
  final String message;
  final String pseudo;

  Reservation({
    required this.idResa,
    required this.dateReservation,
    required this.slotValue,
    required this.nbPers,
    required this.status,
    required this.message,
    required this.pseudo,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    final dateParts = (json['dateReservation'] as String).split('-');
    final formattedDate =
        "${dateParts[2]}/${dateParts[1]}/${dateParts[0]}";

    return Reservation(
      idResa: json['idResa'],
      dateReservation: formattedDate,
      slotValue: json['slotValue'],
      nbPers: json['nbPers'],
      status: json['status'] ?? 'En attente',
      message: json['message'] ?? '',
      pseudo: json['pseudo'] ?? '',
    );
  }
}

// --- Page principale ---
class ReservationsPage extends StatefulWidget {
  final String role; // "client" ou "hote"
  final String clientName;
  final int clientId;

  const ReservationsPage({
    super.key,
    required this.role,
    required this.clientName,
    required this.clientId,
  });

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Reservation> _allReservations = [];
  List<Slot> _slots = [];

  // Création d'une réservation
  DateTime? _selectedDate;
  Slot? _selectedSlot;
  int _guests = 2;
  final TextEditingController _noteController = TextEditingController();
  bool _isLoadingSlots = false;
  bool _isSubmitting = false;
  bool _isLoadingReservations = true;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  // --- Fonction pour obtenir l'icône du statut ---
  Icon _buildStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmée':
        return const Icon(Icons.check_circle, color: Colors.green, size: 18);
      case 'refusé':
        return const Icon(Icons.cancel, color: Colors.red, size: 18);
      case 'annulée':
        return const Icon(Icons.cancel, color: Colors.red, size: 18);
      case 'en attente':
      default:
        return const Icon(Icons.access_time, color: Colors.orange, size: 18);
    }
  }

  // --- Fonction pour la couleur du texte du statut ---
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmée':
        return Colors.green;
      case 'refusé':
        return Colors.red;
      case 'annulée':
        return Colors.red;
      case 'en attente':
      default:
        return Colors.orange;
    }
  }

  // --- Récupérer les réservations ---
  Future<void> _fetchReservations() async {
    setState(() => _isLoadingReservations = true);

    try {
      String baseUrl = "http://localhost:8000";

      final url = widget.role == "hote"
          ? Uri.parse("$baseUrl/reservation/getAll")
          : Uri.parse("$baseUrl/reservation/getAll/${widget.clientId}");

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List reservationsJson = data['reservations'] ?? [];
        setState(() {
          _allReservations =
              reservationsJson.map((json) => Reservation.fromJson(json)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Erreur ${response.statusCode} lors de la récupération des réservations.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Erreur lors de la récupération des réservations: $e\n")),
      );
    } finally {
      setState(() => _isLoadingReservations = false);
    }
  }

  // --- Récupérer les créneaux ---
  Future<void> _fetchSlots(String dateKey) async {
    setState(() => _isLoadingSlots = true);
    try {
      final url = Uri.parse("http://localhost:8000/planning/reservations/$dateKey");
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List slotsJson = data['slots'] ?? [];
        setState(() {
          _slots = slotsJson.map((json) => Slot.fromJson(json)).toList();
          _selectedSlot = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur ${response.statusCode} lors de la récupération des créneaux.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la récupération des créneaux: $e")),
      );
    } finally {
      setState(() => _isLoadingSlots = false);
    }
  }

  // --- Mettre à jour le statut d'une réservation ---
  Future<void> _updateStatus(Reservation resa, bool confirm) async {
    setState(() => _isSubmitting = true);

    try {
      final url = Uri.parse("http://localhost:8000/reservation/manage");
      final body = json.encode({
        "idResa": resa.idResa,
        "confirm": confirm,
      });

      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        await _fetchReservations();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur ${response.statusCode} lors de la mise à jour.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour: $e")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // --- Créer une réservation ---
  Future<void> _confirmReservation() async {
    if (_selectedDate == null || _selectedSlot == null) return;

    setState(() => _isSubmitting = true);

    try {
      final url = Uri.parse("http://localhost:8000/planning/book");
      final body = json.encode({
        "dateReservation": "${_selectedDate!.year.toString().padLeft(4,'0')}-"
            "${_selectedDate!.month.toString().padLeft(2,'0')}-"
            "${_selectedDate!.day.toString().padLeft(2,'0')}",
        "idSlot": _selectedSlot!.idSlot,
        "nbPers": _guests,
        "message": _noteController.text,
        "idUser": widget.clientId,
      });

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 201) {
        await _fetchReservations();

        setState(() {
          _selectedDate = null;
          _selectedSlot = null;
          _guests = 2;
          _noteController.clear();
          _slots = [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Réservation créée avec succès !")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur ${response.statusCode} lors de la création de la réservation.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la création de la réservation: $e")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // --- Sélection de la date ---
  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      final key = "${picked.year.toString().padLeft(4,'0')}-"
          "${picked.month.toString().padLeft(2,'0')}-"
          "${picked.day.toString().padLeft(2,'0')}";
      await _fetchSlots(key);
    }
  }

  String _formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";

  List<Reservation> get _reservationsFiltered => _allReservations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes réservations"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _isLoadingReservations
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: _reservationsFiltered.isEmpty
                  ? const Center(child: Text("Aucune réservation."))
                  : ListView.builder(
                itemCount: _reservationsFiltered.length,
                itemBuilder: (context, index) {
                  final resa = _reservationsFiltered[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                          "${resa.dateReservation} - ${resa.slotValue} (${resa.nbPers} pers)"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.role == "hote")
                            Text("Client : ${resa.pseudo}"),
                          if (resa.message.isNotEmpty)
                            Text("Note : ${resa.message}"),
                            SizedBox(height: 6),
                          Row(
                            children: [
                              _buildStatusIcon(resa.status),
                              const SizedBox(width: 6),
                              Text(
                                resa.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _statusColor(resa.status),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: widget.role == "hote" &&
                          resa.status.toLowerCase() == "en attente"
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check,
                                color: Colors.green),
                            onPressed: _isSubmitting
                                ? null
                                : () =>
                                _updateStatus(resa, true),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red),
                            onPressed: _isSubmitting
                                ? null
                                : () =>
                                _updateStatus(resa, false),
                          ),
                        ],
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (widget.role == "client")
              ExpansionTile(
                title: const Text(
                  "Nouvelle réservation",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: true,
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent
                    ),
                    label: Text(
                      _selectedDate == null
                          ? "Sélectionner une date"
                          : _formatDate(_selectedDate!),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _pickDate(context),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedDate != null)
                    _isLoadingSlots
                        ? const Center(child: SizedBox(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                        )
                        : _slots.isEmpty
                        ? const Text("Aucun créneau disponible pour cette date.")
                        : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _slots.map((slot) {
                        final isSelected = _selectedSlot?.idSlot == slot.idSlot;
                        return ChoiceChip(
                          label: Text(slot.slotValue),
                          selected: isSelected,
                          onSelected: slot.available
                              ? (_) {
                            setState(() {
                              _selectedSlot = slot;
                            });
                          }
                              : null,
                          backgroundColor: slot.available
                              ? Colors.grey[200]
                              : Colors.grey[400],
                          selectedColor: Colors.redAccent,
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Nombre de couverts",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<int>(
                    value: _guests,
                    items: List.generate(
                      10,
                          (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text("${i + 1}"),
                      ),
                    ),
                    onChanged: (val) => setState(() => _guests = val ?? 2),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: "Note (facultatif)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_selectedDate != null &&
                          _selectedSlot != null &&
                          !_isSubmitting)
                          ? _confirmReservation
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                            height: 10.0,
                            width: 10.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                        "Confirmer la réservation",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
