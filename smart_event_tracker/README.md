# Smart Event Tracker (Flutter)

Flutter conversion of the Stitch designs in `stitch_smart_eventtracker.zip`.
Two products in one app, chosen from a launcher screen:

**SmartQueue** (Inter font) — Get Token · My Queue · Counters · Analytics
**CrewMatch** (Noto Sans font) — Browse Crew · Post Shift · Roster · Payouts

Colours, radii and typography come from the two `DESIGN.md` files
(ClearRoute Utility / Workforce Blueprint). The logos are drawn with
`CustomPaint`, so no image or SVG assets are needed.

## Run it

This zip contains the Dart source only (`lib/`, `test/`, `pubspec.yaml`).
Generate the Android/iOS/web runner folders once, then run:

```bash
cd smart_event_tracker
flutter create . --org com.example --project-name smart_event_tracker
flutter pub get
flutter run
```

Requires Flutter 3.19+ (Dart 3.3+). Fonts are fetched at runtime by the
`google_fonts` package, so the first launch needs internet access.

## What works

* Get Token: service selection, form validation, live ETA, token creation
  (shows up on My Queue; "Leave Queue" clears it)
* Counters: All/Active/Break filter, "Call Next" advances the serving token
* Analytics: Today / This Week / Monthly switch (sample numbers)
* Browse Crew: live search, filter chips, category filter, profile sheet, hire dialog
* Post Shift: role picker, headcount stepper, wage field; the escrow total
  recalculates live (staff × 8 hrs × wage + 5 %)
* Payouts: resolve the overtime discrepancy and the release total updates

## Not real yet

All data is hard-coded sample data and buttons such as Broadcast, CSV export,
Fund Escrow and Release Payments show a confirmation only. Hook them to your
backend / IoT feed / payment provider. "My Queue" had no mock-up, so it was
designed from the design system.

## Layout

```
lib/
  main.dart                 app entry
  theme.dart                colour tokens + text style helper
  widgets.dart              shared UI (header, nav, cards, tags, buttons)
  queue_state.dart          token shared by Get Token / My Queue
  screens/launcher_screen.dart
  screens/queue/            SmartQueue screens
  screens/crew/             CrewMatch screens
test/widget_test.dart       unit tests for formatting helpers
```
