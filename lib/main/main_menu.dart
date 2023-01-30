import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:technical_exam/account/login.dart';
import 'package:technical_exam/account/register.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  late DateTime currentBackPressTime;
  late Image imageLogo;
  late final _controllerAnimation;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controllerAnimation =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controllerAnimation);
    imageLogo = Image.asset(
      'assets/app_ico_foreground.png',
      height: 200.0,
      width: 200.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllerAnimation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;
    _controllerAnimation.forward();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          final maxDuration = const Duration(seconds: 1);
          final isWarning =
              lastPressed == null || now.difference(lastPressed!) > maxDuration;
          if (isWarning) {
            lastPressed = DateTime.now();
            Fluttertoast.showToast(
                msg: "Double Tap to Close App",
                backgroundColor: Color(0xFFE4EBF8),
                textColor: Theme.of(context).primaryColor,
                toastLength: Toast.LENGTH_SHORT);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FadeTransition(
                  opacity: _animation,
                  child: Column(
                    children: [
                      imageLogo,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "My APP",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FadeTransition(
                  opacity: _animation,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        margin: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.2),
                                offset: Offset(0, 10),
                                blurRadius: 20),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE4EBF8),
                                  backgroundColor: const Color(0xFF2E315A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ), // foreground
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE4EBF8),
                                  backgroundColor: const Color(0xFF2E315A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ), // foreground
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const RegisterScreen()),
                                  );
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    "A Flutter Application for Technical Exam @geidi",
                    style: TextStyle(color: Color(0xFFE4EBF8)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
