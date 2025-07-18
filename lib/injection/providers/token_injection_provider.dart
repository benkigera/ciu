import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meter_link/enums/status.dart';
import 'package:meter_link/injection/models/token_injection_model.dart';
import 'package:meter_link/injection/services/token_injection_service.dart';
import 'package:meter_link/providers/ciu_screen_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_injection_provider.freezed.dart';
part 'token_injection_provider.g.dart';

@freezed
class TokenInjectionState with _$TokenInjectionState {
  const factory TokenInjectionState({
    @Default(Status.idle) Status status,
    String? errorMessage,
    TokenInjectionResponse? response,
  }) = _TokenInjectionState;
}

@Riverpod(keepAlive: true)
class TokenInjectionNotifier extends _$TokenInjectionNotifier {
  @override
  TokenInjectionState build() {
    return const TokenInjectionState();
  }

  Future<void> injectToken({
    required String meterNumber,
    required String creditToken,
  }) async {
    state = state.copyWith(
      status: Status.processing,
      errorMessage: null,
      response: null,
    );
    ref.read(ciuScreenNotifierProvider.notifier).setStatus(Status.processing);

    final result = await TokenInjectionService().injectToken(
      meterNumber: meterNumber,
      creditToken: creditToken,
    );
    result.fold(
      (error) {
        state = state.copyWith(status: Status.error, errorMessage: error);
        ref.read(ciuScreenNotifierProvider.notifier).setStatus(Status.error);
        ref
            .read(ciuScreenNotifierProvider.notifier)
            .setToken('TOKEN INVALID'); // Display "TOKEN INVALID"
        Future.delayed(const Duration(seconds: 2), () {
          ref.read(ciuScreenNotifierProvider.notifier).setStatus(Status.idle);
          ref
              .read(ciuScreenNotifierProvider.notifier)
              .setToken(''); // Clear token
        });
      },
      (response) {
        state = state.copyWith(status: Status.success);
        ref.read(ciuScreenNotifierProvider.notifier).setStatus(Status.success);
        ref
            .read(ciuScreenNotifierProvider.notifier)
            .setToken('Successful injection'); // Display "Successful injection"
        Future.delayed(const Duration(seconds: 3), () {
          ref.read(ciuScreenNotifierProvider.notifier).setStatus(Status.idle);
          ref
              .read(ciuScreenNotifierProvider.notifier)
              .setToken(''); // Clear token
        });
      },
    );
  }
}
