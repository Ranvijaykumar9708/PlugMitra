import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'localization/app_localizations.dart';
import 'viewmodels/locale_viewmodel.dart';
import 'viewmodels/discover_viewmodel.dart';
import 'viewmodels/charging_viewmodel.dart';
import 'viewmodels/wallet_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PlugMitraApp());
}

class PlugMitraApp extends StatelessWidget {
  const PlugMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<LocaleViewModel>(create: (_) => LocaleViewModel()),
        ChangeNotifierProxyProvider<AppState, DiscoverViewModel>(
          create: (ctx) => DiscoverViewModel(appState: ctx.read<AppState>()),
          update: (_, appState, vm) => vm ?? DiscoverViewModel(appState: appState),
        ),
        ChangeNotifierProxyProvider<AppState, ChargingViewModel>(
          create: (ctx) => ChargingViewModel(appState: ctx.read<AppState>()),
          update: (_, appState, vm) => vm ?? ChargingViewModel(appState: appState),
        ),
        ChangeNotifierProxyProvider<AppState, WalletViewModel>(
          create: (ctx) => WalletViewModel(appState: ctx.read<AppState>()),
          update: (_, appState, vm) => vm ?? WalletViewModel(appState: appState),
        ),
      ],
      child: const _PlugMitraMaterialApp(),
    );
  }
}

class _PlugMitraMaterialApp extends StatelessWidget {
  const _PlugMitraMaterialApp();

  @override
  Widget build(BuildContext context) {
    final localeVm = context.watch<LocaleViewModel>();
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'PlugMitra - Electric Mobility Network',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: localeVm.currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(appState: appState),
    );
  }
}
