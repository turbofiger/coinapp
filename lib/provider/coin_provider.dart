import 'package:coinapp/models/pair_data.dart';
import 'package:coinapp/resources/coin_api.dart';
import 'package:flutter/widgets.dart';

class CoinProvider with ChangeNotifier {

  double _data=0;
  String _time='';
  String _pair='';
  List<PairData> pdList=[];

  get list{
    return pdList;
  }

  double get data => _data;

  String get time => _time;

  String get pair => _pair;

  //Method check input data for containing literal of pair with /
  bool getPairHistory(var pair){
    if(pair.toString().contains('/') && pair.toString().length > 6){
      getData(pair);
      return true;
    }else{
      return false;
    }
  }

  //Method save List<PairData> and call listeners
  getData(String pair)async{
     pdList = await CoinApi().getHistoricalData(pair.split('/')[0], pair.split('/')[1]);
     notifyListeners();
  }

}