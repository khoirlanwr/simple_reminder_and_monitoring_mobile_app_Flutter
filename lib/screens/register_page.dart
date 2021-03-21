import 'package:flutter/material.dart';
import 'package:todo_getx/blocs/bloc_user.dart';
import 'package:provider/provider.dart';
import 'package:todo_getx/widgets/size_config.dart';

class RegisterPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  void signUp(BuildContext context, String email, String password) async {
    String result = await Provider.of<BlocUser>(context, listen: false)
        .createUser(email, password);

    if (result == "register-success") {
      print(result);

      Navigator.pop(context);
    } else {
      print(result);
      // Navigator.pop(context);

      // show snackbar error result
      _scaffoldState.currentState.showSnackBar(SnackBar(
          content: new Text(result), duration: new Duration(seconds: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    //
    //
    final registerBanner = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 2.0,
          horizontal: SizeConfig.safeBlockHorizontal * 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Disini.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 11.4,
                color: Colors.black87),
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 0.3,
          ),
          Text('Silahkan isi form dibawah.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.0))
        ],
      ),
    );

    final emailField = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 0.3,
          horizontal: SizeConfig.safeBlockHorizontal * 12.3),
      child: Row(
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 4.0),
            child: Icon(
              Icons.mail,
              color: Colors.blue,
            ),
          ),
          Expanded(
              child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'email.',
            ),
            style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF211551)),
          ))
        ],
      ),
    );

    final passwordField = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 0.05,
          horizontal: SizeConfig.safeBlockHorizontal * 12.3),
      child: Row(
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 4.0),
            child: Icon(Icons.lock, color: Colors.blue),
          ),
          Expanded(
              child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'password.',
            ),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                color: Color(0xFF211551)),
          ))
        ],
      ),
    );

    final passwordConfirmationField = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 0.5,
          horizontal: SizeConfig.safeBlockHorizontal * 12.3),
      child: Row(
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 4.0),
            child: Icon(Icons.lock, color: Colors.blue),
          ),
          Expanded(
              child: TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'konfirmasi password.',
            ),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                color: Color(0xFF211551)),
          ))
        ],
      ),
    );

    final register = Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 1.5,
          horizontal: SizeConfig.safeBlockHorizontal * 12.3),
      child: GestureDetector(
        onTap: () {
          if (passwordController.text == confirmPasswordController.text) {
            signUp(context, emailController.text, passwordController.text);
          } else {
            _scaffoldState.currentState.showSnackBar(SnackBar(
                content: new Text('Password tidak sama'),
                duration: new Duration(seconds: 1)));
          }
        },
        child: Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical * 7.0,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius:
                BorderRadius.circular(SizeConfig.safeBlockHorizontal * 1.6),
          ),
          child: Center(
            child: Text(
              'Daftar',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.safeBlockHorizontal * 5.0,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );

    final backPage = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 12.3,
          vertical: SizeConfig.safeBlockVertical * 2.1),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Center(
            child: Text(
              'Kembali ke halaman login.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.safeBlockHorizontal * 3.7,
                  color: Colors.black54),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 6),
          children: [
            registerBanner,
            SizedBox(height: SizeConfig.safeBlockVertical * 1),
            emailField,
            SizedBox(
              height: SizeConfig.safeBlockVertical * 0.5,
            ),
            passwordField,
            SizedBox(
              height: SizeConfig.safeBlockVertical * 0.5,
            ),
            passwordConfirmationField,
            SizedBox(height: SizeConfig.safeBlockVertical * 2.5),
            register,
            backPage
          ],
        ),
      ),
    );
  }
}
