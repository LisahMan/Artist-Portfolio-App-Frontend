import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen>{

  var _loginFormKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _setLoginInfo(String id , String username,String mobile) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
    prefs.setString("username",username);
    prefs.setString("mobile", mobile);
    prefs.setBool("loggedIn", true);

  }

  void _postData(BuildContext context) async{
    Map<String,dynamic> body = {'username' : usernameController.text , 'password' : passwordController.text};
    String url = "http://10.0.2.2:8000/user/auth/";

    var response = await http.post(url,
        headers: {
          "Accept" : "application/json",
          "Content-Type" : "application/json"
        },
        body: json.encode(body)
    );

    var data = json.decode(response.body);
    if(data.toString().contains("Enter")){
      final _snackbar = SnackBar(content: Text("Enter Username and Password again!"));
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    }
    else{
      _setLoginInfo(data['id'], data['username'], data['mobile_number']);
      Navigator.of(context).pushNamedAndRemoveUntil('/home', ModalRoute.withName('/start'));
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Login"),),
      body: Form(
          key: _loginFormKey,
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: <Widget>[

                  TextFormField(
                    controller: usernameController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter your Username";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Johndoe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),

                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your password";
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "*********",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Container(
                      width: 250.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),),
                         child: Text("Login",style: TextStyle(fontSize: 25.0,color: Colors.white),),
                          onPressed: (){
                          if(_loginFormKey.currentState.validate()){
                            debugPrint("login validated");
                            _postData(context);
                          }
                          }),
                    ),
                  )
                ],
              ),
          )
      ),
    );
  }
}