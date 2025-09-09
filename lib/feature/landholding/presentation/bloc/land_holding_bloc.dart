import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/geographymaster_response_mapper.dart';
import 'package:newsee/Utils/hive_cache_service.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/addressdetails/data/repository/citylist_repo_impl.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/landholding/data/repository/land_Holding_respository_impl.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/landholding/domain/modal/Land_Holding_delete_request.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:newsee/AppData/app_constants.dart';

part 'land_holding_event.dart';
part 'land_holding_state.dart';

final class LandHoldingBloc extends Bloc<LandHoldingEvent, LandHoldingState> {
  LandHoldingBloc() : super(LandHoldingState.init()) {
    on<LandHoldingInitEvent>(initLandHoldingDetails);
    on<LandDetailsSaveEvent>(_onSubmit);
    on<LandDetailsLoadEvent>(_onLoad);
    on<OnStateCityChangeEvent>(getCityListBasedOnState);
    on<LandDetailsDeleteEvent>(_onDelete);
  }

  // Future initLandHoldingDetails(
  //   LandHoldingInitEvent event,
  //   Emitter emit,
  // ) async {
  //   Database _db = await DBConfig().database;
  //   List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
  //   List<GeographyMaster> stateCityMaster = await GeographymasterCrudRepo(
  //     _db,
  //   ).getByColumnNames(
  //     columnNames: [
  //       TableKeysGeographyMaster.stateId,
  //       TableKeysGeographyMaster.cityId,
  //     ],
  //     columnValues: ['0', '0'],
  //   );
  //   final cachedData = HiveCacheService.getPage('land');
  //   print('cachedData $cachedData');
  //   if (cachedData == null || event.isRefresh == true) {
  //     final LandHoldingRepository landHoldingRepository =
  //         LandHoldingRespositoryImpl();

  //     final response = await landHoldingRepository.getLandholding(
  //       event.proposalNumber,
  //     );

  //     if (response.isRight()) {
  //       List<LandData> landData =
  //           response.right.agriLandHoldingsList
  //               .map((e) => LandData.fromMap(e))
  //               .toList();
  //       print("LandData from response at get=> $landData");

  //       List<GeographyMaster>? cityMaster = [];

  //       for (var i = 0; i < landData.length; i++) {
  //         List<GeographyMaster>? coappCityList = await getCityMaster(
  //           landData[i].lslLandState,
  //           null,
  //         );
  //         cityMaster.addAll(coappCityList ?? []);
  //       }
  //       print(response.right.agriLandHoldingsList);
  //       await HiveCacheService.savePage('land', {
  //         'landRes': response.right.agriLandHoldingsList,
  //       });

  //       emit(
  //         state.copyWith(
  //           lovlist: listOfLov,
  //           status: SaveStatus.init,
  //           stateCityMaster: stateCityMaster,
  //           cityMaster: cityMaster,
  //           landData: landData,
  //         ),
  //       );
  //     } else {
  //       emit(
  //         state.copyWith(
  //           lovlist: listOfLov,
  //           status: SaveStatus.init,
  //           stateCityMaster: stateCityMaster,
  //         ),
  //       );
  //     }
  //   } else {
  //     print(cachedData['landRes']);
  //     List<LandData> landData =
  //         (cachedData['landRes'] as List)
  //             .map((e) => LandData.fromMap(Map<String, dynamic>.from(e)))
  //             .toList();
  //     print("LandData from response at get=> $landData");

  //     List<GeographyMaster>? cityMaster = [];

  //     for (var i = 0; i < landData.length; i++) {
  //       List<GeographyMaster>? coappCityList = await getCityMaster(
  //         landData[i].lslLandState,
  //         null,
  //       );
  //       cityMaster.addAll(coappCityList ?? []);
  //     }
  //     emit(
  //       state.copyWith(
  //         lovlist: listOfLov,
  //         status: SaveStatus.init,
  //         stateCityMaster: stateCityMaster,
  //         cityMaster: cityMaster,
  //         landData: landData,
  //       ),
  //     );
  //   }
  // }

