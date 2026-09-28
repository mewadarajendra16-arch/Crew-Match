import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../launcher_screen.dart';
import 'browse_crew_screen.dart';
import 'payouts_screen.dart';
import 'post_shift_screen.dart';
import 'roster_screen.dart';

class CrewShell extends StatefulWidget {
  const CrewShell({super.key});

  @override
  State<CrewShell> createState() => _CrewShellState();
}

class _CrewShellState extends State<CrewShell> {
  int _i = 0;

  @override
  void initState() {
    super.initState();
    AppFont.family = 'Noto Sans';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          BrandHeader(
            crew: true,
            onSwitch: () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => const LauncherScreen())),
          ),
          Expanded(
            child: IndexedStack(index: _i, children: const [
              BrowseCrewScreen(),
              PostShiftScreen(),
              RosterScreen(),
              PayoutsScreen(),
            ]),
          ),
        ]),
      ),
      bottomNavigationBar: AppBottomNav(
        index: _i,
        onTap: (v) => setState(() => _i = v),
        items: const [
          NavItem(Icons.person_search_outlined, 'Browse Crew'),
          NavItem(Icons.add_circle_outline, 'Post Shift'),
          NavItem(Icons.fact_check_outlined, 'Roster'),
          NavItem(Icons.payments_outlined, 'Payouts'),
        ],
      ),
    );
  }
}
