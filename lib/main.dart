import 'package:coinapp/provider/coin_provider.dart';
import 'package:coinapp/provider/websocket_provider.dart';
import 'package:coinapp/ui/coindata_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//App based on Provider, REST API, WebSocket
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MultiProvider(
         providers: [
            ChangeNotifierProvider<CoinProvider>(create: (context) => CoinProvider()),
            ChangeNotifierProvider<WebSocketProvider>(create: (context) => WebSocketProvider()),
          ],
             child: CoindataScreen(),
        ),
    );
  }
}

