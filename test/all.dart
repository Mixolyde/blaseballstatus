library all_tests;

import 'calc_stats_test.dart' as calc_stats_test;
import 'database_api_test.dart' as database_api_test;
import 's3_api_test.dart' as s3_api_test;
import 'site_objects_test.dart' as site_objects_test;
import 'sim_postseason_test.dart' as sim_postseason_test;
import 'sim_season_test.dart' as sim_season_test;
import 'update_stats_test.dart' as update_stats_test;

void main() async {
  calc_stats_test.main();
  database_api_test.main();
  s3_api_test.main();
  site_objects_test.main();
  //await sim_postseason_test.main();
  //await sim_season_test.main();
  update_stats_test.main();
  
}