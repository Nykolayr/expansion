import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expansion/core/network/dio_client.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/core/storage/secure_storage_service.dart';
import 'package:expansion/data/datasources/local/campaign_local_datasource.dart';
import 'package:expansion/data/datasources/local/game_database.dart';
import 'package:expansion/data/repositories/battle_session_factory_impl.dart';
import 'package:expansion/data/repositories/campaign_repository_impl.dart';
import 'package:expansion/data/repositories/guest_profile_repository_impl.dart';
import 'package:expansion/data/seed/campaign_content_seeder.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/battle/battle_cubit.dart';
import 'package:expansion/presentation/bloc/begin/begin_cubit.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_cubit.dart';
import 'package:expansion/presentation/bloc/maps/maps_cubit.dart';
import 'package:expansion/presentation/bloc/settings/app_locale_cubit.dart';
import 'package:expansion/presentation/bloc/settings/game_difficulty_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/game_core/battle/battle_session_factory.dart';
import 'package:expansion/presentation/bloc/progress/progress_cubit.dart';
import 'package:expansion/presentation/bloc/upgrades/upgrades_cubit.dart';

/// Глобальный контейнер зависимостей. Регистрации добавляй в [initDependencies].
final sl = GetIt.instance;

/// Вызывать из [main] после [WidgetsFlutterBinding.ensureInitialized].
Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<AppFeedbackService>(AppFeedbackService.new);

  sl.registerSingleton<AppLocaleCubit>(AppLocaleCubit(sl<SharedPreferences>()));
  await sl<AppLocaleCubit>().load();

  sl.registerLazySingleton<DioClient>(DioClient.new);
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  sl.registerLazySingleton<SecureStorageService>(SecureStorageService.new);

  sl.registerLazySingleton<GameDatabase>(GameDatabase.new);

  sl.registerLazySingleton<CampaignLocalDataSource>(
    () => CampaignLocalDataSource(sl<GameDatabase>().database),
  );

  sl.registerLazySingleton<CampaignContentSeeder>(
    () => CampaignContentSeeder(sl<CampaignLocalDataSource>()),
  );

  sl.registerLazySingleton<CampaignRepository>(
    () => CampaignRepositoryImpl(sl<CampaignLocalDataSource>()),
  );

  sl.registerLazySingleton<GuestProfileRepository>(
    () => GuestProfileRepositoryImpl(sl<SharedPreferences>()),
  );

  sl.registerSingleton<GameDifficultyCubit>(
    GameDifficultyCubit(sl<GuestProfileRepository>()),
  );
  await sl<GameDifficultyCubit>().load();

  sl.registerSingleton<AppBootstrapCubit>(
    AppBootstrapCubit(sl<GameDatabase>(), sl<CampaignContentSeeder>()),
  );

  sl.registerSingleton<SplashCubit>(
    SplashCubit(
      sl<SharedPreferences>(),
      sl<AppBootstrapCubit>(),
      sl<GuestProfileRepository>(),
    ),
  );

  sl.registerSingleton<MapsCubit>(
    MapsCubit(sl<CampaignRepository>(), sl<GuestProfileRepository>()),
  );

  sl.registerLazySingleton<BattleSessionFactory>(
    () => BattleSessionFactoryImpl(sl<CampaignRepository>()),
  );

  sl.registerSingleton<BeginCubit>(BeginCubit(sl<GuestProfileRepository>()));

  sl.registerSingleton<BattleCubit>(
    BattleCubit(
      sl<BattleSessionFactory>(),
      sl<CampaignRepository>(),
      sl<GuestProfileRepository>(),
    ),
  );

  sl.registerSingleton<ProgressCubit>(
    ProgressCubit(sl<GuestProfileRepository>()),
  );

  sl.registerSingleton<UpgradesCubit>(
    UpgradesCubit(sl<GuestProfileRepository>()),
  );
}
