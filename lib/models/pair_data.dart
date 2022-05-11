class PairData {

  String? symbol_id;
  String? time_exchange;
  String? time_coinapi;
  String? uuid;
  double? price;
  double? size;
  String? taker_side;

  PairData.fromJson(Map<String, dynamic> json)
      : symbol_id = json['symbol_id'],
        time_exchange = json['time_exchange'],
        time_coinapi =  json['time_coinapi'],
        uuid = json['uuid'],
        price = json['price'].toDouble(),
        size = json['size'].toDouble(),
        taker_side = json['taker_side'];

  Map<String, dynamic> toJson() => {
    'symbol_id': symbol_id,
    'time_exchange': time_exchange,
    'time_coinapi': time_coinapi,
    'uuid' : uuid,
    'price' : price,
    'size' : size,
    'taker_side' : taker_side
  };

}