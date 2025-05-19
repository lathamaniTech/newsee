class Globalconfig {
  static final bool isInitialRoute = false;

  static List<Map<String, dynamic>> _stateData = [];
  static List<Map<String, dynamic>> _districtData = [];
  static List<Map<String, dynamic>> _branchData = [];
  static List<Map<String, dynamic>> _staticData = [];
  static List<Map<String, dynamic>> _gender = [];
  static List<Map<String, dynamic>> _leadBy = [];
  static List<Map<String, dynamic>> _module = [];
  static List<Map<String, dynamic>> _title = [];

  // setters for masters data

  static void setStateData(List<Map<String, dynamic>> data) {
    _stateData = data;
  }

  static void setDistrictData(List<Map<String, dynamic>> data) {
    _districtData = data;
  }

  static void setBranchData(List<Map<String, dynamic>> data) {
    _branchData = data;
  }

  static void setStaticData(List<Map<String, dynamic>> data) {
    _staticData = data;
  }

  static void setConstitution(List<Map<String, dynamic>> data) {}

  static void setTitle(List<Map<String, dynamic>> data) {
    _title = data;
  }

  static void setVisitFor(List<Map<String, dynamic>> data) {}
  static void setGender(List<Map<String, dynamic>> data) {
    _gender = data;
  }

  static void setModule(List<Map<String, dynamic>> data) {
    _module = data;
  }

  static void setLeadBy(List<Map<String, dynamic>> data) {
    _leadBy = data;
  }

  // Getters for masters
  List<Map<String, dynamic>> get stateData => _stateData;
  List<Map<String, dynamic>> get districtData => _districtData;
  List<Map<String, dynamic>> get branchData => _branchData;
  List<Map<String, dynamic>> get staticData => _staticData;
  List<Map<String, dynamic>> get constitution => _staticData;
  List<Map<String, dynamic>> get titleData => _title;
  List<Map<String, dynamic>> get gender => _gender;
  List<Map<String, dynamic>> get leadByData => _leadBy;
  List<Map<String, dynamic>> get moduleData => _module;
}
