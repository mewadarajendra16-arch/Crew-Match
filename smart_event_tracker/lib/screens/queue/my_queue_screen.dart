import 'package:flutter/material.dart';
import '../../queue_state.dart';
import '../../theme.dart';
import '../../widgets.dart';

/// The mock-ups did not include a "My Queue" screen, so this one is built
/// from the design system to show the token created on the Get Token tab.
class MyQueueScreen extends StatelessWidget {
  const MyQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QueueToken?>(
      valueListenable: myToken,
      builder: (context, t, _) {
        if (t == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const IconBox(Icons.confirmation_number_outlined, size: 64),
                const SizedBox(height: 16),
                Text('No active token', style: ts(20, w: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Generate a digital token from the Get Token tab to track your place in line.',
                    textAlign: TextAlign.center, style: ts(14, color: C.slate600)),
              ]),
            ),
          );
        }
        final eta = t.issuedAt.add(Duration(minutes: t.waitMin));
        return ListView(padding: const EdgeInsets.all(16), children: [
          AppCard(
            accent: C.primary,
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('YOUR TOKEN', style: ts(11, w: FontWeight.w700, color: C.slate600, ls: 0.6)),
                const Spacer(),
                const Tag('WAITING', fg: C.amber, bg: C.amberBg, border: C.amberBorder),
              ]),
              const SizedBox(height: 8),
              Text(t.id, style: ts(56, w: FontWeight.w800, color: C.primary, ls: -1.5, height: 1.05)),
              const SizedBox(height: 4),
              Text(t.service, style: ts(14, w: FontWeight.w600)),
              Text('Issued to ${t.name}', style: ts(12, color: C.slate600)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: MetricBox(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Position', style: ts(12, color: C.slate600)),
                      Text(t.ahead == 0 ? 'Next' : '${t.ahead} ahead', style: ts(18, w: FontWeight.w800)),
                    ]),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MetricBox(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Est. turn', style: ts(12, color: C.slate600)),
                      Text(fmtTime(eta), style: ts(18, w: FontWeight.w800)),
                    ]),
                  ),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          AppButton('Leave Queue', icon: Icons.logout, kind: BtnKind.dangerSoft, onPressed: () {
            myToken.value = null;
            toast(context, 'You have left the queue.');
          }),
        ]);
      },
    );
  }
}
