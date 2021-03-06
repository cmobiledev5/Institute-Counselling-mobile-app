import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsViewModel extends BaseViewModel {
  final databaseReference = FirebaseFirestore.instance;
  List<DocumentSnapshot> notificationList;

  void init() async {
    setBusy(true);
    notificationList = (await getData()).docs;
    setBusy(false);
  }

  Future<QuerySnapshot> getData() async {
    return await databaseReference.collection("nots").get();
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
