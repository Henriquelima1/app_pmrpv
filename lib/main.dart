import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';


import 'car_info.dart';
import 'api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData.dark().copyWith(
        // Adicione as cores personalizadas aqui
        primaryColor: Colors.grey[800]!, // Adicione "!" aqui
        scaffoldBackgroundColor: Colors.grey[900]!, // Adicione "!" aqui
        colorScheme: ColorScheme.dark(
          primary: Colors.grey[800]!, // Adicione "!" aqui
          secondary: Colors.grey[600]!, // Adicione "!" aqui
        ),
        // ... outras personalizações de cor conforme necessário
      ),
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
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];
  TextEditingController plateController = TextEditingController();
  String result = '';
  String statusMessage = '';
  bool checkIcon = false;
  CarInfo? carInfo;

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

  // ...

  void _connectToBluetooth() async {
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();

    if (devices.isNotEmpty) {
      BluetoothDevice selectedDevice = devices[0];
      BluetoothConnection.toAddress(selectedDevice.address).then((conn) {
        print('Conectado ao dispositivo: ${selectedDevice.name}');
        setState(() {
          connection = conn;
        });

        // Inicie a escuta por dados
        connection?.input?.listen(
          (Uint8List data) {
            String receivedMessage = String.fromCharCodes(data);
            print('Mensagem recebida: $receivedMessage');

            
          },
          onDone: () {
            print('Conexão Bluetooth encerrada');
            
          },
        );
      }).catchError((error) {
        print('Erro ao conectar ao dispositivo Bluetooth: $error');
      });
    } else {
    print('Nenhum dispositivo Bluetooth emparelhado encontrado.');
  }
  }

  // ...


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
      carInfo = await ApiService.getCarInfo(plate);

      if (carInfo != null) {
         setState(() {
          result = 'codigoRetorno: ${carInfo?.codigoRetorno},\n'
            'mensagemRetorno: "${carInfo?.mensagemRetorno}",\n'
            'codigoSituacao: "${carInfo?.codigoSituacao}",\n'
            'situacao: "${carInfo?.situacao}",\n'
            'modelo: "${carInfo?.modelo}",\n'
            'marca: "${carInfo?.marca}",\n'
            'cor: "${carInfo?.cor}",\n'
            'ano: "${carInfo?.ano}",\n'
            'anoModelo: "${carInfo?.anoModelo}",\n'
            'placa: "${carInfo?.placa}",\n'
            'data: "${carInfo?.data}",\n'
            'uf: "${carInfo?.uf}",\n'
            'municipio: "${carInfo?.municipio}",\n'
            'chassi: "${carInfo?.chassi}",\n'
            'dataAtualizacaoCaracteristicasVeiculo: "${carInfo?.dataAtualizacaoCaracteristicasVeiculo}",\n'
            'dataAtualizacaoRouboFurto: "${carInfo?.dataAtualizacaoRouboFurto}",\n'
            'dataAtualizacaoAlarme: "${carInfo?.dataAtualizacaoAlarme}"';
          statusMessage = 'Consulta bem-sucedida!';
          if(carInfo?.codigoSituacao == '200'){
            checkIcon = true;
          }else{
            checkIcon = false;
          }
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
        Column(
         children: [
            if (checkIcon)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            Container(
              child: Text(
                result,
                style: TextStyle(color: Colors.white), // Defina a cor do texto
              ),
            ),
         ],
        ),
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
