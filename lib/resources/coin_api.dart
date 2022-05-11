import 'dart:convert';
import 'package:coinapp/models/pair_data.dart';
import 'package:http/http.dart' as http;

const apiKey = '93B45286-137C-4820-89A6-9F13A46DC213';
//const apiKey = 'CB9B77F2-9F1C-41C0-A252-385A34E79481'; //rig

class CoinApi {

  //Method not used in app. It returns one data of pair
  Future<dynamic> getRate(String pair) async {
    var url = 'https://rest.coinapi.io/v1/exchangerate/$pair?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {

      var decodedData = jsonDecode(response.body);

      return decodedData;
    } else {
      throw 'Have a problem with request';
    }
  }

  //Method return List with PairData models
  Future<List<PairData>> getHistoricalData(String coin1, String coin2) async {
    var url = 'https://rest.coinapi.io/'
        'v1/trades/BITSTAMP_SPOT_'+coin1+'_'+coin2+'/history?period_id=1MIN&time_start=2022-05-10T00:00:00&time_end=2022-05-11T00:00:00&limit=1000&include_id=false';

    var headers = {'X-CoinAPI-Key' : '$apiKey'};
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {

      Iterable list = json.decode(response.body);
      List<PairData> pdList = List<PairData>.from(list.map((model)=> PairData.fromJson(model)));

      return pdList as List<PairData>;
    } else {
      throw 'Have a problem with request';
    }
  }
}