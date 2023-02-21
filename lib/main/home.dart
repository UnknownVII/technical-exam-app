import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technical_exam/misc/account_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String authKey = '';
  var authHeaders;
  var currentUser;
  var scrollController = ScrollController();
  var _isVisible = true;
  var _searchEmpty = false;
  var lengthList = 0;
  FocusNode searchFocus = new FocusNode();
  TextEditingController editingController = TextEditingController();
  List<dynamic> duplicatedData = [];
  var stringVal = "";

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchEmpty = false;
        _users = duplicatedData;
      });
      return;
    }
    query = query.toLowerCase();
    print(query);
    List result = [];
    duplicatedData.forEach((p) {
      var fname = p["first_name"].toString().toLowerCase();
      var lname = p["last_name"].toString().toLowerCase();
      var age = p["age"].toString().toLowerCase();
      var course = p["course"].toString().toLowerCase();
      var year = p["year_level"].toString().toLowerCase();
      if (fname.contains(query) || lname.contains(query) || age.contains(query) || course.contains(query) || year.contains(query)) {
        result.add(p);
      }
    });

    if (result.isEmpty) {
      setState(
        () {
          _searchEmpty = true;
        },
      );
    } else {
      setState(
        () {
          _searchEmpty = false;
          _users = result;
        },
      );
    }
  }

  Future getAuthKeyData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var authKeyObtained = sharedPreferences.getString('authKey');
    currentUser = sharedPreferences.getString('currentUser');
    setState(
      () {
        if (authKeyObtained != null) {
          authKey = authKeyObtained;
          authHeaders = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'auth-token': authKey.toString(),
          };
          fetchContacts(authHeaders);
        }
      },
    );
  }

  final String apiUrlget = "https://technical-exam-api.vercel.app/test/all-objects";

  List<dynamic> _users = [];

  void fetchContacts(var authHeaders) async {
    print(authKey);
    var result = await http.get(Uri.parse(apiUrlget), headers: authHeaders);
    setState(() {
      Map<String, dynamic> map = json.decode(result.body);
      List<dynamic> data = map["students"];
      _users = data;
      duplicatedData = data;
    });
    print("Status Code [" + result.statusCode.toString() + "]: All Data Fetched");
    Fluttertoast.showToast(
      msg: "All Contacts fetched",
      backgroundColor: Color(0xFF202342),
      textColor: Color(0xFFE4EBF8),
    );
  }

  String _name(dynamic user) {
    return user['first_name'] + " " + user['last_name'];
  }

  Future<http.Response> deleteContact(String id) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var authKeyObtained = sharedPreferences.getString('authKey');
    return http.delete(
      Uri.parse('https://technical-exam-api.vercel.app/test/delete/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'auth-token': authKeyObtained.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 1);
        final isWarning = lastPressed == null || now.difference(lastPressed!) > maxDuration;
        if (isWarning) {
          lastPressed = DateTime.now();
          Fluttertoast.showToast(msg: "Double Tap to Close App", backgroundColor: Color(0xFF202342), textColor: Color(0xFFE4EBF8), toastLength: Toast.LENGTH_SHORT);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF2E315A),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Student/s List", style: TextStyle(color: Color(0xFFE4EBF8))),
          backgroundColor: Theme.of(context).primaryColor,
          leading: Image.asset(
            'assets/app_ico_foreground.png',
            height: 80.0,
            width: 80.0,
          ),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Color(0xFFFD5066)),
              child: PopupMenuButton<int>(
                icon: Icon(
                  Icons.more_vert,
                  color: Color(0xFFE4EBF8),
                ),
                color: Color(0xFFE4EBF8),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text('Account'),
                  ),
                  // PopupMenuItem<int>(
                  //   value: 1,
                  //   child: Text('About'),
                  // ),
                  // PopupMenuItem<int>(
                  //   value: 3,
                  //   //enabled: false,
                  //   child: new Container(width: 95, child: Text('App version')),
                  // ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Color(0xFFFD5066)),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFD5066),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                onSelected: (item) => selectedItem(context, item),
              ),
            )
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12.0, 24, 12.0, 4.0),
                  child: TextField(
                    controller: editingController,
                    onChanged: (value) {
                      filterSearchResults(value);
                      stringVal = value;
                    },
                    style: TextStyle(
                      color: Color(0xFFE4EBF8),
                    ),
                    cursorColor: Color(0xFFE4EBF8),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE4EBF8).withOpacity(0.2),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            editingController.clear();
                            filterSearchResults("");
                            FocusScopeNode currentFocus = FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          icon: Icon(Icons.clear, color: Color(0xFFE4EBF8)),
                        ),
                        disabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE4EBF8),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFD5066),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFD5066),
                          ),
                        ),
                        labelText: "Search",
                        labelStyle: TextStyle(
                          color: searchFocus.hasFocus ? Colors.white : Color(0xFFE4EBF8),
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: searchFocus.hasFocus ? Colors.white : Color(0xFFE4EBF8),
                        ),
                        prefixIcon: Icon(Icons.search, color: Color(0xFFE4EBF8)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: !_searchEmpty
                        ? FutureBuilder<List<dynamic>>(
                            builder: (context, snapshot) {
                              this.lengthList = _users.length;
                              return _users.length != 0
                                  ? RefreshIndicator(
                                      color: Theme.of(context).primaryColor,
                                      child: ListView.builder(
                                        controller: scrollController,
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        padding: EdgeInsets.all(12.0),
                                        itemCount: _users.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Dismissible(
                                            key: Key(_users[index].toString()),
                                            direction: DismissDirection.endToStart,
                                            background: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 14.0),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                                                Icon(Icons.delete_forever, color: Colors.white70),
                                                Text("Delete", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white70))
                                              ]),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            onDismissed: (direction) {
                                              String id = _users[index]['_id'].toString();
                                              String userDeleted = _users[index]['first_name'].toString();
                                              deleteContact(id);
                                              print("Status [Deleted]: [" + id + "]");
                                              setState(() {
                                                _users.removeAt(index);
                                                if (_users.length <= 8) {
                                                  setState(() {
                                                    _isVisible = true;
                                                  });
                                                }
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('$userDeleted deleted'),
                                                ),
                                              );
                                            },
                                            confirmDismiss: (DismissDirection direction) async {
                                              return await showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Confirm Delete",
                                                        style: TextStyle(
                                                          color: Color(0xFF5B3415),
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                    content: const Text("Are you sure you wish to delete this contact?"),
                                                    actions: <Widget>[
                                                      Icon(Icons.delete_forever, color: Colors.redAccent),
                                                      TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("DELETE", style: TextStyle(color: Colors.redAccent))),
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(false),
                                                        child: const Text("CANCEL", style: TextStyle(color: Color(0xFFFCC13A))),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 90,
                                              color: Colors.transparent,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                ),
                                                color: Color(0xFFE4EBF8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ListTile(
                                                      tileColor: Colors.transparent,
                                                      selectedTileColor: Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15.0),
                                                      ),
                                                      leading: CircleAvatar(
                                                        backgroundColor: Color(int.parse((_users[index]['color']).replaceFirst(RegExp(r"#"), "0xFF"))),
                                                        radius: 30.0,
                                                        child: Text(_users[index]['first_name'][0].toUpperCase() + _users[index]['last_name'][0].toUpperCase(),
                                                            style: TextStyle(fontSize: 20, color: Color(0xFFE4EBF8), fontWeight: FontWeight.bold)),
                                                      ),
                                                      trailing: Icon(Icons.arrow_back_ios),
                                                      title: Text(
                                                        _name(_users[index]) + ", " + _users[index]["age"],
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Theme.of(context).primaryColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      subtitle: Text(_users[index]["course"] + " - " + _users[index]["year_level"] + " year",
                                                          style: TextStyle(
                                                            color: Theme.of(context).primaryColor,
                                                          )),
                                                      onTap: () {
                                                        List listSubjects = [];
                                                        for (int i = 0; i < _users[index]['subjects'].length; i++) {
                                                          listSubjects.add(i + 1);
                                                        }
                                                        showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext context) => Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                child: AlertDialog(
                                                                  content: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          CircleAvatar(
                                                                            backgroundColor: Color(int.parse((_users[index]['color']).replaceFirst(RegExp(r"#"), "0xFF"))),
                                                                            radius: 60.0,
                                                                            child: Text(_users[index]['first_name'][0].toUpperCase() + _users[index]['last_name'][0].toUpperCase(),
                                                                                style: TextStyle(fontSize: 48, color: Color(0xFFE4EBF8), fontWeight: FontWeight.bold)),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 20,
                                                                          ),
                                                                          Text(
                                                                            _name(_users[index]),
                                                                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 24),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Age: ",
                                                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                                                              ),
                                                                              Text(
                                                                                _users[index]["age"],
                                                                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w900),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Course: ",
                                                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                                                              ),
                                                                              Text(
                                                                                _users[index]["course"],
                                                                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w900),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Year Level: ",
                                                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                                                              ),
                                                                              Text(
                                                                                _users[index]["year_level"] + " year",
                                                                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w900),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text("Subject/s", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
                                                                                ],
                                                                              ),
                                                                              // TextButton(
                                                                              //   onPressed: () {
                                                                              //     // Navigator.pushAndRemoveUntil(
                                                                              //     //     context,
                                                                              //     //     MaterialPageRoute(
                                                                              //     //       builder: (context) => UpdateContact(
                                                                              //     //           specificID: _users[index]['_id'].toString()),
                                                                              //     //     ),
                                                                              //     //         (_) => false);
                                                                              //   },
                                                                              //   child: Text(
                                                                              //     'EDIT',
                                                                              //     style: TextStyle(
                                                                              //       color: Theme.of(context).primaryColor,
                                                                              //       fontWeight: FontWeight.bold,
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                          Divider(color: Theme.of(context).primaryColor),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: List.generate(
                                                                              listSubjects.length,
                                                                              (iter) {
                                                                                return Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      listSubjects[iter].toString() + ')\t\t' + _users[index]['subjects'][iter].toString(),
                                                                                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  //contentPadding: EdgeInsets.fromLTRB(24, 12, 0, 0),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                                      child: Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                          color: Theme.of(context).primaryColor,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  actionsPadding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      onRefresh: _getData,
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE4EBF8)),
                                        backgroundColor: Theme.of(context).primaryColor,
                                      ),
                                    );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Search " + "'" + stringVal + "'" + " does not exists",
                                    style: TextStyle(color: Color(0xFFE4EBF8)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Query can be of first name, last name, age, course, or year ",
                                    style: TextStyle(color: Color(0xFFE4EBF8)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewContact()));
            },
            child: Icon(
              Icons.add,
            ),
            foregroundColor: Color(0xFFE4EBF8),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() async {
      if (_users.length <= 8) {
        setState(() {
          _isVisible = true;
        });
      } else {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels > 0) {
            if (_isVisible) {
              setState(() {
                _isVisible = false;
              });
            }
          }
        } else {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    getAuthKeyData();
  }

  Future<void> _getData() async {
    setState(() {
      Fluttertoast.showToast(
        msg: "All Contacts fetched",
        backgroundColor: Color(0xFF202342),
        textColor: Color(0xFFE4EBF8),
      );
      getAuthKeyData();
    });
  }

  selectedItem(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        //print("Account is Pressed");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountScreen(currentUser: currentUser, lengthList: lengthList),
          ),
        );
        break;
      case 1:
        //print("About is Pressed");
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AboutScreen(),
        //     ),
        //   );
        break;
      case 2:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: const Text("Logout",
                  style: TextStyle(
                    color: Color(0xFF5B3415),
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
                    Fluttertoast.showToast(
                      msg: "Logged out Successfully",
                      backgroundColor: Color(0xFF202342),
                      textColor: Color(0xFFE4EBF8),
                    );
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
        break;
      case 3:
        setState(() {
          Fluttertoast.showToast(msg: "App ver.0.2.1-alpha", backgroundColor: Color(0xFF202342), textColor: Color(0xFFE4EBF8), toastLength: Toast.LENGTH_SHORT);
        });
    }
  }

  void _requestFocusSearch() {
    setState(() {
      FocusScope.of(context).requestFocus(searchFocus);
    });
  }
}
