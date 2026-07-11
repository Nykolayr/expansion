import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expansion/core/storage/fresh_install_guard.dart';
import 'package:expansion/core/network/dio_client.dart';
import 'package:expansion/core/audio/game_audio_service.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/core/storage/auth_token_storage.dart';
import 'package:expansion/core/storage/secure_storage_service.dart';
import 'package:expansion/data/datasources/local/campaign_local_datasource.dart';
import 'package:expansion/data/datasources/local/game_database.dart';
import 'package:expansion/data/datasources/remote/campaign_content_remote_datasource.dart';
import 'package:expansion/data/datasources/remote/auth_remote_datasource.dart';
import 'package:expansion/data/datasources/remote/leaderboard_remote_datasource.dart';
import 'package:expansion/data/datasources/remote/profile_remote_datasource.dart';
import 'package:expansion/data/repositories/auth_repository_impl.dart';
import 'package:expansion/data/repositories/battle_session_factory_impl.dart';
import 'package:expansion/data/repositories/campaign_repository_impl.dart';
import 'package:expansion/data/repositories/guest_profile_repository_impl.dart';
import 'package:expansion/data/repositories/leaderboard_repository_impl.dart';
import 'package:expansion/data/seed/campaign_content_seeder.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/domain/repositories/leaderboard_repository.dart';
import 'package:expansion/presentation/bloc/auth/forgot_password_cubit.dart';
import 'package:expansion/presentation/bloc/leaderboard/leaderboard_cubit.dart';
import 'package:expansion/presentation/bloc/auth/login_cubit.dart';
import 'package:expansion/presentation/bloc/auth/register_cubit.dart';
import 'package:expansion/presentation/bloc/battle/battle_cubit.dart';
import 'package:expansion/presentation/bloc/begin/begin_cubit.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_cubit.dart';
import 'package:expansion/presentation/bloc/maps/maps_cubit.dart';
import 'package:expansion/presentation/bloc/settings/app_locale_cubit.dart';
import 'package:expansion/presentation/bloc/settings/game_difficulty_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/game_core/battle/battle_session_factory.dart';
import 'package:expansion/presentation/bloc/progress/progress_cubit.dart';
import 'package:expansion/presentation/bloc/profile/profile_cubit.dart';
import 'package:expansion/presentation/bloc/upgrades/upgrades_cubit.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';
import 'package:expansion/presentation/services/campaign_content_sync_service.dart';
import 'package:expansion/presentation/services/profile_sync_service.dart';

/// Глобальный контейнер зависимостей. Регистрации добавляй в [initDependencies].
final sl = GetIt.instance;

/// Вызывать из [main] после [WidgetsFlutterBinding.ensureInitialized].
Future<void> initDependencies() async {
  if (sl.isRegistered<SharedPreferences>()) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  await FreshInstallGuard.applyIfNeeded(prefs);
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<AppFeedbackService>(AppFeedbackService.new);

  sl.registerLazySingleton<GameAudioService>(
    () => GameAudioService(sl<SharedPreferences>()),
  );

  sl.registerSingleton<AppLocaleCubit>(AppLocaleCubit(sl<SharedPreferences>()));
  await sl<AppLocaleCubit>().load();

  sl.registerLazySingleton<SecureStorageService>(SecureStorageService.new);

  sl.registerLazySingleton<AuthTokenStorage>(
    () => AuthTokenStorage(sl<SecureStorageService>()),
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl<AuthTokenStorage>()),
  );
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<Dio>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<AuthTokenStorage>(),
    ),
  );

  sl<DioClient>().bindTokenRefresh(() async {
    final result = await sl<AuthRepository>().refreshSession();
    return result.isRight();
  });

  sl.registerLazySingleton<CampaignContentRemoteDataSource>(
    () => CampaignContentRemoteDataSource(sl<Dio>()),
  );

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

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<Dio>()),
  );

  sl.registerLazySingleton<ProfileSyncService>(
    () => ProfileSyncService(sl<AuthRepository>(), sl<ProfileRemoteDataSource>()),
  );

  sl.registerLazySingleton<GuestProfileRepository>(
    () => GuestProfileRepositoryImpl(
      sl<SharedPreferences>(),
      sl<ProfileSyncService>(),
    ),
  );

  sl.registerLazySingleton<AuthPostLoginService>(
    () => AuthPostLoginService(
      sl<GuestProfileRepository>(),
      sl<ProfileRemoteDataSource>(),
      sl<ProfileSyncService>(),
    ),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(sl<AuthRepository>(), sl<AuthPostLoginService>()),
  );

  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(sl<AuthRepository>(), sl<AuthPostLoginService>()),
  );

  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<LeaderboardRemoteDataSource>(
    () => LeaderboardRemoteDataSource(sl<Dio>()),
  );

  sl.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepositoryImpl(sl<LeaderboardRemoteDataSource>()),
  );

  sl.registerFactory<LeaderboardCubit>(
    () => LeaderboardCubit(sl<LeaderboardRepository>(), sl<AuthRepository>()),
  );

  sl.registerSingleton<GameDifficultyCubit>(
    GameDifficultyCubit(sl<GuestProfileRepository>()),
  );
  await sl<GameDifficultyCubit>().load();

  sl.registerLazySingleton<CampaignContentSyncService>(
    () => CampaignContentSyncService(
      sl<CampaignContentRemoteDataSource>(),
      sl<CampaignLocalDataSource>(),
      sl<AuthRepository>(),
      sl<GuestProfileRepository>(),
      sl<ProfileSyncService>(),
    ),
  );

  sl.registerSingleton<AppBootstrapCubit>(
    AppBootstrapCubit(
      sl<GameDatabase>(),
      sl<CampaignContentSeeder>(),
      sl<CampaignContentSyncService>(),
      sl<CampaignLocalDataSource>(),
      sl<SharedPreferences>(),
    ),
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

  sl.registerSingleton<ProfileCubit>(
    ProfileCubit(sl<GuestProfileRepository>(), sl<AuthRepository>()),
  );
}
