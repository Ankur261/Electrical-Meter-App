import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:test_app2/Data_Conversion.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'dart:io';

Future<Uint8List> meterReportPDF() async {
  final pdf = pw.Document();
  addZero() ;
  pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (pw.Context context) {
      return <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text('Gepdec Energy Pvt. Ltd.', textScaleFactor: 2),
                ])),
        pw.Header(level: 1, text: 'Instantaneous Parameter'),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Column(children: <pw.Widget>[
          pw.Container(
            margin: const pw.EdgeInsets.all(20),
            child: pw.Table(
              defaultColumnWidth: const pw.FixedColumnWidth(120.0),
              border: pw.TableBorder.all(style: pw.BorderStyle.solid, width: 2),
              children: [
                pw.TableRow(children: [
                  pw.Column(children: [
                    pw.Text('Parameter',
                        style: const pw.TextStyle(fontSize: 14.0))
                  ]),
                  pw.Column(children: [
                    pw.Text('Value', style: const pw.TextStyle(fontSize: 14.0))
                  ]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Serial Number')]),
                  pw.Column(children: [pw.Text('${serialNo()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('RTC')]),
                  pw.Column(children: [
                    pw.Text(
                        '${mData[5]}/${mData[6]}/${mData[7]}  ${mData[8]}:${mData[9]}:${mData[10]}'),
                  ]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('RTC Error')]),
                  pw.Column(children: [pw.Text(mData[11].toString())]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('KWH')]),
                  pw.Column(children: [pw.Text('')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Power Factor')]),
                  pw.Column(children: [pw.Text(mData[19].toString())]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Frequency')]),
                  pw.Column(children: [pw.Text('${frequency()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Phase Voltage')]),
                  pw.Column(children: [pw.Text('${phaseVoltage()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Phase Current')]),
                  pw.Column(children: [pw.Text('${phaseCurrent()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Neutral Current')]),
                  pw.Column(children: [pw.Text('${neutralCurrent()}')]),
                ]),
              ],
            ),
          ),
        ])
      ];
    },
  ));
  return pdf.save();
}

Future<Uint8List> meterReportPdfTamper1() async {
  final pdf = pw.Document();
  pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (pw.Context context) {
      return <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text('Gepdec Energy Pvt. Ltd.', textScaleFactor: 2),
                ])),
        pw.Header(level: 1, text: 'Tamper Data,'),
        pw.Padding(padding: const pw.EdgeInsets.all(20)),
        pw.Column(children: <pw.Widget>[
          pw.Container(
            margin: const pw.EdgeInsets.all(20),
            child: pw.Table(
              defaultColumnWidth: const pw.FixedColumnWidth(120.0),
              border: pw.TableBorder.all(style: pw.BorderStyle.solid, width: 2),
              children: [
                pw.TableRow(children: [
                  pw.Column(children: [
                    pw.Text('Parameter',
                        style: const pw.TextStyle(fontSize: 14.0))
                  ]),
                  pw.Column(children: [
                    pw.Text('Value', style: const pw.TextStyle(fontSize: 14.0))
                  ]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Serial Number')]),
                  pw.Column(children: [pw.Text('${serialNo()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('RTC')]),
                  pw.Column(children: [
                    pw.Text(
                        '${mData[5]}/${mData[6]}/${mData[7]}  ${mData[8]}:${mData[9]}:${mData[10]}'),
                  ]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('RTC Error')]),
                  pw.Column(children: [pw.Text(mData[11].toString())]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('KWH')]),
                  pw.Column(children: [pw.Text('')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Power Factor')]),
                  pw.Column(children: [pw.Text(mData[19].toString())]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Frequency')]),
                  pw.Column(children: [pw.Text('${frequency()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Phase Voltage')]),
                  pw.Column(children: [pw.Text('${phaseVoltage()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Phase Current')]),
                  pw.Column(children: [pw.Text('${phaseCurrent()}')]),
                ]),
                pw.TableRow(children: [
                  pw.Column(children: [pw.Text('Neutral Current')]),
                  pw.Column(children: [pw.Text('${neutralCurrent()}')]),
                ]),
              ],
            ),
          ),
        ])
      ];
    },
  ));
  return pdf.save();
}

Future<void> savePdfFile(Uint8List byteList, String type) async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = '${appDocumentsDirectory.path}/Gepdec Energy';
  final now = DateTime.now().toString();
  final time = now.replaceAll(RegExp('[^0-9]'), '');
  final file = File(
      "$appDocumentsPath/${serialNo()}${time.substring(0, time.length - 6)}-$type.pdf");
  await file.writeAsBytes(byteList);
}

createPDF() async {
  final data = await meterReportPDF();
  await savePdfFile(data, 'Instantaneous');
  mData.clear();
}

createPdfTamper1() async {
  final data = await meterReportPdfTamper1();
  await savePdfFile(data, 'Tamper1');
  mData.clear();
}
