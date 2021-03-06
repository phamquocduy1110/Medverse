import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../services/service_data.dart';
import '../../../../theme/palette.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/awesome_dialog.dart';
import '../../../../widgets/dimension.dart';
import 'compare_result.dart';

class CompareDrug extends StatefulWidget {
  const CompareDrug({Key key}) : super(key: key);

  @override
  State<CompareDrug> createState() => _CompareDrugState();
}

class _CompareDrugState extends State<CompareDrug> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Editing controller
  final TextEditingController _typeAheadController = TextEditingController();
  FocusNode focusNode;

  // String _selectedDrug;
  List<String> addedItemsList = [];
  List<String> addedItemsIdList = [];

  // Add to list function
  void __addItemToList(String value) {
    setState(() {
      addedItemsList.insert(0, value);
    });
  }

  void __addItemIdToList(String value) {
    setState(() {
      addedItemsIdList.insert(0, value);
    });
  }

  /// Intro text
  String introText =
      "Xem cách các loại thuốc của bạn xếp chồng lên nhau. Xem các so sánh song song về việc sử dụng thuốc, tác dụng phụ, tương tác thuốc, phân loại, tính khả dụng chung và hơn thế nữa.";

  /// Select text
  String selectText =
      "Bắt đầu gõ tên một loại thuốc. Một danh sách các gợi ý sẽ xuất hiện sau đó vui lòng chọn từ danh sách.";

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// intro
    Widget __intro() {
      return Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 25),
        child: Container(
          child: AppText(
            text: introText,
            size: Dimensions.font18,
            color: Palette.mainBlueTheme,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }

    /// search drug
    Widget __searchInput() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  autocorrect: true,
                  focusNode: focusNode,
                  controller: this._typeAheadController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          CupertinoIcons.clear,
                          color: Palette.mainBlueTheme,
                        ),
                        onPressed: () {
                          _typeAheadController.clear();
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radius20),
                        ),
                        borderSide: BorderSide(color: Palette.mainBlueTheme),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radius20),
                        ),
                        borderSide:
                            BorderSide(width: 3, color: Palette.mainBlueTheme),
                      ),
                      labelStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          color: Palette.mainBlueTheme),
                      labelText: 'Nhập tên thuốc mà bạn muốn so sánh'),
                ),
                suggestionsCallback: (String pattern) {
                  if (pattern == null ||
                      pattern.trim().isEmpty ||
                      pattern.length == 0) {
                    return [];
                  } else {
                    return TypeAheadByNameFast.getTypeAheadByName(pattern);
                  }
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: AppText(
                      text: suggestion['productName'],
                      color: Colors.black54,
                      size: Dimensions.font14,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  _typeAheadController.text = suggestion['productName'];
                  // print(_typeAheadController.text);
                  // print(suggestion['productId']);
                  __addItemToList(_typeAheadController.text);
                  __addItemIdToList(suggestion['productId']);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mời bạn nhập tên thuốc';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    }

    /// list box
    Widget __listBox() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 100,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            color: Colors.grey[100],
          ),
          child: addedItemsList.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText(
                    text: selectText,
                    size: Dimensions.font14,
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addedItemsList.length,
                  itemBuilder: (context, index) {
                    return Chip(
                      deleteIconColor: Colors.white,
                      backgroundColor: Palette.mainBlueTheme.withOpacity(0.7),
                      label: AppText(
                        text: addedItemsList[index],
                        color: Colors.white,
                        size: Dimensions.font20,
                      ),
                      deleteIcon: Icon(
                        CupertinoIcons.multiply,
                      ),
                      onDeleted: () {
                        setState(() {
                          addedItemsList.removeAt(index);
                          addedItemsIdList.removeAt(index);
                        });
                      },
                    );
                  },
                ),
        ),
      );
    }

    /// btn
    Widget __compare() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Palette.mainBlueTheme,
          ),
          child: TextButton(
            onPressed: () {
              if (addedItemsList.length == 0 && addedItemsIdList.length == 0) {
                AwesomeDialog(
                  dialogBackgroundColor: Colors.white,
                  context: context,
                  headerAnimationLoop: false,
                  titleTextStyle: TextStyle(
                      color: Colors.black, fontSize: Dimensions.font20),
                  descTextStyle: TextStyle(color: Colors.black),
                  dialogType: DialogType.NO_HEADER,
                  btnOkColor: Palette.pastel5,
                  title: 'Lỗi',
                  desc: 'Hãy nhập vào đủ 2 tên thuốc để xem so sánh',
                  btnOkOnPress: () {
                    focusNode.requestFocus();
                  },
                  btnOkIcon: Icons.check_circle,
                ).show();
              } else if (addedItemsList.length == 1 &&
                  addedItemsIdList.length == 1) {
                AwesomeDialog(
                  dialogBackgroundColor: Colors.white,
                  context: context,
                  headerAnimationLoop: false,
                  titleTextStyle: TextStyle(
                      color: Colors.black, fontSize: Dimensions.font20),
                  descTextStyle: TextStyle(color: Colors.black),
                  dialogType: DialogType.NO_HEADER,
                  btnOkColor: Palette.pastelList1,
                  title: 'Lỗi',
                  desc: 'Hãy nhập vào đủ 2 tên thuốc để xem tương kị',
                  btnOkOnPress: () {
                    focusNode.requestFocus();
                  },
                  btnOkIcon: Icons.check_circle,
                ).show();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompareResult(
                      query1: addedItemsIdList[0],
                      query2: addedItemsIdList[1],
                    ),
                  ),
                );
              }
            },
            child: AppText(
              text: "So sánh",
              color: Palette.whiteText,
              size: Dimensions.font20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainBlueTheme,
        title: AppText(
          text: 'So sánh thuốc',
          size: Dimensions.font20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Intro
            __intro(),

            /// Compare box
            Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.height30, right: Dimensions.height30),
              child: Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  depth: 15,
                  lightSource: LightSource.top,
                  color: Colors.white,
                ),
                child: Container(
                  child: Column(
                    children: [
                      __searchInput(),
                      __listBox(),
                      __compare(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height10,
            ),
          ],
        ),
      ),
    );
  }
}
