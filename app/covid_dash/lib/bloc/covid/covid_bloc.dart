import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:covid_dash/bloc/covid/index.dart';

class CovidBloc extends Bloc<CovidEvent, CovidState> {
  static CovidBloc get _covidBlocSingleton => CovidBloc._internal();
  factory CovidBloc() {
    return _covidBlocSingleton;
  }
  CovidBloc._internal();

  @override
  Future<void> close() async {
    await super.close();
  }

  @override
  CovidState get initialState => DataCovidLoading();

  @override
  Stream<CovidState> mapEventToState(
    CovidEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'CovidBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
