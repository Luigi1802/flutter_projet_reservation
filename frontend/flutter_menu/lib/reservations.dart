import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// --- Modèles ---
class Slot {
  final int id;
  final String plageHoraire;
  final String statut;

  Slot({required this.id, required this.plageHoraire, required this.statut});
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
    // Convertir date "yyyy-MM-dd" -> "dd/MM/yyyy"
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

  // Création d'une réservation
  DateTime? _selectedDate;
  Slot? _selectedSlot;
  int _guests = 2;
  final TextEditingController _noteController = TextEditingController();
  bool _isLoadingSlots = false;
  bool _isSubmitting = false;
  bool _isLoadingReservations = true;
  List<Slot> _slots = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    setState(() => _isLoadingReservations = true);

    try {
      String baseUrl = "http://localhost:8000";

      final url = widget.role == "hote"
          ? Uri.parse("$baseUrl/reservation/getAll")
          : Uri.parse("$baseUrl/reservation/getAll/${widget.clientId}");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ...'
        },
      );
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
      // Ceci capture le "Failed to fetch" côté web ou les erreurs de réseau côté mobile
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Erreur lors de la récupération des réservations: $e\n")),
      );
    } finally {
      setState(() => _isLoadingReservations = false);
    }
  }


  // Simule la réponse de l'API pour les créneaux
  Future<List<Slot>> _fetchSlots(String dateKey) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = {
      '2025-11-07': [
        Slot(id: 1, plageHoraire: '12:00 - 12:30', statut: 'disponible'),
        Slot(id: 2, plageHoraire: '12:30 - 13:00', statut: 'occupé'),
        Slot(id: 3, plageHoraire: '13:00 - 13:30', statut: 'disponible'),
        Slot(id: 4, plageHoraire: '18:00 - 18:30', statut: 'disponible'),
      ],
      '2025-11-08': [
        Slot(id: 5, plageHoraire: '11:30 - 12:00', statut: 'occupé'),
        Slot(id: 6, plageHoraire: '12:00 - 12:30', statut: 'disponible'),
        Slot(id: 7, plageHoraire: '14:00 - 14:30', statut: 'disponible'),
      ],
    };
    return data[dateKey] ?? [];
  }

  List<Reservation> get _reservationsFiltered {
    if (widget.role == "client") {
      return _allReservations
          .where((r) => r.pseudo == widget.clientName)
          .toList();
    } else {
      return _allReservations;
    }
  }

  Future<void> _updateStatus(Reservation resa, String newStatus) async {
    setState(() => _isSubmitting = true);
    try {
      // Appel API possible pour mettre à jour le statut ici
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        resa.status = newStatus;
      });
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedSlot = null;
        _isLoadingSlots = true;
      });

      final key =
          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      final slots = await _fetchSlots(key);

      setState(() {
        _slots = slots;
        _isLoadingSlots = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return "$day/$month/$year";
  }

  Future<void> _confirmReservation() async {
    if (_selectedDate == null || _selectedSlot == null) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

    final newResa = Reservation(
      idResa: _allReservations.length + 1,
      dateReservation: _formatDate(_selectedDate!),
      slotValue: _selectedSlot!.plageHoraire,
      nbPers: _guests,
      status: "En attente",
      message: _noteController.text,
      pseudo: widget.clientName,
    );

    setState(() {
      _allReservations.add(newResa);
      _selectedDate = null;
      _selectedSlot = null;
      _guests = 2;
      _noteController.clear();
      _slots = [];
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Réservation créée avec succès !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes réservations"),
        backgroundColor: Colors.redAccent,
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
                          Text("Statut : ${resa.status}"),
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
                                _updateStatus(resa, "Confirmée"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red),
                            onPressed: _isSubmitting
                                ? null
                                : () =>
                                _updateStatus(resa, "Annulée"),
                          ),
                        ],
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),

            if (widget.role == "client") ExpansionTile(
              title: const Text(
                "Nouvelle réservation",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: true,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate == null
                        ? "Sélectionner une date"
                        : _formatDate(_selectedDate!),
                  ),
                  onPressed: () => _pickDate(context),
                ),
                const SizedBox(height: 10),
                if (_selectedDate != null) ...[
                  _isLoadingSlots
                      ? const Center(child: CircularProgressIndicator())
                      : _slots.isEmpty
                      ? const Text("Aucun créneau disponible pour cette date.")
                      : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _slots.map((slot) {
                      final isSelected = _selectedSlot?.id == slot.id;
                      final isAvailable = slot.statut.toLowerCase() == 'disponible';
                      return ChoiceChip(
                        label: Text(slot.plageHoraire),
                        selected: isSelected,
                        onSelected: isAvailable
                            ? (_) {
                          setState(() {
                            _selectedSlot = slot;
                          });
                        }
                            : null,
                        backgroundColor: isAvailable
                            ? Colors.grey[200]
                            : Colors.grey[400],
                        selectedColor: Colors.redAccent,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Nombre de convives",
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
                    onChanged: (val) {
                      setState(() => _guests = val ?? 2);
                    },
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
                  const SizedBox(height: 10),
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Confirmer la réservation",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
