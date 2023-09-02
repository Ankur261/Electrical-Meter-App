
import 'package:cp949/cp949.dart' as cp949;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:libserialport/libserialport.dart';
import 'pdf.dart';
import 'home.dart';

void main() {
 
  runApp(const MyApp());
  
}

List<dynamic> mData = [];
List<int> srlNo = [] ;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 252),
        canvasColor: const Color.fromARGB(255, 249, 249, 249)
      ),
      title: 'WELCOME to Gepdec Energy BCS',
      initialRoute: '/',
      routes: {
     //   When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const Myhome()
        
      
      },
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SerialPort> portList = [];
  SerialPort? _serialPort;
  List<Uint8List> receiveDataList = [];
  final textInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    var i = 0;
    for (final name in SerialPort.availablePorts) {
      final sp = SerialPort(name);
      if (kDebugMode) {
        print('${++i}) $name');
      }
      portList.add(sp);
    }
    if (portList.isNotEmpty) {
      _serialPort = portList.first;
    }
  }

  void changedDropDownItem(SerialPort sp) {
    setState(() {
      _serialPort = sp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var openButtonText = _serialPort == null
        ? 'N/A'
        : _serialPort!.isOpen
            ? 'Close'
            : 'Open';
    return Scaffold(
      appBar: AppBar(
        title: const Text('WELCOME to Gepdec Energy BCS'),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DropdownButton(
                    value: _serialPort,
                    items: portList.map((item) {
                      return DropdownMenuItem(
                          value: item,
                          child: Text(
                              "${item.name}: ${cp949.decodeString(item.description ?? '')}"));
                    }).toList(),
                    onChanged: (e) {
                      setState(() {
                        changedDropDownItem(e as SerialPort);
                      });
                    },
                  ),
                  const SizedBox(
                    width: 50.0,
                  ),
                  OutlinedButton(
                    child: Text(openButtonText),
                    onPressed: () async {
                      if (_serialPort == null) {
                        return;
                      }
                      if (_serialPort!.isOpen) {
                        _serialPort!.close();
                        debugPrint('${_serialPort!.name} closed!');
                      } else {
                        if (_serialPort!.open(mode: SerialPortMode.readWrite)) {
                          SerialPortConfig config = _serialPort!.config;
                          config.baudRate = 9600;
                          config.parity = 0;
                          config.bits = 8;
                          config.cts = 0;
                          config.rts = 0;
                          config.stopBits = 1;
                          config.xonXoff = 0;
                          _serialPort!.config = config;
                          if (_serialPort!.isOpen) {
                            debugPrint('${_serialPort!.name} opened!');
                            var code = [
                              0x41,
                              0x31,
                              0x66,
                              0x40,
                              0x42,
                              0x0F,
                              0x00,
                              0x72,
                              0xDB,
                              0x0D,
                              0x0A
                            ];

                            _serialPort!.write(Uint8List.fromList(code));
                          }

                          final reader = SerialPortReader(_serialPort!);
                          reader.stream.listen((data) {
                            debugPrint('received: $data');
                            //receiveDataList.add(data);
                            mData = List.from(mData)..addAll(data);
                          }, onError: (error) {
                            if (error is SerialPortError) {
                              debugPrint(
                                  'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                            }
                          });
                        } //if serial port is open
                      }

                      setState(() {});
                    },
                  ),
                ],
              ),
            ),

             Expanded(
              flex: 8,
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: receiveDataList.length,
                    itemBuilder: (context, index) {
                      /*
                      OUTPUT for raw bytes*/
                      return Text(receiveDataList[index].toString());

                      /* output for string */
                      /*return Text(String.fromCharCodes(receiveDataList[index]));*/
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      enabled: (_serialPort != null && _serialPort!.isOpen)
                          ? true
                          : false,
                      controller: textInputCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton.icon(
                    onPressed: (_serialPort != null && _serialPort!.isOpen)
                        ? () {
                            if (_serialPort!.write(Uint8List.fromList(
                                    textInputCtrl.text.codeUnits)) ==
                                textInputCtrl.text.codeUnits.length) {
                              setState(() {
                                textInputCtrl.text = '';
                              });
                            }
                          }
                        : null,
                    icon: const Icon(Icons.send),
                    label: const Text("Send"),
                  ),
                ),
                Flexible(
                  child: TextButton.icon(
                    onPressed: (_serialPort != null && _serialPort!.isOpen)
                        ? () {
                            var code = [
                              0x41,
                              0x31,
                              0x66,
                              0x40,
                              0x42,
                              0x0F,
                              0x00,
                              0x72,
                              0xDB,
                              0x0D,
                              0x0A
                            ];

                            _serialPort!.write(Uint8List.fromList(code));
                            
                            {
                              setState(() {});
                            }
                          }
                        : null,
                    icon: const Icon(Icons.send),
                    label: const Text("Test Command"),
                  ),
                ),
                Flexible(
                  child: TextButton.icon(
                    onPressed: () async {
                      final data = await meterReportPDF();
                      savePdfFile(data, 'Instantaneous');
                    },
                    icon: const Icon(Icons.create),
                    label: const Text("Instantaneous Reading"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}//MyHomePageState*/
