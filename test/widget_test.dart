import 'package:flutter_test/flutter_test.dart';
import 'package:smart_event_tracker/widgets.dart';

void main() {
  test('inr formats with Indian digit grouping', () {
    expect(inr(750), '₹750');
    expect(inr(25200), '₹25,200');
    expect(inr(125000), '₹1,25,000');
    expect(inr(10000000), '₹1,00,00,000');
  });

  test('fmtTime uses a 12-hour clock', () {
    expect(fmtTime(DateTime(2025, 1, 1, 0, 5)), '12:05 AM');
    expect(fmtTime(DateTime(2025, 1, 1, 13, 30)), '1:30 PM');
  });
}
