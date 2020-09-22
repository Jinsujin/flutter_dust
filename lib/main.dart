import 'package:flutter/material.dart';
import 'package:flutter_dust/models/AirResult.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult _result;

// 비동기 데이터는 Future 로 받아야 한다
  Future<AirResult> fetchData() async {
    var response = await http.get(
        'http://api.airvisual.com/v2/nearest_city?key=2b265a6b-83d7-4e09-88e3-8854aefa9a78');
    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

// 초기에 수행되는 생명주기 함수
  @override
  void initState() {
    super.initState();

// 비동기로 데이터를 가져왔을경우, 해당 데이터를 result 에 넣고 setState 로 화면을 갱신한다
    fetchData().then((airResult) {
      setState(() {
        _result = airResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _result == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('현재 위치 미세먼지', style: TextStyle(fontSize: 30)),
                      SizedBox(
                        height: 16,
                      ),
                      Card(
                          child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text('얼굴사진'),
                                Text('${_result.data.current.pollution.aqius}',
                                    style: TextStyle(fontSize: 40)),
                                Text(getString(_result),
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            color: getColor(_result),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.network(
                                        'https://airvisual.com/images/${_result.data.current.weather.ic}.png',
                                        width: 32,
                                        height: 32),
                                    SizedBox(width: 16),
                                    Text('${_result.data.current.weather.tp}',
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Text('습도 ${_result.data.current.weather.hu}%',
                                    style: TextStyle(fontSize: 16)),
                                Text('풍속 ${_result.data.current.weather.ws}m/s',
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          )
                        ],
                      )),
                      SizedBox(
                        height: 16,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: RaisedButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 50),
                            onPressed: () {},
                            color: Colors.orange,
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ));
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return Colors.greenAccent;
    } else if (result.data.current.pollution.aqius <= 100) {
      return Colors.yellow;
    } else if (result.data.current.pollution.aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return '좋음';
    } else if (result.data.current.pollution.aqius <= 100) {
      return '보통';
    } else if (result.data.current.pollution.aqius <= 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
