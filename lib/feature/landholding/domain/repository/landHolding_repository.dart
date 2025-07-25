import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/landholding/domain/modal/Land_Holding_delete_request.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_responce_model.dart';

abstract class LandHoldingRepository {
  Future<AsyncResponseHandler<Failure, LandHoldingResponceModel>>
  submitLandHolding(LandHoldingRequest request);
  Future<AsyncResponseHandler<Failure, LandHoldingResponceModel>> getLandholding(String proposalNumber);
  Future<AsyncResponseHandler<Failure, String>> deleteLandHoldingData(LandHoldingDeleteRequest req);
}
