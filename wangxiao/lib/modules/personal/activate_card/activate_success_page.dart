import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:online_school/event/CardActivated.dart';
import 'package:online_school/common/network/error_code.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/modules/enterence/navigation_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

///
/// @name ActivateSuccessPage
/// @description 激活卡成功
/// @author liuca
/// @date 2020-01-11
///
class ActivateSuccessPage extends StatefulWidget {
  bool waitAudit;

  ActivateSuccessPage({this.waitAudit = false});

  @override
  _ActivateSuccessPageState createState() => _ActivateSuccessPageState();
}

class _ActivateSuccessPageState extends State<ActivateSuccessPage>
    with SingleTickerProviderStateMixin {
  LottieComposition _composition;
  AnimationController _controller;

  // 初始化
  @override
  void initState() {
    super.initState();

    _loadButtonPressed('assets/bind_success.json');
    _controller = new AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // _controller.addListener(() => setState(() {}));
  }

  void _loadButtonPressed(String assetName) {
    loadAsset(assetName).then((LottieComposition composition) {
      setState(() {
        _composition = composition;
        _controller.forward();
      });
    });
  }

  buildContent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Lottie(
            composition: _composition,
            width: 200,
            height: 200,
            controller: _controller,
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Wrap(
              children: <Widget>[
                Text(
                    widget.waitAudit
                        ? '说明：\n1.首次激活课程卡时系统需要认证您的学员信息\n2.您可以联系您所在地区的分校老师，让其帮您尽快审核信息，审核后您就可以使用网校APP学习了'
                        : '课程申请成功！',
                    style: textStyleNormal666)
              ],
            ),
          ),
          const SizedBox(height: 100),
          _buildButton(),
        ]);
  }

  Container _buildButton() {
    return Container(
      height: 36.0,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Color(0x59FF8156),
            blurRadius: 11.0, // has the effect of softening the shadow
            spreadRadius: 0.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              6.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: MaterialButton(
          child: Text('开始学习', style: textStyleBtnWhite),
          color: Color(0xFFFF8156),
          minWidth: 158,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          onPressed: () {
            _getStore().state.userInfo.data.stateType = 1;
            debugLog('@@@@@@@@@@@--->CODE FIRE');
            ErrorCode.eventBus.fire(CardActivatedEvent());
            NavigatorRoute.backHome(context);
          }),
    );
  }

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('激活成功'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        alignment: Alignment.center,
        child: buildContent(),
      ),
    );
  }

  Future<LottieComposition> loadAsset(String assetName) async {
    var assetData = await rootBundle.load(assetName);
    return await LottieComposition.fromByteData(assetData);
  }

}
