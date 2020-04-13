class CountryModel {
  String country;
  int cases;
  int confirmed;
  int deaths;
  int recovered;
  String updatedAt;

  CountryModel(
      {this.country,
      this.cases,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.updatedAt});

  CountryModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    cases = json['cases'];
    confirmed = json['confirmed'];
    deaths = json['deaths'];
    recovered = json['recovered'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['cases'] = this.cases;
    data['confirmed'] = this.confirmed;
    data['deaths'] = this.deaths;
    data['recovered'] = this.recovered;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
