import 'package:hive/hive.dart';
import 'package:newsee/AppData/app_constants.dart';

class HiveCacheService {
  static const String boxName = AppConstants.proposalApp;

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static Future<void> savePage(
    String pageName,
    String proposal,
    Map<String, dynamic> data,
  ) async {
    final box = Hive.box(boxName);
    print(data);
    await box.put('${pageName}_$proposal', data);
  }

  static Map<String, dynamic>? getPage(String pageName, String proposal) {
    try {
      final box = Hive.box(boxName);
      final rawdata = box.get('${pageName}_$proposal');
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
