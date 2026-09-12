import 'package:dio/dio.dart';

/// Android emulators reach the host at 10.0.2.2. Override this for devices.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000/api/',
);

final apiClient = Dio(BaseOptions(
  baseUrl: apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 15),
));
