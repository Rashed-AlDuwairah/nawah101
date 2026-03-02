import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/constants/app_colors.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NawahApp()));
}

class NawahApp extends StatefulWidget {
  const NawahApp({super.key});

  @override
  State<NawahApp> createState() => _NawahAppState();
}

class _NawahAppState extends State<NawahApp> {
  bool _showStartupSplash = true;

  @override
  void initState() {
    super.initState();
    // Dismiss startup splash after delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _showStartupSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: 'نواة',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          scrollBehavior: NawahScrollBehavior(),
          routerConfig: AppRouter.router,

          // ── Localization ──
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ── Force RTL + mobile width + splash overlay ──
          builder: (context, child) {
            // Sync legacy AppColors with current Theme Brightness
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            AppColors.isDark = isDarkMode;

            // Strict iOS System UI Overlay (Status Bar & Home Indicator)
            final overlayStyle = isDarkMode
                ? SystemUiOverlayStyle.light.copyWith(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: AppColors.background,
                    systemNavigationBarIconBrightness: Brightness.light,
                  )
                : SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: AppColors.background,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  );

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 430),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      child: Stack(
                        children: [
                          child!,

                          // ── Startup Splash ──
                          if (_showStartupSplash)
                            Positioned.fill(
                              child: SplashScreen(
                                onDone: () {
                                  if (mounted) {
                                    setState(() => _showStartupSplash = false);
                                  }
                                },
                              ),
                            ),

                          // ── Theme Switch Splash ──
                          if (ThemeNotifier.instance.isSwitching)
                            Positioned.fill(
                              child: SplashScreen(
                                onDone: () {
                                  ThemeNotifier.instance.onSplashDone();
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
