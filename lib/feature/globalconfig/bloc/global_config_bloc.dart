import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/globalconfig.dart';

part './global_config_state.dart';
part './globalconfig_event.dart';

class GlobalConfigBloc extends Bloc<GlobalconfigEvent, NetworkState> {
  GlobalConfigBloc()
    : super(NetworkState(globalconfig: Globalconfig.fromValue())) {
    on<NetworkChangedEvent>(onNetworkChanged);
  }

  Future<void> onNetworkChanged(NetworkChangedEvent ev, Emitter emit) async {
    emit(NetworkState(globalconfig: ev.globalConfig));
  }
}
