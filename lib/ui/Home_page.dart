import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _search = "Building";
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response response;
    if (_search == "") {
      print(1);
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/trending?api_key=QptEZIIGWxwJ6LTSOZ6R1R7GG3cyqxiv&limit=25&rating=g'));
    } else {
      print(2);
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/search?api_key=QptEZIIGWxwJ6LTSOZ6R1R7GG3cyqxiv&q=$_search&limit=25&offset=$_offset&rating=g&lang=en'));
    }
    //print(response);
    return json.decode(response.body);
  }

  @override
  void intState() {
    super.initState();
    _getGif().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisar Gif",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child:  FutureBuilder(
                future: _getGif(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) return Container();
                      else {
                        return _creatGifTable(context, snapshot);
                      }
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _creatGifTable(BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data['data'][0]['title']);
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
                itemCount: snapshot.data['data'].length,
        itemBuilder: (context, index){
          return GestureDetector(
            child: Image.network(snapshot.data['data'][index]['images']['original']['url'],
            height: 300.00,
            fit: BoxFit.cover,
            ),
          );
        }
    );
  }
}
