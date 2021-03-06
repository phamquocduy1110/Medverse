import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';
import '/models/post.dart';
import '/theme/palette.dart';
import 'package:flutter/material.dart';
import '/utils/validation.dart';
import '/utils/app_text_theme.dart';
import '/pages/nav-items/feeds/widgets/custom_form_field.dart';

class EditItemForm extends StatefulWidget {
  final String documentId;
  final String currentImageUrl;
  final String currentDescription;
  final String currentLocation;
  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;

  const EditItemForm({
    this.documentId,
    this.currentImageUrl,
    this.currentDescription,
    this.currentLocation,
    this.titleFocusNode,
    this.descriptionFocusNode,
  });

  @override
  State<EditItemForm> createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  /// Editing Controller
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  /// Connect to Post Manger model
  final PostModel _postModel = PostModel();
  File _postImageFile;
  final ImagePicker _imagePicker = ImagePicker();

  bool isLoading = false;

  /// Select image from camera or gallery
  selectImage(ImageSource imageSource) async {
    XFile file = await _imagePicker.pickImage(source: imageSource);
    File croppedFile = File(file.path);
    setState(() {
      _postImageFile = croppedFile;
    });
  }

  /// Check validation
  final _addItemFormKey = GlobalKey<FormState>();

  /// Loading processing
  bool _isProcessing = false;

  String updateImage = "";
  String updateDescription = "";
  String updateLocation = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _addItemFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  selectImage(ImageSource.camera);
                                },
                                icon: const Icon(UniconsLine.camera),
                                label: const Text(
                                  'Ch???n t??? M??y ???nh',
                                ),
                              ),
                              const Divider(),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  selectImage(ImageSource.gallery);
                                },
                                icon: const Icon(UniconsLine.picture),
                                label: const Text('Ch???n t??? Th?? vi???n'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: Palette.grey300,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        border: Border.all(
                          color: Palette.mainBlueTheme,
                        ),
                      ),
                      child: _postImageFile == null
                          ? Image.network(
                              widget.currentImageUrl,
                              height: MediaQuery.of(context).size.width - 30,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _postImageFile,
                              height: MediaQuery.of(context).size.width - 30,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'M?? t??? b??i vi???t'.toUpperCase(),
                        style:
                            MobileTextTheme().inputDescriptionAndLocationTitle,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Palette.red,
                        ),
                      ),
                    ],
                  ),
                  CustomFormField(
                    maxLines: null,
                    isLabelEnabled: false,
                    initialValue: widget.currentDescription,
                    controller: _descriptionController,
                    focusNode: widget.descriptionFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return ("M???i b???n nh???p m?? t??? b??i vi???t");
                      }
                      updateDescription = value;
                    },
                    label: 'M?? t??? b??i vi???t',
                    hint: 'Eg. ????y l?? m???t b???c h??nh ?????p',
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'V??? tr??'.toUpperCase(),
                    style: MobileTextTheme().inputDescriptionAndLocation,
                  ),
                  CustomFormField(
                    maxLines: null,
                    isLabelEnabled: false,
                    initialValue: widget.currentLocation ?? "Kh??ng c?? v??? tr??",
                    controller: _locationController,
                    focusNode: widget.descriptionFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    validator: (value) {
                      Validations.validateField(
                        value: value,
                      );
                      updateLocation = value;
                    },
                    label: 'V??? tr??',
                    hint: 'Vi???t Nam, H??? Ch?? Minh',
                  ),
                ],
              ),
            ),
            _isProcessing
                ? Padding(
                    padding: const EdgeInsets.all(
                      16.0,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Palette.mainBlueTheme,
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Palette.mainBlueTheme,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        widget.titleFocusNode.unfocus();
                        widget.descriptionFocusNode.unfocus();

                        if (_addItemFormKey.currentState.validate()) {
                          setState(
                            () {
                              _isProcessing = true;
                            },
                          );

                          await _postModel.updatePost(
                            postId: widget.documentId,
                            postImage: _postImageFile,
                            currentImage: widget.currentImageUrl,
                            description: updateDescription,
                            location: updateLocation,
                          );

                          setState(
                            () {
                              _isProcessing = false;
                            },
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'C???p nh???t b??i vi???t',
                          style: MobileTextTheme().kLargeButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
