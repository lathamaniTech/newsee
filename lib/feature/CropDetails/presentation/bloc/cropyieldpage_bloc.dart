import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/CropDetails/data/repository/cropdetails_repository_impl.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_delete_request.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_get_response.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropmodel.dart';
import 'package:newsee/feature/CropDetails/domain/modal/croprequestmodel.dart';
import 'package:newsee/feature/CropDetails/domain/repository/cropdetails_repository.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

part 'cropyieldpage_event.dart';
part 'cropyieldpage_state.dart';

class CropyieldpageBloc extends Bloc<CropyieldpageEvent, CropyieldpageState> {
  CropyieldpageBloc() : super(CropyieldpageState.init()) {
    on<CropPageInitialEvent>(initCropYieldDetails);
    on<CropFormSaveEvent>(onSaveCropYieldPage);
    on<CropDetailsSetEvent>(onDataSet);
    on<CropDetailsResetEvent>(onResetForm);
    on<CropDetailsUpdateEvent>(onUpdateForm);
    on<CropDetailsSubmitEvent>(onSubmitCropDetails);
    on<CropDetailsDeleteEvent>(onDeleteCropDetails);
    on<CropDetailsRemoveEvent>(onRemoveCrop);
    on<RBIHCropDetailsFetch>(loadRBIHData);
  }

