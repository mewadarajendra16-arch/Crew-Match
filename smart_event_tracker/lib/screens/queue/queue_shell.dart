import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../launcher_screen.dart';
import 'analytics_screen.dart';
import 'counters_screen.dart';
import 'get_token_screen.dart';
import 'my_queue_screen.dart';

class QueueShell extends StatefulWidget {
  const QueueShell({super.key});

  @override
  State<QueueShell> createState() => _QueueShellState();
}

class _QueueShellState extends State<QueueShell> {
  int _i = 0;
  static const _titles = ['Get Token', 'My Queue', 'Counters', 'Analytics'];

  @override
  void initState() {
    super.initState();
    AppFont.family = 'Inter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          BrandHeader(
            crew: false,
            section: _titles[_i],
            onSwitch: () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => const LauncherScreen())),
          ),
          Expanded(
            child: IndexedStack(index: _i, children: [
              GetTokenScreen(onGenerated: () => setState(() => _i = 1)),
              const MyQueueScreen(),
              const CountersScreen(),
              const AnalyticsScreen(),
            ]),
          ),
        ]),
      ),
      bottomNavigationBar: AppBottomNav(
        index: _i,
        onTap: (v) => setState(() => _i = v),
        items: const [
          NavItem(Icons.confirmation_number_outlined, 'Get Token'),
          NavItem(Icons.schedule, 'My Queue'),
          NavItem(Icons.desktop_windows_outlined, 'Counters'),
          NavItem(Icons.bar_chart, 'Analytics'),
        ],
      ),
    );
  }
}
