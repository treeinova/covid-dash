import 'package:covid_dash/core/models/country_model.dart';
import 'package:covid_dash/core/models/state_model.dart';
import 'package:dio/dio.dart';

class ReportCovidRepository {
  Dio _dio;

  ReportCovidRepository() {
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
    );

    _dio = new Dio(options);
  }

  Future<List<StateModel>> getReportCovidByStetes() async {
    Response response =
        await _dio.get('https://covid19-brazil-api.now.sh/api/report/v1');
    var list =
        response.data['data'].map((f) => StateModel.fromJson(f)).toList();
    return response.statusCode == 404 ? [] : List<StateModel>.from(list);
  }

  Future<CountryModel> getReportCovidBrazil() async {
    Response response = await _dio
        .get('https://covid19-brazil-api.now.sh/api/report/v1/brazil');
    return response.statusCode == 404
        ? []
        : CountryModel.fromJson(response.data['data']);
  }
}
