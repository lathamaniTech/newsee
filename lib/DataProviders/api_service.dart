import 'package:dio/dio.dart';
import 'package:newsee/AppData/app_constants.dart';

final dio = Dio();

class ApiService {
  static Future<dynamic> restAPICall(
    String method,
    Map<String, dynamic> reqData,
  ) async {
    print(reqData);
    try {
      final response = await dio.post(
        AppConstants.apiUrl + method,
        data: reqData,

        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ApiException('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      final errorMessage = _handleDioError(dioError);
      throw ApiException(errorMessage);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Error handling for Dio exceptions
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Received invalid status: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request to server was cancelled';
      case DioExceptionType.unknown:
      default:
        return 'Unexpected error occurred: ${error.message}';
    }
  }
}

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
