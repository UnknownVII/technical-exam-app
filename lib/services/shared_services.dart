import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technical_exam/main/home.dart';
import 'package:technical_exam/main/main_menu.dart';

class SharedService extends StatefulWidget {
  const SharedService({Key? key}) : super(key: key);

  @override
  _SharedServiceState createState() => _SharedServiceState();
}

class _SharedServiceState extends State<SharedService> {
  late String finalEmail = '';
  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedData = sharedPreferences.getString('data');
    setState(() {
      if (obtainedData != null) {
        finalEmail = obtainedData;
      }
    });
  }

  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(
          const Duration(seconds: 1),
              () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => finalEmail.isEmpty ? const MainMenu() : const HomePage()), (_) => false));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,

      body: WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFFE4EBF8),
            ),
            backgroundColor: Color(0xFF2E315A),
          ),
        ),
      ),
    );
  }
}