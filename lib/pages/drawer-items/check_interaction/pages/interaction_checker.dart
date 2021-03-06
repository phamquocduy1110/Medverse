import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '/widgets/awesome_dialog.dart';
import '/services/service_data.dart';
import '/theme/palette.dart';
import '/widgets/app_text.dart';
import '/widgets/dimension.dart';
import 'interaction_checker_result.dart';

class InteractionChecker extends StatefulWidget {
  const InteractionChecker({Key key}) : super(key: key);

  @override
  _InteractionCheckerState createState() => _InteractionCheckerState();
}

class _InteractionCheckerState extends State<InteractionChecker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String selectText =
      "Bắt đầu gõ tên một loại thuốc. Một danh sách các gợi ý sẽ xuất hiện sau đó vui lòng chọn từ danh sách.";

  // String _selectedDrug;
  List<String> addedItemsList = [];
  List<String> addedItemsIdList = [];

  // Add to list function
  void __addItemToList(String value) {
    if (addedItemsList.length == 2) {
      addedItemsList.removeLast();
      setState(() {
        addedItemsList.insert(0, value);
      });
    } else {
      setState(() {
        addedItemsList.insert(0, value);
      });
    }
  }

  void __addItemIdToList(String value) {
    if (addedItemsIdList.length == 2) {
      addedItemsIdList.removeLast();
      setState(() {
        addedItemsIdList.insert(0, value);
      });
    } else {
      setState(() {
        addedItemsIdList.insert(0, value);
      });
    }
  }

  FocusNode focusNode;

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
    //title
    Widget __title() {
      return Container(
        padding: EdgeInsets.all(Dimensions.height20),
        child: AppText(
          color: Palette.mainBlueTheme,
          text:
              "Bắt đầu nhập tên loại thuốc và chọn loại thuốc phù hợp nhất từ danh sách gợi ý. Lặp lại quy trình để thêm nhiều loại thuốc. Sau khi danh sách của bạn hoàn tất, bạn có thể kiểm tra các tương tác ngay lập tức.",
          size: Dimensions.font18,
          fontWeight: FontWeight.normal,
        ),
      );
    }

    // input text
    Widget __textInput() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  focusNode: focusNode,
                  autocorrect: true,
                  controller: this._typeAheadController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(CupertinoIcons.clear),
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
                    labelText: 'Nhập thuốc bạn muốn kiểm tra tương kỵ',
                  ),
                ),
                suggestionsCallback: (String pattern) {
                  if (pattern == null ||
                      pattern.trim().isEmpty ||
                      pattern.length == 0) {
                    return [];
                  } else {
                    return TypeAheadByName.getTypeAheadByName(pattern);
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
                  // print(suggestion['drugId']);
                  __addItemToList(_typeAheadController.text);
                  __addItemIdToList(suggestion['drugId']);
                },
              ),
            ],
          ),
        ),
      );
    }

    // Check Interaction btn
    Widget __checkBtn() {
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
                  btnOkColor: Palette.pastelList1,
                  title: 'Lỗi',
                  desc: 'Hãy nhập vào đủ 2 tên thuốc để xem tương kị',
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
                    builder: (context) => InteractionCheckerResult(
                      name1: addedItemsList[0],
                      name2: addedItemsList[1],
                      id1: addedItemsIdList[0],
                      id2: addedItemsIdList[1],
                    ),
                  ),
                );
              }
            },
            child: AppText(
              text: "Kiểm tra tương kỵ",
              color: Palette.whiteText,
              size: Dimensions.font20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
    }

// list items
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainBlueTheme,
        title: AppText(
          text: 'Kiểm tra tương kỵ thuốc',
          size: Dimensions.font20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            __title(),

            /// Input Box
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
                      __textInput(),
                      __listBox(),
                      __checkBtn(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
