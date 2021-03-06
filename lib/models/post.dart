import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:medverse_mobile_app/models/user.dart';
import '/services/file_upload_service.dart';
import '/utils/firebase.dart';

class PostModel {
  String id;
  String postId;
  String ownerId;
  String username;
  String location;
  String description;
  String mediaUrl;
  Timestamp timestamp;
  String pictureUrl;
  String status;

  PostModel({
    this.id,
    this.postId,
    this.ownerId,
    this.location,
    this.description,
    this.mediaUrl,
    this.username,
    this.timestamp,
    this.status,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    ownerId = json['ownerId'];
    location = json['location'];
    username = json['username'];
    description = json['description'];
    mediaUrl = json['mediaUrl'];
    timestamp = json['timestamp'];
    status = json['status'];
  }

  String _message = '';

  String get message => _message; //getter

  setMessage(String message) {
    /// Setter
    _message = message;
/*
    notifyListeners();
*/
  }

  /// Call service file upload
  final FileUploadService _fileUploadService = FileUploadService();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['ownerId'] = this.ownerId;
    data['location'] = this.location;
    data['description'] = this.description;
    data['mediaUrl'] = this.mediaUrl;

    data['timestamp'] = this.timestamp;
    data['username'] = this.username;
    return data;
  }

  /// Get post details from the db
  Future<bool> updatePost({
    String postId,
    File postImage,
    String currentImage,
    String description,
    String location,
  }) async {
    bool isSubmitted = false;

    /// Get the current user's uid
    ownerId = firebaseAuth.currentUser.uid;

    /// Connect to posts collection
    DocumentReference documentReference = postRef.doc(postId);

    /// Connect to users collection
    DocumentSnapshot doc = await usersRef.doc(ownerId).get();
    DocumentSnapshot docPost = await postRef.doc(postId).get();

    /// Call user's model
    UserModel user = UserModel.fromJson(doc.data());
    PostModel post = PostModel.fromJson(docPost.data());

    pictureUrl = await _fileUploadService.uploadPostFile(file: postImage);

    Map<String, dynamic> data = <String, dynamic>{
      "id": documentReference.id,
      "postId": documentReference.id,
      "username": user.username,
      'description': description,
      'mediaUrl': pictureUrl ?? post.mediaUrl,
      "location": location ?? "Kh??ng c?? v??? tr??",
      "uid": ownerId
    };

    /// Check the pictureUrl then upload to Firebase
    if (pictureUrl != null) {
      await documentReference
          .update(data)
          .whenComplete(() => print('The post has been updated successfully'))
          .catchError((e) => print(e))
          .then((_) {
        isSubmitted = true;
        setMessage('C???p nh???t b??i vi???t th??nh c??ng');
      }).catchError((onError) {
        isSubmitted = false;
        setMessage('$onError');
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        isSubmitted = false;
        setMessage('Vui l??ng ki???m tra k???t n???i m???ng c???a b???n');
      });
    } else {
      isSubmitted = false;
      setMessage('T???i h??nh l??n th???t b???i');
    }
    return isSubmitted;
  }
}
