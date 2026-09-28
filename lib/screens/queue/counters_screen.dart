import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets.dart';

enum _St { active, session, onBreak }

class _Desk {
  final String no, name, staff, device, prefix, hwLabel, hwValue;
  final String? secLabel;
  final IconData? secIcon;
  final _St st;
  int serving, waiting;
  _Desk({
    required this.no,
    required this.name,
    required this.staff,
    required this.device,
    required this.prefix,
    required this.serving,
    required this.waiting,
    required this.st,
    this.hwLabel = '',
    this.hwValue = '',
    this.secLabel,
    this.secIcon,
  });
}

class CountersScreen extends StatefulWidget {
  const CountersScreen({super.key});

  @override
  State<CountersScreen> createState() => _CountersScreenState();
}

class _CountersScreenState extends State<CountersScreen> {
  int _filter = 0;
  final _desks = <_Desk>[
    _Desk(no: '01', name: 'General Inquiries', staff: 'Sarah M.', device: 'Station-A', prefix: 'G',
        serving: 89, waiting: 2, st: _St.active, hwLabel: 'Hardware Buzzer', hwValue: 'Pager #04 Paged',
        secLabel: 'Ping Buzzer', secIcon: Icons.notifications_active_outlined),
    _Desk(no: '02', name: 'Document Verification', staff: 'David K.', device: 'Optical-1', prefix: 'D',
        serving: 44, waiting: 5, st: _St.active, hwLabel: 'Scanner Link', hwValue: 'Kiosk-A Synced',
        secLabel: 'Feed Doc', secIcon: Icons.document_scanner_outlined),
    _Desk(no: '03', name: 'Biometrics IoT Booth', staff: 'Priya R.', device: 'Camera & FP Pod', prefix: 'A',
        serving: 107, waiting: 2, st: _St.active, hwLabel: 'Hardware Status', hwValue: 'Sensor Calibrated',
        secLabel: 'Calibrate', secIcon: Icons.fingerprint),
    _Desk(no: '04', name: 'Billing & Express', staff: 'Michael T.', device: 'Terminal POS-3', prefix: 'B',
        serving: 12, waiting: 0, st: _St.session, hwLabel: 'POS Terminal', hwValue: 'Processing Tx'),
    _Desk(no: '05', name: 'Accessible & Senior Care', staff: 'Elena V.', device: 'Returns in 4m', prefix: 'S',
        serving: 0, waiting: 1, st: _St.onBreak),
  ];

  void _callNext(_Desk d) {
    setState(() {
      d.serving += 1;
      if (d.waiting > 0) d.waiting -= 1;
    });
    toast(context, 'Now serving #${d.prefix}-${d.serving.toString().padLeft(3, '0')} at desk ${d.no}');
  }

