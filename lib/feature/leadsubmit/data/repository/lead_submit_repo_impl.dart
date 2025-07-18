import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/feature/leadsubmit/data/datasource/lead_submit_datasource.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/lead_submit_request.dart';
import 'package:newsee/feature/leadsubmit/domain/repository/lead_submit_repo.dart';

class LeadSubmitRepoImpl extends LeadSubmitRepo {
  @override
  Future<AsyncResponseHandler<Failure, Map<String, dynamic>>> submitLead({
    required Map<String, dynamic> request,
  }) async {
    LeadSubmitDatasource leadSubmitDatasource = LeadSubmitDatasource(
      dio: ApiClient().getDio(),
    );

    var response = await leadSubmitDatasource.submitLead(request);
    if (response.data[ApiConstants.api_response_success]) {
      print(response.data['responseData']);
      return AsyncResponseHandler.right(
        response.data[ApiConstants.api_response_data],
      );
    } else {
      String errorMessage = response.data['ErrorMessage'];
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: errorMessage),
      );
    }
  }
}
