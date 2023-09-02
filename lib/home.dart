import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:cp949/cp949.dart' as cp949;
import 'package:open_document/open_document.dart';
import 'package:test_app2/pdf.dart';
import 'main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path/path.dart';

String datetime = DateTime.now().toString();
bool isDataReadInst = true;
bool isDataPDFInst = false;
bool isDataReadBill = true;
bool isDataPDFBill = false;
bool isDataReadLoad = true;
bool isDataPDFLoad = false;
bool isDataReadTamper = true;
bool isDataPDFTamper = false;
bool isDataReadTOD = true;
bool isDataPDFTOD = false;
bool isButtonDisable = true;

class Myhome extends StatefulWidget {
  const Myhome({super.key});

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  List<SerialPort> portList = [];
  SerialPort? _serialPort;
  double value = 0;
  @override
  void initState() {
    getFiles();
    super.initState();
    serialPortList();
    value = 0;

    if (portList.isNotEmpty) {
      _serialPort = portList.first;
    }
    //call getFiles() function on initial state.
  }

  serialPortList() {
    portList.clear();
    var i = 0;
    for (final name in SerialPort.availablePorts) {
      final sp = SerialPort(name);
      debugPrint('${++i}) $name');
      portList.add(sp);
    }
  }

  dynamic files;
  dynamic fileName;
  //To get file saved in Documents/Gepdec Energy
  void getFiles() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    var appDocumentsPath = '${appDocumentsDirectory.path}/Gepdec Energy';
    var fm = FileManager(root: Directory(appDocumentsPath));
    files = await fm.filesTree(
      extensions: ['pdf'],
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    buttonText() {
      var openButtonText = _serialPort == null
          ? 'No Serial Port Available'
          : _serialPort!.isOpen
              ? 'Ready to read data from this Meter'
              : 'Please press Apply after Port Selection';
      return openButtonText;
    }

    // Bools for enableing Read data and Create PDF buttons

    void changedDropDownItem(SerialPort sp) {
      setState(() {
        _serialPort = sp;
      });
    }

    // Button Style for Log Out Button
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(221, 0, 0, 0),
      backgroundColor: const Color.fromARGB(255, 206, 126, 69),
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text('GEPDEC Energy Private Limited',
              textAlign: TextAlign.right),
          shadowColor: const Color.fromARGB(255, 2, 2, 2),
          backgroundColor: const Color.fromARGB(255, 227, 153, 92),
          toolbarHeight: 35,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 12,
                  child: Container(
                    color: const Color.fromARGB(227, 21, 21, 18),
                    child: Row(children: [
                      const SizedBox(
                        width: 20,
                      ),
                      //Gepdec Logo
                      Image.asset(
                        'assets/logo.png',
                        height: 70,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Spacer(),
                      //Update Serial Port List Button
                      IconButton(
                        onPressed: () {
                          setState(() {
                            SerialPort.availablePorts;
                          });
                        },
                        tooltip: 'Update Serial Port List',
                        icon: const Icon(Icons.update),
                        color: const Color.fromARGB(255, 206, 126, 69),
                        iconSize: 20,
                      ),
                      //Refresh Button for PDF files saved at Document/Gepdec Energy
                      IconButton(
                        onPressed: () {
                          setState(() {
                            getFiles();
                          });
                        },
                        tooltip: 'Reload',
                        icon: const Icon(Icons.replay),
                        color: const Color.fromARGB(255, 206, 126, 69),
                        iconSize: 20,
                      ),
                      const SizedBox(
                        height: 40,
                        width: 20,
                      ),
                      //Log Out Button
                      ElevatedButton(
                        style: flatButtonStyle,
                        onPressed: () {},
                        child: const Text('Log Out',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            Flexible(
              flex: 90,
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.fromLTRB(2.5, 3, 3, 1)),
                  Flexible(
                    flex: 20,
                    child: Column(
                      children: [
                        //Card for Selection of serial port
                        Card(
                          child: ListTile(
                            title: const Text(
                              'Serial Port Selection',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            trailing: const Icon(Icons.usb),
                            tileColor: const Color.fromARGB(232, 0, 0, 0),
                            enabled: true,
                            selected: false,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(width: 1)),
                            onTap: () => showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text('Select COM Port '),
                                    content: DropdownButton(
                                      value: _serialPort,
                                      items: portList.map((item) {
                                        return DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                                "${item.name}: ${cp949.decodeString(item.description ?? '')}"));
                                      }).toList(),
                                      hint: const Text('Select COM Port'),
                                      onChanged: (e) {
                                        setState(() {
                                          changedDropDownItem(e as SerialPort);
                                        });
                                      },
                                    ),
                                    actions: <StatefulWidget>[
                                      TextButton(
                                        onPressed: null,
                                        child: Text(buttonText()),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _serialPort!.close();
                                          isButtonDisable = true;
                                          _serialPort!.drain();
                                          _serialPort!.flush();
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      ),
                                      TextButton(
                                        onPressed: (isButtonDisable)
                                            ? () {
                                                if (_serialPort == null) {
                                                  return;
                                                }
                                                SerialPortTransport.usb;
                                                _serialPort!.open(
                                                    mode: SerialPortMode
                                                        .readWrite);

                                                /* _serialPort?.config =
                                                        SerialPortConfig()
                                                          ..baudRate = 9600
                                                          ..bits = 8
                                                          ..stopBits = 1
                                                          ..parity =
                                                              SerialPortParity
                                                                  .none
                                                          ..setFlowControl(
                                                              SerialPortFlowControl
                                                                  .none)
                                                          ..rts = SerialPortRts
                                                              .flowControl
                                                          ..cts = SerialPortCts
                                                              .flowControl
                                                          ..dsr = SerialPortDsr
                                                              .flowControl
                                                          ..dtr = SerialPortDtr
                                                              .flowControl
                                                          ..setFlowControl(
                                                              SerialPortFlowControl
                                                                  .rtsCts);*/
                                                SerialPortConfig config =
                                                    _serialPort!.config;
                                                config.baudRate = 9600;
                                                config.parity =
                                                    SerialPortParity.none;
                                                config.bits = 8;
                                                config.cts = 0;
                                                config.rts = 0;
                                                config.stopBits = 1;
                                                config.xonXoff = 0;
                                                config.setFlowControl(
                                                    SerialPortFlowControl.none);
                                                //     config.setFlowControl(
                                                //SerialPortFlowControl
                                                //  .rtsCts );
                                                _serialPort!.config = config;

                                                debugPrint(
                                                    '${_serialPort!.name} opened!');
                                                srlNo = [];

                                                _serialPort!.flush();
                                                var code = [
                                                  0x41,
                                                  0x52,
                                                  0x00,
                                                  0x00,
                                                  0x00,
                                                  0x00,
                                                  0x00,
                                                  0x00,
                                                  0x93,
                                                  0x0D,
                                                  0x0A
                                                ];
                                                _serialPort!.write(
                                                    Uint8List.fromList(code));

                                                final reader = SerialPortReader(
                                                    _serialPort!,
                                                    timeout: 0);
                                                reader.stream.listen((data) {
                                                  debugPrint('received: $data');
                                                  //receiveDataList.add(data);
                                                  srlNo = List.from(srlNo)
                                                    ..addAll(data);
                                                }, onError: (error) {
                                                  if (error
                                                      is SerialPortError) {
                                                    debugPrint(
                                                        'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                                                  }
                                                });

                                                //if serial port is open
                                                _serialPort!.drain;
                                                _serialPort!.flush();
                                                setState(() {
                                                  isButtonDisable = false;
                                                  isDataReadInst = true;
                                                  isDataReadBill = true;
                                                  isDataReadTOD = true;
                                                  isDataReadTamper = true;
                                                  isDataReadLoad = true;
                                                });
                                              }
                                            : null,
                                        child: const Text('Apply'),
                                      ),
                                    ],
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                        //Instantaneous Parameter Reading Card Tile
                        Card(
                          child: ListTile(
                            title: const Text(
                              'Instantaneous Reading',
                            ),
                            trailing: const Icon(Icons.download),
                            tileColor: const Color(0xE8E87C2A),
                            selected: false,
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title:
                                          const Text('Read Instantenous Data'),
                                      content: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return SizedBox(
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                  'Are you sure you want to download this PDF'),
                                              LinearProgressIndicator(
                                                backgroundColor: Colors.white,
                                                color: const Color(0xE8E87C2A),
                                                minHeight: 5,
                                                value: value,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      actions: <StatefulWidget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                            _serialPort!.close();
                                            isDataReadInst = true;
                                            setState(
                                              () {
                                                value = 0.0;
                                              },
                                            );
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: (isDataReadInst &&
                                                  srlNo.length == 7)
                                              ? () {
                                                  isDataPDFInst = false;
                                                  mData = [];
                                                  Timer.periodic(
                                                      const Duration(
                                                          seconds: 1),
                                                      (Timer timer) {
                                                    setState(() {
                                                      if (value == 1) {
                                                        timer.cancel();
                                                        value = 0.0;
                                                        isDataPDFInst = true;
                                                      } else {
                                                        value = value + 0.2;
                                                      }
                                                    });
                                                  });

                                                  _serialPort!.open(
                                                      mode: SerialPortMode
                                                          .readWrite);
                                                  _serialPort!.flush();
                                                  dynamic code = [
                                                    0x41,
                                                    0x31,
                                                    0x66,
                                                    srlNo[1],
                                                    srlNo[2],
                                                    srlNo[3],
                                                    srlNo[4],
                                                    0x72,
                                                    0xDB,
                                                    0x0D,
                                                    0x0A,
                                                  ];
                                                  _serialPort!.write(
                                                      Uint8List.fromList(code));

                                                  _serialPort!.flush();
                                                  SerialPortReader reader =
                                                      SerialPortReader(
                                                          _serialPort!,
                                                          timeout: 0);
                                                  reader.stream.listen((data) {
                                                    //receiveDataList.add(data);
                                                    mData = List.from(mData)
                                                      ..addAll(data);
                                                    debugPrint(
                                                        'This is Data received: $data');
                                                  }, onError: (error) {
                                                    if (error
                                                        is SerialPortError) {
                                                      debugPrint(
                                                          'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                                                    }
                                                  });
                                                  _serialPort!.drain();
                                                  _serialPort!.flush();

                                                  setState(() {});
                                                  isDataReadInst = false;
                                                  debugPrint(
                                                      'mData Length is ${mData.length}');
                                                }
                                              : null,
                                          child: const Text('Read Meter Data'),
                                        ),
                                        TextButton(
                                          onPressed: (isDataPDFInst)
                                              ? () {
                                                  _serialPort!.drain();
                                                  createPDF();
                                                  _serialPort!.close();

                                                  setState(() {
                                                    getFiles();
                                                  });
                                                  Navigator.pop(context, '/');
                                                  isDataPDFInst = false;
                                                  isDataReadInst = true;
                                                }
                                              : null,
                                          child: const Text('Create PDF'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        // Billing Card Tile
                        Card(
                          child: ListTile(
                            title: const Text(
                              'Billing',
                            ),
                            trailing: const Icon(Icons.download),
                            tileColor: const Color.fromARGB(232, 232, 124, 42),
                            selected: false,
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Read Billing Data'),
                                      content: const Text(
                                          'Are you sure you want to download this PDF'),
                                      actions: <StatefulWidget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                            _serialPort!.close();
                                            isDataReadBill = true;
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: (_serialPort != null &&
                                                  isDataReadBill &&
                                                  srlNo.isNotEmpty)
                                              ? () async {
                                                  _serialPort!.open(
                                                      mode: SerialPortMode
                                                          .readWrite);
                                                  _serialPort!.flush();
                                                  dynamic code = [
                                                    0x41,
                                                    0x2A,
                                                    0x00,
                                                    srlNo[1],
                                                    srlNo[2],
                                                    srlNo[3],
                                                    srlNo[4],
                                                    0x90,
                                                    0x8C,
                                                    0x0D,
                                                    0x0A,
                                                  ];
                                                  _serialPort!.write(
                                                      Uint8List.fromList(code));
                                                  _serialPort!.flush();
                                                  SerialPortReader reader =
                                                      SerialPortReader(
                                                          _serialPort!,
                                                          timeout: 0);
                                                  reader.stream.listen((data) {
                                                    mData = List.from(mData)
                                                      ..addAll(data);
                                                    debugPrint(
                                                        'This is Data received: $data');
                                                  }, onError: (error) {
                                                    if (error
                                                        is SerialPortError) {
                                                      debugPrint(
                                                          'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                                                    }
                                                  });
                                                  _serialPort!.drain();
                                                  _serialPort!.flush();
                                                  setState(() {});
                                                  isDataPDFBill = true;
                                                  isDataReadBill = false;
                                                }
                                              : null,
                                          child: const Text('Read Meter Data'),
                                        ),
                                        TextButton(
                                          onPressed: (isDataPDFBill)
                                              ? () {
                                                  _serialPort!.drain();
                                                  _serialPort!.close();
                                                  setState(() {
                                                    getFiles();
                                                  });
                                                  Navigator.pop(context, '/');
                                                }
                                              : null,
                                          child: const Text('Create PDF'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        // Load Survey Card Tile
                        Card(
                          child: ListTile(
                            title: const Text(
                              'Load Survey',
                            ),
                            trailing: const Icon(Icons.download),
                            tileColor: const Color.fromARGB(232, 232, 124, 42),
                            enabled: true,
                            selected: false,
                            onTap: () => {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title:
                                          const Text('Read Load Survey Data'),
                                      content: const Text(
                                          "Press button for downloading",
                                          style: TextStyle(fontSize: 15)),
                                      actions: <StatefulWidget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                            _serialPort!.close();
                                            isDataReadLoad = true;
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: (_serialPort != null &&
                                                  isDataReadLoad &&
                                                  srlNo.isNotEmpty)
                                              ? () async {
                                                  _serialPort!.open(
                                                      mode: SerialPortMode
                                                          .readWrite);
                                                  _serialPort!.flush();
                                                  dynamic code = [
                                                    0x41,
                                                    0x2A,
                                                    0x0C,
                                                    srlNo[1],
                                                    srlNo[2],
                                                    srlNo[3],
                                                    srlNo[4],
                                                    0x12,
                                                    0x1A,
                                                    0x0D,
                                                    0x0A,
                                                  ];
                                                  _serialPort!.write(
                                                      Uint8List.fromList(code));

                                                  _serialPort!.flush();
                                                  SerialPortReader reader =
                                                      SerialPortReader(
                                                          _serialPort!,
                                                          timeout: 0);
                                                  reader.stream.listen((data) {
                                                    //receiveDataList.add(data);
                                                    mData = List.from(mData)
                                                      ..addAll(data);
                                                    debugPrint('$data');
                                                  }, onError: (error) {
                                                    if (error
                                                        is SerialPortError) {
                                                      debugPrint(
                                                          'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                                                    }
                                                  });
                                                  _serialPort!.drain();
                                                  _serialPort!.flush();
                                                  setState(() {});
                                                  isDataReadLoad = false;

                                                  isDataPDFLoad = true;
                                                }
                                              : null,
                                          child: const Text('Read Meter Data'),
                                        ),
                                        TextButton(
                                          onPressed: (isDataPDFLoad)
                                              ? () {
                                                  _serialPort!.drain();
                                                  createPDF();
                                                  _serialPort!.close();
                                                  setState(() {
                                                    getFiles();
                                                  });
                                                  Navigator.pop(context, '/');
                                                }
                                              : null,
                                          child: const Text('Create PDF'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              ),
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: const Text(
                              'Tamper 1',
                            ),
                            trailing: const Icon(Icons.download),
                            tileColor: const Color.fromARGB(232, 232, 124, 42),
                            enabled: true,
                            selected: false,
                            onTap: () => {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Read Tamper Data'),
                                      content: const Text(
                                          'Are you sure you want to download this PDF'),
                                      actions: <StatefulWidget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                            _serialPort!.close();
                                            isDataReadTamper = true;
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: (_serialPort != null &&
                                                  isDataReadTamper &&
                                                  srlNo.isNotEmpty)
                                              ? () async {
                                                  _serialPort!.open(
                                                      mode: SerialPortMode
                                                          .readWrite);
                                                  _serialPort!.flush();
                                                  dynamic code = [
                                                    0x41,
                                                    0x2A,
                                                    0x03,
                                                    srlNo[1],
                                                    srlNo[2],
                                                    srlNo[3],
                                                    srlNo[4],
                                                    0x57,
                                                    0x56,
                                                    0x0D,
                                                    0x0A,
                                                  ];
                                                  _serialPort!.write(
                                                      Uint8List.fromList(code));

                                                  _serialPort!.flush();
                                                  SerialPortReader reader =
                                                      SerialPortReader(
                                                          _serialPort!,
                                                          timeout: 0);
                                                  reader.stream.listen((data) {
                                                    //receiveDataList.add(data);
                                                    mData = List.from(mData)
                                                      ..addAll(data);
                                                    debugPrint('$data');
                                                  }, onError: (error) {
                                                    if (error
                                                        is SerialPortError) {
                                                      debugPrint(
                                                          'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                                                    }
                                                  });
                                                  _serialPort!.drain();
                                                  _serialPort!.flush();

                                                  setState(() {});
                                                  isDataPDFTamper = true;
                                                  isDataReadTamper = false;
                                                }
                                              : null,
                                          child: const Text('Read Meter Data'),
                                        ),
                                        TextButton(
                                          onPressed: (isDataPDFTamper)
                                              ? () {
                                                  _serialPort!.drain();
                                                  createPdfTamper1();
                                                  _serialPort!.close();
                                                  setState(() {
                                                    getFiles();
                                                  });
                                                  Navigator.pop(context, '/');
                                                }
                                              : null,
                                          child: const Text('Create PDF'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              ),
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: const Text(
                              'Tamper 2',
                            ),
                            trailing: const Icon(Icons.download),
                            tileColor: const Color.fromARGB(232, 232, 124, 42),
                            enabled: true,
                            selected: false,
                            onTap: () => {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Read Tamper Data'),
                                      content: const Text(
                                          'Are you sure you want to download this PDF'),
                                      actions: <StatefulWidget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                            _serialPort!.close();
                                            isDataReadTamper = true;
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: (_serialPort != null &&
                                                  isDataReadTamper &&
                                                  srlNo.isNotEmpty)
                                              ? () async {
                                                  _serialPort!.open(
                                                      mode: SerialPortMode
                                                          .readWrite);
                                                  _serialPort!.flush();
                                                  dynamic code = [
                                                    0x41,
                                                    0x2A,
                                                    0x06,
                                                    srlNo[1],
                                                    srlNo[2],
                                                    srlNo[3],
                                                    srlNo[4],
                                                    0x1A,
                                                    0x1C,
                                                    0x0D,
                                                    0x0A,
                                                  ];
                                                  _serialPort!.write(
                                                      Uint8List.fromList(code));

                                                  _serialPort!.flush();
                                                  SerialPortReader reader =
                                                      SerialPortReader(
                                                          _serialPort!,
                                                          timeout: 0);
                                                  reader.stream.listen((data) {
                                                    //receiveDataList.add(data);
                                                    mData = List.from(mData)
                                                      ..addAll(data);
                                                    debugPrint('$data');
                                                  }, onError: (error) {
                                                    if (error
                                                        is SerialPortError) {
                                                      debugPrint(
                                                          'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                                                    }
                                                  });
                                                  _serialPort!.drain();
                                                  _serialPort!.flush();

                                                  setState(() {});
                                                  isDataPDFTamper = true;
                                                  isDataReadTamper = false;
                                                }
                                              : null,
                                          child: const Text('Read Meter Data'),
                                        ),
                                        TextButton(
                                          onPressed: (isDataPDFTamper)
                                              ? () {
                                                  _serialPort!.drain();
                                                  createPDF();
                                                  _serialPort!.close();
                                                  setState(() {
                                                    getFiles();
                                                  });
                                                  Navigator.pop(context, '/');
                                                }
                                              : null,
                                          child: const Text('Create PDF'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              ),
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: const Text(
                              'TOD',
                            ),
                            trailing: const Icon(Icons.download),
                            tileColor: const Color.fromARGB(232, 232, 124, 42),
                            enabled: true,
                            selected: false,
                            onTap: () => {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Read TOD Data'),
                                      content: const Text(
                                          'Are you sure you want to download this PDF'),
                                      actions: <StatefulWidget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                            _serialPort!.close();
                                            isDataReadTOD = true;
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: (_serialPort != null &&
                                                  isDataReadTOD &&
                                                  srlNo.isNotEmpty)
                                              ? () async {
                                                  _serialPort!.open(
                                                      mode: SerialPortMode
                                                          .readWrite);
                                                  _serialPort!.flush();
                                                  dynamic code = [
                                                    0x41,
                                                    0x2A,
                                                    0x01,
                                                    srlNo[1],
                                                    srlNo[2],
                                                    srlNo[3],
                                                    srlNo[4],
                                                    0x5D,
                                                    0x5A,
                                                    0x0D,
                                                    0x0A,
                                                  ];
                                                  _serialPort!.write(
                                                      Uint8List.fromList(code));
                                                  _serialPort!.flush();
                                                  SerialPortReader reader =
                                                      SerialPortReader(
                                                          _serialPort!,
                                                          timeout: 0);
                                                  reader.stream.listen((data) {
                                                    //receiveDataList.add(data);
                                                    mData = List.from(mData)
                                                      ..addAll(data);
                                                    debugPrint('$data');
                                                  }, onError: (error) {
                                                    if (error
                                                        is SerialPortError) {
                                                      debugPrint(
                                                          'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                                                    }
                                                  });
                                                  _serialPort!.drain();
                                                  _serialPort!.flush();

                                                  setState(() {});
                                                  isDataPDFTOD = true;
                                                  isDataReadTOD = false;
                                                }
                                              : null,
                                          child: const Text('Read Meter Data'),
                                        ),
                                        TextButton(
                                          onPressed: (isDataPDFTOD)
                                              ? () {
                                                  _serialPort!.drain();
                                                  createPDF();
                                                  _serialPort!.close();
                                                  setState(() {
                                                    getFiles();
                                                  });
                                                  Navigator.pop(context, '/');
                                                }
                                              : null,
                                          child: const Text('Create PDF'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              ),
                            },
                          ),
                        ),
                        /*   const Spacer(),
                        //Add button to explicitly close an serial Port
                        ElevatedButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.settings,
                            size: 35,
                          ),
                          label: const Text(
                            'Settings',
                            textScaleFactor: 2,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 100, bottom: 5)),*/
                      ],
                    ),
                  ),
                  //  List of meter reading in the form of pdf as Listile
                  Flexible(
                    flex: 85,
                    child: files == null
                        ? const Text(
                            "No File Available",
                            style: TextStyle(fontSize: 50),
                            textAlign: TextAlign.center,
                            selectionColor: Colors.black,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(1, 2, 5, 0),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height - 20 , 
                                child: ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  dragStartBehavior: DragStartBehavior.start,
                                  itemCount: files?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    fileName = basename(files[index].path);
                                    String rTC =
                                        '${fileName.substring(13, 15)}/${fileName.substring(11, 13)}/${fileName.substring(7, 11)}, ${fileName.substring(15, 17)}:${fileName.substring(17, 19)}:${fileName.substring(19, 21)}';
                                    String seNo =
                                        '${fileName.substring(0, 7)}';
                                    String typeOfReading =
                                        '${fileName.substring(21, fileName.length - 4)}';
                                    return Card(
                                        child: ListTile(
                                      title: Text(
                                          '   Serial Number: $seNo              System RTC: $rTC              Type of Reading: $typeOfReading '),
                                      leading:
                                          const Icon(Icons.picture_as_pdf),
                                      trailing: const Icon(
                                          Icons.open_in_browser_rounded),
                                      tileColor: const Color.fromARGB(
                                          154, 67, 72, 121),
                                      onTap: () async {
                                        await OpenDocument.openDocument(
                                            filePath: files[index]
                                                .path
                                                .split('/')
                                                .last);
                                      },
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  void determinateIndicator() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (value == 1) {
        timer.cancel();
      }
      setState(() {});
      value = value + 0.1;
    });
  }
}



/*appBar: NavigationAppBar(
          title: const Text(
            'Gepdec Energy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  SizedBox(height: 10,),
                  material.OutlinedButton(child: const Text('Log Out'), onPressed: () {}),
                ],
              ),
              const SizedBox(
                width: 20,
                height: 10,
              )
            ],
          )
          ),
      pane: NavigationPane(items: [
        PaneItem(
            icon: const Icon(FluentIcons.read),
            title: const Text('Port Selection'),
            body: const ButtonPage(),
            ),
      
        PaneItem(
            icon: const Icon(FluentIcons.bill),
            title: const Text('Instantaneous'),
            body: Text('hello'),
            onTap:  
                  ),
                
        PaneItem(
          
            icon: const Icon(FluentIcons.bill),
            title: const Text('Billing'),
            body: const Text('')),
        PaneItem(
            icon: const Icon(FluentIcons.bill),
            title: const Text('Load Survey'),
            body: const Text('')),
        PaneItem(
            icon: const Icon(FluentIcons.bill),
            title: const Text('Tampers'),
            body: const Text('')),
        PaneItem(
            icon: const Icon(FluentIcons.bill),
            title: const Text('TOD'),
            body: const Text('')),
      ],
      ),*/
