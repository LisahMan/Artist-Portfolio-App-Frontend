import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intern_project_app/args/screenarguments.dart';

class SearchScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen>{

  List<UserDetail> _userList = new List<UserDetail>();

  void getSearchedUser(String username) async{

    String url = "http://10.0.2.2:8000/user/search/";
    Map<String,dynamic> body = {'username' : username};

    List<UserDetail> userList = new List<UserDetail>();

    var response = await http.post(url,
        headers: {
          "Accept" : "application/json",
          "Content-Type" : "application/json"
        },
        body: json.encode(body)
    );

    var data = json.decode(response.body);

    for(var u in data ){
      userList.add(UserDetail.fromJson(u));
    }

    setState(() {
      this._userList = userList;
    });

    debugPrint('SearchData : $data');

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            style: TextStyle(
                color: Colors.white
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search,color: Colors.white,),
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white),
            ),
            onSubmitted: (value){

                debugPrint(value);
                getSearchedUser(value);

            },
          ),
        ),

      body: (_userList.length==0)
             ? Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("No result",style: TextStyle(fontSize: 20.0),),
      )

             : ListView.builder(
               itemCount: _userList.length,
               itemBuilder: (context,position){
                 return ListTile(
                   leading: Icon(Icons.supervised_user_circle),
                   title: Text(_userList[position].username),
                   onTap: (){
                     Navigator.of(context).pushNamed('/searchresult',arguments: ScreenArguments(_userList[position].id,_userList[position].username));
                   },
                 );
               })
    );
  }
}

class UserDetail{

  String _id;
  String _username;

  UserDetail(this._id,this._username);

  String get id =>this._id;
  String get username => this._username;

  void set id(String id){
    this._id = id;
  }

  void set username(String username){
    this._username = username;
  }

  UserDetail.fromJson(Map<String,dynamic> json){
    this._id = json['id'];
    this._username = json['username'];
  }
}