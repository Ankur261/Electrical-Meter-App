import 'package:number_system/number_system.dart';
import 'main.dart';

serialNo() {
  dynamic s = ['0', '0', '0', '0'];
  s[0] = srlNo[1].toRadixString(16);
  s[1] = srlNo[2].toRadixString(16);
  s[2] = srlNo[3].toRadixString(16);
  s[3] = srlNo[4].toRadixString(16);
  String str = (s[3] + s[2] + s[1] + s[0]);
  int sNo = str.hexToDEC();
  return sNo;
}

frequency() {
  var s = ['0', '0'];
  s[0] = mData[30].toRadixString(16);
  s[1] = mData[31].toRadixString(16);
  String str1 = (s[1] + s[0]);
  int freq = str1.hexToDEC();
  double freq1 = freq / 1000;
  return freq1;
}

phaseVoltage() {
  var s = ['0', '0'];
  s[0] = mData[41].toRadixString(16);
  s[1] = mData[42].toRadixString(16);
  String str1 = (s[1] + s[0]);
  int phsVol = str1.hexToDEC();
  double phsVol1 = phsVol / 100;
  return phsVol1;
}

phaseCurrent() {
  var s = ['0', '0'];
  s[0] = mData[57].toRadixString(16);
  s[1] = mData[58].toRadixString(16);
  String str1 = (s[1] + s[0]);
  int phsCrnt = str1.hexToDEC();
  double phsCrnt1 = phsCrnt / 100;
  return phsCrnt1;
}

neutralCurrent() {
  var s = ['0', '0'];
  s[0] = mData[59].toRadixString(16);
  s[1] = mData[60].toRadixString(16);
  String str1 = (s[1] + s[0]);
  int neuCrnt = str1.hexToDEC();
  double neuCrnt1 = neuCrnt / 100;
  return neuCrnt1;
}

addZero() {
  dynamic s;
  for (int i = 5; i < 11; i++) {
    s = mData[i].toString() ;
    if (s.length == 1) {
      s = s.padLeft(2, '0');
    }
    mData[i] = s;
  }
}