  Future<void> initLandHoldingDetails(
    LandHoldingInitEvent event,
    Emitter emit,
  ) async {
    final db = await DBConfig().database;

    final listOfLov = await LovCrudRepo(db).getAll();
    final stateCityMaster = await GeographymasterCrudRepo(db).getByColumnNames(
      columnNames: [
        TableKeysGeographyMaster.stateId,
        TableKeysGeographyMaster.cityId,
      ],
      columnValues: ['0', '0'],
    );

    final cachedData = HiveCacheService.getPage('land', event.proposalNumber);
    print('cachedData $cachedData');

    List<LandData> landData = [];
    List<GeographyMaster> cityMaster = [];

    if (cachedData == null || event.isRefresh == true) {
      emit(state.copyWith(status: SaveStatus.loading));
      final repo = LandHoldingRespositoryImpl();
      final response = await repo.getLandholding(event.proposalNumber);

      if (response.isRight()) {
        final respLandData = response.right.agriLandHoldingsList;
        landData = mapToLandData(respLandData);
        cityMaster = await getCityMasterCall(landData);

        print("LandData from API => $landData");

        await HiveCacheService.savePage('land', event.proposalNumber, {
          'landRes': respLandData,
          'proposal': event.proposalNumber,
        });

        emit(state.copyWith(status: SaveStatus.success));
      } else {
        emit(state.copyWith(status: SaveStatus.success));
        await HiveCacheService.savePage('land', event.proposalNumber, {
          'landRes': [],
          'proposal': event.proposalNumber,
        });
      }
    } else {
      final landRes = cachedData['landRes'] as List;
      landData = landRes.isNotEmpty ? mapToLandData(landRes) : [];
      cityMaster = landData.isNotEmpty ? await getCityMasterCall(landData) : [];
      print("LandData from cache => $landData");
    }

    emit(
      state.copyWith(
        lovlist: listOfLov,
        status: SaveStatus.init,
        stateCityMaster: stateCityMaster,
        cityMaster: cityMaster,
        landData: landData,
      ),
    );
  }

