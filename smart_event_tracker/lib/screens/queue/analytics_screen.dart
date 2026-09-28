import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets.dart';

class _Stats {
  final String footfall, delta, wait, rate, served, uptime;
  const _Stats(this.footfall, this.delta, this.wait, this.rate, this.served, this.uptime);
}

// Sample data — swap for your real API / IoT feed.
const _stats = [
  _Stats('348', '+12% vs yesterday', '6.4', '94.2%', '328 served, 20 queued', '99.8%'),
  _Stats('2,184', '+5% vs last week', '7.1', '92.6%', '2,022 served, 162 queued', '99.5%'),
  _Stats('9,420', '+8% vs last month', '6.8', '93.4%', '8,798 served, 622 queued', '99.7%'),
];

const _hours = ['08', '09', '10', '11', '12', '13', '14', '15', '16', '17'];
const _load = [0.18, 0.28, 0.52, 1.0, 1.0, 0.86, 0.44, 0.50, 0.88, 0.22];

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _range = 0;

  Color _bar(double v) {
    if (v >= 1) return C.primaryDeep;
    if (v >= 0.8) return C.primary;
    if (v >= 0.5) return C.blueSoft;
    if (v >= 0.4) return const Color(0xFFC3C6D3);
    return C.blueHigh;
  }

  @override
  Widget build(BuildContext context) {
    final s = _stats[_range];
    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
      Row(children: [
        Expanded(child: Text('Service Analytics & Footfall', style: ts(22, w: FontWeight.w700, ls: -0.3))),
        const Tag('LIVE', fg: C.navy, bg: C.blueHigh, icon: Icons.circle, size: 11),
      ]),
      const SizedBox(height: 4),
      Text('Live station utilization and citizen flow metrics', style: ts(12, color: C.slate600)),
      const SizedBox(height: 12),
      SegTabs(
        labels: const ['Today', 'This Week', 'Monthly'],
        index: _range,
        onChanged: (v) => setState(() => _range = v),
      ),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _kpi('Total Footfall', Icons.groups_outlined, s.footfall, 'Visitors', s.delta, up: true)),
        const SizedBox(width: 12),
        Expanded(child: _kpi('Avg Wait Time', Icons.timer_outlined, s.wait, 'mins', 'Goal: <10m • Optimal')),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _kpi('Service Rate', Icons.check_circle_outline, s.rate, '', s.served)),
        const SizedBox(width: 12),
        Expanded(child: _kpi('Station Uptime', Icons.sensors, s.uptime, '', '● All sensors live')),
      ]),
      const SizedBox(height: 16),
      AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Hourly Queue Density', style: ts(18, w: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Citizen arrival load across working shifts', style: ts(12, color: C.slate600)),
              ]),
            ),
            Text('PEAK:\n48/hr', textAlign: TextAlign.right, style: ts(13, w: FontWeight.w800, color: C.navy)),
          ]),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              for (final v in _load)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      height: 130 * v,
                      decoration: BoxDecoration(
                          color: _bar(v),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                    ),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 6),
          Row(children: [
            for (var i = 0; i < _hours.length; i++)
              Expanded(
                child: Text(_hours[i],
                    textAlign: TextAlign.center,
                    style: ts(12,
                        w: _load[i] >= 1 ? FontWeight.w800 : FontWeight.w500,
                        color: _load[i] >= 1 ? C.navy : C.slate600)),
              ),
          ]),
          const SizedBox(height: 14),
          MetricBox(
            color: C.blueLow,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const IconBox(Icons.lightbulb_outline, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Load Optimization Insight', style: ts(14, w: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                      'Peak load detected between 11:30 AM – 1:00 PM. Recommend allocating Counter 05 to Biometrics to absorb overflow.',
                      style: ts(12, color: C.slate700, height: 1.4)),
                ]),
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text('Counter Productivity', style: ts(18, w: FontWeight.w700))),
            Text('Active: 4/5', style: ts(12, w: FontWeight.w700)),
          ]),
          Text('Efficiency by counter position', style: ts(12, color: C.slate600)),
          const SizedBox(height: 12),
          _prod('01', 'Express Intake', '72 tokens completed', '4.8 min', 'avg time', false),
          _prod('02', 'Identity & Pass', '85 tokens completed', '7.1 min', 'avg time', false),
          _prod('03', 'Document Review', '98 tokens completed', '5.5 min', 'High Volume', true),
          _prod('04', 'Special Dispatch', '65 tokens completed', '3.2 min', 'Fastest Pace', true),
        ]),
      ),
      const SizedBox(height: 16),
      AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.sms_outlined, color: C.navy),
            const SizedBox(width: 8),
            Expanded(child: Text('Notification Health', style: ts(18, w: FontWeight.w700))),
            const Tag('99.4% Rate', fg: C.navy, bg: C.blueHigh),
          ]),
          const SizedBox(height: 12),
          MetricBox(
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('346 SMS Dispatched', style: ts(13, w: FontWeight.w700)),
                  Text('0 transit drops • 0 failed queues', style: ts(12, color: C.slate600)),
                ]),
              ),
              const Icon(Icons.verified_outlined, color: C.navy, size: 18),
              const SizedBox(width: 4),
              Text('Synced', style: ts(13, w: FontWeight.w700, color: C.navy)),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Text('Citizen response post-SMS ping', style: ts(12, color: C.slate600))),
            Text('1.8 mins avg', style: ts(14, w: FontWeight.w800)),
          ]),
        ]),
      ),
      const SizedBox(height: 16),
      AppButton('Optimize Shift Schedule',
          icon: Icons.event_repeat_outlined,
          height: 52,
          onPressed: () => toast(context, 'Shift optimisation queued (demo).')),
      const SizedBox(height: 10),
      AppButton('Download CSV Summary',
          icon: Icons.download_outlined,
          kind: BtnKind.outline,
          height: 48,
          onPressed: () => toast(context, 'CSV export is not wired to a backend yet (demo).')),
    ]);
  }

  Widget _kpi(String label, IconData icon, String value, String unit, String foot, {bool up = false}) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(label, style: ts(12, w: FontWeight.w600, color: C.slate600))),
          Icon(icon, size: 18, color: C.navy),
        ]),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: value, style: ts(28, w: FontWeight.w800, ls: -0.5)),
            if (unit.isNotEmpty) TextSpan(text: ' $unit', style: ts(12, color: C.slate600)),
          ]),
        ),
        const SizedBox(height: 4),
        Text(foot,
            style: ts(11, w: FontWeight.w600, color: up ? C.green : C.slate600), maxLines: 2),
      ]),
    );
  }

  Widget _prod(String no, String name, String done, String avg, String note, bool hi) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: C.blueLow, borderRadius: BorderRadius.circular(6)),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: C.blueHigh, borderRadius: BorderRadius.circular(4)),
            child: Text(no, style: ts(13, w: FontWeight.w800, color: C.navy)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: ts(14, w: FontWeight.w700)),
              Text(done, style: ts(12, color: C.slate600)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(avg, style: ts(16, w: FontWeight.w800, color: hi ? C.navy : C.ink)),
            Text(note, style: ts(11, color: hi ? C.navy : C.slate600)),
          ]),
        ]),
      );
}
