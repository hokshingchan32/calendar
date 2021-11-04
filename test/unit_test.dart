import 'package:flutter_calendar/util/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('datetime round with 15minutes test', () {
    final now1 = DateTime(2021, 11, 2, 10, 8, 0);

    final nowFifteen1 = Util.roundWithFifteen(now1);

    expect(nowFifteen1, DateTime(2021, 11, 2, 10, 15, 0));

    final now2 = DateTime(2021, 11, 1, 23, 55, 0);
    final nowFifteen2 = Util.roundWithFifteen(now2);

    expect(nowFifteen2, DateTime(2021, 11, 2, 0, 0, 0));

    final now3 = DateTime(2021, 10, 1, 0, 0, 0);
    final nowFifteen3 = Util.roundWithFifteen(now3);

    expect(nowFifteen3, DateTime(2021, 10, 1, 0, 0, 0));

    final now4 = DateTime(2021, 12, 31, 23, 58, 0);
    final nowFifteen4 = Util.roundWithFifteen(now4);

    expect(nowFifteen4, DateTime(2022, 1, 1, 0, 0, 0));

    final now5 = DateTime(2021, 10, 10, 10, 15, 0);
    final nowFifteen5 = Util.roundWithFifteen(now5);

    expect(nowFifteen5, DateTime(2021, 10, 10, 10, 15, 0));
  });
}
