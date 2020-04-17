import 'package:app_covid_dash/core/models/country_model.dart';
import 'package:app_covid_dash/core/models/map-covid_model.dart';
import 'package:app_covid_dash/core/models/overview_model.dart';
import 'package:app_covid_dash/core/models/state_model.dart';
import 'package:dio/dio.dart';

class ReportCovidRepository {
  Dio _dio;

  ReportCovidRepository() {
    BaseOptions options = new BaseOptions(
      connectTimeout: 60000,
    );

    _dio = new Dio(options);
  }

  Future<List<StateModel>> getReportCovidByStetes() async {
    try {
      Response response =
          await _dio.get('https://covid19-brazil-api.now.sh/api/report/v1');
      var list =
          response.data['data'].map((f) => StateModel.fromJson(f)).toList();
      return response.statusCode == 404 ? [] : List<StateModel>.from(list);
    } finally {
      return [];
    }
  }

  Future<CountryModel> getReportCovidBrazil() async {
    try {
      Response response = await _dio
          .get('https://covid19-brazil-api.now.sh/api/report/v1/brazil');
      return response.statusCode == 404
          ? []
          : CountryModel.fromJson(response.data['data']);
    } catch (err) {
      return null;
    }
  }

  Future<List<CountryAccumulatdModel>> getReportCovidBrazilAccumulated() async {
    try {
      Response response = await _dio.get(
        'https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalAcumulo',
        options: Options(
          headers: {
            'x-parse-application-id':
                'unAFkcaNDeXajurGB7LChj8SgQYS2ptm', // set content-length
          },
        ),
      );
      var list = response.data['results']
          .map((f) => CountryAccumulatdModel.fromJson(f))
          .toList();
      return response.statusCode == 404
          ? []
          : List<CountryAccumulatdModel>.from(list);
    } catch (err) {
      return [];
    }
  }

  Future<List<MapCovidModel>> getReportCovidBrazilMap() async {
    try {
      Response response = await _dio.get(
        'https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalMapa',
        options: Options(
          headers: {
            'x-parse-application-id':
                'unAFkcaNDeXajurGB7LChj8SgQYS2ptm', // set content-length
          },
        ),
      );
      var list = response.data['results']
          .map((f) => MapCovidModel.fromJson(f))
          .toList();
      return response.statusCode == 404 ? [] : List<MapCovidModel>.from(list);
    } catch (err) {
      return [];
    }
  }

  Future<OverviewModel> getReportCovidBrazilOverview() async {
    try {
      Response response = await _dio.get(
        'https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalGeral',
        options: Options(
          headers: {
            'x-parse-application-id':
                'unAFkcaNDeXajurGB7LChj8SgQYS2ptm', // set content-length
          },
        ),
      );
      var data = response.data['results'][0];
      return response.statusCode == 404
          ? OverviewModel(
              totalConfirmado: '0', totalLetalidade: '0', totalObitos: '0')
          : OverviewModel.fromJson(data);
    } catch (err) {
      return OverviewModel(
          totalConfirmado: '0', totalLetalidade: '0', totalObitos: '0');
    }
  }
}

class CountryAccumulatdModel {
  String objectId;
  String label;
  DateTime date;
  int qtdConfirmado;
  int qtdObito;
  String createdAt;
  String updatedAt;

  CountryAccumulatdModel(
      {this.objectId,
      this.label,
      this.qtdConfirmado,
      this.qtdObito,
      this.createdAt,
      this.updatedAt});

  CountryAccumulatdModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    label = json['label'];
    var dt = label.split('/');
    date = DateTime(2020, int.parse(dt[1]), int.parse(dt[0]));
    qtdConfirmado = json['qtd_confirmado'];
    qtdObito = json['qtd_obito'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectId'] = this.objectId;
    data['label'] = this.label;
    data['qtd_confirmado'] = this.qtdConfirmado;
    data['qtd_obito'] = this.qtdObito;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
