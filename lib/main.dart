import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens.dart';
import 'state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final s = AppState();
  await s.load();
  runApp(KashanEnergyApp(state: s));
}

class KashanEnergyApp extends StatefulWidget {
  final AppState state;
  const KashanEnergyApp({super.key, required this.state});
  @override
  State<KashanEnergyApp> createState() => _KashanEnergyAppState();
}

class _KashanEnergyAppState extends State<KashanEnergyApp> {
  AppState get s => widget.state;

  @override
  void dispose() {
    s.dispose();
    super.dispose();
  }

  ThemeData _theme(Color seed, Brightness b) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: b)
            .copyWith(secondary: const Color(0xFFF5C84C), error: const Color(0xFFE5484D)),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, scrolledUnderElevation: 0, elevation: 0),
        scaffoldBackgroundColor: Colors.transparent,
        // fontFamily: 'Vazirmatn',
      );

  @override
  Widget build(BuildContext context) => Scope(
        notifier: s,
        child: Builder(builder: (c) {
          final a = Scope.of(c);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'انرژی کاشان',
            locale: const Locale('fa', 'IR'),
            supportedLocales: const [Locale('fa', 'IR')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: _theme(a.seed, Brightness.light),
            darkTheme: _theme(a.seed, Brightness.dark),
            themeMode: a.dark ? ThemeMode.dark : ThemeMode.light,
            builder: (ctx, child) => MediaQuery(
              data: MediaQuery.of(ctx).copyWith(textScaler: TextScaler.linear(a.scale)),
              child: child!,
            ),
            home: !a.onboarded
                ? const Onboarding()
                : a.signedIn
                    ? (const Shell())
                    : const AuthPage(),
          );
        }),
      );
}
