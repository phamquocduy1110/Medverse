import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '/pages/drawer-items/drug_index/pages/drug_index.dart';
import 'package:medverse_mobile_app/utils/app_text_theme.dart';
import '/utils/firebase.dart';
import '/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/theme/palette.dart';
import '/auth/login/login.dart';
import '/pages/drawer-items/profile/pages/profile.dart';
import '/pages/drawer-items/pill_identifier/pages/pill_identifier.dart';
import '/pages/drawer-items/capture_images/pages/image_capture_page.dart';
import '/pages/drawer-items/bmi_calculator/pages/input_screen.dart';
import '/pages/drawer-items/check_interaction/pages/interaction_checker.dart';
import '/pages/drawer-items/compare_drugs/pages/compare_drug_screen.dart';
import '/pages/drawer-items/medicine_dictionary/pages/medicine_dictionary.dart';
import '/pages/drawer-items/health_profile/pages/health_profile.dart';
import '/pages/drawer-items/drug_recommendation/pages/drug_recommedation.dart';
import '/pages/drawer-items/introduction_side/pages/intro_slider_screen.dart';
import '/pages/drawer-items/disclaimer/pages/disclaimer.dart';
import 'awesome_dialog.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key key}) : super(key: key);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  /// Check if user is authenticated
  User user = FirebaseAuth.instance.currentUser;

  /// Calling user's model
  UserModel loggedInUser = UserModel();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    Widget checkAuthentication;

    /// Check user is authenticated
    if (user != null) {
      FirebaseFirestore.instance.collection("users").doc(user.uid).get().then(
        (value) {
          this.loggedInUser = UserModel.fromJson(value.data());
          setState(() {});
        },
      );
      checkAuthentication = new Container(
        width: 300,
        child: Drawer(
          child: Material(
            color: Palette.mainBlueTheme,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                    profileId: firebaseAuth.currentUser.uid),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(top: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: loggedInUser.photoUrl == null ||
                                      loggedInUser.photoUrl.isEmpty
                                  ? CircleAvatar(
                                      radius: 22, // Image radius
                                      backgroundImage: AssetImage(
                                          'assets/icons/user_login.png'),
                                    )
                                  : CircleAvatar(
                                      radius: 22, // Image radius
                                      backgroundImage: NetworkImage(
                                          '${loggedInUser.photoUrl}'),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: padding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${loggedInUser.username}",
                                style: MobileTextTheme().drawerHeaderTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${loggedInUser.email}",
                                style: MobileTextTheme().drawerHeaderTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: padding,
                  child: Column(
                    children: [
                      buildMenuItem(
                        text: 'Danh m???c thu???c',
                        icon: Icons.info_outlined,
                        onClicked: () => selectedItem(context, 12),
                      ),
                      buildMenuItem(
                        text: 'T??m ki???m n??ng cao',
                        icon: Icons.zoom_in,
                        onClicked: () => selectedItem(context, 1),
                      ),
                      buildMenuItem(
                        text: 'B??o c??o ???nh thu???c',
                        icon: Icons.photo_camera_outlined,
                        onClicked: () => selectedItem(context, 2),
                      ),
                      buildMenuItem(
                        text: 'T??nh ch??? s??? BMI',
                        icon: Icons.calculate_outlined,
                        onClicked: () => selectedItem(context, 3),
                      ),
                      buildMenuItem(
                        text: 'Ki???m tra t????ng k??? thu???c',
                        icon: Icons.do_disturb_alt_outlined,
                        onClicked: () => selectedItem(context, 4),
                      ),
                      buildMenuItem(
                        text: 'So s??nh thu???c',
                        icon: Icons.compare_outlined,
                        onClicked: () => selectedItem(context, 5),
                      ),
                      buildMenuItem(
                        text: 'G???i ?? thu???c',
                        icon: Icons.recommend_outlined,
                        onClicked: () => selectedItem(context, 6),
                      ),
                      buildMenuItem(
                        text: 'T??? ??i???n y h???c',
                        icon: Icons.list_alt_outlined,
                        onClicked: () => selectedItem(context, 7),
                      ),
                      buildMenuItem(
                        text: 'H??? s?? s???c kh???e',
                        icon: Icons.health_and_safety_outlined,
                        onClicked: () => selectedItem(context, 8),
                      ),
                      Divider(color: Palette.whiteText),
                      buildMenuItem(
                        text: 'H?????ng d???n s??? d???ng',
                        icon: Icons.help_outline_sharp,
                        onClicked: () => selectedItem(context, 10),
                      ),
                      buildMenuItem(
                        text: 'Mi???n tr??? tr??ch nhi???m',
                        icon: Icons.info_outlined,
                        onClicked: () => selectedItem(context, 11),
                      ),
                      buildMenuItem(
                        text: '????ng xu???t',
                        icon: Icons.logout_outlined,
                        onClicked: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            headerAnimationLoop: false,
                            animType: AnimType.TOPSLIDE,
                            showCloseIcon: true,
                            closeIcon:
                                const Icon(Icons.close_fullscreen_outlined),
                            title: 'Th??ng b??o',
                            desc: 'B???n c?? ch???c mu???n tho??t t??i kho???n n??y?',
                            descTextStyle: AppTextTheme.oswaldTextStyle,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              setState(
                                () {
                                  isLoading = true;
                                },
                              );

                              /// Calling delete post method in Post Manager model
                              firebaseAuth.signOut();
                              setState(
                                () {
                                  isLoading = false;
                                },
                              );
                              logout(context);
                            },
                          ).show();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      checkAuthentication = new Container(
        width: 300,
        child: Drawer(
          child: Material(
            color: Palette.mainBlueTheme,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: padding,
                  child: Column(
                    children: [
                      buildMenuItem(
                        text: 'Ch??? m???c danh s??ch thu???c',
                        icon: Icons.info_outlined,
                        onClicked: () => selectedItem(context, 12),
                      ),
                      buildMenuItem(
                        text: 'T??m ki???m n??ng cao',
                        icon: Icons.zoom_in,
                        onClicked: () => selectedItem(context, 1),
                      ),
                      buildMenuItem(
                        text: 'B??o c??o thu???c ?????n Admin',
                        icon: Icons.photo_camera_outlined,
                        onClicked: () => selectedItem(context, 2),
                      ),
                      buildMenuItem(
                        text: 'T??nh ch??? s??? BMI',
                        icon: Icons.calculate_outlined,
                        onClicked: () => selectedItem(context, 3),
                      ),
                      buildMenuItem(
                        text: 'Ki???m tra t????ng k??? thu???c',
                        icon: Icons.do_disturb_alt_outlined,
                        onClicked: () => selectedItem(context, 4),
                      ),
                      buildMenuItem(
                        text: 'So s??nh thu???c',
                        icon: Icons.compare_outlined,
                        onClicked: () => selectedItem(context, 5),
                      ),
                      buildMenuItem(
                        text: 'G???i ?? thu???c',
                        icon: Icons.recommend_outlined,
                        onClicked: () => selectedItem(context, 6),
                      ),
                      buildMenuItem(
                        text: 'T??? ??i???n y h???c',
                        icon: Icons.list_alt_outlined,
                        onClicked: () => selectedItem(context, 7),
                      ),
                      buildMenuItem(
                        text: 'H??? s?? s???c kh???e',
                        icon: Icons.health_and_safety_outlined,
                        onClicked: () => selectedItem(context, 8),
                      ),
                      Divider(color: Palette.whiteText),
                      buildMenuItem(
                        text: 'H?????ng d???n s??? d???ng',
                        icon: Icons.help_outline_sharp,
                        onClicked: () => selectedItem(context, 10),
                      ),
                      buildMenuItem(
                        text: 'Mi???n tr??? tr??ch nhi???m',
                        icon: Icons.info_outlined,
                        onClicked: () => selectedItem(context, 11),
                      ),
                      buildMenuItem(
                        text: '????ng nh???p',
                        icon: Icons.login_outlined,
                        onClicked: () => selectedItem(context, 9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      child: checkAuthentication,
    );
  }

  Widget buildHeader({
    String urlImage,
    String name,
    String email,
    VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: MobileTextTheme().drawerHeader,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: MobileTextTheme().drawerHeader,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    showInSnackBar('???? tho??t t??i kho???n th??nh c??ng', context);
    Navigator.pushReplacementNamed(context, "/home");
  }

  Widget buildMenuItem({
    String text,
    IconData icon,
    VoidCallback onClicked,
  }) {
    const color = Palette.whiteText;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: MobileTextTheme().navigationDrawerStyle),
      hoverColor: Palette.grey,
      onTap: onClicked,
    );
  }

  /// Config snack bar message style
  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: GoogleFonts.oswald(),
        ),
        backgroundColor: Palette.activeButton,
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PillIdentifier(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CaptureimagePage(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InputCalculateBMI(),
          ),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InteractionChecker(),
          ),
        );
        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompareDrug(),
          ),
        );
        break;
      case 6:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DrugRecommendation(),
          ),
        );
        break;
      case 7:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MedicineDictionary(),
          ),
        );
        break;
      case 8:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TabHealthProfile(),
          ),
        );
        break;
      case 9:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
        break;
      case 10:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HelpScreen(),
          ),
        );
        break;
      case 11:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Disclaimer(),
          ),
        );
        break;
      case 12:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DrugIndex(),
          ),
        );
        break;
    }
  }
}
