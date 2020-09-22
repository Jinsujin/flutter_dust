import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_dust/models/air_result.dart';

class AirBloc {
  final _airSubject = BehaviorSubject<AirResult>();

  /// 앱이 시작하자 마자, API 로 데이터를 기져옴
  AirBloc() {
    fetch();
  }

// 비동기 데이터는 Future 로 받아야 한다
  Future<AirResult> fetchData() async {
    var response = await http.get(
        'http://api.airvisual.com/v2/nearest_city?key=2b265a6b-83d7-4e09-88e3-8854aefa9a78');
    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  void fetch() async {
    print('start fetch');
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

// _airSubject의 스트림을 getter로 외부에 꺼낼수 있도록 함
  Stream<AirResult> get airResult => _airSubject.stream;
}
