import 'package:covid_dash/core/models/country_model.dart';
import 'package:covid_dash/core/models/state_model.dart';

abstract class CovidState {}

class DataCovidLoading extends CovidState {
  DataCovidLoading();

  @override
  String toString() => 'InitialState';
}

/// Initialized
class DataCovidLoaded extends CovidState {
  final List<StateModel> states;
  final CountryModel countryModel;

  DataCovidLoaded({this.states, this.countryModel});

  @override
  String toString() =>
      'DataCovidLoaded - country ${countryModel.country} with ${states.length}';
}

class ErrorCovidState extends CovidState {
  final String errorMessage;

  ErrorCovidState(this.errorMessage);
}
