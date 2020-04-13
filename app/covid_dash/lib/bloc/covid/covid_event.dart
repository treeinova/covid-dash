import 'dart:async';
import 'dart:developer' as developer;

import 'package:covid_dash/bloc/covid/index.dart';
import 'package:covid_dash/core/repositories/report-covid_repository.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CovidEvent {
  Stream<CovidState> applyAsync({CovidState currentState, CovidBloc bloc});
  final ReportCovidRepository _covidRepository = ReportCovidRepository();
}

class UnCovidEvent extends CovidEvent {
  @override
  Stream<CovidState> applyAsync(
      {CovidState currentState, CovidBloc bloc}) async* {
    yield DataCovidLoading();
  }
}

class LoadDataCovid extends CovidEvent {
  @override
  String toString() => 'LoadCovidEvent';

  LoadDataCovid();

  @override
  Stream<CovidState> applyAsync(
      {CovidState currentState, CovidBloc bloc}) async* {
    try {
      yield DataCovidLoading();
      var reportCovidBrazil =
          await this._covidRepository.getReportCovidBrazil();
      var reportCovidState =
          await this._covidRepository.getReportCovidByStetes();
      yield DataCovidLoaded(
          states: reportCovidState, countryModel: reportCovidBrazil);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadCovidEvent', error: _, stackTrace: stackTrace);
      yield ErrorCovidState(_?.toString());
    }
  }
}
