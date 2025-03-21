import 'package:api_structure/api_structures/app_error.dart';
import 'package:api_structure/api_structures/enums.dart';
import 'package:dartz/dartz.dart';

typedef ApiResponse<T> = Either<AppError, T>;

abstract class ApiService {
  Future<ApiResponse<T>> callApi<T>({
    required ApiCallType type,
    required String endpoint,
    required String screenName,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? filePath,
    T Function(Map<String, dynamic>)? fromJson,
  });
}