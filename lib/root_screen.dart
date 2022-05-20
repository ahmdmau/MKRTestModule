import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkr_test_module/default_page.dart';
import 'package:mkr_test_module/detail_page.dart';
import 'package:mkr_test_module/home_screen.dart';

const CHANNEL = "com.mkr.test_module";
const PlatformChannel = const MethodChannel(CHANNEL);

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  static const homeScreen = "HOME";
  static const detailScreen = "DETAIL";
  static const defaultScreen = "DEFAULT";

  Widget currentScreen = DetailPage();
  String title = "Default Page";

  @override
  void initState() {
    super.initState();
    PlatformChannel.setMethodCallHandler(_triggerFromNative);
  }

  Future<void> _triggerFromNative(MethodCall call) async {
    if (call.method == "open_mkr_test_module") {
      switch (call.arguments) {
        case homeScreen:
          setState(() {
            title = "Home Page";
            currentScreen = HomePage();
          });
          break;
        case detailScreen:
          setState(() {
            title = "Detail Page";
            currentScreen = DetailPage();
          });
          break;
        case defaultScreen:
          setState(() {
            title = "Default Page";
            currentScreen = const DefaultPage();
          });
          break;
        default:
      }
    } else if (call.method == "auth") {
      print(call.arguments); // sso

    }
  }

  void _exitFlutter() {
    PlatformChannel.invokeMethod('exitFlutter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _exitFlutter,
        ),
      ),
      body: currentScreen,
    );
  }
}
