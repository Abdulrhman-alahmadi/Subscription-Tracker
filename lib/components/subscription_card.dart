import 'package:flutter/material.dart';
import 'package:p2021/class/subscription.dart';
import 'package:p2021/utill/device_data.dart';
import 'package:p2021/utill/shared_preferences_helper.dart';
import 'package:p2021/utill/sqlite_api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubscriptionCard extends StatefulWidget {
  final Subscription sub;
  final VoidCallback callback;
  final bool custom;

  const SubscriptionCard({Key key, this.sub, this.callback, this.custom}) : super(key: key);

  @override
  _SubscriptionCardState createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Confirm deletion",
          desc: "Are you sure u want to delete this subscription?",
          buttons: [
            DialogButton(
              color: Colors.red,
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                SqliteApi().deleteSub(widget.sub);
                widget.callback();
                SharedPreferencesHelper.removeSubPrice(widget.sub);
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 10.0),
        child: Card(
          color: widget.sub.color,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Image.asset(
                        widget.sub.img,
                        color: Colors.white,
                        height: deviceData.height * 0.05,
                      )),
                  SizedBox(
                    width: deviceData.width * 0.040,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // name and desc if any..
                    children: [
                      Container(
                          width: deviceData.width * 0.50,
                          child: Text(
                            widget.sub.name,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                      Container(
                          width: deviceData.width * 0.50,
                          child: Text(
                            widget.sub.desc,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      padding: new EdgeInsets.only(right: 1.0),
                      child: Text(
                         widget.sub.price.toString()+" SR",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