  List<LandData> mapToLandData(List rawData) {
    return rawData
        .map((e) => LandData.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<GeographyMaster>> getCityMasterCall(
    List<LandData> landData,
  ) async {
    final result = <GeographyMaster>[];
    for (final land in landData) {
      final coappCityList = await getCityMaster(land.lslLandState, null);
      result.addAll(coappCityList ?? []);
    }
    return result;
  }

  // Save new land data
  Future<void> _onSubmit(
    LandDetailsSaveEvent event,
    Emitter<LandHoldingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      // final newList = [...?state.landData, event.landData as LandData];
      print("event.landData not a map => ${event.landData}");
      final landdata = event.landData;
      final proposalNo = event.proposalNumber;
      print("event.landData => $landdata");

      LandHoldingRequest req = LandHoldingRequest(
        proposalNumber: event.proposalNumber,
        applicantName: event.landData['applicantName'] ?? '',
        LandOwnedByApplicant:
            event.landData['landOwnedByApplicant'] ? 'Y' : 'N',
        LocationOfFarm: event.landData['locationOfFarm'] ?? '',
        DistanceFromBranch: event.landData['distanceFromBranch'] ?? '',
        State: event.landData['state'] ?? '',
        District: event.landData['district'] ?? '',
        Taluk: event.landData['taluk'] ?? '',
        Village: event.landData['village'] ?? '',
        Firka: event.landData['firka'] ?? '',
        SurveyNo: event.landData['surveyNo'] ?? '',
        TotalAcreage: event.landData['totalAcreage'] ?? '',
        NatureOfRight: event.landData['natureOfRight'] ?? '',
        OutOfTotalAcreage: event.landData['irrigatedLand'] ?? '',
        NatureOfIrrigation: event.landData['irrigationFacilities'] ?? '',
        LandsSituatedCompactBlocks: event.landData['compactBlocks'] ? '1' : '2',
        landCeilingEnactments: event.landData['affectedByCeiling'] ? '1' : '2',
        villageOfficersCertificate:
            event.landData['villageOfficerCertified'] ? '1' : '2',
        LandAgriculturellyActive: event.landData['landAgriActive'] ? '1' : '2',
        rowId:
            event.landData['lslLandRowid'] != null
                ? int.parse(event.landData['lslLandRowid'])
                : null,
        token: ApiConstants.api_qa_token,
      );

      final landReq = req;
      print('final request for land holding => $landReq');

      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();
      final response = await landHoldingRepository.submitLandHolding(landReq);

      if (response.isRight()) {
        List<LandData> landData =
            response.right.agriLandHoldingsList
                .map((e) => LandData.fromMap(e))
                .toList();

        print("LandData from response => $landData");
        emit(
          state.copyWith(
            status: SaveStatus.success,
            landData: landData,
            selectedLandData: null,
            errorMessage: null,
          ),
        );
        await HiveCacheService.savePage('land', event.proposalNumber, {
          'landRes': response.right.agriLandHoldingsList,
        });
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure,
            errorMessage: response.left.message,
          ),
        );
      }
    } catch (e) {
      print("Error in LandDetailsSaveEvent: $e");
      emit(
        state.copyWith(status: SaveStatus.failure, errorMessage: e.toString()),
      );
      return;
    }
  }

  // Load data into form for editing
  void _onLoad(LandDetailsLoadEvent event, Emitter<LandHoldingState> emit) {
    emit(
      state.copyWith(
        status: SaveStatus.update,
        selectedLandData: event.landData,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onDelete(LandDetailsDeleteEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      final LandHoldingDeleteRequest landDeleteReq = LandHoldingDeleteRequest(
        proposalNumber: event.landData.lslPropNo.toString(),
        rowId: event.landData.lslLandRowid.toString(),
        token: ApiConstants.api_qa_token,
      );

      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();
      final response = await landHoldingRepository.deleteLandHoldingData(
        landDeleteReq,
      );
      if (response.isRight()) {
        List<LandData> landDetailsList = state.landData!;
        landDetailsList.removeAt(event.index);
        print("final landDetailsList $landDetailsList");
        emit(
          state.copyWith(
            status: SaveStatus.delete,
            errorMessage: response.right,
            landData: landDetailsList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure,
            errorMessage: response.left.message,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      print("LandDetailsDeleteEvent-error $error");
    }
  }

  Future<void> getCityListBasedOnState(
    OnStateCityChangeEvent event,
    Emitter emit,
  ) async {
    /** 
     * @modified    : karthick.d 22/06/2025
     * 
     * @reson       : geograhy master parsing logic should be kept as function 
     *                so it the logic can be reused across various bLoC
     * 
     * @desc        : so geograpgy master fetching logic is reusable 
                      encapsulate geography master datafetching in citylist_repo_impl 
                      the desired statement definition as simple as calling the funtion 
                      and set the state
                      emit(state.copyWith(status:SaveStatus.loading));
                      await cityrepository.fetchCityList(
                              citydistrictrequest,
                          );
    */

    emit(state.copyWith(status: SaveStatus.loading));
    final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
      stateCode: event.stateCode,
      cityCode: event.cityCode,
    );
    Cityrepository cityrepository = CitylistRepoImpl();
    AsyncResponseHandler response = await cityrepository.fetchCityList(
      citydistrictrequest,
    );
    GeographymasterResponseMapper landHoldingState =
        GeographymasterResponseMapper(state).mapResponse(response);
    LandHoldingState _landHoldingState =
        landHoldingState.state as LandHoldingState;
    emit(
      state.copyWith(
        status: _landHoldingState.status,
        cityMaster: _landHoldingState.cityMaster,
        districtMaster: _landHoldingState.districtMaster,
      ),
    );
  }

  Future<List<GeographyMaster>?> getCityMaster(stateCode, cityCode) async {
    try {
      final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
        stateCode: stateCode,
        cityCode: cityCode,
      );
      Cityrepository cityrepository = CitylistRepoImpl();
      AsyncResponseHandler response = await cityrepository.fetchCityList(
        citydistrictrequest,
      );

      Map<String, dynamic> _resp = response.right as Map<String, dynamic>;

      List<GeographyMaster> cityMaster =
          _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
              ? _resp['cityMaster'] as List<GeographyMaster>
              : [];
      List<GeographyMaster> districtMaster =
          _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
              ? _resp['districtMaster'] as List<GeographyMaster>
              : [];

      if (cityCode == null) {
        return cityMaster;
      } else {
        return districtMaster;
      }
    } catch (error) {
      print("mapGaurantor-error => $error");
      return null;
    }
  }
}
