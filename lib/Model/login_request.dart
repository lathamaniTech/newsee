// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginRequest {
  String username;
  String password;
  LoginRequest({required this.username, required this.password});

  @override
  String toString() => 'LoginRequest(username: $username, password: $password)';
}
