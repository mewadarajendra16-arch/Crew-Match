import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets.dart';

enum _Duty { on, breakTime }

class _Info {
  final IconData icon;
  final String k, v;
  final bool hi;
  const _Info(this.icon, this.k, this.v, {this.hi = false});
}

class _Staff {
  final String name, role, msg;
  final _Duty duty;
  final List<_Info> info;
  final String? action2;
  final IconData? action2Icon;
  final bool danger;
  const _Staff(this.name, this.role, this.duty, this.info, this.msg,
      {this.action2, this.action2Icon, this.danger = false});
}

const _staff = [
  _Staff('Pooja Sundaram', 'Registration Lead', _Duty.on, [
    _Info(Icons.place_outlined, 'Station', 'Hall 3 Registration Desk'),
    _Info(Icons.qr_code_2, 'Checked In', '08:15 AM via GPS QR'),
    _Info(Icons.schedule, 'Logged', '3.7 hrs active', hi: true),
  ], 'Message / Call', action2: 'Reassign Station', action2Icon: Icons.swap_vert),
  _Staff('Karan Joshi', 'VIP Escort', _Duty.breakTime, [
    _Info(Icons.free_breakfast_outlined, 'Status', 'Scheduled Lunch Break'),
    _Info(Icons.hourglass_bottom, 'Break Window', 'Until 12:00 PM (18m elapsed)'),
  ], 'Ping Staff', action2: 'Emergency Recall', action2Icon: Icons.warning_amber, danger: true),
  _Staff('Sneha Patel', 'Speaker Lounge Host', _Duty.on, [
    _Info(Icons.place_outlined, 'Station', 'Green Room / VIP Stage'),
    _Info(Icons.qr_code_2, 'Checked In', '08:22 AM (On Schedule)'),
  ], 'Message / Call', action2: 'Swap Shift', action2Icon: Icons.swap_horiz),
  _Staff('Amit Roy', 'Helpdesk & Flow Controller', _Duty.on, [
    _Info(Icons.place_outlined, 'Station', 'Main Entrance Turnstiles'),
    _Info(Icons.qr_code_2, 'Checked In', '08:10 AM (Punctual +10m)'),
  ], 'Message / Call Amit'),
];

