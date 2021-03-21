import 'package:flutter/material.dart';
import 'package:todo_getx/blocs/bloc_user.dart';
import 'package:provider/provider.dart';
import 'package:todo_getx/screens/register_page.dart';
import 'package:todo_getx/screens/home_page.dart';
import 'package:todo_getx/widgets/size_config.dart';

class LoginPage extends StatelessWidget {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // get scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void loginUser(BuildContext context, String email, String password) async {
    String result = await Provider.of<BlocUser>(context, listen: false)
        .signIn(email, password);
    if (result == "login-success") {
      // maka login berhasil
      print('login-success');

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      // Navigator.pop(context);
      // maka login gagal
      print(result);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text(result),
        duration: new Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 0.3,
          horizontal: SizeConfig.safeBlockHorizontal * 12.3),
      child: Row(
        children: [
          // first children: email logo
          Padding(
            padding:
                EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 4.0),
            child: Icon(
              Icons.mail,
              color: Colors.blue,
            ),
          ),
          // second children: input email
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'email.'),
              keyboardType: TextInputType.emailAddress,
              controller: emailTextController,
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF211551)),
            ),
          )
        ],
      ),
    );

    final password = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 0.3,
          horizontal: SizeConfig.safeBlockHorizontal * 12.3),
      child: Row(
        children: [
          // first children: password/key logo
          Padding(
            padding:
                EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 4.0),
            child: Icon(
              Icons.lock,
              color: Colors.blue,
            ),
          ),
          // second children: textfield
          Expanded(
              child: TextField(
            controller: passwordTextController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'password.'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                color: Color(0xFF211551)),
          ))
        ],
      ),
    );

    final loginBanner = Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 2.0,
            horizontal: SizeConfig.safeBlockHorizontal * 14.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome.',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 11.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 0.3),
              Text(
                'Silahkan login untuk melanjutkan.',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              )
            ],
          ),
        ));

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 1.1,
          horizontal: SizeConfig.safeBlockHorizontal * 12.3),
      child: GestureDetector(
        onTap: () {
          loginUser(
              context, emailTextController.text, passwordTextController.text);
        },
        child: Container(
            width: double.infinity,
            height: SizeConfig.safeBlockVertical * 7.0,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(SizeConfig.safeBlockHorizontal * 1.6),
                color: Colors.blue[700]),
            child: Center(
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
      ),
    );

    final registerButton = FlatButton(
      child: Text(
        'Daftar disini jika belum punya akun.',
        style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 3.7,
            fontWeight: FontWeight.bold,
            color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
    );

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(
            child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 6),
          children: [
            loginBanner,
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            email,
            SizedBox(
              height: SizeConfig.safeBlockVertical * 0.5,
            ),
            password,
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2.5,
            ),
            loginButton,
            registerButton
          ],
        )));
  }
}
