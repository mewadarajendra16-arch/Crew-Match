import 'package:flutter/material.dart';
import 'theme.dart';

/// Indian digit grouping, e.g. 125000 -> ₹1,25,000
String inr(num v) {
  final s = v.round().toString();
  if (s.length <= 3) return '₹$s';
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '₹${parts.join(',')},$last3';
}

String fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
}

void toast(BuildContext context, String msg) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(content: Text(msg)));
}

// ───────────────────────── Logos ─────────────────────────

class Logo extends StatelessWidget {
  final bool crew;
  final double size;
  const Logo({super.key, required this.crew, this.size = 36});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _LogoPainter(crew));
}

class _LogoPainter extends CustomPainter {
  final bool crew;
  _LogoPainter(this.crew);

  @override
  void paint(Canvas canvas, Size s) {
    final k = s.width / 100;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, s.width, s.height), Radius.circular((crew ? 18 : 20) * k)),
      Paint()..color = C.primary,
    );
    if (!crew) {
      void dot(double x, double r, double a) => canvas.drawCircle(
          Offset(x * k, 50 * k), r * k, Paint()..color = Color.fromRGBO(255, 255, 255, a));
      dot(34, 10, 0.4);
      dot(50, 12, 0.75);
      dot(68, 15, 1);
      final chevron = Path()
        ..moveTo(68 * k, 40 * k)
        ..lineTo(76 * k, 50 * k)
        ..lineTo(68 * k, 60 * k);
      canvas.drawPath(
        chevron,
        Paint()
          ..color = C.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * k
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    } else {
      canvas.drawCircle(Offset(50 * k, 38 * k), 16 * k, Paint()..color = C.white);
      final body = Path()
        ..moveTo(26 * k, 78 * k)
        ..cubicTo(26 * k, 62 * k, 40 * k, 56 * k, 50 * k, 56 * k)
        ..cubicTo(60 * k, 56 * k, 74 * k, 62 * k, 74 * k, 78 * k)
        ..close();
      canvas.drawPath(body, Paint()..color = const Color.fromRGBO(255, 255, 255, 0.9));
      canvas.drawCircle(Offset(68 * k, 62 * k), 11 * k, Paint()..color = C.greenMid);
      final tick = Path()
        ..moveTo(63 * k, 62 * k)
        ..lineTo(67 * k, 66 * k)
        ..lineTo(74 * k, 58 * k);
      canvas.drawPath(
        tick,
        Paint()
          ..color = C.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * k
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ───────────────────────── Header & Nav ─────────────────────────

class BrandHeader extends StatelessWidget {
  final bool crew;
  final String? section;
  final VoidCallback onSwitch;
  const BrandHeader({super.key, required this.crew, this.section, required this.onSwitch});

  void _profileSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: C.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: C.navy),
            title: Text('Switch app', style: ts(15, w: FontWeight.w600)),
            subtitle: Text('Go back to the launcher', style: ts(12, color: C.slate600)),
            onTap: () {
              Navigator.pop(ctx);
              onSwitch();
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: C.surface,
        border: Border(bottom: BorderSide(color: C.slate200)),
      ),
      child: Row(children: [
        Logo(crew: crew, size: 36),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: crew ? 'CrewMatch' : 'SmartQueue',
                      style: ts(19, w: FontWeight.w800, color: C.navy)),
                  if (section != null)
                    TextSpan(text: ' / $section', style: ts(15, w: FontWeight.w600)),
                ]),
              ),
              if (crew)
                Text('Event Staffing / On-Demand',
                    style: ts(11, w: FontWeight.w600, color: C.slate600))
              else
                Row(children: [
                  Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(color: C.greenMid, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('IOT LIVE STREAM',
                      style: ts(11, w: FontWeight.w700, color: C.slate600, ls: 0.4)),
                ]),
            ],
          ),
        ),
        if (crew)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.notifications_none, color: C.navy, size: 26),
              Positioned(
                right: 1,
                top: 1,
                child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle)),
              ),
            ]),
          ),
        InkWell(
          onTap: () => _profileSheet(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: C.navy, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.person, color: C.white, size: 20),
          ),
        ),
      ]),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

class AppBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.items, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: C.white,
        border: Border(top: BorderSide(color: C.slate200)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(items[i].icon, size: 24, color: i == index ? C.primary : C.slate600),
                    const SizedBox(height: 3),
                    Text(items[i].label,
                        style: ts(11,
                            w: i == index ? FontWeight.w700 : FontWeight.w500,
                            color: i == index ? C.primary : C.slate600)),
                  ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

// ───────────────────────── Building blocks ─────────────────────────

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color border;
  final Color? accent;
  final double radius;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = C.white,
    this.border = C.slate200,
    this.accent,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Padding(padding: padding, child: child);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border),
      ),
      child: accent == null
          ? inner
          : IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(width: 4, color: accent),
                Expanded(child: inner),
              ]),
            ),
    );
  }
}

class Tag extends StatelessWidget {
  final String text;
  final Color fg;
  final Color bg;
  final Color? border;
  final IconData? icon;
  final double radius;
  final double size;
  const Tag(
    this.text, {
    super.key,
    this.fg = C.slate600,
    this.bg = C.slate100,
    this.border,
    this.icon,
    this.radius = 4,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: size + 2, color: fg),
          const SizedBox(width: 4),
        ],
        Flexible(child: Text(text, style: ts(size, w: FontWeight.w700, color: fg))),
      ]),
    );
  }
}

enum BtnKind { primary, tonal, outline, danger, dangerSoft }

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool iconAfter;
  final VoidCallback? onPressed;
  final BtnKind kind;
  final double height;
  const AppButton(
    this.label, {
    super.key,
    this.icon,
    this.iconAfter = false,
    required this.onPressed,
    this.kind = BtnKind.primary,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    Color? bd;
    switch (kind) {
      case BtnKind.primary:
        bg = onPressed == null ? C.slate300 : C.primary;
        fg = C.white;
        break;
      case BtnKind.tonal:
        bg = C.blueHigh;
        fg = C.navy;
        break;
      case BtnKind.outline:
        bg = C.white;
        fg = C.primary;
        bd = C.primary;
        break;
      case BtnKind.danger:
        bg = const Color(0xFFDC2626);
        fg = C.white;
        break;
      case BtnKind.dangerSoft:
        bg = const Color(0xFFFEE2E2);
        fg = C.red;
        break;
    }
    final iconW = icon == null ? null : Icon(icon, size: 18, color: fg);
    return Material(
      color: bg,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: bd == null ? BorderSide.none : BorderSide(color: bd, width: 1.5),
      ),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (iconW != null && !iconAfter) ...[iconW, const SizedBox(width: 8)],
                Flexible(
                  child: Text(label,
                      textAlign: TextAlign.center,
                      style: ts(14, w: FontWeight.w700, color: fg, height: 1.2)),
                ),
                if (iconW != null && iconAfter) ...[const SizedBox(width: 8), iconW],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final String name;
  final double size;
  final Color? dot;
  const Avatar(this.name, {super.key, this.size = 52, this.dot});

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts.take(2).map((p) => p.isEmpty ? '' : p[0].toUpperCase()).join();
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: C.blueHigh, borderRadius: BorderRadius.circular(10)),
        child: Text(initials, style: ts(size * 0.36, w: FontWeight.w800, color: C.navy)),
      ),
      if (dot != null)
        Positioned(
          right: -3,
          bottom: -3,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
                color: dot, shape: BoxShape.circle, border: Border.all(color: C.white, width: 2)),
          ),
        ),
    ]);
  }
}

class SegTabs extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  const SegTabs({super.key, required this.labels, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: C.blue, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == index ? C.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(labels[i],
                    style: ts(13,
                        w: i == index ? FontWeight.w700 : FontWeight.w500,
                        color: i == index ? C.navy : C.slate600)),
              ),
            ),
          ),
      ]),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionTitle(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: ts(18, w: FontWeight.w700))),
      if (trailing != null) Text(trailing!, style: ts(12, w: FontWeight.w700, color: C.navy)),
    ]);
  }
}

class IconBox extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final double size;
  const IconBox(this.icon, {super.key, this.bg = C.blueHigh, this.fg = C.navy, this.size = 40});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: fg, size: size * 0.5),
      );
}

/// Small light-fill box used for token / metric read-outs.
class MetricBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const MetricBox({
    super.key,
    required this.child,
    this.color = C.blueLow,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: C.slate200),
        ),
        child: child,
      );
}
