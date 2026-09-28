import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets.dart';

class PostShiftScreen extends StatefulWidget {
  const PostShiftScreen({super.key});

  @override
  State<PostShiftScreen> createState() => _PostShiftScreenState();
}

class _PostShiftScreenState extends State<PostShiftScreen> {
  final _event = TextEditingController(text: 'Tech Leadership Summit 2025');
  final _venue = TextEditingController(text: 'Jio World Convention Centre, BKC, Mumbai');
  final _wage = TextEditingController(text: '750');
  String _category = 'Corporate Conference / Exhibition';
  String _role = 'Registration & Guest Escort Specialist';
  int _staff = 4;
  final _crit = <String, bool>{
    'Formal Business Attire (All Black)': true,
    'Fluent English & Hindi': true,
    'Verified Govt ID Mandatory': true,
    'Smart Badge / QR Scanner Experience': true,
  };
  static const _critSub = {
    'Formal Business Attire (All Black)': 'Blazer, crisp black shirt/trousers, polished shoes',
    'Fluent English & Hindi': 'Comfortable handling C-suite attendees & international delegates',
    'Verified Govt ID Mandatory': 'Strict background checks pre-vetted by CrewMatch',
    'Smart Badge / QR Scanner Experience': 'Familiar with rapid NFC event kiosks',
  };
  static const _roles = [
    'Registration & Guest Escort Specialist',
    'VIP Host / Hostess',
    'AV & Sound Technician',
    'Event Bartender',
    'Security & Crowd Control',
  ];

  @override
  void dispose() {
    _event.dispose();
    _venue.dispose();
    _wage.dispose();
    super.dispose();
  }

  int get _rate => int.tryParse(_wage.text.trim()) ?? 0;
  int get _base => _staff * 8 * _rate;
  int get _fee => (_base * 0.05).round();

