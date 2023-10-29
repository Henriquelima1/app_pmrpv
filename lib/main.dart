import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;

import 'car_info.dart';
import 'api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> devices = [];
  TextEditingController plateController = TextEditingController();
  String result = '';
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    List<BluetoothDevice> _devices = [];

    try {
      _devices = await bluetooth.getBondedDevices();
    } catch (error) {
      print("Erro ao obter dispositivos Bluetooth: $error");
    }

    setState(() {
      devices = _devices;
    });
  }

  void _makeHttpRequest(String plate) async {
    try {
      //final response = await http.get(Uri.parse('https://cidadao.sinesp.gov.br/sinesp-cidadao/mobile/consultar-placa/v4/$plate'));
      // if (response.statusCode == 200) {
      //   // Processar os dados recebidos
      //   setState(() {
      //     result = response.body;
      //     statusMessage = 'Consulta bem-sucedida!';
      //   });
      // } else {
      //   // Lidar com erros
      //   setState(() {
      //     result = 'Erro na requisição HTTP: ${response.statusCode}';
      //     statusMessage = 'Erro na consulta';
      //   });
      // }
      //Simulação de dados
      final CarInfo? carInfo = await ApiService.getCarInfo(plate);

      if (carInfo != null) {
        setState(() {
          result = 'Placa: ${carInfo.placa}\nMarca: ${carInfo.marca}\nModelo: ${carInfo.modelo}';
          statusMessage = 'Consulta bem-sucedida!';
        });
      } else {
        setState(() {
          result = 'Carro não encontrado';
          statusMessage = 'Nenhum resultado encontrado para a placa $plate';
        });
      }
    }catch (error) {
      setState(() {
        result = 'Erro na requisição HTTP simulada: $error';
        statusMessage = 'Erro na consulta simulada';
      });
    }
    // catch (error) {
    //   setState(() {
    //     result = 'Erro na requisição HTTP: $error';
    //     statusMessage = 'Erro na consulta';
    //   });
    // }

    // Exibir um SnackBar com o status da requisição
    final snackBar = SnackBar(content: Text(statusMessage));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: plateController,
              decoration: InputDecoration(labelText: 'Insira a placa do carro'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String plate = plateController.text;
              if (plate.isNotEmpty) {
                _makeHttpRequest(plate);
              }
            },
            child: Text('Consultar Placa'),
          ),
          SizedBox(height: 20),
          Text(result),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name ?? 'Nome Desconhecido'),
                  onTap: () {
                    // Conectar ao dispositivo selecionado e realizar operações Bluetooth
                    // Exemplo: bluetooth.connect(devices[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
