/*
  @author         :   lathamani
  @description    :   this file method copyWith returns a copy of MastersState Instance 
                      of loading and done list values of masters and initial() method is set initialize the loading, done
  @return         :   MastersStatus

  */

class MastersState {
  final Map<String, bool> loading;
  final Map<String, bool> done;

  MastersState({required this.loading, required this.done});

  factory MastersState.initial() {
    return MastersState(
      loading: {
        'state': false,
        'district': false,
        'branch': false,
        'static': false,
      },
      done: {
        'state': false,
        'district': false,
        'branch': false,
        'static': false,
      },
    );
  }

  MastersState copyWith({Map<String, bool>? loading, Map<String, bool>? done}) {
    return MastersState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
    );
  }

  bool get allSynced => done.values.every((v) => v == true);
}
