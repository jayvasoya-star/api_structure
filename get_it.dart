import 'package:api_structure/api_structures/api_service.dart';
import 'package:api_structure/api_structures/api_service_impl.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<ApiService>(ApiServiceImpl());
}