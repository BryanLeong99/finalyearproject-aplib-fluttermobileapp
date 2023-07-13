import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/enum/enum_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fswitch/fswitch.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';
import 'setting_data_provider.dart';
import 'setting_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingDataProvider _settingDataProvider;
  AuthenticationHandler _authenticationHandler;

  SettingModel userSetting;

  LoadState _loadState = LoadState.Loading;

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  void _updateSetting(bool value) async {
    EasyLoading.show(
      status: 'Updating...',
      maskType: EasyLoadingMaskType.black,
    );
    _settingDataProvider.updateUserSetting(
      this.userSetting.settingId,
      value ? '1' : '0'
    ).then((status) => {
      if (status == 'success') {
        _fetchUserSetting().then((userSetting) => {
          if (userSetting.length != 0) {
            setState(() {
              this.userSetting = userSetting[0];
              this._loadState = LoadState.Done;
              EasyLoading.dismiss();
            }),
          } else {
            setState(() {
              this._loadState = LoadState.Done;
              EasyLoading.dismiss();
            }),
          }
        }),
      } else {
        showDialog(
          context: context,
          builder: (context) =>
            AlertDialog(
              title: Text(
                "Update Failed",
                style: Constants
                    .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
              ),
              content: Text(
                "Unexpected error. Please try again later.",
                style: Constants.TEXT_STYLE_DIALOG_CONTENT,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: Constants
                        .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                  ),
                ),
              ],
            ),
        ),
      }
    });
  }

  Future<List<SettingModel>> _fetchUserSetting() async {
    String userToken = await new AuthenticationHandler().getToken();
    return await _settingDataProvider.getUserSetting(userToken);
  }

  @override initState() {
    super.initState();

    _settingDataProvider = new SettingDataProvider();
    _authenticationHandler = new AuthenticationHandler();

    _fetchUserSetting().then((userSetting) => {
      if (userSetting.length != 0) {
        setState(() {
          this.userSetting = userSetting[0];
          this._loadState = LoadState.Done;
        }),
      } else {
        setState(() {
          this._loadState = LoadState.Done;
        }),
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => _back(context),
          child: Icon(
            Icons.arrow_back_outlined,
            color: Constants.COLOR_BLACK,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // page title
              Container(
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                width: screenWidth,
                child: Text(
                  'Settings',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              // setting option
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Push Notification',
                        style: Constants.TEXT_STYLE_SETTING_OPTION_TEXT,
                      ),
                    ),

                    Container(
                      child: FSwitch(
                        open: _loadState == LoadState.Loading ? false : userSetting != null && userSetting.enabledNotification,
                        width: 65.0,
                        height: 35.538,
                        enable: _loadState == LoadState.Loading ? false : true,
                        onChanged: (value) => _updateSetting(value),
                        color: Constants.COLOR_RED,
                        openColor: Constants.COLOR_GREEN_LIGHT,
                        closeChild: Text(
                          "Off",
                          style: Constants.TEXT_STYLE_SWITCH_TEXT,
                        ),
                        openChild: Text(
                          "On",
                          style: Constants.TEXT_STYLE_SWITCH_TEXT,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // sub-heading of linked device
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.05),
                child: Text(
                  'Linked Device',
                  style: Constants.TEXT_STYLE_HEADING_3,
                ),
              ),

              // device
              userSetting != null && userSetting.enabledNotification ? Container(
                margin: EdgeInsets.only(top: screenHeight * 0.03),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.devices_rounded,
                        color: Constants.COLOR_BLUE_MEDIUM_STATE,
                        size: 32,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: screenWidth * 0.035),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.028,
                              decoration: BoxDecoration(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ) : userSetting != null ? Container(
                            child: Text(
                              userSetting.deviceName,
                              style: Constants.TEXT_STYLE_SETTING_OPTION_TEXT,
                            ),
                          ) : Container(),

                          _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.015,
                              margin: EdgeInsets.only(top: screenHeight * 0.01),
                              decoration: BoxDecoration(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ) : userSetting != null ? Container(
                            child: Text(
                              'OS Build: ' + userSetting.buildOs,
                              style: Constants.TEXT_STYLE_DEVICE_NAME_TEXT,
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ) : Container(
                margin: EdgeInsets.only(top: screenHeight * 0.01),
                child: Text(
                  'No linked device found.',
                  style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}