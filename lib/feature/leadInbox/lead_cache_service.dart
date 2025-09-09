import 'package:hive/hive.dart';
import 'package:newsee/AppData/app_constants.dart';

class LeadCacheService {
  static const String boxName = AppConstants.inboxName;

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static Future<void> savePage(
    String inbox,
    int pageNo,
    Map<String, dynamic> data,
  ) async {
    final box = Hive.box(boxName);
    print(data);
    await box.put('${inbox}_$pageNo', data);
  }

  static Map<String, dynamic>? getPage(String inbox, int pageNo) {
    try {
      final box = Hive.box(boxName);
      final rawdata = box.get('${inbox}_$pageNo');
      if (rawdata == null) return null;
      final data = Map<String, dynamic>.from(rawdata);
      return data;
    } catch (e) {
      print('getLeads: $e');
      return null;
    }
  }

  static Future<void> clearCache() async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
