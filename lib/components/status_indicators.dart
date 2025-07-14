import 'package:flutter/material.dart';
import 'package:pawane_ciu/components/status_light.dart';
import 'package:pawane_ciu/enums/status.dart';

class StatusIndicators extends StatelessWidget {
  final Status status;
  final bool isPowerOn;

  const StatusIndicators({
    super.key,
    required this.status,
    required this.isPowerOn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatusLight(
          label: 'READY',
          color:
              status == Status.idle && isPowerOn
                  ? const Color(0xFF00A8FF)
                  : Colors.transparent,
          isActive: status == Status.idle && isPowerOn,
        ),
        StatusLight(
          label: 'PROCESSING',
          color:
              status == Status.processing
                  ? const Color(0xFFFFB800)
                  : Colors.transparent,
          isActive: status == Status.processing,
        ),
        StatusLight(
          label: 'SUCCESS',
          color:
              status == Status.success
                  ? const Color(0xFF00FF88)
                  : Colors.transparent,
          isActive: status == Status.success,
        ),
        StatusLight(
          label: 'ERROR',
          color:
              status == Status.error
                  ? const Color(0xFFFF3B30)
                  : Colors.transparent,
          isActive: status == Status.error,
        ),
        StatusLight(
          label: 'OFFLINE',
          color: !isPowerOn ? const Color(0xFF8E8E93) : Colors.transparent,
          isActive: !isPowerOn,
        ),
      ],
    );
  }
}
