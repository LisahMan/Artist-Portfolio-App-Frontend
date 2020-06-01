import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intern_project_app/screens/homescreen.dart';

class SignupScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen>{

  var _signupFormKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void _setSignupInfo(String id,String username,String mobile) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
    prefs.setString("username", username);
    prefs.setString("mobile", mobile);
    prefs.setBool("loggedIn", true);
  }

  void postData(BuildContext context) async{
    Map<String,dynamic> body = {'username' : usernameController.text,'password' : passwordController.text,'mobile_number' : mobileController.text,'address' : addressController.text};
    String url = "http://10.0.2.2:8000/user/";

    var response = await http.post(url,
      headers: {
        "Accept" : "application/json",
        "Content-Type" : "application/json"
      },
      body: json.encode(body)
    );

   var data = json.decode(response.body);
   if(data.toString().contains("Enter")) {
     debugPrint("data : $data");
     final _snackBar = SnackBar(content: Text("Please Enter a new Username"),);
     _scaffoldKey.currentState.showSnackBar(_snackBar);
   }else{
     _setSignupInfo(data['id'], data['username'], data['mobile_number']);
     Navigator.of(context).pushNamedAndRemoveUntil('/home',ModalRoute.withName('/start'));

   }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Sign Up"),
      ),
      body: Form(
        key: _signupFormKey,
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
                    obscureText: true,
                    validator: (value){
                    if(value.isEmpty){
                      return "Please enter your Password";
                    }
                    else if(value.length<8){
                      return "The minimum length of password is 8";
                    }
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "********",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    validator: (value){
                      if(value.isEmpty){
                        return "Please Enter your mobile number";
                      }
                      else if(value.length<10){
                        return "The minimum length of mobile number is 10";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      hintText: "9818676627",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: addressController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter your address";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Address",
                      hintText: "Banansthali",
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
                        child: Text("Sign Up",style: TextStyle(fontSize: 25.0,color: Colors.white)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),),
                        onPressed: (){
                           if(_signupFormKey.currentState.validate()){
                             postData(context);
                           }
                        }),
                  ),
                )

              ]
            ),
        ),
      )

    );
  }

}