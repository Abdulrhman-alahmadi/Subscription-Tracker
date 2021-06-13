import 'package:p2021/class/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{
  static double userBalance = 0;
  static Future<SharedPreferences> _prefsIns = SharedPreferences.getInstance();
  static void updateMonthSpend(double price) async{
    final SharedPreferences prefs = await _prefsIns;
    if(prefs.containsKey("balance")){
      double currentBalance = prefs.getDouble('balance');
      double nBalance = price+currentBalance;
      prefs.setDouble('balance', nBalance);
      userBalance = nBalance;
    } else{
      // the device don't have any prev data about balance. add the new sub price.
      prefs.setDouble('balance', price);
      userBalance = price;
    }
  }
  static void removeSubPrice(Subscription sub) async{
    final SharedPreferences prefs = await _prefsIns;
    double currentBalance = prefs.getDouble('balance');
    double nBalance = currentBalance-sub.price;
    prefs.setDouble('balance', nBalance);
    userBalance = nBalance;
  }
  static Future<double> getBalance() async{
    final SharedPreferences prefs = await _prefsIns;
  return prefs.getDouble('balance');
  }
}