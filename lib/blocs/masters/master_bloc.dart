import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'masters_event.dart';
import 'masters_state.dart';
import '../../DataProviders/api_service.dart';
import '../../DataProviders/db_service.dart';
import '../../AppData/app_constants.dart';

/*
  @author         :   Lathamani  14-05-2025
  @description    :   MastersBloc class for masters data fetch from api's and saved into database after success.
                      it implemented with MastersEvent, MastersState to dispatch the events, status of each masters
  */

class MastersBloc extends Bloc<MastersEvent, MastersState> {
  final Map<String, String> masterTypeMap = {
    'state': 'state',
    'district': 'district',
    'branch': 'branchList',
  };

  MastersBloc() : super(MastersState.initial()) {
    on<UpdateMaster>((event, emit) async {
      await _sequenceMasterUpdates(emit);
    });
  }

  /* this is passing masters type taken from list like (state, district, branch) 
  to fetch data and after success of previous pass another */

  Future<void> _sequenceMasterUpdates(Emitter<MastersState> emit) async {
    final types = AppConstants.lovMastersList;
    for (final type in types) {
      if (type != 'static') {
        final success = await _onUpdateMaster(type, emit, isChained: true);
        // if (!success) break; // stop chain if one fails
      } else {
        await fetchAllStaticMasters(type, emit);
      }
    }
  }

  /*
  @author         :   Lathamani  14-05-2025
  @description    :   this method returns a true or false after fetch data from api one by one and save in database 
                      and update masters Status
  */
  Future<bool> _onUpdateMaster(
    String type,
    Emitter<MastersState> emit, {
    bool isChained = false,
  }) async {
    // final type = event.type;
    emit(state.copyWith(loading: {...state.loading, type: true}));

    try {
      final reqData = {'masterfor': masterTypeMap[type] ?? type, 'id': ''};
      final data = await ApiService.restAPICall(
        AppConstants.staticMasterAPI,
        reqData,
      );

      if (data != null && data['Status'] == 'Success') {
        final List<dynamic> resData = data['Response'];

        if (type == 'state' && resData.isNotEmpty) {
          await insertResponseDataIntoTable(
            AppConstants.stateDataTable,
            resData,
            ['code', 'desc'],
          );
        } else if (type == 'district') {
          await insertResponseDataIntoTable(
            AppConstants.districtDataTable,
            resData,
            ['code', 'desc'],
          );
        } else if (type == 'branch') {
          await insertResponseDataIntoTable(
            AppConstants.branchDataTable,
            resData,
            ['code', 'desc', 'username'],
          );
        }

        emit(
          state.copyWith(
            loading: {...state.loading, type: false},
            done: {...state.done, type: true},
          ),
        );

        return true;
      } else {
        throw Exception('API failure or invalid response');
      }
    } catch (e) {
      print('Error updating $type: $e');
      emit(state.copyWith(loading: {...state.loading, type: false}));
      return false;
    }
  }

  // this method is for delete data from table and save into table when call masters api's
  Future<void> insertResponseDataIntoTable(
    String tableName,
    List<dynamic> respData,
    List<String> columnNames,
  ) async {
    await DBService.deleteTablesData(tableName);
    for (var item in respData) {
      await DBService.basicInsert(
        tableName,
        columnNames,
        columnNames.map((col) => col == item[col]).toList(),
      );
    }
  }

  // this method is for static lov masters data fetching

  Future<void> fetchAllStaticMasters(
    String type,
    Emitter<MastersState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: {...state.loading, type: true}));

      final staticDataRequestList = AppConstants.staticMasterReqData;

      final List<List<dynamic>> staticDataList = [];

      for (int i = 0; i < staticDataRequestList.length; i++) {
        try {
          final res = await ApiService.restAPICall(
            AppConstants.staticMasterAPI,
            staticDataRequestList[i],
          );
          if (res != null && res['Status'] == 'Success') {
            staticDataList.add(res['Response']);
          } else {
            throw Exception(
              'Failed for ${staticDataRequestList[i]['masterfor']}',
            );
          }
        } catch (e) {
          print('Static data failed: $e');
          return;
        }
      }

      await DBService.deleteTablesData(AppConstants.staticDataTable);
      for (int i = 0; i < staticDataList.length; i++) {
        for (var item in staticDataList[i]) {
          await DBService.basicInsert(
            AppConstants.staticDataTable,
            ['code', 'desc', 'master_id'],
            [item['code'], item['desc'], i.toString()],
          );
        }
      }

      await setGlobalStaticData(); // Custom mapping logic

      emit(
        state.copyWith(
          loading: {...state.loading, type: false},
          done: {...state.done, type: true},
        ),
      );
    } catch (e) {
      print('fetchStaticDataMaster- $e');
    }
  }

  Future<void> setGlobalStaticData() async {
    final staticData = await DBService.getAllData(AppConstants.staticDataTable);
    print(staticData);
    final mappings = {
      '0': (data) => Globalconfig.setConstitution(data),
      '1': (data) => Globalconfig.setTitle(data),
      '2': (data) => Globalconfig.setGender(data),
      '3': (data) => Globalconfig.setModule(data),
      '4': (data) => Globalconfig.setLeadBy(data),
    };

    for (final entry in mappings.entries) {
      final data =
          staticData.where((e) => e['master_id'] == entry.key).toList();
      if (data.isNotEmpty) {
        entry.value(data);
      }
    }

    // Optionally update UI state data too
    final states = await DBService.getAllData(
      AppConstants.stateDataTable,
      'desc',
    );
    final districts = await DBService.getAllData(
      AppConstants.districtDataTable,
      'desc',
    );
    final branches = await DBService.getAllData(
      AppConstants.branchDataTable,
      'desc',
    );

    Globalconfig.setStateData(states);
    Globalconfig.setDistrictData(districts);
    Globalconfig.setBranchData(branches);
  }
}
