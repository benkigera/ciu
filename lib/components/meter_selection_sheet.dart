import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meter_link/models/meter.dart';
import 'package:meter_link/providers/ciu_screen_notifier.dart';
import 'package:meter_link/utils/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeterSelectionSheet extends ConsumerStatefulWidget {
  final int selectedMeterIndex;
  final Function(int) onMeterSelected;

  const MeterSelectionSheet({
    super.key,
    required this.selectedMeterIndex,
    required this.onMeterSelected,
  });

  @override
  ConsumerState<MeterSelectionSheet> createState() =>
      _MeterSelectionSheetState();
}

class _MeterSelectionSheetState extends ConsumerState<MeterSelectionSheet> {
  String _formatTime(DateTime? time) {
    if (time == null) {
      return 'No update';
    }
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
    final ciuState = ref.watch(ciuScreenNotifierProvider);
    final ciuNotifier = ref.read(ciuScreenNotifierProvider.notifier);
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surfaceColor2, AppColors.backgroundColor],
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
              color: AppColors.textColorDisabled,
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
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Select Meter',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    _showAddMeterDialog(context, ciuNotifier);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ciuState.meters.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final meter = ciuState.meters[index];
                final isSelected = index == widget.selectedMeterIndex;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isSelected
                              ? [
                                AppColors.primaryColor.withOpacity(0.2),
                                AppColors.secondaryColor.withOpacity(0.1),
                              ]
                              : [
                                AppColors.surfaceColor3.withOpacity(0.3),
                                AppColors.surfaceColor4.withOpacity(0.5),
                              ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : AppColors.borderColor2,
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
                                ? AppColors.successColor
                                : AppColors.textColorSecondary,
                        boxShadow:
                            meter.isActive
                                ? [
                                  BoxShadow(
                                    color: AppColors.successColor.withOpacity(
                                      0.5,
                                    ),
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
                            isSelected
                                ? AppColors.primaryColor
                                : AppColors.textColorPrimary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meter.location,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        Text(
                          'Last update: ${_formatTime(meter.lastUpdate)}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 10,
                            color: AppColors.textColorTertiary,
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
                                  ? AppColors.primaryColor
                                  : AppColors.textColorDisabled,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.deleteIconColor,
                          ),
                          onPressed: () {
                            ciuNotifier.deleteMeter(meter.serialNumber);
                            Navigator.pop(
                              context,
                            ); // Close the sheet after deletion
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

  void _showAddMeterDialog(
    BuildContext context,
    CiuScreenNotifier ciuNotifier,
  ) {
    final serialNumberController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceColor2,
          title: Text(
            'Add New Meter',
            style: GoogleFonts.orbitron(color: AppColors.textColorPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: serialNumberController,
                style: GoogleFonts.robotoMono(
                  color: AppColors.textColorPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  labelStyle: GoogleFonts.robotoMono(
                    color: AppColors.textColorWhite70,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                style: GoogleFonts.robotoMono(
                  color: AppColors.textColorPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: GoogleFonts.robotoMono(
                    color: AppColors.textColorWhite70,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
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
                style: GoogleFonts.robotoMono(
                  color: AppColors.textColorWhite70,
                ),
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
                    lastUpdate: null,
                    availableCredit: 0.0, // Default to 0.0
                  );
                  ciuNotifier.addMeter(newMeter);
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.robotoMono(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
