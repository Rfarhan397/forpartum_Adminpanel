import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../controller/menu_App_Controller.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/services/enum/toastType.dart';

class ActionProvider extends ChangeNotifier{
  int _selectedIndex = 0;
  final Map<int, bool> _isHovered = {};
  final Map<int, bool> _isLoading = {};

  Map<int, bool> _isCardHovered = {};

  bool isCardHovered(int index) => _isCardHovered[index] ?? false;

  void setHover(int index, bool value) {
    _isCardHovered[index] = value;
    notifyListeners();
  }

  static final ActionProvider _instance = ActionProvider._internal();
  factory ActionProvider() => _instance;
  ActionProvider._internal();

  int get selectedIndex => _selectedIndex;
  bool  isHovered(int index) => _isHovered[index] ?? false;
  bool  isLoading(int index) => _isLoading[index] ?? false;

  void selectMenu(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void onHover(int index,bool isHovered) {
    _isHovered[index] = isHovered;
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading[0] = isLoading;
    notifyListeners();
  }

  // Static methods to start and stop loading globally
  static void startLoading() {
    _instance.setLoading(true);
  }

  static void stopLoading() {
    _instance.setLoading(false);
  }

  String? _message;
  bool _isVisible = false;
  ToastType? _toastType;

  String? get message => _message;
  bool get isVisible => _isVisible;
  ToastType? get toastType => _toastType;

  void showToast(String message, ToastType toastType) {
    _message = message;
    _toastType = toastType;
    _isVisible = true;
    notifyListeners();

    // Automatically hide the toast after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      hideToast();
    });
  }

  void hideToast() {
    _isVisible = false;
    notifyListeners();
  }

  final Map<String, bool> _loadingStates = {};
  bool isLoadingState(String key) => _loadingStates[key] ?? false;

  void setLoadingState(String key, bool loading) {
    _loadingStates[key] = loading;
    notifyListeners();
  }


  bool _isFooterHovered = false;

  bool get isFooterHovered => _isFooterHovered;

  void setHovered(bool value) {
    _isFooterHovered = value;
    notifyListeners();
  }

  int _hoveredIndex = -1;

  int get hoveredIndex => _hoveredIndex;

  void setHoveredIndex(int index) {
    _hoveredIndex = index;
    notifyListeners();
  }

  void clearHover() {
    _hoveredIndex = -1;
    notifyListeners();
  }


  bool _isEditVisible = false;
  bool get isEditVisible => _isEditVisible;

  void setEditVisible(bool value) {
    _isEditVisible = value;
    notifyListeners();
  }


  final GlobalKey<ScaffoldState> _scaffoldKeyDashboard = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKeyDashboard;

  void controlMenuDashboard() {
    if (!_scaffoldKeyDashboard.currentState!.isDrawerOpen) {
      _scaffoldKeyDashboard.currentState!.openDrawer();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKeyInstructor = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKeyInstructor => _scaffoldKeyInstructor;

  void controlMenuInstructor() {
    if (!_scaffoldKeyInstructor.currentState!.isDrawerOpen) {
      _scaffoldKeyInstructor.currentState!.openDrawer();
    }
  }


  // date picker d
  DateTime? _selectedDateTime;

  DateTime? get selectedDateTime => _selectedDateTime;

  void setDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  DateTimeRange? _selectedDateTimeRange;

  DateTimeRange? get selectedDateTimeRange => _selectedDateTimeRange;

  void setDateTimeRange(DateTimeRange dateTimeRange) {
    _selectedDateTimeRange = dateTimeRange;
    notifyListeners();
  }


  void deleteItem(String collection,String id) {
    FirebaseFirestore.instance.collection(collection).doc(id).delete().then((value) {
      // Success
    }).catchError((error) {
      // Handle error
    });
  }

  ///to update the value of button on updating speciality
  String _buttonText = 'upload';
  String _publishText = 'publish';

  String? _editingId;
  bool _isUpdate = false;
  String get buttonText => _buttonText;
  String get publishText => _publishText;

  String? get editingId => _editingId;
  bool get isUpdate => _isUpdate;

  void setEditingMode(String id) {
    _buttonText = 'Update';
    _publishText = 'Update';
    _editingId = id;
    notifyListeners();
  }

  void resetMode() {
    _buttonText = 'upload';
    _publishText = 'publish';
    _editingId = null;
    _isUpdate = false;
    notifyListeners();
  }
///to scroll to top///
  void scrollToTextField(controller) {
    // Scroll to the TextField position
    controller.animateTo(
      10.0, // Adjust this value based on your layout
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  /////////to show the dialog box for deleting////
  Future<bool> showDeleteConfirmationDialog(BuildContext context,String title,content) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title),
          content:  Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
                AppUtils().showToast(text: 'Deleted successfully');

              },
            ),
          ],
        );
      },
    ) ?? false;
  }
  //////to show the dialog box  for notifications////
  Future<bool> showConfirmDialog(BuildContext context,String title,content) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          title:  Text(title,style: TextStyle(color: Colors.white,fontSize: 16),),
          content:  Text(content,style: TextStyle(color: Colors.white,fontSize: 13)),
        );
      },
    ) ?? false;
  }

  int _backIndex = 0;

  int get backIndex => _backIndex;

  void setBackIndex(int index) {
    _backIndex = index;
    notifyListeners();
  }


  void changeScreen(){
    Provider.of<MenuAppController>(Get.context!,
        listen: false)
        .changeScreen(_backIndex);
  }

}