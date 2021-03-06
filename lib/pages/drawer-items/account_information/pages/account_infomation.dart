import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/models/user.dart';
import '/utils/app_text_theme.dart';
import '/widgets/dimension.dart';
import '/theme/palette.dart';
import '/auth/login/login.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({Key key}) : super(key: key);

  @override
  State<AccountInformation> createState() => _AccountInfomationState();
}

class _AccountInfomationState extends State<AccountInformation> {
  User user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser = UserModel();

  @override
  Widget build(BuildContext context) {
    /// Get all data from users collection
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromJson(value.data());
      setState(() {});
    });

    Widget _checkAuthentication;

    /// Check if user is authenticated
    if (user != null) {
      _checkAuthentication = new Scaffold(
        body: new SingleChildScrollView(
            child: Column(
          children: <Widget>[
            /// Username card
            Container(
              margin: EdgeInsets.only(top: 25.0, left: 25.0, right: 25),
              decoration: BoxDecoration(
                color: Palette.whiteText,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                    color: Palette.blueGrey,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ), //BoxShadow
                ],
                border: Border.all(
                  color: Palette.blueGrey,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Palette.textNo,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'T??n ng?????i d??ng:',
                          style: MobileTextTheme().blackKLabelStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    loggedInUser.username == null ||
                            loggedInUser.username.isEmpty
                        ? Text(
                            'Kh??ng c?? d??? li???u',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          )
                        : Text(
                            '${loggedInUser.username}',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          ),
                  ],
                ),
              ),
            ),

            /// Email card
            Container(
              margin: EdgeInsets.only(top: 25.0, left: 25.0, right: 25),
              decoration: BoxDecoration(
                color: Palette.whiteText,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                    color: Palette.blueGrey,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ), //BoxShadow
                ],
                border: Border.all(
                  color: Palette.blueGrey,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Palette.textNo,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Email ng?????i d??ng:',
                          style: MobileTextTheme().blackKLabelStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    loggedInUser.email == null || loggedInUser.email.isEmpty
                        ? Text(
                            'Kh??ng c?? d??? li???u',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          )
                        : Text(
                            '${loggedInUser.email}',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          ),
                  ],
                ),
              ),
            ),

            /// Country card
            Container(
              margin: EdgeInsets.only(top: 25.0, left: 25.0, right: 25),
              decoration: BoxDecoration(
                color: Palette.whiteText,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                    color: Palette.blueGrey,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ), //BoxShadow
                ],
                border: Border.all(
                  color: Palette.blueGrey,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_sharp,
                          color: Palette.textNo,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Qu???c gia:',
                          style: MobileTextTheme().blackKLabelStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    loggedInUser.country == null || loggedInUser.country.isEmpty
                        ? Text(
                            'Kh??ng c?? d??? li???u',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          )
                        : Text(
                            '${loggedInUser.country}',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          ),
                  ],
                ),
              ),
            ),

            /// Gi???i thi???u
            Container(
              margin: EdgeInsets.only(top: 25.0, left: 25.0, right: 25),
              decoration: BoxDecoration(
                color: Palette.whiteText,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                    color: Palette.blueGrey,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ), //BoxShadow
                ],
                border: Border.all(
                  color: Palette.blueGrey,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.info_rounded,
                          color: Palette.textNo,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Gi???i thi???u:',
                          style: MobileTextTheme().blackKLabelStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    loggedInUser.bio == null || loggedInUser.bio.isEmpty
                        ? Text(
                            'Kh??ng c?? d??? li???u',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          )
                        : Text(
                            '${loggedInUser.bio}',
                            style: MobileTextTheme()
                                .accountInformationDataTextStyle,
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
          ],
        )),
      );
    } else {
      _checkAuthentication = new Login();
    }
    return _checkAuthentication;
  }
}
