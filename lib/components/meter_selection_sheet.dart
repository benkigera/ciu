import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawane_ciu/models/meter.dart';
import 'package:pawane_ciu/providers/ciu_screen_notifier.dart';

class MeterSelectionSheet extends StatefulWidget {
  final List<Meter> meters;
  final int selectedMeterIndex;
  final Function(int) onMeterSelected;
  final CiuScreenNotifier ciuNotifier;

  const MeterSelectionSheet({
    super.key,
    required this.meters,
    required this.selectedMeterIndex,
    required this.onMeterSelected,
    required this.ciuNotifier,
  });

  @override
  State<MeterSelectionSheet> createState() => _MeterSelectionSheetState();
}

class _MeterSelectionSheetState extends State<MeterSelectionSheet> {
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2329), Color(0xFF0B0E10)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF4A5568),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.electrical_services,
                      color: Color(0xFF00D4FF),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Select Meter',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00D4FF),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00D4FF)),
                  onPressed: () {
                    _showAddMeterDialog(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.meters.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final meter = widget.meters[index];
                final isSelected = index == widget.selectedMeterIndex;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isSelected
                              ? [
                                const Color(0xFF00D4FF).withOpacity(0.2),
                                const Color(0xFF00A8FF).withOpacity(0.1),
                              ]
                              : [
                                const Color(0xFF2A3A47).withOpacity(0.3),
                                const Color(0xFF1E2832).withOpacity(0.5),
                              ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF00D4FF)
                              : const Color(0xFF3A4A57),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      widget.onMeterSelected(index);
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            meter.isActive
                                ? const Color(0xFF00FF88)
                                : const Color(0xFF8E8E93),
                        boxShadow:
                            meter.isActive
                                ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00FF88,
                                    ).withOpacity(0.5),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                                : [],
                      ),
                    ),
                    title: Text(
                      meter.serialNumber,
                      style: GoogleFonts.robotoMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? const Color(0xFF00D4FF) : Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meter.location,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                        Text(
                          'Last update: ${_formatTime(meter.lastUpdate)}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 10,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color:
                              isSelected
                                  ? const Color(0xFF00D4FF)
                                  : const Color(0xFF4A5568),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            widget.ciuNotifier.deleteMeter(meter.serialNumber);
                            Navigator.pop(context); // Close the sheet after deletion
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMeterDialog(BuildContext context) {
    final serialNumberController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A2329),
          title: Text(
            'Add New Meter',
            style: GoogleFonts.orbitron(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: serialNumberController,
                style: GoogleFonts.robotoMono(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  labelStyle: GoogleFonts.robotoMono(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3A4A57)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00D4FF)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                style: GoogleFonts.robotoMono(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: GoogleFonts.robotoMono(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3A4A57)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00D4FF)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.robotoMono(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                if (serialNumberController.text.isNotEmpty &&
                    locationController.text.isNotEmpty) {
                  final newMeter = Meter(
                    serialNumber: serialNumberController.text,
                    location: locationController.text,
                    isActive: true, // New meters are active by default
                    lastUpdate: DateTime.now(),
                  );
                  widget.ciuNotifier.addMeter(newMeter);
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.robotoMono(color: const Color(0xFF00D4FF)),
              ),
            ),
          ],
        );
      },
    );
  }
}