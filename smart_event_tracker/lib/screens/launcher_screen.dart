import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'crew/crew_shell.dart';

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppFont.family = 'Noto Sans';
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          const SizedBox(height: 24),
          Text('CrewMatch', style: ts(30, w: FontWeight.w800, color: C.navy, ls: -0.5)),
          const SizedBox(height: 6),
          Text('On-demand event staffing workspace.', style: ts(15, color: C.slate600)),
          const SizedBox(height: 28),
          _AppTile(
            crew: true,
            title: 'CrewMatch',
            subtitle: 'On-demand event staffing: browse verified crew, post shifts, roster and escrow payouts.',
            onTap: () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => const CrewShell())),
          ),
        ]),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  final bool crew;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _AppTile({required this.crew, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AppCard(
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          Logo(crew: crew, size: 56),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: ts(20, w: FontWeight.w800, color: C.navy)),
              const SizedBox(height: 4),
              Text(subtitle, style: ts(13, color: C.slate600, height: 1.4)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: C.slate500),
        ]),
      ),
    );
  }
}
