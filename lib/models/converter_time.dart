class ConverterTime {

  millisMy(String str){
     str=str.replaceAll(RegExp('T'), ' ');
     str=str.substring(0,23);
     var parsedDate = DateTime.parse(str);
     return parsedDate.millisecondsSinceEpoch;
  }
}