  // submit all added crop details to server
  Future<void> onSubmitCropDetails(
    CropDetailsSubmitEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      int totalCul = 0;
      int totalSof = 0;
      int totalIns = 0;

      for (final detail in state.cropData ?? []) {
        print('submit $detail');

        final int areaOfCul =
            int.tryParse(
              detail.lcdCostOfCul?.toString().replaceAll(',', '') ?? '0',
            ) ??
            0;
        print('submit $areaOfCul');
        final int addsofamt = detail.lcdAddSofAmount ?? 0;
        final int insPre = detail.lcdInsPre ?? 0;

        print('submit $areaOfCul, $insPre, $addsofamt');

        totalCul += areaOfCul;
        totalSof += addsofamt;
        totalIns += insPre;

        print('Submitting detail: $detail');
      }

      print('submit');
      final CropRequestModel cropReq = CropRequestModel(
        proposalNumber: int.tryParse(event.proposalNumber),
        userid: event.userid,
        cropDetailList:
            state.cropData
                ?.map(
                  (detail) => CropModal(
                    rowId: detail.lcdRowId.toString(),
                    season: detail.lcdSeason,
                    cropName: detail.lcdCropName,
                    cropType: detail.lcdCropType,
                    culAreaLand: detail.lcdCulAreaLand,
                    culAreaSize: detail.lcdCulAreaSize,
                    typeOfLand: detail.lcdTypeOfLand,
                    scaOfFin: detail.lcdScaOfFin,
                    addSofByRo: detail.lcdAddSofByRo,
                    costOfCul: detail.lcdCostOfCul?.toInt(),
                    covOfCrop: detail.lcdCovOfCrop,
                    cropIns: detail.lcdCropIns,
                    addSofAmount: detail.lcdAddSofAmount?.toInt(),
                    insPre: detail.lcdInsPre?.toInt(),
                    dueDateOfRepay: getDateFormatedByProvided(
                      detail.lcdDueDateOfRepay,
                      from: AppConstants.Format_dd_MM_yyyy,
                      to: AppConstants.Format_yyyy_MM_dd,
                    ),
                  ),
                )
                .toList(),
        totalInsurprem: totalIns,
        totalSofamt: totalSof,
        totalcostCultivation: totalCul,
        token: ApiConfig.AUTH_TOKEN,
      );
      print("cropReq $cropReq");
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      var responseHandler = await cropRepository.saveCrop(cropReq);

      AsyncResponseHandler<Failure, CropGetResponse> cropGetResponse =
          await cropRepository.getCrop(event.proposalNumber);
      if (responseHandler.isRight() && cropGetResponse.isRight()) {
        // List<Map<String, dynamic>> listofAssessment = responseHandler.right.responseData?['AssessmentSOF'];
        // print("listofAssessment value is => $listofAssessment");
        // List<LandData> landData = listofAssessment.map((e) => LandData.fromMap(e)).toList();

        print(
          "cropGetResponse.right.agriCropDetails ${cropGetResponse.right.agriCropDetails}",
        );
        Globalconfig.RBIHCropDataList = [];

        emit(
          state.copyWith(
            status: SaveStatus.success,
            cropData: cropGetResponse.right.agriCropDetails,
            showSubmit: false,
          ),
        );
      } else if (responseHandler.isRight()) {
        emit(state.copyWith(status: SaveStatus.success, showSubmit: false));
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure,
            errorMessage: responseHandler.left.message,
            showSubmit: true,
          ),
        );
      }
    } catch (error) {
      print("onSubmitCropDetails $error");
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  // get all crop details from server
  Future<void> initCropYieldDetails(
    CropPageInitialEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      Database _db = await DBConfig().database;
      List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
      print('listOfLov => $listOfLov');

      //Get Crop Details
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      AsyncResponseHandler<Failure, CropGetResponse> cropResponse =
          await cropRepository.getCrop(event.proposalNumber);

      //Get Land Details
      // final LandHoldingRepository landHoldingRepository =
      //     LandHoldingRespositoryImpl();
      // final landresponse = await landHoldingRepository.getLandholding(event.proposalNumber);
      // print("get responseHandler value is => $cropResponse");

      //Emit init state
      // if (cropResponse.isRight() && landresponse.isRight()) {
      if (cropResponse.isRight()) {
        print(
          "cropResponse.right.agriCropDetails-gettime ${cropResponse.right.agriCropDetails}",
        );
        // List<LandData> landData = landresponse.right.agriLandHoldingsList.map((e) => LandData.fromMap(e)).toList();
        emit(
          state.copyWith(
            lovlist: listOfLov,
            status: SaveStatus.init,
            cropData: cropResponse.right.agriCropDetails,
            // landDetails: cropResponse.right.agriLandDetails,
            // landData: landData
          ),
        );
        // } else if (landresponse.isRight()) {
        //   List<LandData> landData = landresponse.right.agriLandHoldingsList.map((e) => LandData.fromMap(e)).toList();
        //   emit(
        //     state.copyWith(
        //       lovlist: listOfLov,
        //       status: SaveStatus.init,
        //       landData: landData
        //     )
        //   );
      } else {
        emit(state.copyWith(lovlist: listOfLov, status: SaveStatus.init));
      }
    } catch (error) {
      print("onSaveCropYieldPage-error $error");
      emit(state.copyWith(status: SaveStatus.failure));
    }
  }

  // save crop details in cropdata list
  Future<void> onSaveCropYieldPage(
    CropFormSaveEvent event,
    Emitter<CropyieldpageState> emit,
  ) async {
    final newList = [...?state.cropData, event.cropData];
    emit(
      state.copyWith(
        status: SaveStatus.mastersucess,
        cropData: newList,
        selectedCropData: null,
        showSubmit: true,
      ),
    );
  }

  // Load data into form for editing
  Future<void> onDataSet(
    CropDetailsSetEvent event,
    Emitter<CropyieldpageState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedCropData: event.cropData,
        status: SaveStatus.update,
      ),
    );
    await Future.delayed(Duration(seconds: 2));
    emit(state.copyWith(status: SaveStatus.edit));
  }

  void onResetForm(
    CropDetailsResetEvent event,
    Emitter<CropyieldpageState> emit,
  ) {
    emit(state.copyWith(selectedCropData: null, status: SaveStatus.reset));
  }

  // save edited data
  void onUpdateForm(
    CropDetailsUpdateEvent event,
    Emitter<CropyieldpageState> emit,
  ) {
    List<CropDetailsModal>? fullcropdata = state.cropData;
    fullcropdata?[event.index] = event.cropData;
    print("Updated crop data is there is $fullcropdata");
    emit(
      state.copyWith(
        cropData: fullcropdata,
        selectedCropData: null,
        status: SaveStatus.mastersucess,
        showSubmit: true,
      ),
    );
  }

  // delete crop data
  Future<void> onDeleteCropDetails(
    CropDetailsDeleteEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      CropDeleteRequest deleteReq = CropDeleteRequest(
        proposalNumber: event.proposalNumber,
        rowId: event.rowId,
        token: ApiConfig.AUTH_TOKEN,
      );
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      var delResponseHandler = await cropRepository.deleteCrop(deleteReq);
      print("get responseHandler value is => $delResponseHandler");

      if (delResponseHandler.isRight()) {
        // AsyncResponseHandler<Failure, CropGetResponse> cropGetResponse = await cropRepository.getCrop(
        //   event.proposalNumber
        // );

        // if (cropGetResponse.isRight()) {
        //   emit(
        //     state.copyWith(
        //       status: SaveStatus.delete,
        //       cropData: cropGetResponse.right.agriCropDetails,
        //       errorMessage: delResponseHandler.right
        //     )
        //   );
        // } else {
        print("final landDetailsList ${state.cropData}, ${event.index}");
        List<CropDetailsModal> cropDetailsList = state.cropData!;
        cropDetailsList.removeAt(event.index);
        final addedCrop = checkNewArray(cropDetailsList);
        final showSubmit = addedCrop ? true : false;
        print("final landDetailsList $cropDetailsList");
        emit(
          state.copyWith(
            status: SaveStatus.delete,
            cropData: cropDetailsList,
            errorMessage: delResponseHandler.right,
            showSubmit: showSubmit,
          ),
        );
        // }
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure,
            cropData: state.cropData,
            errorMessage: delResponseHandler.left.message,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          cropData: state.cropData,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> onRemoveCrop(CropDetailsRemoveEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      Future.delayed(Duration(seconds: 2));
      List<CropDetailsModal> cropDetailsList = state.cropData!;
      cropDetailsList.removeAt(event.index);
      print("final landDetailsList $cropDetailsList");
      final addedCrop = checkNewArray(cropDetailsList);
      final showSubmit = addedCrop ? true : false;
      emit(
        state.copyWith(
          status: SaveStatus.delete,
          cropData: cropDetailsList,
          errorMessage: '',
          showSubmit: showSubmit,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          cropData: state.cropData,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  bool checkNewArray(List<CropDetailsModal> arraydata) {
    try {
      for (int i = 0; i < arraydata.length; i++) {
        if (arraydata[i].lcdRowId == '') {
          return true;
        }
      }
      return false;
    } catch (error) {
      print("final checkNewArray $error");
      return false;
    }
  }

  Future<void> loadRBIHData(RBIHCropDetailsFetch event, Emitter emit) async {
    try {
      // final response = await offlineDataProvider(
      //   path: AppConstants.rhIHLandCropResponse,
      // );
      // if (response != null) {
      //   final jsonData = response.data;
      //   final data = jsonData['data']['data'] as Map<String, dynamic>;

      // print("_loadData response $response");
      // Assuming the JSON structure has these keys
      // final List<dynamic> cryieldDetails =
      //     response.data['data']['data']['cropYieldDetails']['cropDetail'];

      // final cropYieldDetailsList =
      //     (cryieldDetails as List<dynamic>?)
      //         ?.map((item) => item as Map<String, dynamic>)
      //         .toList() ??
      //     [];
      emit(state.copyWith(status: SaveStatus.loading));
      final rbiCropDataList = Globalconfig.RBIHCropDataList;
      print("cropYieldDetailsList: $rbiCropDataList");
      List<CropDetailsModal> cropDataList =
          rbiCropDataList.map((cropDetail) {
            print("totarea raw value: ${cropDetail}");
            String crop = '';
            String cropname = cropDetail['croptype'] ?? '';
            if (cropname.toLowerCase().contains('wheat')) {
              print('This is wheat crop');
              crop = '3';
            } else if (cropname.toLowerCase().contains('bajara')) {
              crop = '1';
            } else if (cropname.toLowerCase().contains('coffee')) {
              crop = '6';
            } else if (cropname.toLowerCase().contains('daal')) {
              crop = '5';
            } else if (cropname.toLowerCase().contains('jawar')) {
              crop = '2';
            } else {
              crop = '7';
            }
            return CropDetailsModal(
              lcdSeason:
                  cropDetail['seasontype'].toString().isNotEmpty
                      ? cropDetail['seasontype'].toString()
                      : '5',
              lcdCulAreaLand: cropDetail['croparea'].toString(),
              lcdScaOfFin: 0,
              lcdCropName: crop,
              lcdCropType: '2',
              lcdTypeOfLand: '1',
              lcdCovOfCrop:
                  (crop == '1' ||
                          crop == '2' ||
                          crop == '3' ||
                          crop == '5' ||
                          crop == '6')
                      ? '1'
                      : '2',
            );
          }).toList();

      emit(state.copyWith(status: SaveStatus.init, cropData: cropDataList));
      // }
    } catch (e) {
      print('Error loading data: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error loading data: $e')),
      // );
    }
  }
}