  @override
  Widget build(BuildContext context) {
    final onBreak = _desks.where((d) => d.st == _St.onBreak).length;
    final active = _desks.length - onBreak;
    final shown = _desks.where((d) {
      if (_filter == 1) return d.st != _St.onBreak;
      if (_filter == 2) return d.st == _St.onBreak;
      return true;
    }).toList();

    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Text('Counters & IoT Desks', style: ts(28, w: FontWeight.w700, height: 1.15, ls: -0.3)),
        ),
        const Tag('Live Feed', fg: C.navy, bg: C.blueHigh, icon: Icons.circle, size: 11),
      ]),
      const SizedBox(height: 6),
      Text('Real-time terminal telemetry, hardware routing, and queue management.',
          style: ts(13, color: C.slate600)),
      const SizedBox(height: 12),
      SegTabs(
        labels: ['All Desks (${_desks.length})', 'Active ($active)', 'Break ($onBreak)'],
        index: _filter,
        onChanged: (v) => setState(() => _filter = v),
      ),
      const SizedBox(height: 14),
      AppCard(
        color: C.blueLow,
        border: C.blueHigh,
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Row(children: [
            Text('IOT MESH HEALTH CHECK', style: ts(11, w: FontWeight.w800, color: C.navy, ls: 0.4)),
            const Spacer(),
            Text('Latency: 14ms', style: ts(11, color: C.slate600)),
          ]),
          const SizedBox(height: 8),
          _health(Icons.notifications_active_outlined, '6 Hardware Buzzers', 'All Units Online'),
          _health(Icons.qr_code_scanner, '1 Kiosk Scanner', 'Connected (Kiosk A)'),
          _health(Icons.center_focus_strong_outlined, 'Footfall Sensor', 'Active • Calibrated 2m ago'),
        ]),
      ),
      const SizedBox(height: 14),
      for (final d in shown) ...[
        d.st == _St.onBreak ? _breakCard(d) : _deskCard(d),
        const SizedBox(height: 12),
      ],
      const SizedBox(height: 4),
      Row(children: [
        Expanded(child: Text('OPERATIONAL CONTROL & OVERRIDES', style: ts(11, w: FontWeight.w700, color: C.slate600, ls: 0.4))),
        Text('Supervisor Key active', style: ts(11, color: C.slate600)),
      ]),
      const SizedBox(height: 8),
      AppButton('Fast-Track Emergency Queue',
          icon: Icons.bolt, kind: BtnKind.dangerSoft, height: 44,
          onPressed: () => toast(context, 'Emergency fast-track queue enabled.')),
      const SizedBox(height: 8),
      AppButton('Broadcast Announcement to IoT Display',
          icon: Icons.sensors, kind: BtnKind.tonal, height: 44,
          onPressed: () => toast(context, 'Announcement sent to all IoT displays.')),
    ]);
  }

  Widget _health(IconData icon, String title, String sub) => Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: C.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: C.slate200)),
        child: Row(children: [
          IconBox(icon, size: 34),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: ts(13, w: FontWeight.w700)),
            Text(sub, style: ts(12, w: FontWeight.w600, color: C.green)),
          ]),
        ]),
      );

  Widget _deskCard(_Desk d) {
    final session = d.st == _St.session;
    return AppCard(
      accent: C.navy,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(color: C.blueHigh, borderRadius: BorderRadius.circular(4)),
            child: Text(d.no, style: ts(15, w: FontWeight.w800, color: C.navy)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.name, style: ts(19, w: FontWeight.w700, height: 1.15)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.badge_outlined, size: 14, color: C.slate600),
                const SizedBox(width: 4),
                Flexible(
                  child: Text('${d.staff} • ${d.device}',
                      overflow: TextOverflow.ellipsis, style: ts(12, w: FontWeight.w600, color: C.primary)),
                ),
              ]),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            session
                ? const Tag('IN SESSION', fg: C.navy, bg: C.blueHigh)
                : const Tag('ACTIVE', fg: C.green, bg: C.greenBg50, border: C.greenBorder),
            const SizedBox(height: 6),
            Text('In Line', style: ts(11, color: C.slate600)),
            Text('${d.waiting} waiting', style: ts(15, w: FontWeight.w800)),
          ]),
        ]),
        const SizedBox(height: 12),
        MetricBox(
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Serving Token', style: ts(12, color: C.slate600)),
              Text('#${d.prefix}-${d.serving.toString().padLeft(3, '0')}', style: ts(17, w: FontWeight.w800)),
            ]),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(d.hwLabel, style: ts(12, color: C.slate600)),
              Text('● ${d.hwValue}', style: ts(12, w: FontWeight.w700, color: C.green)),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          if (d.secLabel != null) ...[
            Expanded(
              flex: 4,
              child: AppButton(d.secLabel!,
                  icon: d.secIcon, kind: BtnKind.tonal, height: 44,
                  onPressed: () => toast(context, '${d.secLabel} sent to desk ${d.no}.')),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 6,
            child: AppButton('Call Next',
                icon: Icons.campaign_outlined, height: 44, onPressed: () => _callNext(d)),
          ),
        ]),
      ]),
    );
  }

  Widget _breakCard(_Desk d) => AppCard(
        accent: C.slate500,
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
              decoration: BoxDecoration(color: C.slate100, borderRadius: BorderRadius.circular(4)),
              child: Text(d.no, style: ts(15, w: FontWeight.w800, color: C.slate600)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d.name, style: ts(19, w: FontWeight.w700, height: 1.15)),
                const SizedBox(height: 4),
                Text('${d.staff} • ${d.device}', style: ts(12, w: FontWeight.w600, color: C.amber)),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Tag('ON BREAK', fg: C.amber, bg: C.amberBg, border: C.amberBorder),
              const SizedBox(height: 6),
              Text('Hold Queue', style: ts(11, color: C.slate600)),
              Text('${d.waiting} on-hold', style: ts(15, w: FontWeight.w800, color: C.red)),
            ]),
          ]),
          const SizedBox(height: 12),
          MetricBox(
            color: C.slate50,
            child: Row(children: [
              const Icon(Icons.free_breakfast_outlined, size: 18, color: C.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Staff rest period scheduled. Terminal locked.',
                    style: ts(12, color: C.slate600)),
              ),
              Text('03:42 left', style: ts(14, w: FontWeight.w800)),
            ]),
          ),
          const SizedBox(height: 12),
          AppButton('Reassign Desk',
              icon: Icons.swap_horiz, kind: BtnKind.tonal, height: 44,
              onPressed: () => toast(context, 'Desk ${d.no} reassigned to the shared pool.')),
        ]),
      );
}
