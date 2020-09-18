import 'package:test/test.dart';

import '../lib/calc_stats.dart';

void main() {
  group('calc tests', () {
    test('Format games behind', () {
      expect(formatGamesBehind(0), "0");
      expect(formatGamesBehind(1), "1")2
      expect(formatGamesBehind(0.5), "½");
      expect(formatGamesBehind(1.5), "1½");
      expect(formatGamesBehind(2.5), "2½");
    });  
  });

}

