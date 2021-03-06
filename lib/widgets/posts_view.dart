import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

//import 'package:like_button/like_button.dart';
import '../pages/nav-items/feeds/widgets/edit_post_screen.dart';
import '../utils/app_text_theme.dart';
import '/models/post.dart';
import '/models/user.dart';
import '../pages/drawer-items/profile/pages/profile.dart';
import '/screens/comment.dart';
import '/screens/view_image.dart';
import '/utils/firebase.dart';
import '/widgets/cached_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'awesome_dialog.dart';

class Posts extends StatefulWidget {
  final PostModel post;

  Posts({this.post});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  /// Loading animation
  bool _isDeleting = false;

  final DateTime timestamp = DateTime.now();

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  //UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => ViewImage(post: widget.post),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPostHeader(),
            Container(
              height: 320.0,
              width: MediaQuery.of(context).size.width - 18.0,
              child: cachedNetworkImage(widget.post.mediaUrl),
            ),
            Flexible(
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                title: Text(
                  widget.post.description == null
                      ? ""
                      : widget.post.description,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StreamBuilder(
                            stream: likesRef
                                .where('postId', isEqualTo: widget.post.postId)
                                .snapshots(),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot snap = snapshot.data;
                                List<DocumentSnapshot> docs = snap.docs;
                                return buildLikesCount(context, docs?.length ?? 0);
                              } else {
                                return buildLikesCount(context, 0);
                              }
                            },
                          ),
                          SizedBox(width: 5.0),
                          StreamBuilder(
                            stream: commentRef
                                .doc(widget.post.postId)
                                .collection("comments")
                                .snapshots(),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot snap = snapshot.data;
                                List<DocumentSnapshot> docs = snap.docs;
                                return buildCommentsCount(
                                    context, docs?.length ?? 0);
                              } else {
                                return buildCommentsCount(context, 0);
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 3.0),
                      Text(
                        timeago.format(widget.post.timestamp.toDate()),
                      ),
                    ],
                  ),
                ),
                trailing: Wrap(
                  children: [
                    buildLikeButton(),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.chat_bubble,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => Comments(post: widget.post),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      ),
    );
  }

  buildCommentsCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5),
      child: Text(
        '-   $count comments',
        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildPostHeader() {
    bool isMe = currentUserId() == widget.post.ownerId;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
      leading: buildUserDp(),
      title: Text(
        widget.post.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.post.location == null ? 'Kh??ng c?? v??? tr??' : widget.post.location,
      ),
      trailing: isMe
          ? IconButton(
              icon: Icon(Feather.more_horizontal),
              onPressed: () => handleOption(context),
            )
          : IconButton(
              ///Feature coming soon
              icon: Icon(CupertinoIcons.bookmark, size: 25.0),
              onPressed: () {},
            ),
    );
  }

  buildUserDp() {
    return StreamBuilder(
      stream: usersRef.doc(widget.post.ownerId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          UserModel user = UserModel.fromJson(snapshot.data.data());
          return GestureDetector(
            onTap: () => showProfile(context, profileId: user?.id),
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
          );
        }
        return Container();
      },
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: likesRef
          .where('postId', isEqualTo: widget.post.postId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot?.data?.docs ?? [];
          return IconButton(
            onPressed: () {
              if (docs.isEmpty) {
                likesRef.add({
                  'userId': currentUserId(),
                  'postId': widget.post.postId,
                  'dateCreated': Timestamp.now(),
                });
                addLikesToNotification();
              } else {
                likesRef.doc(docs[0].id).delete();
                removeLikeFromNotification();
              }
            },
            icon: docs.isEmpty
                ? Icon(
                    CupertinoIcons.heart,
                  )
                : Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  ),
          );
        }
        return Container();
      },
    );
  }

  addLikesToNotification() async {
    bool isNotMe = currentUserId() != widget.post.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromJson(doc.data());
      notificationRef
          .doc(widget.post.ownerId)
          .collection('notifications')
          .doc(widget.post.postId)
          .set({
        "type": "like",
        "username": user.username,
        "userId": currentUserId(),
        "userDp": user.photoUrl,
        "postId": widget.post.postId,
        "mediaUrl": widget.post.mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromNotification() async {
    bool isNotMe = currentUserId() != widget.post.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromJson(doc.data());
      notificationRef
          .doc(widget.post.ownerId)
          .collection('notifications')
          .doc(widget.post.postId)
          .get()
          .then((doc) => {
                if (doc.exists) {doc.reference.delete()}
              });
    }
  }

  handleOption(BuildContext parentContext) {
    //shows a simple dialog box
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  headerAnimationLoop: false,
                  animType: AnimType.TOPSLIDE,
                  showCloseIcon: true,
                  closeIcon: const Icon(Icons.close_fullscreen_outlined),
                  title: 'Th??ng b??o',
                  desc: 'B???n c?? ch???c mu???n x??a b??i vi???t n??y?',
                  descTextStyle: AppTextTheme.oswaldTextStyle,
                  btnCancelText: 'Hu??? b???',
                  btnCancelOnPress: () {},
                  btnOkText: 'X??a',
                  btnOkOnPress: () async {
                    setState(
                          () {
                        _isDeleting = true;
                      },
                    );

                    /// Calling delete post method in Post Manager model
                    deletePost();
                    setState(
                          () {
                        _isDeleting = false;
                      },
                    );
                    Navigator.pop(context);
                  },
                ).show();
              },
              child: Text('X??a b??i bi???t'),
            ),
            Divider(),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('H???y b???'),
            ),
            Divider(),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => EditPostScreen(
                      documentId: widget.post.postId,
                      currentUserID: widget.post.ownerId,
                      currentImageUrl: widget.post.mediaUrl,
                      currentDescription: widget.post.description,
                      currentLocation: widget.post.location,
                    ),
                  ),
                );
              },
              child: Text('Ch???nh s???a b??i vi???t'),
            ),
          ],
        );
      },
    );
  }

  /// You can only delete your own posts
  deletePost() async {
    postRef.doc(widget.post.id).delete();

    ///delete notification associated with that given post
    QuerySnapshot notificationsSnap = await notificationRef
        .doc(widget.post.ownerId)
        .collection('notifications')
        .where('postId', isEqualTo: widget.post.postId)
        .get();
    notificationsSnap.docs.forEach(
      (doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      },
    );

    /// Delete all the comments associated with that given post
    QuerySnapshot commentSnapshot =
        await commentRef.doc(widget.post.postId).collection('comments').get();
    commentSnapshot.docs.forEach(
      (doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      },
    );
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => Profile(profileId: profileId),
      ),
    );
  }
}
