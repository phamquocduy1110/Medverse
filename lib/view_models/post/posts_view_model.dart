import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '/theme/palette.dart';
import '/models/post.dart';
import '/screens/mainscreen.dart';
import '/services/post_service.dart';
import '/services/user_service.dart';
import '/utils/constants.dart';
import '/utils/firebase.dart';

class PostsViewModel extends ChangeNotifier {
  /// Connect to user's service
  UserService userService = UserService();

  /// Connect to post's service
  PostService postService = PostService();

  /// Check all keys validation
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Variables
  bool loading = false;
  String username;
  File mediaUrl;
  final picker = ImagePicker();
  String location;
  bool validate = false;
  Position position;
  Placemark placemark;
  String bio;
  String description;
  String email;
  String commentData;
  String ownerId;
  String userId;
  String type;
  File userDp;
  String imgLink;
  bool edit = false;
  String id;

  /// Editing Controllers
  TextEditingController locationTEC = TextEditingController();

  // Setters
  setEdit(bool val) {
    edit = val;
    notifyListeners();
  }

  setPost(PostModel post) {
    if (post != null) {
      description = post.description;
      imgLink = post.mediaUrl;
      location = post.location;
      edit = true;
      edit = false;
      notifyListeners();
    } else {
      edit = false;
      notifyListeners();
    }
  }

  setUsername(String val) {
    print('SetName $val');
    username = val;
    notifyListeners();
  }

  setDescription(String val) {
    print('SetDescription $val');
    description = val;
    notifyListeners();
  }

  setLocation(String val) {
    print('SetCountry $val');
    location = val;
    notifyListeners();
  }

  setBio(String val) {
    print('SetBio $val');
    bio = val;
    notifyListeners();
  }

  //Functions
  pickImage({bool camera = false, BuildContext context}) async {
    loading = true;
    notifyListeners();
    try {
      PickedFile pickedFile = await picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      File croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'C???t h??nh',
          toolbarColor: Constants.lightAccent,
          toolbarWidgetColor: Palette.whiteText,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      mediaUrl = File(croppedFile.path);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showErrorInSnackBar('H???y b???', context);
    }
  }

  getLocation() async {
    loading = true;
    notifyListeners();
    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission rPermission = await Geolocator.requestPermission();
      print(rPermission);
      await getLocation();
    } else {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      placemark = placemarks[0];
      location = " ${placemarks[0].locality}, ${placemarks[0].country}";
      locationTEC.text = location;
      print(location);
    }
    loading = false;
    notifyListeners();
  }

  uploadPosts(BuildContext context) async {
    if(mediaUrl == null) {
      showErrorInSnackBar('Vui l??ng ch???n h??nh ???nh', context);
    } else {
      if(formKey.currentState.validate()) {
        try {
          loading = true;
          notifyListeners();
          await postService.uploadPost(mediaUrl, location, description);
          showActiveInSnackBar('T???o b??i vi???t th??nh c??ng!', context);
          Navigator.of(context).pop();
          loading = false;
          resetPost();
          notifyListeners();
        } catch (e) {
          print(e);
          loading = false;
          resetPost();
          notifyListeners();
        }
      } else {
        loading = false;
        resetPost();
        showErrorInSnackBar('Vui l??ng ho??n th??nh t???t c??? th??ng tin tr?????c khi ????ng b??i', context);
        notifyListeners();
      }
    }
  }

  uploadProfilePicture(BuildContext context) async {
    if (mediaUrl == null) {
      showErrorInSnackBar('Vui l??ng ch???n h??nh ???nh', context);
    } else {
      try {
        loading = true;
        notifyListeners();
        await postService.uploadProfilePicture(
            mediaUrl, firebaseAuth.currentUser);
        loading = false;
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (_) => TabScreen(),
          ),
        );
        notifyListeners();
      } catch (e) {
        print(e);
        loading = false;
        showActiveInSnackBar('T???i ???nh l??n th??nh c??ng!', context);
        notifyListeners();
      }
    }
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    location = null;
    edit = null;
    notifyListeners();
  }

  /// This message will show when validation is failed
  void showErrorInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: GoogleFonts.oswald(),
        ),
        backgroundColor: Palette.red,
      ),
    );
  }

  /// This message will show when validation is successful
  void showActiveInSnackBar(String value, context) {
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
}
