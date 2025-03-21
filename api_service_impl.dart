import 'package:api_structure/api_structures/api_service.dart';
import 'package:api_structure/api_structures/app_error.dart';
import 'package:api_structure/api_structures/enums.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'dart:convert'; // For jsonDecode

class ApiServiceImpl implements ApiService {
  final Dio _dio = Dio();
  final http.Client _httpClient = http.Client();
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/'; // Base URL

  @override
  Future<ApiResponse<T>> callApi<T>({
    required ApiCallType type,
    required String endpoint,
    required String screenName, // screenName is a required parameter
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? filePath,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    print('Fetching data for screen: $screenName'); // Print the screenName

    try {
      final url = '$_baseUrl$endpoint'; // Construct full URL
      dynamic response;

      // Convert headers to Map<String, String> for HTTP package
      Map<String, String>? httpHeaders;
      if (headers != null) {
        httpHeaders = headers.map((key, value) => MapEntry(key, value.toString()));
      }

      // Use HTTP for GET and POST
      if (type == ApiCallType.get || type == ApiCallType.post) {
        if (type == ApiCallType.get) {
          response = await _httpClient.get(Uri.parse(url), headers: httpHeaders);
        } else if (type == ApiCallType.post) {
          response = await _httpClient.post(
            Uri.parse(url),
            headers: httpHeaders,
            body: data,
          );
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (fromJson != null) {
            // Parse the response body as JSON
            final jsonData = jsonDecode(response.body);
            if (jsonData is List) {
              // If the response is a list, convert it to a map with a key
              return Right(fromJson({'data': jsonData}));
            } else {
              return Right(fromJson(jsonData));
            }
          } else {
            return Right(response.body as T);
          }
        } else {
          return Left(AppError(AppErrorType.api, "API Error: ${response.statusCode}"));
        }
      }

      // Use Dio for other types (e.g., file upload, direct requests, etc.)
      else {
        switch (type) {
          case ApiCallType.directGet:
            response = await _dio.get(url);
            break;
          case ApiCallType.directPost:
            response = await _dio.post(url, data: data);
            break;
          case ApiCallType.postFile:
            var formData = FormData.fromMap({
              'file': await MultipartFile.fromFile(filePath!),
            });
            response = await _dio.post(url, data: formData, options: Options(headers: headers));
            break;
          case ApiCallType.delete:
            response = await _dio.delete(url, data: data, options: Options(headers: headers));
            break;
          default:
            return Left(AppError(AppErrorType.api, "Unsupported API call type"));
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (fromJson != null) {
            return Right(fromJson(response.data));
          } else {
            return Right(response.data as T);
          }
        } else {
          return Left(AppError(AppErrorType.api, "API Error: ${response.statusCode}"));
        }
      }
    } on DioError catch (e) {
      return Left(AppError(AppErrorType.network, "Dio Network Error: ${e.message}"));
    } on http.ClientException catch (e) {
      return Left(AppError(AppErrorType.network, "HTTP Network Error: ${e.message}"));
    } catch (e) {
      return Left(AppError(AppErrorType.unknown, "Unknown Error: $e"));
    }
  }
}