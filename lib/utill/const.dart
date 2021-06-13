import 'package:flutter/material.dart';
import 'package:p2021/class/subscription.dart';


class Constants{

  static List<Subscription> subs = [Subscription("Netflix", 0, "", DateTime.now(), DateTime.now(), "assets/icons/brand.png",Color(0xFFE410914),),
    Subscription("PSN", 0, "", DateTime.now(), DateTime.now(), "assets/icons/psn.png",Colors.blue),
    Subscription("XBOX", 0, "", DateTime.now(), DateTime.now(), "assets/icons/xbox.png",Colors.green),
    Subscription("Amazon prime video", 0, "", DateTime.now(), DateTime.now(), "assets/icons/amazon.png",Color(0xFF1B242D)),
    Subscription("Hulu", 0, "", DateTime.now(), DateTime.now(), "assets/icons/hulu.png",Color(0xFF3BB53B)),
    Subscription("Disney Plus", 0, "", DateTime.now(), DateTime.now(), "assets/icons/disney_plus.png",Color(0xFF382F68)),
    Subscription("Hbo Max", 0, "", DateTime.now(), DateTime.now(), "assets/icons/hbo_max.png",Color(0xFF030328)),
    Subscription("Apple Tv+", 0, "", DateTime.now(), DateTime.now(), "assets/icons/apple_tv.png",Color(0xFF373536)),
    Subscription("Crunchyroll", 0, "", DateTime.now(), DateTime.now(), "assets/icons/crunchyroll.png",Color(0xFFF47521)),
    Subscription("YouTube TV", 0, "", DateTime.now(), DateTime.now(), "assets/icons/youtube_tv.png",Color(0xFF7f0000)),
    Subscription("EA", 0, "", DateTime.now(), DateTime.now(), "assets/icons/ea.png",Color(0xFFFF4747)),


  ];

  static Subscription getSubIndex(String name){
    for(var sub in subs){
      if(sub.name == name){
        return sub;
      }
    }
    return null;
  }
}