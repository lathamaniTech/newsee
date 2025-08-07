import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsee/feature/draft/domain/draft_lead_model.dart';

class DraftService {
  static const String _draftKeyPrefix = 'draft_';
  static String leadref = '';

  /// Save or update a specific tab data for a lead
  Future<void> saveOrUpdateTabData({
    String? leadrefOverride,
    required String tabKey, // 'loan', 'personal', etc.
    required dynamic tabData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    print('leadref: $leadrefOverride, $tabData');
    if (tabKey == 'loan') {
      // Generate leadref on loan tab only
      leadref = DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      // Use existing leadref
      // if (leadref.isEmpty && leadrefOverride == null) {
      //   throw Exception('LeadRef not initialized. Save loan tab first.');
      // }
      leadref = leadrefOverride ?? leadref;
    }

    final key = '$_draftKeyPrefix$leadref';

    final Map<String, dynamic> currentData;
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      currentData = jsonDecode(jsonString);
      currentData[tabKey] = tabData;
      await prefs.setString(key, jsonEncode(currentData));
    } else {
      // First save (i.e., loan tab), create structure
      currentData = {
        'leadref': leadref,
        'loan': {},
        'dedupe': {},
        'personal': {},
        'address': {},
        'coapplicant': [],
      };
      currentData[tabKey] = tabData;
      await prefs.setString(key, jsonEncode(currentData));
    }
  }

  /// Get full draft by lead reference
  Future<DraftLead?> getDraft(String leadref) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_draftKeyPrefix$leadref';
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;
    print('getDraft:  $jsonString');
    return DraftLead.fromJson(jsonDecode(jsonString));
  }

  Future<void> deleteDraft(String leadref) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_draftKeyPrefix$leadref';
    await prefs.remove(key);
  }

  /// Get list of all leadrefs with saved drafts
  Future<List<String>> getAllDraftLeadRefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('datadraft:  $keys');
    return keys
        .where((k) => k.startsWith(_draftKeyPrefix))
        .map((k) => k.replaceFirst(_draftKeyPrefix, ''))
        .toList();
  }

  /// Optional method: return currently active leadref
  String getCurrentLeadRef() {
    return leadref;
  }
}
