import 'dart:io';
import 'package:online_school/common/dao/manager/dao_manager.dart';
import 'package:online_school/common/loading/loading_manager.dart';
import 'package:online_school/common/logger/logger_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/model/new/review_status_model.dart';
import 'package:online_school/model/new/submit_review_info_model.dart';
import 'package:online_school/model/upload_file_model.dart';
import 'package:online_school/modules/widgets/list_type_loading_placehold_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

///
/// @name AssistanceVerifyPage
/// @description 助学活动审核页面
/// @author liuca
/// @date 2020-02-24
///
class AssistanceVerifyPage extends StatefulWidget {
  //AssistanceVerifyPage();
  @override
  State<StatefulWidget> createState() {
    return _AssistanceVerifyState();
  }
}

class _AssistanceVerifyState extends State {

  ReviewStatusModel reviewStatusModel;

  AsyncMemoizer _memoizer = AsyncMemoizer();

  /// 输入控制器
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();

  /// 焦点处理
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _schoolFocusNode = FocusNode();

  /// 删除图标
  bool showNameDelete = false; ///删除是否可见
  bool showCityDelete = false; ///删除是否可见
  bool showSchoolDelete = false; ///删除是否可见

  int isNewUser; ///是否免费用户 也就是是否新用户 新用户才能提交审核信息
  int stateId; ///新用户提交的审核信息 审核状态 0中 1过 -1未过

  /// 学科Id
  int gradeId = 6;

  /// 是否正在加载审核状态
  bool isLoadingReviewStatus = false;

  File selectedImage;

  @override
  void initState() {
    _nameFocusNode.addListener(() {
      LoggerManager.info("_userFocusNode.hasFocus: ${_nameFocusNode.hasFocus}");
      if (!_nameFocusNode.hasFocus) {
        showNameDelete = false;
      } else {
        if (_nameController.text.length > 0) {
          showNameDelete = true;
        }
      }
      setState(() {});
    });

    _cityFocusNode.addListener(() {
      LoggerManager.info("_cityFocusNode.hasFocus: ${_cityFocusNode.hasFocus}");
      if (!_cityFocusNode.hasFocus) {
        showCityDelete = false;
      } else {
        if (_cityController.text.length > 0) {
          showCityDelete = true;
        }
      }
      setState(() {});
    });

    _schoolFocusNode.addListener(() {
      LoggerManager.info("_schoolFocusNode.hasFocus: ${_schoolFocusNode.hasFocus}");
      if (!_schoolFocusNode.hasFocus) {
        showSchoolDelete = false;
      } else {
        if (_schoolController.text.length > 0) {
          showSchoolDelete = true;
        }
      }
      setState(() {});
    });

    loadReviewStatus();

    super.initState();
  }

  ///
  /// @name loadReviewStatus
  /// @description 加载审核状态信息
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-25
  ///
  loadReviewStatus() async {
    ResponseData responseData = await DaoManager.fetchReviewStatusInfo({"":""});
    var model = responseData.model as ReviewStatusModel;
    reviewStatusModel = model;

    if (reviewStatusModel.code == 1 && reviewStatusModel != null) {
      /// 是否是新用户
      if (reviewStatusModel.data.stateId == 1) {
        Fluttertoast.showToast(msg: "该活动仅限新用户参加，您已经是老用户啦，继续学习吧^_^！");
        Future.delayed(Duration(seconds: 2),(){
          Navigator.pop(context);
        });
      }

      if (reviewStatusModel.data.infos != null) {
        /// 审核状态
        stateId = reviewStatusModel.data.infos.stateId;
      }
      isLoadingReviewStatus = false;
      setState(() {

      });
    }

  }

