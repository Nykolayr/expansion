import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expansion/core/network/dio_client.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/core/storage/secure_storage_service.dart';
import 'package:expansion/data/datasources/local/game_database.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';

/// Глобальный контейнер зависимостей. Регистрации добавляй в [initDependencies].
final sl = GetIt.instance;

/// Вызывать из [main] после [WidgetsFlutterBinding.ensureInitialized].
Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<AppFeedbackService>(AppFeedbackService.new);

  sl.registerLazySingleton<DioClient>(DioClient.new);
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  sl.registerLazySingleton<SecureStorageService>(SecureStorageService.new);

  sl.registerLazySingleton<GameDatabase>(GameDatabase.new);

  sl.registerSingleton<AppBootstrapCubit>(
    AppBootstrapCubit(sl<GameDatabase>()),
  );

  sl.registerSingleton<SplashCubit>(
    SplashCubit(sl<SharedPreferences>(), sl<AppBootstrapCubit>()),
  );

  // Дальше: repositories → use cases → registerFactory<BLoC>(...)
}
