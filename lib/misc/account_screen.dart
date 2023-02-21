import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  final String currentUser;
  final int lengthList;

  const AccountScreen({
    Key? key,
    required this.currentUser,
    required this.lengthList,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState(currentUser, lengthList);
}

class _AccountScreenState extends State<AccountScreen> {
  String currentUser;
  int lengthList;

  _AccountScreenState(this.currentUser, this.lengthList);

  var currentEmail;
  SharedPreferences? preferences;

  Future<bool> getEmail() async {
    this.preferences = await SharedPreferences.getInstance();
    this.currentEmail = preferences!.getString('currentEmail');
    return currentEmail == null;
  }

  @override
  void initState() {
    // TODO: implement initState
    getEmail().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E315A),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Account", style: TextStyle(color: Color(0xFFE4EBF8))),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          InkWell(
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Color(0xFFE4EBF8),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE4EBF8),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: Text("Logout",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                    content: const Text("Are you sure to Logout?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          sharedPreferences.remove('data');
                          sharedPreferences.remove('authKey');
                          sharedPreferences.remove('currentUser');
                          sharedPreferences.remove('currentEmail');
                          Fluttertoast.showToast(msg: "Logged out Successfully", backgroundColor: Color(0xFF202342), textColor: Color(0xFFE4EBF8));
                          Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
                        },
                        child: const Text("LOGOUT", style: TextStyle(color: Color(0xFFFD5066))),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFE4EBF8),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 5), blurRadius: 10),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Currently Signed as:"),
                        Container(
                          child: ListTile(
                            tileColor: Colors.transparent,
                            selectedTileColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  "User: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(currentUser),
                              ],
                            ),
                            subtitle: Text(currentEmail.toString()),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Number of Students: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              lengthList.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Theme.of(context).primaryColor,
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              Fluttertoast.showToast(
                                msg: "Feature [Change Password] not yet Integrated",
                                backgroundColor: Color(0xFF202342),
                                textColor: Color(0xFFE4EBF8),
                              );
                            });
                          },
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).primaryColor,
                        ),
                        TextButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.error,
                                        color: Color(0xFFFD5066),
                                      ),
                                      Text(
                                        "  Delete Account",
                                        style: TextStyle(
                                          color: Color(0xFFFD5066),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: const Text("Are you sure you want to delete your account? Your Account Will be Deleted Permanently (Not Yet Integrated, You will be Logged out)"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        sharedPreferences.remove('data');
                                        sharedPreferences.remove('authKey');
                                        sharedPreferences.remove('currentUser');
                                        sharedPreferences.remove('currentEmail');
                                        Fluttertoast.showToast(
                                          msg: "Deleted Successfully",
                                          backgroundColor: Color(0xFF202342),
                                          textColor: Color(0xFFE4EBF8),
                                        );
                                        Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
                                      },
                                      child: const Text("DELETE",
                                          style: TextStyle(
                                            color: Color(0xFFFD5066),
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFD5066),
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('The user $currentUser is accessing the Public Database\n',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          Fluttertoast.showToast(
                            msg: "Feature [Edit] not yet Integrated",
                            backgroundColor: Color(0xFF202342),
                            textColor: Color(0xFFE4EBF8),
                          );
                        });
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
