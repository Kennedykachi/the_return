import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

/// Web uses localhost; Android emulators reach the host at 10.0.2.2.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: kIsWeb ? 'http://localhost:8000/api/' : 'http://10.0.2.2:8000/api/',
);

final apiClient = Dio(BaseOptions(
  baseUrl: apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 15),
));

Future<Response<List<dynamic>>> fetchExperiences({String? category}) {
  return apiClient.get<List<dynamic>>(
    'experiences/',
    queryParameters: category == null ? null : {'category': category},
  );
}
