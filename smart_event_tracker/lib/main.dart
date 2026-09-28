import 'package:flutter/material.dart';

// Theme
import 'theme.dart';

// Launcher Screen
import 'screens/launcher_screen.dart';

// CrewMatch Screens
import 'screens/crew/crew_shell.dart';
import 'screens/crew/browse_crew_screen.dart';
import 'screens/crew/post_shift_screen.dart';
import 'screens/crew/roster_screen.dart';
import 'screens/crew/payouts_screen.dart';

// SmartQueue Screens
import 'screens/queue/queue_shell.dart';
import 'screens/queue/get_token_screen.dart';
import 'screens/queue/my_queue_screen.dart';
import 'screens/queue/counters_screen.dart';
import 'screens/queue/analytics_screen.dart';

/// Centralized route definitions connecting every screen across the app.
class AppRoutes {
  AppRoutes._();

  // Root defaults directly to CrewMatch (SmartQueue option removed from start)
  static const String home = '/';
  static const String crew = '/crew';
  static const String launcher = '/launcher';

  // CrewMatch individual screen routes
  static const String browseCrew = '/crew/browse';
  static const String postShift = '/crew/post-shift';
  static const String roster = '/crew/roster';
  static const String payouts = '/crew/payouts';

  // SmartQueue individual screen routes (available if needed)
  static const String queue = '/queue';
  static const String getToken = '/queue/get-token';
  static const String myQueue = '/queue/my-queue';
  static const String counters = '/queue/counters';
  static const String analytics = '/queue/analytics';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const CrewShell(),
        crew: (context) => const CrewShell(),
        launcher: (context) => const LauncherScreen(),
        browseCrew: (context) => const BrowseCrewScreen(),
        postShift: (context) => const PostShiftScreen(),
        roster: (context) => const RosterScreen(),
        payouts: (context) => const PayoutsScreen(),
        queue: (context) => const QueueShell(),
        getToken: (context) => const GetTokenScreen(),
        myQueue: (context) => const MyQueueScreen(),
        counters: (context) => const CountersScreen(),
        analytics: (context) => const AnalyticsScreen(),
      };
}

void main() => runApp(const SmartEventTrackerApp());

class SmartEventTrackerApp extends StatelessWidget {
  const SmartEventTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrewMatch',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const CrewShell(),
      ),
    );
  }
}
