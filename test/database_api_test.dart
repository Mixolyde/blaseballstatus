import 'package:test/test.dart';

import '../lib/database_api.dart';

void main() {
  apiTests();
}

void apiTests() {
  group('api tests', () {
    test('Current Season', () {
      expect(getCurrentSeason(), equals(5));
    });
  });

}
