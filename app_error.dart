import 'package:api_structure/api_structures/enums.dart';

class AppError {
  final AppErrorType type;
  final String message;

  AppError(this.type, this.message);

  @override
  String toString() => 'AppError(type: $type, message: $message)';
}