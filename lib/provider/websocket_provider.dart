import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

//const apiKey = '93B45286-137C-4820-89A6-9F13A46DC213'; //tur
const apiKey = 'CB9B77F2-9F1C-41C0-A252-385A34E79481'; //rig

class WebSocketProvider with ChangeNotifier {

  var _price;
  var _time;
  var _pair;
  bool _progressBar = false;

  WebSocketChannel? channel;

  set progressBar(bool value) {
    _progressBar = value;
    notifyListeners();
  }

  bool get progressBar => _progressBar;

  get price => _price;

  get time => _time;

  get pair => _pair;

  set pair(value) {
    _pair = null;
    _progressBar=true;
    notifyListeners();
  }

  setprice(value) {
    _price = value;
    notifyListeners();
  }

  setdata(var data, var pair){
    if(data['bid_price']!=null) {
      _price = data['ask_price'];
      _time = Jiffy(data['time_exchange']).format('dd MMM, hh:mm');
      _pair = pair;
    }
    notifyListeners();
  }

  void stop(){
    if(channel!=null) {
      channel!.stream.skip(0);
      channel!.sink.close();
    }
  }

  bool getPair(var pair){
    if(pair.toString().contains('/') && pair.toString().length > 6){
      start(pair);
      return true;
    }else{
      return false;
    }
  }

  //Method connect to WSS, data saves with ChangeNotifier
  void start(var pair) async {
    _pair = null;
    _progressBar=true;
    notifyListeners();

    if(channel!=null){
      channel!.stream.skip(0);
      channel!.sink.close();
    }

    channel = WebSocketChannel.connect(
        Uri.parse('wss://ws-sandbox.coinapi.io/v1/'),
    );

    channel!.sink.add(
      jsonEncode(
        {
          "type": "hello",
          "apikey": "$apiKey",
          "heartbeat": false,
          "subscribe_data_type": ["quote"],
          "subscribe_filter_asset_id": ["$pair"]
        },
      ),
    );

    channel!.stream.listen(
          (data) {
            var message= json.decode(data);
            setdata(message, pair);
      },
      onError: (error) => print(error),
    );
  }


}