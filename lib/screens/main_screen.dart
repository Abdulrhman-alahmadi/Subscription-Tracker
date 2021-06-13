import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2021/components/add_new_subscription_card.dart';
import 'package:p2021/components/subscription_stream.dart';
import 'package:p2021/utill/device_data.dart';
import 'package:p2021/utill/const.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:p2021/class/subscription.dart';
import 'package:p2021/utill/shared_preferences_helper.dart';
import 'package:p2021/utill/sqlite_api.dart';

class mainScreen extends StatefulWidget {
  static String id = "mainScreen";
  final String email;

  mainScreen({Key key, this.email}) : super(key: key);

  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  Future _futureData;
  bool finishLoadUserDate = false;
  double currentBalance = 0;

  @override
  void initState() {
    _futureData = SqliteApi().retrieveSubs();
    SharedPreferencesHelper.getBalance()
        .then((value) => {
              if (value == null)
                {
                  // first time
                  SharedPreferencesHelper.userBalance = 0,
                }
              else
                {
                  SharedPreferencesHelper.userBalance = value,
                },
            })
        .then((value) => {
              setState(() {
                finishLoadUserDate = true;
              }),
            });

    super.initState();
  }

  void refreshFuture() {
    setState(() {
      _futureData = SqliteApi().retrieveSubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceData.getDeviceInfo(context);
    return Scaffold(
        floatingActionButton: finishLoadUserDate == true
            ? FloatingActionButton(
                backgroundColor: Color(0xFF122732),
                child: Icon(Icons.add),
                onPressed: () {
                  ListOfSubsBottomSheet();
                },
              )
            : null,
        backgroundColor: Color(0XFFFEFEFE),
        body: SafeArea(
          child: finishLoadUserDate == false
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                )
              : SingleChildScrollView(
                child: Column(
                    children: [
                      Container(
                        height: deviceData.height * 0.15,
                        child: Stack(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.all(30.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       IconButton(
                            //           icon: Icon(
                            //             CupertinoIcons.back,
                            //             color: Colors.white,
                            //             size: 30,
                            //           ),
                            //           onPressed: () {
                            //             Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       mainScreen()),
                            //             );
                            //           }),
                            //       IconButton(
                            //           icon: FaIcon(
                            //             FontAwesomeIcons.plus,
                            //             color: Colors.white,
                            //           ),
                            //           onPressed: () {
                            //             chooseNewSubBottomSheet();
                            //           }),
                            //     ],
                            //   ),
                            // ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "This month's spend",
                                    style: GoogleFonts.farro(
                                        fontSize: 20,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: deviceData.height * 0.01,
                                  ),
                                  Text(
                                    SharedPreferencesHelper.userBalance
                                            .toString() +
                                        " SR",
                                    style: GoogleFonts.farro(
                                        fontSize: 20,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFF122732),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                            )),
                      ),
                      SubscriptionStream(
                        futureData: _futureData,
                        callback: refreshFuture,
                      ),
                    ],
                  ),
              ),
        ));
  }

  void ListOfSubsBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: deviceData.height * 0.90,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Text(
                        "Add new Subscription",
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 22,
                            color: Colors.transparent,
                          ),
                          onPressed: null),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: Constants.subs.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            addSubscriptionInfo(
                                Constants.subs.elementAt(i), false);
                          },
                          child: AddNewSubscriptionCard(
                            isCustom: false,
                            currentSub: Constants.subs.elementAt(i),
                          ),
                        );
                      }),
                ),
                Container(
                  height: deviceData.height * 0.08,
                  child: GestureDetector(
                    onTap: () {
                      addSubscriptionInfo(null, true);
                    },
                    child: AddNewSubscriptionCard(
                      isCustom: true,
                      currentSub: Constants.subs.elementAt(0),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void addSubscriptionInfo(Subscription chosenSub, bool custom) {
    TextEditingController inputControlelr = TextEditingController();
    TextEditingController descController = TextEditingController();
    TextEditingController billController = TextEditingController();

    if (custom == true) {
      String dropdownValue = 'Shows Subscription';
      TextEditingController nameController = TextEditingController();
      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                height: deviceData.height * 0.90,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 28,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Text(
                            "[" + 'Custom Subscription' + "]",
                            style: GoogleFonts.koHo(
                                fontSize: 22, color: Colors.black),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.check,
                                size: 22,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                if (descController.text.isNotEmpty &&
                                    billController.text.isNotEmpty &&
                                    inputControlelr.text.isNotEmpty && nameController.text.isNotEmpty) {
                                  //
                                  SqliteApi().insertSub(Subscription(
                                      nameController.text,
                                      double.parse(inputControlelr.text),
                                      descController.text,
                                      new DateFormat("yyyy-MM-dd")
                                          .parse(billController.text),
                                    DateTime.now(),
                                      dropdownValue == 'Shows Subscription' ? 'assets/icons/tv.png' : 'assets/icons/game_controller.png',
                                      Colors.blueGrey));
                                  setState(() {
                                    _futureData = SqliteApi().retrieveSubs();
                                    SharedPreferencesHelper.updateMonthSpend(
                                      double.parse(inputControlelr.text),
                                    );
                                  });
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "please fill all the data");
                                }
                              }),
                        ],
                      ),
                    ),
                    Container(
                      width: deviceData.width * 0.30,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: inputControlelr,
                        onChanged: (value) {},
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.black,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            hintText: "SR0.00",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: deviceData.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: GoogleFonts.koHo(
                                    fontSize: 22, color: Colors.black),
                              ),
                              Container(
                                  width: deviceData.width * 0.40,
                                  child: TextField(
                                    controller: nameController,
                                    style: GoogleFonts.koHo(
                                        fontSize: 20, color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Enter name',
                                      hintStyle: GoogleFonts.koHo(
                                          fontSize: 20, color: Colors.black26),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ))
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Description",
                                style: GoogleFonts.koHo(
                                    fontSize: 22, color: Colors.black),
                              ),
                              Container(
                                  width: deviceData.width * 0.40,
                                  child: TextField(
                                    controller: descController,
                                    style: GoogleFonts.koHo(
                                        fontSize: 20, color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Enter Description',
                                      hintStyle: GoogleFonts.koHo(
                                          fontSize: 20, color: Colors.black26),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  )),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "First Bill",
                                style: GoogleFonts.koHo(
                                    fontSize: 22, color: Colors.black),
                              ),
                              SizedBox(
                                width: deviceData.width * 0.40,
                                child: TextField(
                                  controller: billController,
                                  onTap: () async {
                                    DateTime selectedDate = DateTime.now();
                                    final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate, // Refer step 1
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                    if (picked != null && picked != selectedDate)
                                      setState(() {
                                        selectedDate = picked;
                                        String convertedDate =
                                            new DateFormat("yyyy-MM-dd")
                                                .format(picked);
                                        billController.text = convertedDate;
                                      });
                                  },
                                  readOnly: true,
                                  style: GoogleFonts.koHo(
                                      fontSize: 20, color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Date',
                                    hintStyle: GoogleFonts.koHo(
                                        fontSize: 20, color: Colors.black),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Subscription Type",
                                style: GoogleFonts.koHo(
                                    fontSize: 22, color: Colors.black),
                              ),
                              DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    print(dropdownValue);
                                  });
                                },
                                items: <String>['Shows Subscription', 'Gaming Subscription']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      showModalBottomSheet(
          backgroundColor: chosenSub.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                height: deviceData.height * 0.90,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 28,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Text(
                            "[" + chosenSub.name + "]",
                            style: GoogleFonts.koHo(
                                fontSize: 22, color: Colors.white),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.check,
                                size: 22,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (descController.text.isNotEmpty &&
                                    billController.text.isNotEmpty &&
                                    inputControlelr.text.isNotEmpty) {
                                  SqliteApi().insertSub(Subscription(
                                      chosenSub.name,
                                      double.parse(inputControlelr.text),
                                      descController.text,
                                      new DateFormat("yyyy-MM-dd")
                                          .parse(billController.text),
                                      DateTime.now(),
                                      chosenSub.img,
                                      chosenSub.color));
                                  setState(() {
                                    _futureData = SqliteApi().retrieveSubs();
                                    SharedPreferencesHelper.updateMonthSpend(
                                      double.parse(inputControlelr.text),
                                    );
                                  });
                                  // DatabaseApi.insertNewSub(Subscription(
                                  //     chosenSub.name,
                                  //     double.parse(inputControlelr.text),
                                  //     descController.text,
                                  //     new DateFormat("yyyy-MM-dd")
                                  //         .parse(billController.text),
                                  //     DateTime.now(),
                                  //     chosenSub.img,
                                  //     chosenSub.color));
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "please fill all the data");
                                }
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        chosenSub.img,
                        height: deviceData.height * 0.10,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: deviceData.width * 0.30,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: inputControlelr,
                        onChanged: (value) {},
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            hintText: "SR0.00",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: deviceData.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: GoogleFonts.koHo(
                                    fontSize: 22, color: Colors.white),
                              ),
                              Container(
                                width: deviceData.width * 0.40,
                                child: Text(
                                  chosenSub.name,
                                  style: GoogleFonts.koHo(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Description",
                                style: GoogleFonts.koHo(
                                    fontSize: 22, color: Colors.white),
                              ),
                              Container(
                                  width: deviceData.width * 0.40,
                                  child: TextField(
                                    controller: descController,
                                    style: GoogleFonts.koHo(
                                        fontSize: 20, color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Enter Description',
                                      hintStyle: GoogleFonts.koHo(
                                          fontSize: 20, color: Colors.black26),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  )),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "First Bill",
                                style: GoogleFonts.koHo(
                                    fontSize: 22, color: Colors.white),
                              ),
                              SizedBox(
                                width: deviceData.width * 0.40,
                                child: TextField(
                                  controller: billController,
                                  onTap: () async {
                                    DateTime selectedDate = DateTime.now();
                                    final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate, // Refer step 1
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                    if (picked != null && picked != selectedDate)
                                      setState(() {
                                        selectedDate = picked;
                                        String convertedDate =
                                            new DateFormat("yyyy-MM-dd")
                                                .format(picked);
                                        billController.text = convertedDate;
                                      });
                                  },
                                  readOnly: true,
                                  style: GoogleFonts.koHo(
                                      fontSize: 20, color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Date',
                                    hintStyle: GoogleFonts.koHo(
                                        fontSize: 20, color: Colors.white),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}
