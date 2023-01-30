import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:technical_exam/main/main_menu.dart';
import 'package:technical_exam/model/login_model.dart';
import 'package:technical_exam/services/api_service.dart';
import 'package:technical_exam/services/progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  FocusNode nameFocus = new FocusNode();
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();

  late RegisterRequestModel regRequestModel;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    nameFocus = FocusNode();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    regRequestModel = new RegisterRequestModel(name: '', email: '', password: '');
  }

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: buildUIRegister(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget buildUIRegister(BuildContext context) {
    Timer _timer;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 10), blurRadius: 20),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            _onBackPressed();
                          });
                        },
                        child: Container(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFFFCC13A),
                              ),
                              Text(
                                '  Back',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFCC13A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Form(
                        key: globalFormKey,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  " Register",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              focusNode: nameFocus,
                              onTap: _requestFocusName,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(34),
                              ],
                              onSaved: (input) => regRequestModel.name = input!,
                              validator: (input) => input!.length < 6 ? "Name is less than 6 characters" : null,
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                                  ),
                                ),
                                disabledBorder: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: nameFocus.hasFocus ? Color(0xFF5B3415) : Colors.grey,
                                ),
                                prefixIcon: Icon(Icons.account_box_rounded, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              focusNode: emailFocus,
                              onTap: _requestFocusEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSaved: (input) => regRequestModel.email = input!,
                              validator: (input) => !input!.contains("@") ? "Email Address invalid" : null,
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                                  ),
                                ),
                                disabledBorder: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                labelText: 'Email Address',
                                labelStyle: TextStyle(
                                  color: emailFocus.hasFocus ? Color(0xFF5B3415) : Colors.grey,
                                ),
                                prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              focusNode: passwordFocus,
                              onTap: _requestFocusPassword,
                              keyboardType: TextInputType.text,
                              onSaved: (input) => regRequestModel.password = input!,
                              validator: (input) => input!.length < 3 ? "Password is less than 6 characters" : null,
                              obscureText: hidePassword,
                              decoration: new InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                                    ),
                                  ),
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: passwordFocus.hasFocus ? Color(0xFF5B3415) : Colors.grey,
                                  ),
                                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                                    icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  primary: Color(0xFF5B3415), // background
                                  onPrimary: Color(0xFFFCC13A), // foreground
                                ),
                                onPressed: () {
                                  int alertTime = 3;
                                  _timer = Timer(Duration(seconds: 20), () {
                                    setState(
                                          () {
                                        isApiCallProcess = false;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return new AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.redAccent,
                                                  ),
                                                  Text(
                                                    "  Unexpected Error",
                                                    style: TextStyle(
                                                      color: Color(0xFF5B3415),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Text('Connection Timeout [@_@]: Check your Internet Connection',
                                                  textAlign: TextAlign.left),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child:
                                                    const Text("OK", style: TextStyle(color: Color(0xFFFCC13A)))),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  });
                                  if (validateAndSave() == false){
                                    _timer.cancel();
                                  }
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (validateAndSave()) {
                                    setState(() {
                                      isApiCallProcess = true;

                                    });
                                    RegisterService apiService = new RegisterService();
                                    apiService.login(regRequestModel).then(
                                          (value) {
                                        setState(() {
                                          isApiCallProcess = false;
                                        });
                                        if (value.message.isNotEmpty) {
                                          _timer.cancel();
                                          globalFormKey.currentState!.reset();
                                          return showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return new AlertDialog(
                                                title: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.error,
                                                      color: Color(0xFFFCC13A),
                                                    ),
                                                    Text(
                                                      "  Registered",
                                                      style: TextStyle(
                                                        color: Color(0xFF5B3415),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: new Text(value.message),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        Navigator.pushNamedAndRemoveUntil(
                                                            context, '/menu', (_) => false);
                                                      },
                                                      child:
                                                      const Text("OK", style: TextStyle(color: Color(0xFFFCC13A)))),
                                                ],
                                              );
                                            },
                                          ).timeout(
                                            Duration(seconds: alertTime),
                                            onTimeout: () {
                                              _timer.cancel();
                                              Navigator.of(context).pop();
                                              Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
                                            },
                                          );
                                        } else {
                                          _timer.cancel();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return new AlertDialog(
                                                title: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.redAccent,
                                                    ),
                                                    Text(
                                                      "  Register",
                                                      style: TextStyle(
                                                        color: Color(0xFF5B3415),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: new Text(value.error),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:
                                                      const Text("OK", style: TextStyle(color: Color(0xFFFCC13A)))),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _requestFocusName() {
    setState(() {
      FocusScope.of(context).requestFocus(nameFocus);
    });
  }

  void _requestFocusEmail() {
    setState(() {
      FocusScope.of(context).requestFocus(emailFocus);
    });
  }

  void _requestFocusPassword() {
    setState(() {
      FocusScope.of(context).requestFocus(passwordFocus);
    });
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _onBackPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text("Are you sure?",
              style: TextStyle(
                color: Color(0xFF5B3415),
                fontWeight: FontWeight.bold,
              )),
          content: const Text("Account creation will be stopped"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => MainMenu()), (_) => false);
              },
              child: const Text(
                "CONFIRM",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Color(0xFFFCC13A),
                ),
              ),
            ),
          ],
        );
      },
    );
    return new Future.value(true);
  }
}