  InputDecoration _dec({IconData? icon}) => InputDecoration(
        prefixIcon: icon == null ? null : Icon(icon, size: 20, color: C.navy),
        filled: true,
        fillColor: C.slate50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: C.slate200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: C.slate200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: C.primary, width: 1.5)),
      );

  Widget _label(String t, {bool req = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(text: t, style: ts(13, w: FontWeight.w600)),
            if (req) TextSpan(text: ' *', style: ts(13, w: FontWeight.w700, color: C.red)),
          ]),
        ),
      );

  Widget _cardTitle(IconData i, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(children: [
          Icon(i, color: C.navy, size: 22),
          const SizedBox(width: 8),
          Text(t, style: ts(18, w: FontWeight.w700)),
        ]),
      );

  void _pickRole() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: C.white,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final r in _roles)
            ListTile(
              title: Text(r, style: ts(15, w: FontWeight.w600)),
              trailing: r == _role ? const Icon(Icons.check, color: C.primary) : null,
              onTap: () {
                setState(() => _role = r);
                Navigator.pop(ctx);
              },
            ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _base + _fee;
    final competitive = _rate >= 700;
    return ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), children: [
      Row(children: [
        Text('STEP 1 OF 3', style: ts(11, w: FontWeight.w700, color: C.navy, ls: 0.5)),
        const Spacer(),
        Text('Next: Candidate Match', style: ts(11, color: C.slate600)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: const LinearProgressIndicator(value: 1 / 3, minHeight: 5, color: C.navy, backgroundColor: C.blueHigh),
      ),
      const SizedBox(height: 14),
      Text('Post an Event Shift', style: ts(26, w: FontWeight.w700, ls: -0.3)),
      Row(children: [
        const Icon(Icons.bolt, size: 16, color: C.green),
        const SizedBox(width: 4),
        Text('Match with verified talent in under 15 minutes', style: ts(13, color: C.slate600)),
      ]),
      const SizedBox(height: 14),
      AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _cardTitle(Icons.event_note_outlined, 'Event Particulars'),
          _label('Event Name', req: true),
          TextField(controller: _event, style: ts(14), decoration: _dec()),
          const SizedBox(height: 14),
          _label('Event Category'),
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            decoration: _dec(),
            style: ts(14),
            items: const [
              'Corporate Conference / Exhibition',
              'Wedding & Social',
              'Concert / Festival',
              'Trade Show',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
          const SizedBox(height: 14),
          _label('Venue & Location'),
          TextField(controller: _venue, style: ts(14), decoration: _dec(icon: Icons.place_outlined)),
          const SizedBox(height: 14),
          _label('Shift Window'),
          MetricBox(
            color: C.slate50,
            child: Row(children: [
              const Icon(Icons.schedule, color: C.navy),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Sat, 22 Nov 2025 • 08:30 AM - 05:30 PM', style: ts(13, w: FontWeight.w600)),
                  Text('9 hrs total duration (8 billable hrs + 1 hr lunch break)',
                      style: ts(12, color: C.slate600)),
                ]),
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 14),
      AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _cardTitle(Icons.badge_outlined, 'Role & Headcount'),
          _label('Designation / Role Needed'),
          InkWell(
            onTap: _pickRole,
            child: MetricBox(
              color: C.blueHigh,
              child: Row(children: [
                const IconBox(Icons.badge, bg: C.navy, fg: C.white, size: 36),
                const SizedBox(width: 10),
                Expanded(child: Text(_role, style: ts(13, w: FontWeight.w700, color: C.navy))),
                Text('Change', style: ts(12, w: FontWeight.w700, color: C.navy)),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Required Staff', style: ts(14, w: FontWeight.w600)),
                Text('Guaranteed deployment', style: ts(12, color: C.slate600)),
              ]),
            ),
            _stepBtn(Icons.remove, () => setState(() => _staff = _staff > 1 ? _staff - 1 : 1)),
            SizedBox(width: 44, child: Text('$_staff', textAlign: TextAlign.center, style: ts(20, w: FontWeight.w700))),
            _stepBtn(Icons.add, () => setState(() => _staff += 1)),
          ]),
          const SizedBox(height: 14),
          _label('Target Hourly Wage (per crew member)'),
          TextField(
            controller: _wage,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            style: ts(18, w: FontWeight.w700),
            decoration: _dec().copyWith(
              prefixText: '₹  ',
              prefixStyle: ts(18, w: FontWeight.w700),
              suffixText: '/ hour',
              suffixStyle: ts(13, color: C.slate600),
            ),
          ),
          const SizedBox(height: 8),
          Tag(
            competitive ? 'Competitive wage • 98% matching probability' : 'Below market • lower match probability',
            fg: competitive ? C.green : C.amber,
            bg: competitive ? C.greenBg50 : C.amberBg,
            icon: competitive ? Icons.trending_up : Icons.trending_down,
          ),
        ]),
      ),
      const SizedBox(height: 14),
      AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _cardTitle(Icons.shield_outlined, 'Shift Criteria & Protocols'),
          Text('Only candidates satisfying all checked prerequisites can accept.',
              style: ts(12, color: C.slate600)),
          const SizedBox(height: 10),
          for (final k in _crit.keys)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: C.slate50, borderRadius: BorderRadius.circular(6)),
              child: CheckboxListTile(
                value: _crit[k],
                onChanged: (v) => setState(() => _crit[k] = v ?? false),
                activeColor: C.primary,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(k, style: ts(14, w: FontWeight.w600)),
                subtitle: Text(_critSub[k] ?? '', style: ts(12, color: C.slate600)),
              ),
            ),
        ]),
      ),
      const SizedBox(height: 14),
      AppCard(
        color: C.blueLow,
        border: C.blueHigh,
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.account_balance_wallet_outlined, color: C.navy),
            const SizedBox(width: 8),
            Expanded(child: Text('Instant Escrow Breakdown', style: ts(16, w: FontWeight.w700, color: C.navy))),
            const Tag('100% Protected', fg: C.navy, bg: C.blueHigh, radius: 999, size: 11),
          ]),
          const SizedBox(height: 12),
          _line('Base Pay ($_staff staff × 8 billable hrs × ${inr(_rate)})', inr(_base)),
          const SizedBox(height: 4),
          _line('Worker Comprehensive Insurance & Platform (5%)', inr(_fee)),
          const Divider(height: 24, color: C.blueSoft),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Total Escrow Lock', style: ts(17, w: FontWeight.w700)),
                Text('Secured in automated trust account', style: ts(12, color: C.slate600)),
              ]),
            ),
            Text(inr(total), style: ts(24, w: FontWeight.w800, color: C.navy)),
          ]),
          const SizedBox(height: 12),
          MetricBox(
            color: C.white,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.info_outline, size: 18, color: C.navy),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    'Zero cancellation penalty up to 12 hours prior. Funds are released exclusively upon your digital timesheet sign-off post-shift.',
                    style: ts(12, color: C.slate700, height: 1.35)),
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 14),
      AppButton('Fund Escrow & Broadcast Shift',
          icon: Icons.podcasts, height: 52, onPressed: () {
        if (_event.text.trim().isEmpty || _rate <= 0) {
          toast(context, 'Enter an event name and an hourly wage first.');
          return;
        }
        toast(context, 'Shift broadcast. ${inr(total)} locked in escrow (demo).');
      }),
      const SizedBox(height: 8),
      AppButton('Save as Template / Draft',
          kind: BtnKind.outline, height: 44, onPressed: () => toast(context, 'Draft saved (demo).')),
    ]);
  }

  Widget _stepBtn(IconData i, VoidCallback f) => InkWell(
        onTap: f,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: C.slate50, borderRadius: BorderRadius.circular(6), border: Border.all(color: C.slate200)),
          child: Icon(i, size: 20, color: C.ink),
        ),
      );

  Widget _line(String a, String b) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(a, style: ts(12, color: C.slate700))),
        const SizedBox(width: 8),
        Text(b, style: ts(13, w: FontWeight.w600)),
      ]);
}
