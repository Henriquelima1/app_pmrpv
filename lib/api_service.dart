// lib/api_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';

import 'car_info.dart';

class ApiService {
  static Future<CarInfo?> getCarInfo(String plate) async {
    // Simula um atraso de 2 segundos
    await Future.delayed(Duration(seconds: 2));

    // Lê o arquivo JSON simulado
    final String jsonString = await rootBundle.loadString('assets/car_info.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    // Converte a lista de dados JSON em uma lista de objetos CarInfo
    final List<CarInfo> carInfoList = jsonData.map((json) => CarInfo.fromJson(json)).toList();

    // Tenta encontrar o carro com a placa especificada
    final List<CarInfo?> matchingCars = carInfoList.where((carInfo) => carInfo.placa == plate).toList();

    // Retorna o primeiro carro correspondente ou null se nenhum for encontrado
    return matchingCars.isNotEmpty ? matchingCars.first : null;
  }
}





