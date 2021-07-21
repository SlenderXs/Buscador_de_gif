import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _search = "";
  int _offset = 0;

 Future<Map> _getGif() async {
    http.Response response;


    if(_search == "") {
      var url = Uri.https('api.giphy.com',
          '/v1/gifs/trending?api_key=QptEZIIGWxwJ6LTSOZ6R1R7GG3cyqxiv&limit=20&rating=g', {'q': '{http}'});
      response = await http.get(url);
    }
  else {
      var url = Uri.https('api.giphy.com',
          '/v1/gifs/search?api_key=QptEZIIGWxwJ6LTSOZ6R1R7GG3cyqxiv&q=$_search&limit=20offset=$_offset&rating=g&lang=en', {'q': '{http}'});
      response = await http.get(url);
    }
  return json.decode(response.body);
  }

  //@override
  void intState() {
   super.initState();
   _getGif().then((map){
     print(map);
   });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