class RosterScreen extends StatelessWidget {
  const RosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 24), children: [
      Row(children: [
        const Icon(Icons.circle, size: 8, color: C.green),
        const SizedBox(width: 6),
        Text('REAL-TIME OPERATIONAL DESK', style: ts(10, w: FontWeight.w800, color: C.green, ls: 0.6)),
        const Spacer(),
        const Tag('Shift ID: #EV-8842', fg: C.slate600, bg: C.blueHigh, size: 11),
      ]),
      const SizedBox(height: 8),
      AppCard(
        color: C.blueLow,
        border: C.blueLow,
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          const IconBox(Icons.calendar_month_outlined, bg: C.navy, fg: C.white, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tech Leadership Summit 2025', style: ts(17, w: FontWeight.w700, height: 1.2)),
              Text('Day 1 of 2 • Main Convention Center', style: ts(12, color: C.slate600)),
            ]),
          ),
          const Icon(Icons.swap_horiz, color: C.navy),
        ]),
      ),
      const SizedBox(height: 12),
      AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('4', style: ts(30, w: FontWeight.w800)),
            Text('/4', style: ts(18, color: C.slate600)),
            const SizedBox(width: 10),
            const Tag('100% on site', fg: C.green, bg: C.greenBg, icon: Icons.check_circle_outline, radius: 999),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('2:23 AM', style: ts(22, w: FontWeight.w800, color: C.navy)),
              Text('EST Venue Time', style: ts(11, color: C.slate600)),
            ]),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(value: 0.36, minHeight: 8, color: C.navy, backgroundColor: C.blueHigh),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.timer_outlined, size: 14, color: C.slate600),
            const SizedBox(width: 4),
            Text('3h 12m elapsed', style: ts(12, color: C.slate600)),
            const Spacer(),
            Text('5h 48m remaining', style: ts(12, color: C.slate600)),
          ]),
          const SizedBox(height: 10),
          MetricBox(
            color: C.slate50,
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              const Icon(Icons.gpp_good_outlined, size: 18, color: C.navy),
              const SizedBox(width: 8),
              Expanded(
                child: Text('GPS Geofence: All staff validated within 200m venue perimeter.',
                    style: ts(12, w: FontWeight.w600, color: C.slate700)),
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      Row(children: [
        _quick(context, Icons.campaign_outlined, 'Broadcast'),
        const SizedBox(width: 10),
        _quick(context, Icons.person_add_alt, 'Call Standby'),
        const SizedBox(width: 10),
        _quick(context, Icons.receipt_long_outlined, 'Timesheet'),
      ]),
      const SizedBox(height: 18),
      Row(children: [
        Text('Staff Roster', style: ts(20, w: FontWeight.w700)),
        const SizedBox(width: 8),
        Tag('${_staff.length}', fg: C.navy, bg: C.blueHigh, radius: 999),
        const Spacer(),
        Text('Auto-syncs live', style: ts(11, w: FontWeight.w600, color: C.slate600)),
      ]),
      const SizedBox(height: 10),
      for (final s in _staff) ...[_staffCard(context, s), const SizedBox(height: 12)],
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: C.primary, borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.lock_clock, color: C.white),
            const SizedBox(width: 8),
            Text('Scheduled Shift Wrap-Up', style: ts(16, w: FontWeight.w700, color: C.white)),
            const SizedBox(width: 8),
            Tag('05:30 PM', fg: C.white, bg: C.navy, size: 11),
          ]),
          const SizedBox(height: 6),
          Text(
              'Instant timesheet review prompt will automatically unlock at 05:15 PM (15m before shift conclusion) for one-tap biometric payout signoffs.',
              style: ts(12, color: C.blueHigh, height: 1.4)),
        ]),
      ),
    ]);
  }

  Widget _quick(BuildContext context, IconData i, String label) => Expanded(
        child: InkWell(
          onTap: () => toast(context, '$label (demo)'),
          borderRadius: BorderRadius.circular(8),
          child: AppCard(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(children: [
              Icon(i, color: C.navy, size: 24),
              const SizedBox(height: 6),
              Text(label, style: ts(12, w: FontWeight.w700, color: C.navy)),
            ]),
          ),
        ),
      );

  Widget _staffCard(BuildContext context, _Staff s) {
    final onDuty = s.duty == _Duty.on;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Avatar(s.name, size: 46, dot: onDuty ? C.greenMid : const Color(0xFF3B82F6)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: Text(s.name, style: ts(16, w: FontWeight.w700))),
                const SizedBox(width: 4),
                const Icon(Icons.verified_outlined, size: 16, color: C.greenMid),
              ]),
              Text(s.role, style: ts(12, color: C.slate600)),
            ]),
          ),
          onDuty
              ? const Tag('ON DUTY', fg: C.green, bg: C.greenBg, radius: 999, size: 11)
              : const Tag('ON BREAK (15m)', fg: C.navy, bg: C.blueHigh, radius: 999, size: 11),
        ]),
        const SizedBox(height: 10),
        MetricBox(
          color: C.blueLow,
          child: Column(children: [
            for (final r in s.info)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [
                  Icon(r.icon, size: 16, color: C.navy),
                  const SizedBox(width: 8),
                  Text(r.k, style: ts(12, color: C.slate600)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(r.v,
                        textAlign: TextAlign.right,
                        style: ts(12, w: FontWeight.w700, color: r.hi ? C.navy : C.ink)),
                  ),
                ]),
              ),
          ]),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: AppButton(s.msg,
                icon: s.msg.startsWith('Ping') ? Icons.notifications_active_outlined : Icons.chat_bubble_outline,
                kind: BtnKind.tonal,
                height: 42,
                onPressed: () => toast(context, '${s.msg} → ${s.name} (demo)')),
          ),
          if (s.action2 != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(s.action2!,
                  icon: s.action2Icon,
                  kind: s.danger ? BtnKind.dangerSoft : BtnKind.tonal,
                  height: 42,
                  onPressed: () => toast(context, '${s.action2} → ${s.name} (demo)')),
            ),
          ],
        ]),
      ]),
    );
  }
}
