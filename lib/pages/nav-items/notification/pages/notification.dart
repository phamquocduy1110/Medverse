import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/auth/login/login.dart';
import '/utils/app_text_theme.dart';
import '/theme/palette.dart';
import '/widgets/navigation_drawer_widget.dart';
import '/components/notification_stream_wrapper.dart';
import '/models/notification.dart';
import '/utils/firebase.dart';
import '/widgets/notification_items.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  User user = FirebaseAuth.instance.currentUser;

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    Widget checkAuthentication;

    if (user != null) {
      checkAuthentication = Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Palette.mainBlueTheme,
          title: Text(
            'Thông báo',
            style: MobileTextTheme().appBarStyle,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () => deleteAllItems(),
                child: Text(
                  'Xóa',
                  style: MobileTextTheme().appBarActionButton,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            getActivities(),
          ],
        ),
      );
    } else {
      checkAuthentication = new Login();
    }

    return checkAuthentication;
  }

  getActivities() {
    return ActivityStreamWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: notificationRef
          .doc(currentUserId())
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        ActivityModel activities = ActivityModel.fromJson(snapshot.data());
        return ActivityItems(
          activity: activities,
        );
      },
    );
  }

  deleteAllItems() async {
//delete all notifications associated with the authenticated user
    QuerySnapshot notificationsSnap = await notificationRef
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .get();
    notificationsSnap.docs.forEach(
      (doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      },
    );
  }
}
