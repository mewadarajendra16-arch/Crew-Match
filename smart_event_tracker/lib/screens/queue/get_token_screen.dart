import 'package:flutter/material.dart';
import '../../queue_state.dart';
import '../../theme.dart';
import '../../widgets.dart';

class _Svc {
  final String name, desc, prefix;
  final int wait, ahead;
  const _Svc(this.name, this.desc, this.prefix, this.wait, this.ahead);
}

const _services = [
  _Svc('General Inquiries & Verification', 'ID verification, stamped certificates, general advice', 'G', 6, 3),
  _Svc('Document Submission & Biometrics', 'Fingerprint capture, photo desk, deed approvals', 'D', 14, 8),
  _Svc('Billing, Payments & Refunds', 'Challan payment, receipt reprint, fee disputes', 'B', 2, 1),
  _Svc('Priority Senior & Accessible Desk', 'Age 60+, expectant mothers, assisted mobility', 'A', 0, 0),
];

class GetTokenScreen extends StatefulWidget {
  final VoidCallback? onGenerated;
  const GetTokenScreen({super.key, this.onGenerated});

  @override
  State<GetTokenScreen> createState() => _GetTokenScreenState();
}

class _GetTokenScreenState extends State<GetTokenScreen> {
  int _sel = 0;
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _sms = true, _wa = false, _push = true;
  String? _nameErr, _phoneErr;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _generate() {
    final n = _name.text.trim();
    final p = _phone.text.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _nameErr = n.length < 2 ? 'Enter your full legal name' : null;
      _phoneErr = p.length != 10 ? 'Enter a valid 10-digit mobile number' : null;
    });
    if (_nameErr != null || _phoneErr != null) return;
    final s = _services[_sel];
    myToken.value = QueueToken(
      id: nextTokenId(s.prefix),
      service: s.name,
      name: n,
      issuedAt: DateTime.now(),
      ahead: s.ahead,
      waitMin: s.wait,
    );
    toast(context, 'Token ${myToken.value!.id} generated. SMS confirmation sent.');
    widget.onGenerated?.call();
  }

  InputDecoration _dec(String hint, {IconData? icon, String? err}) => InputDecoration(
        hintText: hint,
        hintStyle: ts(14, color: C.slate500),
        prefixIcon: icon == null ? null : Icon(icon, color: C.slate500, size: 20),
        errorText: err,
        filled: true,
        fillColor: C.blue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: C.primary, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: C.red, width: 2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: C.red, width: 2)),
      );

  Widget _check(String title, String sub, bool v, ValueChanged<bool?> f) => CheckboxListTile(
        value: v,
        onChanged: f,
        activeColor: C.primary,
        dense: true,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(title, style: ts(14, w: FontWeight.w600)),
        subtitle: Text(sub, style: ts(12, color: C.slate600)),
      );

  @override
  Widget build(BuildContext context) {
    final s = _services[_sel];
    final eta = DateTime.now().add(Duration(minutes: s.wait));
    return ListView(padding: const EdgeInsets.fromLTRB(16, 20, 16, 24), children: [
      Text('Get a Digital Token', style: ts(26, w: FontWeight.w700, ls: -0.3)),
      const SizedBox(height: 4),
      Text('Join the virtual queue instantly without waiting in line.',
          style: ts(14, color: C.slate600)),
      const SizedBox(height: 16),
      AppCard(
        color: C.blueLow,
        border: C.blueLow,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('SERVICE HUB', style: ts(11, w: FontWeight.w700, color: C.slate600, ls: 0.6)),
            const Spacer(),
            const Tag('IoT Live Flow', fg: C.green, bg: C.greenBg, icon: Icons.circle, size: 11),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const IconBox(Icons.place_outlined, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Central Service Center — Counter Wing A',
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: ts(15, w: FontWeight.w700)),
                const SizedBox(height: 4),
                const Tag('Low Wait Time • 4 mins avg', fg: C.green, bg: C.greenBg50),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Container(
            height: 92,
            padding: const EdgeInsets.all(12),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(colors: [C.primary, C.navy]),
            ),
            child: Row(children: [
              const Icon(Icons.sensors, color: C.white, size: 16),
              const SizedBox(width: 6),
              Text('14 IoT sensors active at Wing A', style: ts(12, w: FontWeight.w700, color: C.white)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 24),
      const SectionTitle('Select Service Counter', trailing: 'Step 1 of 2'),
      const SizedBox(height: 12),
      for (var i = 0; i < _services.length; i++) ...[
        InkWell(
          onTap: () => setState(() => _sel = i),
          borderRadius: BorderRadius.circular(8),
          child: AppCard(
            color: i == _sel ? C.blue : C.white,
            border: i == _sel ? C.primary : C.slate200,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(i == _sel ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: i == _sel ? C.primary : C.blueSoft, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_services[i].name, style: ts(15, w: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(_services[i].desc, style: ts(12, color: C.slate600)),
                  ]),
                ),
              ]),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 6, children: [
                _services[i].wait == 0
                    ? const Tag('Immediate turn', fg: C.green, bg: C.greenBg50, icon: Icons.bolt)
                    : Tag('~${_services[i].wait} min wait', fg: C.ink, bg: C.blueLow, icon: Icons.timelapse),
                Tag('${_services[i].ahead} ahead', fg: C.ink, bg: C.blueLow, icon: Icons.groups_outlined),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 14),
      const SectionTitle('Visitor Details & Alerts', trailing: 'Step 2 of 2'),
      const SizedBox(height: 12),
      AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Full Legal Name', style: ts(13, w: FontWeight.w600)),
            const Spacer(),
            Text('Matches gov ID', style: ts(12, color: C.slate600)),
          ]),
          const SizedBox(height: 8),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: _dec('e.g. Ramesh Chandra Sharma', icon: Icons.person_outline, err: _nameErr),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Text('Mobile Phone Number', style: ts(13, w: FontWeight.w600)),
            const Spacer(),
            Text('Required for live ping', style: ts(12, color: C.slate600)),
          ]),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: C.blue, borderRadius: BorderRadius.circular(4)),
              child: Text('🇮🇳 +91', style: ts(14, w: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: _dec('98765 43210', err: _phoneErr).copyWith(counterText: ''),
              ),
            ),
          ]),
          const SizedBox(height: 18),
          Text('ALERT PREFERENCES', style: ts(11, w: FontWeight.w700, color: C.navy, ls: 0.6)),
          const SizedBox(height: 4),
          _check('Send SMS Token & live web link', 'Instant ticket ID and private live tracking URL', _sms,
              (v) => setState(() => _sms = v ?? false)),
          _check('Receive WhatsApp status updates', 'Get notified directly when 5 and 2 people remain', _wa,
              (v) => setState(() => _wa = v ?? false)),
          _check('Push notification 3 turns before', 'Audio ping so you can return to the counter area', _push,
              (v) => setState(() => _push = v ?? false)),
        ]),
      ),
      const SizedBox(height: 16),
      AppCard(
        color: C.blueHigh,
        border: C.blueHigh,
        child: Row(children: [
          const IconBox(Icons.schedule, bg: C.navy, fg: C.white, size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('QUEUE PREDICTION', style: ts(11, w: FontWeight.w700, color: C.slate600, ls: 0.6)),
              const SizedBox(height: 2),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: fmtTime(eta), style: ts(22, w: FontWeight.w800, color: C.navy)),
                  TextSpan(
                      text: s.wait == 0 ? '  (now)' : '  (approx. ${s.wait} mins)',
                      style: ts(12, color: C.slate600)),
                ]),
              ),
              const SizedBox(height: 2),
              Text('${s.ahead} visitors currently ahead of you at Wing A.',
                  style: ts(12, color: C.slate600)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      AppButton('Generate Digital Token',
          icon: Icons.confirmation_number_outlined, onPressed: _generate, height: 52),
      const SizedBox(height: 10),
      Text('Powered by IoT smart-sensor dispatch. You will receive an SMS confirmation instantly.',
          textAlign: TextAlign.center, style: ts(12, color: C.slate600)),
    ]);
  }
}
