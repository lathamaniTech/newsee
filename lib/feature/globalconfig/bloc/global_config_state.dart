// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'global_config_bloc.dart';

abstract class GlobalConfigState extends Equatable {
  final Globalconfig globalconfig;
  GlobalConfigState({required this.globalconfig});
  @override
  // TODO: implement props
  List<Object?> get props => [globalconfig];
}

class NetworkState extends GlobalConfigState {
  NetworkState({required super.globalconfig});
}
