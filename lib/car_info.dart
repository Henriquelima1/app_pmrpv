// lib/car_info.dart

class CarInfo {
  final String codigoRetorno;
  final String mensagemRetorno;
  final String codigoSituacao;
  final String situacao;
  final String modelo;
  final String marca;
  final String cor;
  final String ano;
  final String anoModelo;
  final String placa;
  final String data;
  final String uf;
  final String municipio;
  final String chassi;
  final String dataAtualizacaoCaracteristicasVeiculo;
  final String dataAtualizacaoRouboFurto;
  final String dataAtualizacaoAlarme;

  CarInfo({
    required this.codigoRetorno,
    required this.mensagemRetorno,
    required this.codigoSituacao,
    required this.situacao,
    required this.modelo,
    required this.marca,
    required this.cor,
    required this.ano,
    required this.anoModelo,
    required this.placa,
    required this.data,
    required this.uf,
    required this.municipio,
    required this.chassi,
    required this.dataAtualizacaoCaracteristicasVeiculo,
    required this.dataAtualizacaoRouboFurto,
    required this.dataAtualizacaoAlarme,
  });

  factory CarInfo.fromJson(Map<String, dynamic> json) {
    return CarInfo(
      codigoRetorno: json['codigoRetorno'] ?? '',
      mensagemRetorno: json['mensagemRetorno'] ?? '',
      codigoSituacao: json['codigoSituacao'] ?? '',
      situacao: json['situacao'] ?? '',
      modelo: json['modelo'] ?? '',
      marca: json['marca'] ?? '',
      cor: json['cor'] ?? '',
      ano: json['ano'] ?? '',
      anoModelo: json['anoModelo'] ?? '',
      placa: json['placa'] ?? '',
      data: json['data'] ?? '',
      uf: json['uf'] ?? '',
      municipio: json['municipio'] ?? '',
      chassi: json['chassi'] ?? '',
      dataAtualizacaoCaracteristicasVeiculo: json['dataAtualizacaoCaracteristicasVeiculo'] ?? '',
      dataAtualizacaoRouboFurto: json['dataAtualizacaoRouboFurto'] ?? '',
      dataAtualizacaoAlarme: json['dataAtualizacaoAlarme'] ?? '',
    );
  }
  
  static List<CarInfo> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => CarInfo.fromJson(json)).toList();
  }
}
