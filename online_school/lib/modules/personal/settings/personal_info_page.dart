import 'dart:io';
import 'package:online_school/common/dao/original_dao/avatar_upload_dao.dart';
import 'package:online_school/common/dao/original_dao/ccuser_info_dao.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/model/base_model.dart';
import 'package:online_school/model/upload_avatar_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/user_reducer.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/radio_button.dart';
import 'package:online_school/modules/widgets/setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';


///
/// @name PersonalInfoPage
/// @description 个人信息页面
/// @author liuca
/// @date 2020-01-11
///
class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // final cropKey = GlobalKey<CropState>();
  File _sample;
  File _file;
  File _lastCropped;

  bool editable;

  var _sex;
  var _realName;
  var _userName;
  var _oldUserName;

  var _birthday;
  var _address;
  var _email;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    editable = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var data = _getStore().state.userInfo.data;
    _sex = data.sex;
    _realName = data?.realName;
    _userName = data?.userName;
    _oldUserName = data?.realName;

    _birthday = data.birthday.split(' ').first;
    _address = data.address;
    _email = data.email;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    // _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return _buildPage(store);
    });
  }

  Widget _buildPage(Store<AppState> store) {
    var data = store.state.userInfo.data;

    return Scaffold(
      backgroundColor: Color(MyColors.background),
        appBar: AppBar(
          elevation: 1.0,
          title: Text(MTTLocalization.of(context).currentLocalized.personal_info_page_navigator_title),
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
          actions: <Widget>[
            Center(
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(editable ? MTTLocalization.of(context).currentLocalized.personal_info_page_save : MTTLocalization.of(context).currentLocalized.personal_info_page_edit, style: textStyleNormal),
                ),
                onTap: () async {
                  await _doSave(_realName, _oldUserName, _address, _email,
                      _birthday, _sex);
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                Divider(height: 0.5, color: Colors.black12),
                Container(
                  color: Color(MyColors.background),
                  width: double.infinity,
                  child: InkWell(
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 15)),
                        Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.black12, width: 1), // 边色与边宽度
                            shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                          ),
                          child: ClipOval(
                            child: _lastCropped == null
                                ? Image.network(
                                    data?.userPhoto,
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _lastCropped,
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 15),
                          child: Text(editable ? MTTLocalization.of(context).currentLocalized.personal_info_page_edit_avatar : '',
                              style: textStyleTabUnselected),
                        ),
                      ],
                    ),
                    onTap: () {
                      editable ? _openImage() : () {};
                    },
                  ),
                ),
                Divider(height: 10.0, color: Colors.black12),
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.personal_info_page_user_id,
                  subText: data?.userId.toString(),
                ),
                Divider(height: 0.5, color: Colors.black12),
                SettingRow(MTTLocalization.of(context).currentLocalized.personal_info_page_user_name, subText: _userName, onPress: null),
                Divider(height: 0.5, color: Colors.black12),
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.personal_info_page_real_name,
                  subText: _realName,
                  onPress: !editable
                      ? null
                      : () {
                          showDialog<String>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              _userNameController.text = _realName;
                              return new AlertDialog(
                                title: new Text('姓名'),
                                content: new SingleChildScrollView(
                                  child: TextField(
                                    controller: _userNameController,
                                  ),
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text('确定'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(_userNameController.text);
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((val) {
                            var match =
                                RegExp(r'[\u4e00-\u9fa5]{2,8}').hasMatch(val);
                            if (match) {
                              _realName = val;
                              setState(() {});
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('提示'),
                                        content: Text('名字必须是2-8个汉字'),
                                      ));
                            }
                          });
                        },
                ),
                Divider(height: 0.5, color: Colors.black12),
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.personal_info_page_gender,
                  subWidget: editable
                      ? Container(
                          padding: EdgeInsets.only(left: 14),
                          child: Row(
                            children: <Widget>[
                              MyRadio(
                                  label: MTTLocalization.of(context).currentLocalized.personal_info_page_male,
                                  labelStyle: textStyleTabUnselected,
                                  onTap: () {
                                    _sex = getSexValue(Sex.MALE);
                                    setState(() {});
                                  },
                                  checked: _sex == getSexValue(Sex.MALE)),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              MyRadio(
                                  label: MTTLocalization.of(context).currentLocalized.personal_info_page_female,
                                  labelStyle: textStyleTabUnselected,
                                  onTap: () {
                                    _sex = getSexValue(Sex.FEMALE);
                                    setState(() {});
                                  },
                                  checked: _sex == getSexValue(Sex.FEMALE)),
                            ],
                          ),
                        )
                      : null,
                  subText: editable
                      ? null
                      : data?.sex == 2 ? '女' : data?.sex == 1 ? '男' : '未填',
                ),
                Divider(height: 0.5, color: Colors.black12),
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.personal_info_page_birthday,
                  subText: _birthday,
                  onPress: !editable
                      ? null
                      : () {
                          DatePicker.showDatePicker(
                            context,
                            currentTime: DateTime.parse(_birthday),
                            showTitleActions: true,
                            minTime: DateTime(1970, 1, 1),
                            locale: LocaleType.zh,
                            maxTime: DateTime.now(),
                            onChanged: (date) {
                              _birthday = DateFormat('yyyy-MM-dd').format(date);

                              setState(() {});
                            },
                            onConfirm: (date) {
                              _birthday = DateFormat('yyyy-MM-dd').format(date);

                              setState(() {});
                            },
                          );
                        },
                ),
                Divider(height: 0.5, color: Colors.black12),
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.personal_info_page_address,
                  subText: _address,
                  onPress: !editable
                      ? null
                      : () {
                          showDialog<String>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              _addressController.text = _address;
                              return new AlertDialog(
                                title: new Text('地址'),
                                content: new SingleChildScrollView(
                                  child: TextField(
                                    controller: _addressController,
                                  ),
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text('确定'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(_addressController.text);
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((val) {
                            var match = val.length <= 200;
                            if (match) {
                              _address = val;
                              setState(() {});
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('提示'),
                                        content: Text('住址长度不能超过200'),
                                      ));
                            }
                          });
                        },
                ),
                Divider(height: 0.5, color: Colors.black12),
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.personal_info_page_email,
                  subText: _email,
                  onPress: !editable
                      ? null
                      : () {
                          showDialog<String>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              _emailController.text = _email;
                              return new AlertDialog(
                                title: new Text('邮箱'),
                                content: new SingleChildScrollView(
                                  child: TextField(
                                    controller: _emailController,
                                  ),
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text('确定'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(_emailController.text);
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((val) {
                            var match = RegExp('.+?@.+?\..+').hasMatch(val);
                            if (match) {
                              _email = val;
                              setState(() {});
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('提示'),
                                        content: Text(
                                            '邮箱地址错误，正确格式示例：wangxiao@163.com'),
                                      ));
                            }
                          });
                        },
                ),
              ],
            ),
          ]),
        ));
    // : _buildCroppingImage();
  }

  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  toast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  Future _doSave(String _realName, String _oldUserName, String _address,
      String _email, String _birthday, Object _sex) async {
    AppState state = _getStore()?.state;
    if (editable) {
      var setUserInfo = await CCUserInfoDao.setUserInfo(
          state.userInfo.data.userId.toString(),
          realName: _realName == _oldUserName ? null : _realName,
          address: _address,
          email: _email,
          birthday: _birthday,
          sex: _sex);
      var model = setUserInfo?.model as BaseModel;
      if (setUserInfo.result && model != null && model.code == 1) {
        editable = !editable;
        _updateLocalUserInfo(
            email: _email,
            realName: _realName,
            sex: _sex,
            address: _address,
            birthday: _birthday);
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: model?.msg ?? '保存失败');
      }
    } else {
      editable = !editable;

      setState(() {});
    }
  }

  Future _selectedImage() async {
    _sample = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
    AvatarUploadDao.upload('8523464', '3', _sample);
  }

  Widget _buildOpenImage() {
    return FlatButton(
      child: Text(
        'Open Image',
        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
      ),
      onPressed: () => _openImage(),
    );
  }

  Future<void> _openImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    final sample = await _cropImage(file);

    var store = StoreProvider.of<AppState>(context);
    var userInfo = store.state.userInfo;
    var uploadResult = await AvatarUploadDao.upload(
        userInfo.data.userId.toString(), /*type_student*/ '3', file);
    var model = uploadResult.model as UploadAvatarModel;
    if (uploadResult.result && model != null && model.result == 1) {
      Fluttertoast.showToast(msg: '头像保存成功');
      userInfo.data.userPhoto = model.data?.userPhoto;
      StoreProvider.of<AppState>(context).dispatch(UpdateUserAction(userInfo));
    } else {
      _lastCropped = null;
      setState(() {});
      Fluttertoast.showToast(msg: model.msg);

      setState(() {
        _sample = sample;
        _file = file;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxWidth: 512,
      maxHeight: 512,
    );
    return croppedFile;
  }

  void _updateLocalUserInfo(
      {String email,
      String realName,
      num sex,
      String address,
      String birthday}) {
    var store = StoreProvider.of<AppState>(context);
    var userInfo = store.state.userInfo;
    userInfo.data.email = email;
    userInfo.data.realName = realName;
    userInfo.data.sex = sex;
    userInfo.data.address = address;
    userInfo.data.birthday = birthday;
    StoreProvider.of<AppState>(context).dispatch(UpdateUserAction(userInfo));
  }
}

enum Sex { MALE, FEMALE, UNKNOW }

getSexValue(Sex sex) {
  switch (sex) {
    case Sex.MALE:
      return 1;
    case Sex.FEMALE:
      return 2;
    default:
      return -1;
  }
}
