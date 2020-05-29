import 'package:http/http.dart' as http;
import 'dart:convert';

class Carton {
  final String id;
  final List<int> value;
  final String gameId;

  Carton({this.id, this.value, this.gameId});

  factory Carton.fromJson(Map<String, dynamic> val,game) {
    final data = new List<int>.from(val['values']);
    return Carton(id: val['id'], value: data,gameId: game);
  }

  static Future<http.Response> fetchCard(String i) async =>
      await http.get("https://ganger-bingo.herokuapp.com/new_card/" + i);

  Future<http.Response> isLinea(String name) async =>
      await http.get("https://ganger-bingo.herokuapp.com/linea/${gameId}/${id}/$name");

  static Future<Carton> newCarton(String game) async {
    var r = await fetchCard(game);
    final Map<String, dynamic> body = json.decode(r.body.trim());
    return Carton.fromJson(body,game);
  }

  Future<http.Response> isBingo(String name) async =>
      await http.get("https://ganger-bingo.herokuapp.com/bingo/${gameId}/${id}/$name");


}
