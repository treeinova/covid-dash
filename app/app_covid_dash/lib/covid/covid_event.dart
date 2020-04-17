import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_covid_dash/core/repositories/report-covid_repository.dart';
import 'package:app_covid_dash/covid/index.dart';
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
      var reportCovidBrazil =
          await this._covidRepository.getReportCovidBrazilOverview();
      var reportCovidBrazilAccumulated =
          await this._covidRepository.getReportCovidBrazilAccumulated();
      var reportCovidState =
          await this._covidRepository.getReportCovidBrazilMap();

      yield DataCovidLoaded(
          states: reportCovidState..sort((a, b) => a.compareTo(b)),
          countryModel: reportCovidBrazil,
          covidAccumulated: reportCovidBrazilAccumulated,
          dateSelected: currentState.dateSelected);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadCovidEvent', error: _, stackTrace: stackTrace);
      yield ErrorCovidState(_?.toString());
    }
  }
}

class SetDateCovidAccumulated extends CovidEvent {
  final DateTime dateSelected;

  SetDateCovidAccumulated(this.dateSelected);
  @override
  String toString() => 'SetDateCovidAccumulated';

  @override
  Stream<CovidState> applyAsync(
      {CovidState currentState, CovidBloc bloc}) async* {
    try {
      var state = currentState as DataCovidLoaded;

      yield state.copyWith(dateSelected: dateSelected);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'SetDateCovidAccumulated', error: _, stackTrace: stackTrace);
      yield ErrorCovidState(_?.toString());
    }
  }
}
