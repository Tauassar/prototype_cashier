

class DummyVariables {
  static String uid='lon5kfHtDcVMLn1f5uzth9ZGBFA3';
  //Data coming from RFID scanners
  List getItemID(){
    return [1,3,5,6,2,2,3,1,1,1];
  }
//data from biometric cameras
  String getUID(){
    return uid;
  }
  //Data coming from the bank terminal
  bool Payment(){
    return true;
  }
}

