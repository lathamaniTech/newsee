import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/fake_loginservice.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/Model/login_response.dart';

part 'login_event.dart';
part 'login_state.dart';

/* 
@author         :   karthick.d    07/05/2025
@description    :   Bloc that perform action on dispatched events
                    like logiInit,loginSuccess,loginError 
@props          :   possible props Future<LoginResponse> callLogin

 */

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRequest loginRequest;

  LoginBloc({required this.loginRequest})
    : super(
        LoginState(
          loginResponse: LoginResponse(
            username: null,
            userId: null,
            userOrgCode: null,
            userSolId: null,
          ),
        ),
      ) {
    // action event handler for LoginInit
    on<LoginFetch>(fetchLogin);
    on<LoginPasswordSecure>(securePassword);
  }

  Future<void> fetchLogin(LoginFetch event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        status :LoginStatus.fetch,
        response : LoginResponse(
          username: null,
          userId: null,
          userOrgCode: null,
          userSolId: null,
        ),
      ),
    );
    LoginState response = await FakeLoginservice().login(
      loginRequest: event.loginRequest,
    );

    if (response.loginStatus == LoginStatus.success) {
      emit(state.copyWith(status : LoginStatus.success, response : response.loginResponse));
    } else {
      emit(state.copyWith(status : LoginStatus.error, response:  response.loginResponse));
    }
  }


  Future<void>  securePassword(LoginPasswordSecure event , Emitter<LoginState> emit) async{
      print('securePassword event handler .... => $event');
      emit(state.copyWith( isPasswordShown:!state.isPasswordHidden));
  }
}
