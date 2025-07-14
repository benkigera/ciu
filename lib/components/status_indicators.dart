import 'package:flutter/material.dart';
import 'package:pawane_ciu/components/status_light.dart';
import 'package:pawane_ciu/enums/status.dart';
import 'package:pawane_ciu/utils/app_colors.dart';

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
                  ? AppColors.secondaryColor
                  : Colors.transparent,
          isActive: status == Status.idle && isPowerOn,
        ),
        StatusLight(
          label: 'PROCESSING',
          color:
              status == Status.processing
                  ? AppColors.warningColor
                  : Colors.transparent,
          isActive: status == Status.processing,
        ),
        StatusLight(
          label: 'SUCCESS',
          color:
              status == Status.success
                  ? AppColors.successColor
                  : Colors.transparent,
          isActive: status == Status.success,
        ),
        StatusLight(
          label: 'ERROR',
          color:
              status == Status.error
                  ? AppColors.errorColor
                  : Colors.transparent,
          isActive: status == Status.error,
        ),
        StatusLight(
          label: 'OFFLINE',
          color: !isPowerOn ? AppColors.textColorSecondary : Colors.transparent,
          isActive: !isPowerOn,
        ),
      ],
    );
  }
}
