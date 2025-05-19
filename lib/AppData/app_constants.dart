class AppConstants {
  static final RegExp PATTERN_SPECIALCHAR = RegExp(
    r'[\*\%!$\^.,;:{}\(\)\-_+=\[\]]',
  );

  static final RegExp PATTER_ONLYALPHABET = RegExp(r'(\w+)');

  static const String apiUrl =
      'https://losmobileuat.psb.co.in:542/psblendperfect/mobility/';

  static const databaseName = 'ubi.db';

  static final String dbTablesFilePath = 'assets/db_tables.txt';

  // database table names
  static const String staticDataTable = 'staticDataMaster';
  static const String stateDataTable = 'stateDataMaster';
  static const String districtDataTable = 'districtDataMaster';
  static const String branchDataTable = 'branchDataMaster';

  // API's names
  static const String staticMasterAPI = 'AppMasterData';

  static final List<String> lovMastersList = [
    'state',
    'district',
    'branch',
    'static',
  ];

  // static lov master requests data
  static final List<Map<String, dynamic>> staticMasterReqData = [
    {'masterfor': 'constitution', 'id': '2'},
    {'masterfor': 'title', 'id': '1'},
    {'masterfor': 'gender', 'id': ''},
    {'masterfor': 'module', 'id': ''},
    {'masterfor': 'leadBy', 'id': ''},
    {'masterfor': 'visitList', 'id': '410'},
    {'masterfor': 'ownershipStatus', 'id': '411'},
    {'masterfor': 'buildingType', 'id': '412'},
    {'masterfor': 'borrRelationship', 'id': '413'},
    {'masterfor': 'yesNo', 'id': '414'},
    {'masterfor': 'leadDocList', 'id': '415'},
    {'masterfor': 'selVisitFor', 'id': '427'},
  ];
}
