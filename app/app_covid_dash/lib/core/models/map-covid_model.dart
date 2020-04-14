class MapCovidModel {
  String nome;
  int qtdConfirmado;
  String latitude;
  String longitude;
  String createdAt;
  String updatedAt;
  String percent;
  String letalidade;
  int qtdObito;

  MapCovidModel(
      {this.nome,
      this.qtdConfirmado,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.percent,
      this.letalidade,
      this.qtdObito});

  MapCovidModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    qtdConfirmado = json['qtd_confirmado'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    percent = json['percent'];
    letalidade = json['letalidade'];
    qtdObito = json['qtd_obito'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['qtd_confirmado'] = this.qtdConfirmado;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['percent'] = this.percent;
    data['letalidade'] = this.letalidade;
    data['qtd_obito'] = this.qtdObito;
    return data;
  }

  compareTo(MapCovidModel b) {
    return Comparable.compare(b.qtdConfirmado, this.qtdConfirmado);
  }
}
