import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import '../../widgets.dart';

class _Worker {
  final String id;
  final String name, role, category, meta, metaKind;
  final int rate;
  final double rating;
  final String stat;
  final List<String> badges, skills;
  final bool immediate, weekend;

  const _Worker({
    required this.id,
    required this.name,
    required this.role,
    required this.category,
    required this.rate,
    required this.rating,
    required this.stat,
    required this.meta,
    required this.metaKind,
    required this.badges,
    required this.skills,
    this.immediate = false,
    this.weekend = false,
  });

  factory _Worker.fromJson(Map<String, dynamic> json) {
    return _Worker(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      category: json['category'] ?? '',
      rate: json['hourlyRate'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      stat: json['stat'] ?? '',
      meta: json['meta'] ?? 'Available',
      metaKind: json['metaKind'] ?? 'clock',
      badges: List<String>.from(json['badges'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      immediate: json['immediate'] ?? false,
      weekend: json['weekend'] ?? false,
    );
  }
}

const _cats = [
  ['Guest Relations', '48'],
  ['AV & Technical', '22'],
  ['Hospitality', '31'],
  ['Security', '23'],
];

class BrowseCrewScreen extends StatefulWidget {
  const BrowseCrewScreen({super.key});

  @override
  State<BrowseCrewScreen> createState() => _BrowseCrewScreenState();
}

class _BrowseCrewScreenState extends State<BrowseCrewScreen> {
  final _q = TextEditingController();
  bool _verified = true, _immediate = false, _weekend = false;
  String? _cat;
  List<_Worker> _workers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Future<void> _fetchWorkers() async {
    setState(() => _loading = true);
    final queryParams = <String>[];
    if (_cat != null) queryParams.add('category=${Uri.encodeComponent(_cat!)}');
    if (_immediate) queryParams.add('immediate=true');
    if (_weekend) queryParams.add('weekend=true');
    if (_q.text.trim().isNotEmpty) queryParams.add('q=${Uri.encodeComponent(_q.text.trim())}');

    final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    final res = await ApiService.get('/workers$queryString');

    if (res != null && res['success'] == true) {
      final list = (res['data'] as List).map((item) => _Worker.fromJson(item)).toList();
      setState(() {
        _workers = list;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _hire(_Worker w) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Direct hire ${w.name}?', style: ts(18, w: FontWeight.w700)),
        content: Text('A hire request at ${inr(w.rate)}/hr will be sent. Funds are held in escrow until sign-off.',
            style: ts(14, color: C.slate600)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel', style: ts(14, w: FontWeight.w600, color: C.slate600))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Send request', style: ts(14, w: FontWeight.w700, color: C.primary)),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      final res = await ApiService.post('/workers/hire', {'workerId': w.id, 'rate': w.rate});
      if (res != null && res['success'] == true) {
        toast(context, res['message'] ?? 'Hire request sent to ${w.name}.');
      }
    }
  }

  void _profile(_Worker w) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: C.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Avatar(w.name, size: 56, dot: C.greenMid),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(w.name, style: ts(20, w: FontWeight.w700)),
                  Text(w.role, style: ts(13, color: C.slate600)),
                ]),
              ),
            ]),
            const SizedBox(height: 14),
            Text('★ ${w.rating} ${w.stat}   •   ${inr(w.rate)}/hr', style: ts(14, w: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final b in w.badges) Tag(b, fg: C.green, bg: C.greenBg50, border: C.greenBorder, radius: 999),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final s in w.skills) Tag(s, fg: C.navy, bg: C.blueLow, radius: 4),
            ]),
            const SizedBox(height: 18),
            AppButton('Direct Hire', icon: Icons.arrow_forward, iconAfter: true, onPressed: () {
              Navigator.pop(ctx);
              _hire(w);
            }),
          ]),
        ),
      ),
    );
  }

  Widget _chip(String label, IconData icon, bool on, VoidCallback f) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: () {
            f();
            _fetchWorkers();
          },
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: on ? C.navy : C.white,
              borderRadius: BorderRadius.circular(999),
              border: on ? null : Border.all(color: C.slate300),
            ),
            child: Row(children: [
              Icon(icon, size: 16, color: on ? C.white : C.slate700),
              const SizedBox(width: 6),
              Text(label, style: ts(12, w: FontWeight.w600, color: on ? C.white : C.slate700)),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 24), children: [
      TextField(
        controller: _q,
        onChanged: (_) => _fetchWorkers(),
        style: ts(15),
        decoration: InputDecoration(
          hintText: 'Search roles, skills or names',
          hintStyle: ts(15, color: C.slate500),
          prefixIcon: const Icon(Icons.search, color: C.navy),
          suffixIcon: _q.text.isEmpty
              ? null
              : IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () {
                  _q.clear();
                  _fetchWorkers();
                }),
          filled: true,
          fillColor: C.blue,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: C.blue, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.place_outlined, size: 20, color: C.navy),
              const SizedBox(width: 8),
              Expanded(child: Text('Mumbai, BKC (+10 km)', overflow: TextOverflow.ellipsis, style: ts(14, w: FontWeight.w600))),
            ]),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => toast(context, 'Advanced filters active.'),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: C.blue, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.tune, size: 20, color: C.navy),
              const SizedBox(width: 6),
              Text('Filters', style: ts(14, w: FontWeight.w600)),
            ]),
          ),
        ),
      ]),
      const SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _chip('Verified ID Only', Icons.verified_outlined, _verified, () => setState(() => _verified = !_verified)),
          _chip('Immediate', Icons.bolt, _immediate, () => setState(() => _immediate = !_immediate)),
          _chip('This Weekend', Icons.calendar_today_outlined, _weekend, () => setState(() => _weekend = !_weekend)),
        ]),
      ),
      const SizedBox(height: 16),
      Row(children: [
        Text('QUICK CATEGORIES', style: ts(12, w: FontWeight.w700, color: C.slate700, ls: 0.6)),
        const Spacer(),
        Text('${_workers.length} Available', style: ts(12, w: FontWeight.w700, color: C.navy)),
      ]),
      const SizedBox(height: 8),
      SizedBox(
        height: 42,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final c in _cats)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() => _cat = _cat == c[0] ? null : c[0]);
                  _fetchWorkers();
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _cat == c[0] ? C.blueHigh : C.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _cat == c[0] ? C.primary : C.slate200),
                  ),
                  child: Row(children: [
                    Text(c[0], style: ts(13, w: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Tag(c[1], fg: C.navy, bg: C.blueHigh, radius: 999),
                  ]),
                ),
              ),
            ),
        ]),
      ),
      const SizedBox(height: 14),
      if (_loading)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (_workers.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(child: Text('No crew match your filters.', style: ts(14, color: C.slate600))),
        )
      else
        for (final w in _workers) ...[_card(w), const SizedBox(height: 14)],
      AppCard(
        color: C.blueLow,
        border: C.blueHigh,
        child: Row(children: [
          const IconBox(Icons.lock_outline, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('100% Escrow Protected', style: ts(14, w: FontWeight.w700)),
              Text('Shift funds are safely held in escrow and released only after your supervisor digital sign-off.',
                  style: ts(12, color: C.slate700, height: 1.35)),
            ]),
          ),
        ]),
      ),
    ]);
  }

  Widget _card(_Worker w) {
    final icon = w.metaKind == 'clock'
        ? Icons.schedule
        : w.metaKind == 'pin'
            ? Icons.place_outlined
            : Icons.check_circle_outline;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Avatar(w.name, size: 52, dot: C.greenMid),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: Text(w.name, style: ts(17, w: FontWeight.w700))),
                const SizedBox(width: 4),
                const Icon(Icons.verified_outlined, size: 18, color: C.greenMid),
              ]),
              Text(w.role, style: ts(12, color: C.slate600, height: 1.3)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(inr(w.rate), style: ts(19, w: FontWeight.w800, color: C.navy)),
            Text('/hr', style: ts(12, color: C.slate600)),
          ]),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (var i = 0; i < w.badges.length; i++)
            w.badges[i].startsWith('Replies')
                ? Tag(w.badges[i], fg: C.navy, bg: C.blueHigh, icon: Icons.bolt, size: 11)
                : Tag(w.badges[i], fg: C.green, bg: C.greenBg50, border: C.greenBorder, size: 11, icon: Icons.verified_user_outlined),
        ]),
        const SizedBox(height: 10),
        MetricBox(
          color: C.blueLow,
          child: Row(children: [
            const Icon(Icons.star_border, size: 18, color: C.amber),
            const SizedBox(width: 4),
            Text('${w.rating}', style: ts(13, w: FontWeight.w800)),
            const SizedBox(width: 4),
            Flexible(child: Text(w.stat, style: ts(12, color: C.slate600))),
            const Spacer(),
            Icon(icon, size: 16, color: C.navy),
            const SizedBox(width: 4),
            Flexible(child: Text(w.meta, style: ts(12, w: FontWeight.w600), textAlign: TextAlign.right)),
          ]),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final s in w.skills) Tag(s, fg: C.navy, bg: C.blueLow, size: 11),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: AppButton('View Profile', kind: BtnKind.tonal, height: 44, onPressed: () => _profile(w))),
          const SizedBox(width: 10),
          Expanded(
            child: AppButton('Direct Hire',
                icon: Icons.arrow_forward, iconAfter: true, height: 44, onPressed: () => _hire(w)),
          ),
        ]),
      ]),
    );
  }
}
