import 'package:coinapp/models/converter_time.dart';
import 'package:coinapp/models/pair_data.dart';
import 'package:coinapp/provider/coin_provider.dart';
import 'package:coinapp/provider/websocket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toast/toast.dart';

class CoindataScreen extends StatefulWidget {

  @override
  State<CoindataScreen> createState() => _CoindataScreenState();
}

class _CoindataScreenState extends State<CoindataScreen> with WidgetsBindingObserver {
  TextEditingController coinController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: singleCoin(context),
    );
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        (context.read<WebSocketProvider>().getPair(coinController.text.trim()) &&
            context.read<CoinProvider>().getPairHistory(coinController.text.trim())) ? null :
        Toast.show('Enter correct data', duration: Toast.lengthShort, gravity:  Toast.center);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        context.read<WebSocketProvider>().stop();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  Widget singleCoin(BuildContext context){
    return Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    children:[
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        margin: EdgeInsets.only(left: 10, right: 10, ),
                        child: TextFormField(
                          controller: coinController,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintText: 'input coin pair',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen
                            ),
                            onPressed: () {
                              (context.read<WebSocketProvider>().getPair(coinController.text.trim()) &&
                                  context.read<CoinProvider>().getPairHistory(coinController.text.trim()))? null :
                              Toast.show('Enter correct data', duration: Toast.lengthShort, gravity:  Toast.center);
                            },
                            child: Text('Subscribe')),
                      )
                    ],
                  ),
                  context.watch<WebSocketProvider>().pair!=null ? Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.lightGreen,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3-20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Symbol'),
                              Text(context.watch<WebSocketProvider>().pair!),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Price'),
                              Text('\$'+context.watch<WebSocketProvider>().price!.toStringAsFixed(3)),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Time'),
                              Text(context.watch<WebSocketProvider>().time!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ): Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    width: 80,
                    height: 80,
                    child: context.watch<WebSocketProvider>().progressBar ? CircularProgressIndicator(
                      color: Colors.lightGreen,
                    ) : null,
                  ),
                  context.watch<CoinProvider>().pdList.length > 0 ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Charting data:'),
                  ) : Container(),
                  context.watch<CoinProvider>().pdList.length > 0 ? widgetChart(context) :
                  Container(
                    alignment: Alignment.center,
                    child: Text('Enter pair data into field like BTC/USD or ETH/USD'),
                  ),
                ],
              ),
    );
  }

  Widget widgetChart(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height/2,
        child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<PairData, DateTime>(
                  dataSource: context.watch<CoinProvider>().pdList,
                  xValueMapper: (PairData pdata, _) =>
                    DateTime.fromMillisecondsSinceEpoch(ConverterTime().millisMy(pdata.time_coinapi.toString())),
                  yValueMapper: (PairData pdata, _) => pdata.price
              )
            ]
        )
    );
  }
}
