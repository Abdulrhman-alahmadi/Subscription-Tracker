import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:p2021/class/subscription.dart';
import 'package:p2021/utill/device_data.dart';

class AddNewSubscriptionCard extends StatelessWidget {
  final Subscription currentSub;
  final bool isCustom;
  const AddNewSubscriptionCard({Key key, this.currentSub, this.isCustom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCustom == false? Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: currentSub.color, width: 2.0),
          borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: deviceData.height *0.08,
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(currentSub.img, color: currentSub.color,),
                )),

            Container(
                width: deviceData.width*0.50,
                child: Text(currentSub.name , style: TextStyle(color: currentSub.color,fontSize: 20),)),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(FontAwesomeIcons.plus,size: 20, color: currentSub.color,),
            ),
          ],

        ),
      ),
    ) : Container(
      color: Colors.blueGrey,
      height: deviceData.height *0.08,
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(CupertinoIcons.person_add, color: Colors.white,),
              )),
          Container(
              width: deviceData.width*0.70,
              child: Text('Create custom Subscription' , style: TextStyle(color: Colors.white,fontSize: 20),)),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(FontAwesomeIcons.plus,size: 20, color: Colors.white,),
          ),
        ],

      ),
    );
  }
}
