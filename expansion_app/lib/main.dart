import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/presentation/bloc/settings/app_locale_cubit.dart';
import 'package:expansion/core/logging/bootstrap_logger.dart';
import 'package:expansion/core/themes/app_theme.dart';
import 'package:expansion/core/ui/app_scaffold_messenger_key.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bootstrapLogger();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await initDependencies();
  runApp(const ExpansionApp());
}

class ExpansionApp extends StatelessWidget {
  const ExpansionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLocaleCubit, Locale>(
      bloc: sl<AppLocaleCubit>(),
      builder: (context, locale) {
        return MaterialApp.router(
          scaffoldMessengerKey: appScaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: AppTheme.game(),
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        );
      },
    );
  }
}
