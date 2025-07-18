import 'package:flutter/material.dart';
import 'package:meter_link/components/status_light.dart';
import 'package:meter_link/enums/status.dart';
import 'package:meter_link/utils/app_colors.dart';

class StatusIndicators extends StatelessWidget {
  final Status status;
  final bool isPowerOn;
  final bool isMqttConnected;
  final List<String> subscribedTopics;
  final String? currentMeterSerialNumber;

  const StatusIndicators({
    super.key,
    required this.status,
    required this.isPowerOn,
    required this.isMqttConnected,
    required this.subscribedTopics,
    this.currentMeterSerialNumber,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFullyConnected =
        isMqttConnected &&
        subscribedTopics.isNotEmpty &&
        currentMeterSerialNumber != null &&
        subscribedTopics.any(
          (topic) => topic.contains(currentMeterSerialNumber!),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatusLight(
          label: isFullyConnected ? 'CONNECTED' : 'READY',
          color:
              isFullyConnected
                  ? AppColors.successColor
                  : (status == Status.idle && isPowerOn
                      ? AppColors.secondaryColor
                      : Colors.transparent),
          isActive: isFullyConnected || (status == Status.idle && isPowerOn),
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
