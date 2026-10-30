import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

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

class PlugMitraApp extends StatefulWidget {
  const PlugMitraApp({super.key});

  @override
  State<PlugMitraApp> createState() => _PlugMitraAppState();
}

class _PlugMitraAppState extends State<PlugMitraApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, child) {
        return MaterialApp(
          title: 'PlugMitra - Electric Mobility Network',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: SplashScreen(appState: _appState),
        );
      },
    );
  }
}
