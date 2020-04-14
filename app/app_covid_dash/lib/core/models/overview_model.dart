class OverviewModel {
  String totalConfirmado;
  String createdAt;
  String updatedAt;
  String totalObitos;
  String versao;
  String dtAtualizacao;
  String totalLetalidade;

  OverviewModel(
      {this.totalConfirmado,
      this.createdAt,
      this.updatedAt,
      this.totalObitos,
      this.versao,
      this.dtAtualizacao,
      this.totalLetalidade});

  OverviewModel.fromJson(Map<String, dynamic> json) {
    totalConfirmado = json['total_confirmado'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    totalObitos = json['total_obitos'];
    versao = json['versao'];
    dtAtualizacao = json['dt_atualizacao'];
    totalLetalidade = json['total_letalidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_confirmado'] = this.totalConfirmado;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['total_obitos'] = this.totalObitos;
    data['versao'] = this.versao;
    data['dt_atualizacao'] = this.dtAtualizacao;
    data['total_letalidade'] = this.totalLetalidade;
    return data;
  }
}