  @override
  void dispose() {

    /// 释放焦点
    if (_nameFocusNode != null) {
      _nameFocusNode.dispose();
    }
    if (_cityFocusNode != null) {
      _cityFocusNode.dispose();
    }
    if (_schoolFocusNode != null) {
      _schoolFocusNode.dispose();
    }

    if(selectedImage != null) {
      selectedImage = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  ///
  /// @name _buildSubmit
  /// @description 审核未提交状态,需要输入
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-24
  ///
  Widget _buildContent() {
    if (isLoadingReviewStatus) {
      return Scaffold(
        appBar: AppBar(
          title: Text("助学活动"),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Center(
            child: LoadingListWidget(),
          ),
        ),
      );
    } else {
      String imageString;
      if (reviewStatusModel != null
          && reviewStatusModel.data != null) {
        if (reviewStatusModel.data.infos == null) {
          imageString = "static/images/assistance_submit_bg.png";
        } else if (reviewStatusModel.data.infos.stateId == 0){
          imageString = "static/images/assistance_review_bg.png";
        } else if (reviewStatusModel.data.infos.stateId == 1){
          imageString = "static/images/assistance_review_bg.png";
        } else {
          imageString = "static/images/assistance_submit_bg.png";
        }
      } else {
        ///调试用的
        imageString = "static/images/assistance_submit_bg.png";
      }

      if (reviewStatusModel != null) {
        /// 如果是免费用户
        if (reviewStatusModel != null && reviewStatusModel.data != null) {
          /// 判断免费用户的审核状态
          /// 免费用户没有提交过审核信息
          if (reviewStatusModel.data.infos == null) {

            LoggerManager.info("免费用户 填写审核信息");
            return GestureDetector(
              child: Scaffold(
                body: Container(
                  color: Color(0xffEDE6FF),
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              height: 330,
                              width: double.infinity,
                              child: Image.asset(
                                "static/images/a_submit_bg.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                const SizedBox(height: 310),

                                Padding(
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15,right: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          /// 姓名
                                          Padding(padding: EdgeInsets.only(top: 16)),
                                          Text("姓名",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                          Padding(padding: EdgeInsets.only(top: 7)),
                                          Container(
                                            width: MediaQuery.of(context).size.width - 50,
                                            height: 48,
                                            color: Color(0xffF3F3F5),
                                            child: TextField(
                                              focusNode: _nameFocusNode,
                                              controller: _nameController,
                                              cursorWidth: 1,
                                              cursorColor: Color(MyColors.primaryLightValue),
                                              inputFormatters: [LengthLimitingTextInputFormatter(100)],
                                              textInputAction: TextInputAction.next,
                                              onSubmitted: (_) {
                                                _cityFocusNode.requestFocus();
                                              },
                                              onChanged: (text){
                                                if (text.length >0) {
                                                  showNameDelete = true;
                                                } else {
                                                  showNameDelete = false;
                                                }

                                                setState(() {

                                                });
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                contentPadding: EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(MyColors.primaryLightValue), width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                                // contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                                                hintStyle: _nameFocusNode.hasFocus ? textStyleHint : textStyleNormal,
                                                suffixIcon: !showNameDelete ? Container(width: 1,height: 1,) : GestureDetector(
                                                  child: Icon(Icons.close,size: 20,color: Color(0xff7494EC),),
                                                  onTap: (){
                                                    if (_nameController.text.length > 0){
                                                      _nameController.text = "";
                                                      showNameDelete = false;
                                                      setState(() {

                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),

                                          /// 年级
                                          Padding(padding: EdgeInsets.only(top: 13)),
                                          Text("年级",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),

                                          Padding(padding: EdgeInsets.only(top: 7)),
                                          Container(
                                            width: MediaQuery.of(context).size.width - 50,
                                            height: 48,
                                            color: Color(0xffF3F3F5),
                                            child: Row(
                                              children: <Widget>[
                                                Padding(padding: EdgeInsets.only(left: 20)),
                                                SizedBox(width: MediaQuery.of(context).size.width - 50 - 30 - 20,
                                                  child: DropdownButton(
                                                    icon: Icon(Icons.arrow_drop_down,color: Color(0xffF3F3F5),),
                                                    iconSize: 26,
                                                    hint: Text(
                                                      gradeTitleDic[gradeId],
                                                      style: TextStyle(fontSize: 20),
                                                    ),
                                                    underline: Container(),
                                                    items: _getListData(),
                                                    value: gradeId,
                                                    onChanged: (currentGradeId) {
                                                      gradeId = currentGradeId;
                                                      setState(() {

                                                      });
                                                    },
                                                  ),
                                                ),
                                                Icon(Icons.keyboard_arrow_down,size: 30,color: Color(0xffC0C5D0),)
                                              ],
                                            ),
                                          ),

                                          /// 城市
                                          Padding(padding: EdgeInsets.only(top: 13)),
                                          Text("城市",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                          Padding(padding: EdgeInsets.only(top: 7)),
                                          Container(
                                            width: MediaQuery.of(context).size.width - 50,
                                            height: 48,
                                            color: Color(0xffF3F3F5),
                                            child: TextField(
                                              focusNode: _cityFocusNode,
                                              controller: _cityController,
                                              cursorWidth: 1,
                                              cursorColor: Color(MyColors.primaryLightValue),
                                              inputFormatters: [LengthLimitingTextInputFormatter(100)],
                                              textInputAction: TextInputAction.next,
                                              onSubmitted: (_) {
                                                _schoolFocusNode.requestFocus();
                                              },
                                              onChanged: (text){
                                                if (text.length >0) {
                                                  showCityDelete = true;
                                                } else {
                                                  showCityDelete = false;
                                                }

                                                setState(() {

                                                });
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                contentPadding: EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(MyColors.primaryLightValue), width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                                hintStyle: _cityFocusNode.hasFocus ? textStyleHint : textStyleNormal,
                                                suffixIcon: !showCityDelete ? Container(width: 1,height: 1,) : GestureDetector(
                                                  child: Icon(Icons.close,size: 20,color: Color(0xff7494EC),),
                                                  onTap: (){
                                                    if (_cityController.text.length > 0){
                                                      _cityController.text = "";
                                                      showCityDelete = false;
                                                      setState(() {

                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),

                                          /// 学校
                                          Padding(padding: EdgeInsets.only(top: 13)),
                                          Text("学校",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                          Padding(padding: EdgeInsets.only(top: 7)),
                                          Container(
                                            width: MediaQuery.of(context).size.width - 50,
                                            height: 48,
                                            color: Color(0xffF3F3F5),
                                            child: TextField(
                                              focusNode: _schoolFocusNode,
                                              controller: _schoolController,
                                              cursorWidth: 1,
                                              cursorColor: Color(MyColors.primaryLightValue),
                                              inputFormatters: [LengthLimitingTextInputFormatter(100)],
                                              textInputAction: TextInputAction.next,
                                              onSubmitted: (_) {

                                              },
                                              onChanged: (text){
                                                if (text.length >0) {
                                                  showSchoolDelete = true;
                                                } else {
                                                  showSchoolDelete = false;
                                                }

                                                setState(() {

                                                });
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                contentPadding: EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(MyColors.primaryLightValue), width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                                // contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                                                hintStyle: _schoolFocusNode.hasFocus ? textStyleHint : textStyleNormal,
                                                suffixIcon: !showSchoolDelete ? Container(width: 1,height: 1,) : GestureDetector(
                                                  child: Icon(Icons.close,size: 20,color: Color(0xff7494EC),),
                                                  onTap: (){
                                                    if (_schoolController.text.length > 0){
                                                      _schoolController.text = "";
                                                      showSchoolDelete = false;
                                                      setState(() {

                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),

                                          /// 学生证
                                          Padding(padding: EdgeInsets.only(top: 13)),
                                          Text("学生证",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                          Padding(padding: EdgeInsets.only(top: 4)),
                                          GestureDetector(
                                            child: selectedImage == null ? Image.asset("static/images/a_add_image.png",height: 125,width: MediaQuery.of(context).size.width - 50,fit: BoxFit.fill,) : Image.file(selectedImage),
                                            onTap: () async {
                                              await showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    return Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(Icons.camera_alt,size: 70,color: Colors.white,),
                                                              Text("相机",style: TextStyle(fontSize: 12,color: Colors.white,decoration: TextDecoration.none),)
                                                            ],
                                                          ),
                                                          onTap: ()async {
                                                            Navigator.pop(context);
                                                            var image = await ImagePicker.pickImage(source: ImageSource.camera);
                                                            if (image != null) {
                                                              selectedImage = image;
                                                              setState(() {

                                                              });
                                                            }
                                                          },
                                                        ),
                                                        Padding(padding: EdgeInsets.only(left: 30)),
                                                        GestureDetector(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(Icons.insert_photo,size: 70,color: Colors.white,),
                                                              Text("相册",style: TextStyle(fontSize: 12,color: Colors.white,decoration: TextDecoration.none),)
                                                            ],
                                                          ),
                                                          onTap: ()async {
                                                            Navigator.pop(context);
                                                            var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                                            if (image != null) {
                                                              selectedImage = image;
                                                              setState(() {

                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),

                                          Padding(padding: EdgeInsets.only(top: 15)),
                                          Text(reviewStatusModel.data.mobile == null ? "您当前账号注册的手机号为：未绑定" + "，如需修改手机号，请联系客服。" : "您当前账号注册的手机号为：" + reviewStatusModel.data.mobile + "，如需修改手机号，请联系客服。", style: TextStyle(color: Color(0xff222222), fontSize: 14),),
                                          Padding(padding: EdgeInsets.only(top: 15)),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width - 50,
                                            height: 48,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(colors: [Color(0xff883FFF), Color(0xff5E21E3)]),// 渐变色
                                                  borderRadius: BorderRadius.circular(6)
                                              ),
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(3)
                                                ),
                                                color: Colors.transparent, // 设为透明色
                                                elevation: 0, // 正常时阴影隐藏
                                                highlightElevation: 0, // 点击时阴影隐藏
                                                onPressed: submitAction,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 48,
                                                  child: Text("提交审核", style: TextStyle(color: Colors.white, fontSize: 15),),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 48)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),

                        Padding(padding: EdgeInsets.only(left: 16,top: 20,),
                          child: Container(
                            child: Text("*本次活动最终解释权归北京四中网校",style: TextStyle(fontSize: 12,color: Color(0xff873FFF)),),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 48)),
                      ],
                    ),
                  ),
                ),),
              onTap: (){
                LoggerManager.info("点击空白处");

                /// 取消焦点
                _nameFocusNode.unfocus();
                _cityFocusNode.unfocus();
                _schoolFocusNode.unfocus();
                setState(() {

                });
              },
            );
          } else {
            /// 审核中
            if (reviewStatusModel.data.infos.stateId == 0){
              return GestureDetector(
                child: Scaffold(
                  body: Container(
                    color: Color(0xffEDE6FF),
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Container(
                                height: 260,
                                width: double.infinity,
                                child: Image.asset(
                                  "static/images/a_review_bg.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  const SizedBox(height: 220),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15,right: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            /// 信息已提交
                                            Padding(padding: EdgeInsets.only(top: 20)),
                                            Text("信息已提交，尚在审核，请耐心等待",style: TextStyle(fontSize: 19,color: Color(0xffFC6F83)),),
                                            Padding(padding: EdgeInsets.only(top: 27)),
                                            /// 姓名
                                            Row(
                                              children: <Widget>[
                                                Text("姓名",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  child: Text(reviewStatusModel.data.infos.realName,style: TextStyle(fontSize: 15,color: Color(0xff222222)),maxLines: 7,overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),

                                            Padding(padding: EdgeInsets.only(top: 23)),
                                            /// 年级
                                            Row(
                                              children: <Widget>[
                                                Text("年级",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Text(gradeTitleDic[reviewStatusModel.data.infos.gradeId],style: TextStyle(fontSize: 15,color: Color(0xff222222)),),
                                              ],
                                            ),

                                            Padding(padding: EdgeInsets.only(top: 27)),
                                            /// 城市
                                            Row(
                                              children: <Widget>[
                                                Text("城市",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  child: Text(reviewStatusModel.data.infos.cityName,style: TextStyle(fontSize: 15,color: Color(0xff222222)),maxLines: 7,overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),

                                            Padding(padding: EdgeInsets.only(top: 27)),
                                            /// 学校
                                            Row(
                                              children: <Widget>[
                                                Text("学校",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  child: Text(reviewStatusModel.data.infos.schoolName,style: TextStyle(fontSize: 15,color: Color(0xff222222)),maxLines: 7,overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),

                                            /// 学生证
                                            Padding(padding: EdgeInsets.only(top: 13)),
                                            Row(
                                              children: <Widget>[
                                                Text("学生证",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 4)),
                                            Image.network(reviewStatusModel.data.infos.imgUrl,height: 125,width: MediaQuery.of(context).size.width - 50,fit: BoxFit.fill,),

                                            Padding(padding: EdgeInsets.only(top: 15)),
                                            Text("您当前账号注册的手机号为：" + reviewStatusModel.data.mobile == null ? "未绑定" + "，如需修改手机号，请联系客服。" : reviewStatusModel.data.mobile + "，如需修改手机号，请联系客服。", style: TextStyle(color: Color(0xff222222), fontSize: 14),),
                                            Padding(padding: EdgeInsets.only(top: 15)),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 50,
                                              height: 48,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(colors: [Color(0xff883FFF), Color(0xff5E21E3)]),// 渐变色
                                                    borderRadius: BorderRadius.circular(6)
                                                ),
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(3)
                                                  ),
                                                  color: Colors.transparent, // 设为透明色
                                                  elevation: 0, // 正常时阴影隐藏
                                                  highlightElevation: 0, // 点击时阴影隐藏
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 48,
                                                    child: Text("关闭此页面", style: TextStyle(color: Colors.white, fontSize: 15),),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 48)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Padding(padding: EdgeInsets.only(left: 16,top: 20,),
                            child: Container(
                              child: Text("*本次活动最终解释权归北京四中网校",style: TextStyle(fontSize: 12,color: Color(0xff873FFF)),),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 48)),
                        ],
                      ),
                    ),
                  ),),
                onTap: (){
                  LoggerManager.info("点击空白处");
                },
              );
            }
            /// 审核通过
            else if (reviewStatusModel.data.infos.stateId == 1){
              return GestureDetector(
                child: Scaffold(
                  body: Container(
                    color: Color(0xffEDE6FF),
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Container(
                                height: 260,
                                width: double.infinity,
                                child: Image.asset(
                                  "static/images/a_review_bg.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  const SizedBox(height: 220),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15,right: 15),
                                        child: Column(
                                          children: <Widget>[
                                            /// 信息已提交
                                            Padding(padding: EdgeInsets.only(top: 28)),
                                            Image.asset("static/images/a_review_success.png",width: 40,height: 40,),
                                            Padding(padding: EdgeInsets.only(top: 20)),
                                            Text("恭喜，通过审核，快去看看课程吧！",style: TextStyle(fontSize: 19,color: Color(0xff1FC9AE)),),
                                            Padding(padding: EdgeInsets.only(top: 27)),
                                            /// 姓名
                                            Row(
                                              children: <Widget>[
                                                Text("姓名",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  child: Text(reviewStatusModel.data.infos.realName,style: TextStyle(fontSize: 15,color: Color(0xff222222)),maxLines: 7,overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),

                                            Padding(padding: EdgeInsets.only(top: 23)),
                                            /// 年级
                                            Row(
                                              children: <Widget>[
                                                Text("年级",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Text(gradeTitleDic[reviewStatusModel.data.infos.gradeId],style: TextStyle(fontSize: 15,color: Color(0xff222222)),),
                                              ],
                                            ),

                                            Padding(padding: EdgeInsets.only(top: 27)),
                                            /// 城市
                                            Row(
                                              children: <Widget>[
                                                Text("城市",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  child: Text(reviewStatusModel.data.infos.cityName,style: TextStyle(fontSize: 15,color: Color(0xff222222)),maxLines: 7,overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),

                                            Padding(padding: EdgeInsets.only(top: 27)),
                                            /// 学校
                                            Row(
                                              children: <Widget>[
                                                Text("学校",style: TextStyle(fontSize: 15,color: Color(0xff888888)),),
                                                Padding(padding: EdgeInsets.only(left: 8)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  child: Text(reviewStatusModel.data.infos.schoolName,style: TextStyle(fontSize: 15,color: Color(0xff222222)),maxLines: 7,overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),

                                            /// 学生证
                                            Padding(padding: EdgeInsets.only(top: 13)),
                                            Row(
                                              children: <Widget>[
                                                Text("学生证",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 4)),
                                            Image.network(reviewStatusModel.data.infos.imgUrl,height: 125,width: MediaQuery.of(context).size.width - 50,fit: BoxFit.fill,),

                                            Padding(padding: EdgeInsets.only(top: 15)),
                                            Text(reviewStatusModel.data.mobile == null ? "您当前账号注册的手机号为：未绑定" + "，如需修改手机号，请联系客服。" : "您当前账号注册的手机号为：" + reviewStatusModel.data.mobile + "，如需修改手机号，请联系客服。", style: TextStyle(color: Color(0xff222222), fontSize: 14),),
                                            Padding(padding: EdgeInsets.only(top: 15)),

                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 50,
                                              height: 48,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(colors: [Color(0xff883FFF), Color(0xff5E21E3)]),// 渐变色
                                                    borderRadius: BorderRadius.circular(6)
                                                ),
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(3)
                                                  ),
                                                  color: Colors.transparent, // 设为透明色
                                                  elevation: 0, // 正常时阴影隐藏
                                                  highlightElevation: 0, // 点击时阴影隐藏
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 48,
                                                    child: Text("关闭此页面", style: TextStyle(color: Colors.white, fontSize: 15),),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 48)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Padding(padding: EdgeInsets.only(left: 16,top: 20,),
                            child: Container(
                              child: Text("*本次活动最终解释权归北京四中网校",style: TextStyle(fontSize: 12,color: Color(0xff873FFF)),),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 48)),
                        ],
                      ),
                    ),
                  ),),
                onTap: (){
                  LoggerManager.info("点击空白处");

                  /// 取消焦点
                  _nameFocusNode.unfocus();
                  _cityFocusNode.unfocus();
                  _schoolFocusNode.unfocus();
                  setState(() {

                  });
                },
              );
            }
            /// 审核未通过 重新提交审核
            else {
              return GestureDetector(
                child: Scaffold(
                  body: Container(
                    color: Color(0xffEDE6FF),
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Container(
                                height: 330,
                                width: double.infinity,
                                child: Image.asset(
                                  "static/images/a_submit_bg.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  const SizedBox(height: 310),

                                  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15,right: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            /// 姓名
                                            Padding(padding: EdgeInsets.only(top: 16)),
                                            Text("姓名",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                            Padding(padding: EdgeInsets.only(top: 7)),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 50,
                                              height: 48,
                                              color: Color(0xffF3F3F5),
                                              child: TextField(
                                                focusNode: _nameFocusNode,
                                                controller: _nameController,
                                                cursorWidth: 1,
                                                cursorColor: Color(MyColors.primaryLightValue),
                                                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                                                textInputAction: TextInputAction.next,
                                                onSubmitted: (_) {
                                                  _cityFocusNode.requestFocus();
                                                },
                                                onChanged: (text){
                                                  if (text.length >0) {
                                                    showNameDelete = true;
                                                  } else {
                                                    showNameDelete = false;
                                                  }

                                                  setState(() {

                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                                  contentPadding: EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(MyColors.primaryLightValue), width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  // contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                                                  hintStyle: _nameFocusNode.hasFocus ? textStyleHint : textStyleNormal,
                                                  suffixIcon: !showNameDelete ? Container(width: 1,height: 1,) : GestureDetector(
                                                    child: Icon(Icons.close,size: 20,color: Color(0xff7494EC),),
                                                    onTap: (){
                                                      if (_nameController.text.length > 0){
                                                        _nameController.text = "";
                                                        showNameDelete = false;
                                                        setState(() {

                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),

                                            /// 年级
                                            Padding(padding: EdgeInsets.only(top: 13)),
                                            Text("年级",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),

                                            Padding(padding: EdgeInsets.only(top: 7)),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 50,
                                              height: 48,
                                              color: Color(0xffF3F3F5),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(padding: EdgeInsets.only(left: 20)),
                                                  SizedBox(width: MediaQuery.of(context).size.width - 50 - 30 - 20,
                                                    child: DropdownButton(
                                                      icon: Icon(Icons.arrow_drop_down,color: Color(0xffF3F3F5),),
                                                      iconSize: 26,
                                                      hint: Text(
                                                        gradeTitleDic[gradeId],
                                                        style: TextStyle(fontSize: 20),
                                                      ),
                                                      underline: Container(),
                                                      items: _getListData(),
                                                      value: gradeId,
                                                      onChanged: (currentGradeId) {
                                                        gradeId = currentGradeId;
                                                        setState(() {

                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Icon(Icons.keyboard_arrow_down,size: 30,color: Color(0xffC0C5D0),)
                                                ],
                                              ),
                                            ),

                                            /// 城市
                                            Padding(padding: EdgeInsets.only(top: 13)),
                                            Text("城市",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                            Padding(padding: EdgeInsets.only(top: 7)),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 50,
                                              height: 48,
                                              color: Color(0xffF3F3F5),
                                              child: TextField(
                                                focusNode: _cityFocusNode,
                                                controller: _cityController,
                                                cursorWidth: 1,
                                                cursorColor: Color(MyColors.primaryLightValue),
                                                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                                                textInputAction: TextInputAction.next,
                                                onSubmitted: (_) {
                                                  _schoolFocusNode.requestFocus();
                                                },
                                                onChanged: (text){
                                                  if (text.length >0) {
                                                    showCityDelete = true;
                                                  } else {
                                                    showCityDelete = false;
                                                  }

                                                  setState(() {

                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                                  contentPadding: EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(MyColors.primaryLightValue), width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  hintStyle: _cityFocusNode.hasFocus ? textStyleHint : textStyleNormal,
                                                  suffixIcon: !showCityDelete ? Container(width: 1,height: 1,) : GestureDetector(
                                                    child: Icon(Icons.close,size: 20,color: Color(0xff7494EC),),
                                                    onTap: (){
                                                      if (_cityController.text.length > 0){
                                                        _cityController.text = "";
                                                        showCityDelete = false;
                                                        setState(() {

                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),

                                            /// 学校
                                            Padding(padding: EdgeInsets.only(top: 13)),
                                            Text("学校",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                            Padding(padding: EdgeInsets.only(top: 7)),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 50,
                                              height: 48,
                                              color: Color(0xffF3F3F5),
                                              child: TextField(
                                                focusNode: _schoolFocusNode,
                                                controller: _schoolController,
                                                cursorWidth: 1,
                                                cursorColor: Color(MyColors.primaryLightValue),
                                                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                                                textInputAction: TextInputAction.next,
                                                onSubmitted: (_) {

                                                },
                                                onChanged: (text){
                                                  if (text.length >0) {
                                                    showSchoolDelete = true;
                                                  } else {
                                                    showSchoolDelete = false;
                                                  }

                                                  setState(() {

                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                                  contentPadding: EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(MyColors.primaryLightValue), width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  // contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                                                  hintStyle: _schoolFocusNode.hasFocus ? textStyleHint : textStyleNormal,
                                                  suffixIcon: !showSchoolDelete ? Container(width: 1,height: 1,) : GestureDetector(
                                                    child: Icon(Icons.close,size: 20,color: Color(0xff7494EC),),
                                                    onTap: (){
                                                      if (_schoolController.text.length > 0){
                                                        _schoolController.text = "";
                                                        showSchoolDelete = false;
                                                        setState(() {

                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),

                                            /// 学生证
                                            Padding(padding: EdgeInsets.only(top: 13)),
                                            Text("学生证",style: TextStyle(fontSize: 17,color: Color(0xff888888)),),
                                            Padding(padding: EdgeInsets.only(top: 4)),
                                            GestureDetector(
                                              child: selectedImage == null ? Image.asset("static/images/a_add_image.png",height: 125,width: MediaQuery.of(context).size.width - 50,fit: BoxFit.fill,) : Image.file(selectedImage),
                                              onTap: () async {
                                                await showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (context) {
                                                      return Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Icon(Icons.camera_alt,size: 70,color: Colors.white,),
                                                                Text("相机",style: TextStyle(fontSize: 12,color: Colors.white,decoration: TextDecoration.none),)
                                                              ],
                                                            ),
                                                            onTap: ()async {
                                                              Navigator.pop(context);
                                                              var image = await ImagePicker.pickImage(source: ImageSource.camera);
                                                              if (image != null) {
                                                                selectedImage = image;
                                                                setState(() {

                                                                });
                                                              }
                                                            },
                                                          ),
                                                          Padding(padding: EdgeInsets.only(left: 30)),
                                                          GestureDetector(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Icon(Icons.insert_photo,size: 70,color: Colors.white,),
                                                                Text("相册",style: TextStyle(fontSize: 12,color: Colors.white,decoration: TextDecoration.none),)
                                                              ],
                                                            ),
                                                            onTap: ()async {
                                                              Navigator.pop(context);
                                                              var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                                              if (image != null) {
                                                                selectedImage = image;
                                                                setState(() {

                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                            ),

                                            Padding(padding: EdgeInsets.only(top: 15)),
                                            Text(reviewStatusModel.data.mobile == null ? "您当前账号注册的手机号为：未绑定" + "，如需修改手机号，请联系客服。" : "您当前账号注册的手机号为：" + reviewStatusModel.data.mobile + "，如需修改手机号，请联系客服。", style: TextStyle(color: Color(0xff222222), fontSize: 14),),
                                            Padding(padding: EdgeInsets.only(top: 15)),
                                            Row(
                                              children: <Widget>[
                                                Text("您上次提交的信息未通过审核，请重新提交",style: TextStyle(fontSize: 14,color: Color(0xff222222)),),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 15)),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 50,
                                              height: 48,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(colors: [Color(0xff883FFF), Color(0xff5E21E3)]),// 渐变色
                                                    borderRadius: BorderRadius.circular(6)
                                                ),
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(3)
                                                  ),
                                                  color: Colors.transparent, // 设为透明色
                                                  elevation: 0, // 正常时阴影隐藏
                                                  highlightElevation: 0, // 点击时阴影隐藏
                                                  onPressed: submitAction,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 48,
                                                    child: Text("提交审核", style: TextStyle(color: Colors.white, fontSize: 15),),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 48)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),

                          Padding(padding: EdgeInsets.only(left: 16,top: 20,),
                            child: Container(
                              child: Text("*本次活动最终解释权归北京四中网校",style: TextStyle(fontSize: 12,color: Color(0xff873FFF)),),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 48)),
                        ],
                      ),
                    ),
                  ),),
                onTap: (){
                  LoggerManager.info("点击空白处");

                  /// 取消焦点
                  _nameFocusNode.unfocus();
                  _cityFocusNode.unfocus();
                  _schoolFocusNode.unfocus();
                  setState(() {

                  });
                },
              );
            }

          }
        } else {
          return _buildWidget();
        }
      } else {

        LoggerManager.info(imageString);
        /// 调试入口 最终显示的是没有数据占位
        return _buildNoDataWidget();
      }
    }

  }

  ///
  /// @name submitAction
  /// @description 提交审核事件回调
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-25
  ///
  submitAction() async{
    
    String nameString = _nameController.text.replaceAll(" ", "");
    String cityString = _cityController.text.replaceAll(" ", "");
    String schoolString = _schoolController.text.replaceAll(" ", "");

    _nameController.text = nameString;
    _cityController.text = cityString;
    _schoolController.text = schoolString;
    
    if (_nameController.text.length == 0
        || _cityController.text.length == 0
        || _schoolController.text.length == 0
        || selectedImage == null) {
      Fluttertoast.showToast(msg: "请检查信息是否完整，页面上的所有信息均为必填，请填写完整后提交。");
      return;
    }

    /// 1.上传图片
    /// 2.提交审核信息
    /// 3.刷新数据源 这里需要判断是首次提交还是审核未通过重新提交
//    if (reviewStatusModel.data.infos == null) {
//      /// 首次提交 创建一个infos
//
//    } else {
//      /// 更新infos
//
//    }
    /// 1.
    /// 显示加载圈
    LoadingManager.showLoading(context,message: "提交中...");
    ResponseData responseData = await DaoManager.fetchUploadImage(selectedImage.path);
    UploadFileModel uploadFileModel = responseData.model as UploadFileModel;
    if (uploadFileModel.data == null) {
      LoadingManager.hideLoading(context);
      Fluttertoast.showToast(msg: "图片提交失败,请重试!");
      return;
    }

    /// 2.
    Map<String,dynamic> parameter = {
      "realName":_nameController.text,
      "gradeId":gradeId,
      "cityName":_cityController.text,
      "schoolName":_schoolController.text,
      "imgUrl":uploadFileModel.data.filePath,
      "activityId":1
    };

    ResponseData response = await DaoManager.fetchSubmitReviewInfo(parameter);
    SubmitReviewInfoModel _model = response.model;
    if (_model != null && _model.code > 0) {
      Future.delayed(Duration(seconds: 1),(){
        LoadingManager.hideLoading(context);
        Fluttertoast.showToast(msg: "审核信息已提交!");
        Future.delayed(Duration(seconds: 2),(){
          selectedImage = null;
          Navigator.pop(context);
        });
      });
    } else {
      LoadingManager.hideLoading(context);
      Fluttertoast.showToast(msg: "审核信息提交失败!");
    }


  }


  Widget _buildWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("助学活动"),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: Container(
        color: Color(MyColors.background),
        child: Padding(
          padding: EdgeInsets.only(top: 10,),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Text("无数据"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  ///
  /// @name _buildNoDataWidget
  /// @description 没有数据占位
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-24
  ///
  Widget _buildNoDataWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("助学活动"),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: EmptyPlaceholderPage(
          assetsPath: 'static/images/empty.png', message: '没有数据'),
    );
  }

  ///
  /// @name _fetchMaterialData
  /// @description 获取审核状态
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-24
  ///
  _fetchMaterialData() {
    return _memoizer.runOnce(()=>DaoManager.fetchReviewStatusInfo({"":""}));
  }


  var gradeTitleDic = {
    1: '高三',
    2: '高二',
    3: '高一',
    4: '初三',
    5: '初二',
    6: '初一',
  };

  var gradeIds = [
    6,5,4,3,2,1
  ];

  /// 下拉菜单列表
  List<DropdownMenuItem> _getListData() {
    List<DropdownMenuItem> items = List();
    if (gradeIds.length < 2) {
      return [];
    }

    for (int i = 0; i < gradeIds.length; i++) {
      String gradeName = gradeTitleDic[gradeIds[i]].toString();
      DropdownMenuItem dropdownMenuItem = DropdownMenuItem(
        child: Text(
          gradeName,
          style: TextStyle(fontSize: 20),
        ),
        value: gradeIds[i],
      );

      items.add(dropdownMenuItem);
    }
    return items;
  }

}