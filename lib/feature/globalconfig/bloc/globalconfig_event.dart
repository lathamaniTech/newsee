part of 'global_config_bloc.dart';

sealed class GlobalconfigEvent {
  final Globalconfig globalConfig;
  GlobalconfigEvent(this.globalConfig);
}

final class NetworkChangedEvent extends GlobalconfigEvent {
  NetworkChangedEvent(super.globalConfig);
}
