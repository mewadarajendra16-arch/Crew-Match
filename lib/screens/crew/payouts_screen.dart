import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets.dart';

enum _Ov { pending, standard, full }

class _Sheet {
  final String name, role, sub, gps, footer;
  final int amount;
  final String? chip;
  final IconData? chipIcon;
  final double? rating;
  final bool flawless;
  const _Sheet(this.name, this.role, this.amount, this.sub, this.gps, this.footer,
      {this.chip, this.chipIcon, this.rating, this.flawless = false});
}

const _sheets = [
  _Sheet('Pooja Sundaram', 'Registration Desk Lead', 6000, '8.0 hrs @ ₹750/hr', 'GPS Verified: 08:15 AM – 05:30 PM',
      'Shift Manager Signed Off', chip: 'Net: 8h 00m billable', chipIcon: Icons.timer_outlined, rating: 5.0),
  _Sheet('Sneha Patel', 'Speaker Lounge Host', 6000, '8.0 hrs @ ₹750/hr', 'GPS Verified: 08:22 AM – 05:30 PM',
      'Client Sign-off Confirmed', chip: '45m break deducted', chipIcon: Icons.restaurant),
  _Sheet('Amit Roy', 'Technical Helpdesk', 6000, '8.0 hrs @ ₹750/hr', 'GPS Verified: 08:30 AM – 05:30 PM',
      'Timesheet Matched', flawless: true),
];

class PayoutsScreen extends StatefulWidget {
  const PayoutsScreen({super.key});

