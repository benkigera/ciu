import 'package:dartz/dartz.dart';
import 'package:pawane_ciu/injection/models/token_injection_model.dart';
import 'package:pawane_ciu/utils/base_service.dart';

class TokenInjectionService extends BaseService {
  static const String basePath = "/api/inject_token";

  Future<Either<String, TokenInjectionResponse>> injectToken({
    required String meterNumber,
    required String creditToken,
  }) async {
    final data = {"meter_number": meterNumber, "credit_token": creditToken};

    final response = await post(basePath, data: data);
    print(response);
    return response.fold((error) => left(error), (result) {
      final tokenInjectionResponse = TokenInjectionResponse.fromJson(
        result['data'],
      );
      if (tokenInjectionResponse.status == 'failed') {
        return left(tokenInjectionResponse.message);
      } else {
        return right(tokenInjectionResponse);
      }
    });
  }
}
