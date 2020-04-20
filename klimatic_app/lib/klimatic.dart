import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'utils.dart';
class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
  Future _goToNextScreen(BuildContext context)async{
  Map results =   await Navigator.of(context).push(new MaterialPageRoute(
        builder:(BuildContext context){
      return new ChangeCity();
    }));
  if(results!=null && results.containsKey('enter'))
    {
      _cityEntered = results['enter'];
      print(results['enter'].toString());
    }
  }
  void showStuff()async
  {
    Map data = await getweather(appId,defaultCity);
    print(data.toString());
  }
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Klimatic'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions:<Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed:(){
                _goToNextScreen(context);
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/backG.jpg',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0),
            child: new Text('${_cityEntered==null ? defaultCity:_cityEntered}',
            style: citystyle(),),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/happy_cloud.jpg',
            width: 147.0,
            height:360.0,
            ),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(75.0, 340.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: updateTempWidget(_cityEntered),
          ),
        ],
        )
      );
  }
  Future<Map>getweather(String appId, String city)async
  {
    String apiurl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric';
    http.Response response = await http.get(apiurl);
    return json.decode(response.body);
  }
  Widget updateTempWidget(String city)
  {

    return new FutureBuilder(
        future: getweather(appId,city==null ? defaultCity:city),
        builder:(BuildContext context,AsyncSnapshot<Map> snapshot)
    {

        if(snapshot.hasData)
          {
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(content['main']['temp'].toString()+" C",
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 50.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    ),),
                    subtitle: new ListTile(
                      title: new Text(""
                          "Humidity: ${content['main']['humidity'].toString()}\n"
                      "Min:${content['main']['temp_min'].toString()} C\n"
                      "Max: ${content['main']['temp_max'].toString()} C\n",
                      style:extraData(),
                      ),
                    ),

                  )
                ],
              )
            );
          }
        else
          {
            return new Container();
          }
    });
  }
}
class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
            new Image.asset('images/snow.jpg',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City'
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed:(){ Navigator.pop(context,{
                      'enter':_cityFieldController
                    });},
                    textColor: Colors.white70,
                    color: Colors.black54,
                    child: new Text('Get Weather',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white70
                    ),)),
              )
            ],
          )
        ],
      ),
    );
  }
}
TextStyle extraData()
{
  return new TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.normal,
    fontSize: 25.0
  );
}

TextStyle citystyle()
{
  return new TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w500,
    fontSize: 45.0,
    fontStyle: FontStyle.italic
  );
}
TextStyle temp()
{
  return new TextStyle(
    color: Colors.red,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 50.0
  );
}