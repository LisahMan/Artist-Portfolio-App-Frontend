import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'startscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'portfolioscreen.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>{


 Widget appBarTitle = Text("Home");
 Icon actionIcon = Icon(Icons.search);
 TextEditingController searchController = TextEditingController();

  _logOut() async{
   final prefs = await SharedPreferences.getInstance();
   prefs.remove('id');
   prefs.remove('username');
   prefs.remove('mobile');
   prefs.setBool('loggedIn', false);
 }

 _logOutAlert(BuildContext context){
      AlertDialog alertDialog = new AlertDialog(
        title: Text("Log Out"),
        content: Text("Do you want to Log Out?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel",style: TextStyle(color: Colors.black),),
            onPressed: (){
              Navigator.of(context).pop();
            },

          ),

          RaisedButton(
            color: Colors.grey,
            child: Text("Log Out",style: TextStyle(color: Colors.white),),
            onPressed: (){
              _logOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/start', ModalRoute.withName('/home'));
            },
          )
        ],
      );

      showDialog(context: context,
         builder: (context){
           return alertDialog;
         });
 }







  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: (){
                 Navigator.of(context).pushNamed('/searchuser');
//               setState(() {
//                 if(this.actionIcon.icon == Icons.search){
//                   this.actionIcon = Icon(Icons.close);
//                   this.appBarTitle = TextField(
//                     style: TextStyle(
//                       color: Colors.white
//                     ),
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search,color: Colors.white,),
//                       hintText: "Search",
//                       hintStyle: TextStyle(color: Colors.white),
//                     ),
//                     onSubmitted: (value){
//                       debugPrint(value);
//                     },
//                   );
//                 }
//                 else{
//                   this.actionIcon = Icon(Icons.search);
//                   this.appBarTitle = Text("Home");
//                 }
//               });
            },
          ),

          IconButton(
            icon: Icon(Icons.power_settings_new,color: Colors.white,),
            onPressed: (){
              _logOutAlert(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
//          RaisedButton(
//              child: Text("Log Out"),
//              onPressed: (){
//                _logOut();
//                Navigator.of(context).pushNamedAndRemoveUntil('/start', ModalRoute.withName('/home'));
//              }),

            Container(
            height: 40.0,
            width: 200.0,
            child: RaisedButton(
              color: Colors.lightBlue,
              child: Text("Add an Image",style: TextStyle(color: Colors.white),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              onPressed: (){
                Navigator.of(context).pushNamed('/selectimage');
              },

            ),
        )
            ,

            SizedBox(
              height: 10.0,
            ),

            Container(
              height: 40.0,
              width: 200.0,
              child: RaisedButton(
                color: Colors.lightBlueAccent,
                child: Text("Portfolio",style: TextStyle(color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PortfolioScreen();
                  }));
                },
              ),
            )

          ],


        ),
      )


    );


  }
}