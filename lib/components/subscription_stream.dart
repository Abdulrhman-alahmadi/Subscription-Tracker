import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2021/class/subscription.dart';
import 'package:p2021/components/subscription_card.dart';
import 'package:p2021/utill/const.dart';
import 'package:p2021/utill/device_data.dart';
import 'package:p2021/utill/sqlite_api.dart';


class SubscriptionStream extends StatefulWidget {
  final Future futureData;
  final VoidCallback callback;
  const SubscriptionStream({Key key, this.futureData, this.callback}) : super(key: key);

  @override
  _SubscriptionStreamState createState() => _SubscriptionStreamState();
}

class _SubscriptionStreamState extends State<SubscriptionStream> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subscription>>(
        future: widget.futureData,
        builder: (BuildContext context, AsyncSnapshot<List<Subscription>> snapshot){
          if (snapshot.hasData){
            return Container(
              height: deviceData.height * 0.70,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return SubscriptionCard(
                    sub: snapshot.data.elementAt(i),
                    callback: widget.callback,
                  );
                },
              ),
            );
          } else{
            return Text('No data - Yet');
          }
        });
  }
}
