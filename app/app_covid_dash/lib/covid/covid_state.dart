import 'package:app_covid_dash/core/models/country_model.dart';
import 'package:app_covid_dash/core/models/map-covid_model.dart';
import 'package:app_covid_dash/core/models/overview_model.dart';
import 'package:app_covid_dash/core/models/state_model.dart';
import 'package:app_covid_dash/core/repositories/report-covid_repository.dart';

abstract class CovidState {}

class DataCovidLoading extends CovidState {
  DataCovidLoading();

  @override
  String toString() => 'InitialState';
}

/// Initialized
class DataCovidLoaded extends CovidState {
  final List<MapCovidModel> states;
  final List<CountryAccumulatdModel> covidAccumulated;
  final OverviewModel countryModel;

  DataCovidLoaded({this.states, this.covidAccumulated, this.countryModel});

  @override
  String toString() =>
      'DataCovidLoaded - confirmados ${countryModel.totalConfirmado} with ${states.length}';
}

class ErrorCovidState extends CovidState {
  final String errorMessage;

  ErrorCovidState(this.errorMessage);
}