  @override
  State<PayoutsScreen> createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen> {
  _Ov _karan = _Ov.pending;
  bool _released = false;

  static const _baseReady = 18000;
  static const _fee = 1200;

  int get _karanAmt => _karan == _Ov.standard ? 6000 : _karan == _Ov.full ? 6750 : 0;
  int get _ready => _baseReady + _karanAmt;
  int get _review => _karan == _Ov.pending ? 6000 : 0;

  Future<void> _release() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Release ${inr(_ready)}?', style: ts(18, w: FontWeight.w700)),
        content: Text('Approved payments are sent instantly to worker accounts via UPI/NEFT.',
            style: ts(14, color: C.slate600)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel', style: ts(14, w: FontWeight.w600, color: C.slate600))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Release', style: ts(14, w: FontWeight.w700, color: C.primary))),
        ],
      ),
    );
    if (ok == true && mounted) {
      setState(() => _released = true);
      toast(context, '${inr(_ready)} released (demo — no real payment made).');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), children: [
          Row(children: [
            const Tag('Automated Escrow Protocol', fg: C.navy, bg: C.blueHigh, icon: Icons.shield_outlined, radius: 999, size: 11),
            const Spacer(),
            Text('Shift Ref: #TLS-892', style: ts(11, color: C.slate600)),
          ]),
          const SizedBox(height: 8),
          Text('Billing & Escrow Settlement', style: ts(24, w: FontWeight.w700, height: 1.15, ls: -0.3)),
          Text('Tech Leadership Summit 2025 • Bengaluru Convention Hall', style: ts(13, color: C.slate600)),
          const SizedBox(height: 12),
          _vault(),
          const SizedBox(height: 12),
          AppCard(
            color: C.blueLow,
            border: C.blueLow,
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              const IconBox(Icons.bolt, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Instant UPI/NEFT Routing', style: ts(13, w: FontWeight.w700, color: C.navy)),
                  Text('Disbursed directly to worker accounts in <60s upon approval.', style: ts(12, color: C.slate600)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Text('Worker Timesheets', style: ts(18, w: FontWeight.w700)),
            const SizedBox(width: 8),
            const Tag('4 Crew', fg: C.navy, bg: C.blueHigh, radius: 999, size: 11),
            const Spacer(),
            InkWell(
              onTap: () => toast(context, 'Logs export (demo)'),
              child: Row(children: [
                const Icon(Icons.download_outlined, size: 16, color: C.navy),
                const SizedBox(width: 4),
                Text('Logs', style: ts(12, w: FontWeight.w700, color: C.navy)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          for (final s in _sheets) ...[_sheetCard(s), const SizedBox(height: 10)],
          _karanCard(),
          const SizedBox(height: 16),
          Text('COMPLIANCE & INVOICES', style: ts(11, w: FontWeight.w700, color: C.slate600, ls: 0.6)),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              const IconBox(Icons.description_outlined, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Tax Invoice #INV-2025-081', style: ts(13, w: FontWeight.w700)),
                  Text('GST Compliant • Axis Escrow Receipt', style: ts(12, color: C.slate600)),
                ]),
              ),
              const Tag('PDF', fg: C.navy, bg: C.blueHigh),
            ]),
          ),
        ]),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(color: C.white, border: Border(top: BorderSide(color: C.slate200))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const Icon(Icons.check_circle_outline, size: 16, color: C.green),
            const SizedBox(width: 6),
            Text(_released ? 'Batch released' : 'Batch Authorized', style: ts(12, w: FontWeight.w600, color: C.slate700)),
            const Spacer(),
            Text('Instant Direct UPI Transfer', style: ts(11, w: FontWeight.w600, color: C.slate600)),
          ]),
          const SizedBox(height: 8),
          AppButton(
            _released ? 'Payments Released' : 'Release ${inr(_ready)} Approved Payments',
            icon: Icons.lock_open,
            kind: BtnKind.primary,
            height: 52,
            onPressed: _released ? null : _release,
          ),
        ]),
      ),
    ]);
  }

  Widget _vault() {
    final total = _baseReady + 6000 + _fee;
    Widget seg(int v, Color c) => v <= 0 ? const SizedBox.shrink() : Expanded(flex: v, child: Container(height: 8, color: c));
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('TOTAL ESCROW VAULT', style: ts(11, w: FontWeight.w700, color: C.slate600, ls: 0.6)),
          const Spacer(),
          const Tag('Axis Bank Escrow Secured', fg: C.green, bg: C.greenBg, icon: Icons.lock_outline, radius: 999, size: 11),
        ]),
        const SizedBox(height: 4),
        Text(inr(total), style: ts(32, w: FontWeight.w800, color: C.navy, ls: -0.5)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(children: [
            seg(_ready, C.navy),
            seg(_review, const Color(0xFFDC2626)),
            seg(_fee, C.slate300),
          ]),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 14, children: [
          _legend(C.navy, 'Ready: ${inr(_ready)}'),
          _legend(const Color(0xFFDC2626), 'Review: ${inr(_review)}'),
          _legend(C.slate300, 'Fee: ${inr(_fee)}'),
        ]),
        const SizedBox(height: 12),
        MetricBox(
          color: C.slate50,
          child: Column(children: [
            _vrow(Icons.check_circle_outline, '3 Verified Shifts', inr(18000), C.ink),
            const SizedBox(height: 6),
            _vrow(Icons.flag_outlined, '1 Overtime Discrepancy Hold', inr(6000), _karan == _Ov.pending ? C.red : C.slate600),
            const SizedBox(height: 6),
            _vrow(Icons.receipt_long_outlined, 'CrewMatch Service Fee (GST 18% incl.)', inr(_fee), C.ink),
          ]),
        ),
      ]),
    );
  }

  Widget _legend(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(t, style: ts(11, w: FontWeight.w600)),
      ]);

  Widget _vrow(IconData i, String a, String b, Color c) => Row(children: [
        Icon(i, size: 16, color: c == C.red ? C.red : C.slate600),
        const SizedBox(width: 8),
        Expanded(child: Text(a, style: ts(12, color: C.slate700))),
        Text(b, style: ts(13, w: FontWeight.w700, color: c)),
      ]);

  Widget _sheetCard(_Sheet s) => AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Avatar(s.name, size: 42),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: ts(15, w: FontWeight.w700)),
                Text(s.role, style: ts(12, color: C.slate600)),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(inr(s.amount), style: ts(19, w: FontWeight.w800)),
              Text(s.sub, style: ts(11, color: C.slate600)),
            ]),
          ]),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Tag(s.gps, fg: C.slate700, bg: C.slate100, icon: Icons.place_outlined, size: 11),
            if (s.chip != null) Tag(s.chip!, fg: C.navy, bg: C.blueLow, icon: s.chipIcon, size: 11),
            if (s.flawless) const Tag('Flawless Log', fg: C.green, bg: C.greenBg, size: 11),
          ]),
          if (s.rating != null) ...[
            const SizedBox(height: 8),
            MetricBox(
              color: C.blueLow,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(children: [
                Text('Supervisor Rating', style: ts(12, color: C.slate700)),
                const Spacer(),
                for (var i = 0; i < 5; i++) const Icon(Icons.star_border, size: 16, color: C.navy),
                const SizedBox(width: 6),
                Text('${s.rating}', style: ts(12, w: FontWeight.w700, color: C.navy)),
              ]),
            ),
          ],
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.check_circle_outline, size: 16, color: C.green),
            const SizedBox(width: 6),
            Expanded(child: Text(s.footer, style: ts(12, w: FontWeight.w700, color: C.green))),
            const Tag('Ready to release', fg: C.navy, bg: C.blueHigh, radius: 999, size: 11),
          ]),
        ]),
      );

  Widget _karanCard() {
    final resolved = _karan != _Ov.pending;
    return AppCard(
      color: resolved ? C.white : C.redBg,
      border: resolved ? C.slate200 : C.redBorder,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Avatar('Karan Joshi', size: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text('Karan Joshi', style: ts(15, w: FontWeight.w700)),
                resolved
                    ? const Tag('Resolved', fg: C.green, bg: C.greenBg, size: 10)
                    : const Tag('Discrepancy', fg: C.red, bg: Color(0xFFFEE2E2), size: 10),
              ]),
              Text('VIP Stage Escort', style: ts(12, color: C.slate600)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(inr(resolved ? _karanAmt : 6750),
                style: ts(19, w: FontWeight.w800, color: resolved ? C.ink : C.red)),
            Text('8.0h + 1.0h OT', style: ts(11, color: C.slate600)),
            if (!resolved) Text('Claimed', style: ts(11, color: C.slate600)),
          ]),
        ]),
        const SizedBox(height: 10),
        MetricBox(
          color: C.blueLow,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.info_outline, size: 16, color: C.red),
              const SizedBox(width: 6),
              Text('Staff Overtime Reason', style: ts(13, w: FontWeight.w700)),
            ]),
            const SizedBox(height: 4),
            Text('"Stayed until 06:30 PM for VIP Keynote speaker wrap-up requested by stage director."',
                style: ts(12, color: C.slate700, height: 1.4).copyWith(fontStyle: FontStyle.italic)),
            const Divider(height: 16),
            Row(children: [
              Text('Standard Base (8.0h): ${inr(6000)}', style: ts(12, color: C.slate700)),
              const Spacer(),
              Text('+ 1.0h Overtime: ${inr(750)}', style: ts(12, w: FontWeight.w700, color: C.red)),
            ]),
          ]),
        ),
        const SizedBox(height: 10),
        if (!resolved)
          Row(children: [
            Expanded(
              child: AppButton('Adjust to Standard (${inr(6000)})',
                  kind: BtnKind.tonal, height: 48, onPressed: () => setState(() => _karan = _Ov.standard)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton('Approve Full ${inr(6750)}',
                  kind: BtnKind.primary, height: 48, onPressed: () => setState(() => _karan = _Ov.full)),
            ),
          ])
        else
          Row(children: [
            const Icon(Icons.check_circle_outline, size: 16, color: C.green),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                  _karan == _Ov.full ? 'Overtime approved — ${inr(6750)} added to batch' : 'Adjusted to standard — ${inr(6000)} added to batch',
                  style: ts(12, w: FontWeight.w700, color: C.green)),
            ),
            if (!_released)
              TextButton(
                onPressed: () => setState(() => _karan = _Ov.pending),
                child: Text('Undo', style: ts(12, w: FontWeight.w700, color: C.navy)),
              ),
          ]),
      ]),
    );
  }
}
