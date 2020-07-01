import 'dart:io';
import 'package:online_school/common/dao/original_dao/material_dao.dart';
import 'package:online_school/model/material_list_model.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// @name ChangeMaterialPage
/// @description 切换教材页面
/// @author liuca
/// @date 2020-01-10
///
class ChangeMaterialPage extends StatefulWidget {
  // 1 ai；2 自学
  var type;
  var subjectId;
  var gradeId;
  var materialId;

  ChangeMaterialPage({this.type, this.subjectId, this.gradeId, this.materialId});

  @override
  _ChangeMaterialPageState createState() => _ChangeMaterialPageState();
}

class _ChangeMaterialPageState extends State<ChangeMaterialPage> {
  MaterialListModel data;

  @override
  void initState() {
    Global.init();
    var response =
        MaterialDao.getMaterials(widget.subjectId, widget.gradeId, widget.type);
    response.then((r) {
      data = r.model;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择教材版本'),
        elevation: 1.0,
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: ListView.separated(
            key: GlobalKey(),
            itemBuilder: itemBuilder,
            itemCount: data?.data?.length ?? 0,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 1);
            },
          )),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    var item = data.data[index];

    var view2 = ExpansionTile(
      title: Text(item.versionName, style: textStyleContent333),
      children: item.teachingMaterialDTOList?.map<Widget>((l) {
            bool isSelected = (widget.materialId != null) &&
                (widget.materialId == l.materialId);
            return Container(
              color:
                  isSelected ? Color(MyColors.choosedLine) : Colors.transparent,
              padding: EdgeInsets.only(left: 10),
              child: ListTile(
                  title: Text(l.materialName, style: textStyleSubLarge),
                  selected: isSelected,
                  onTap: () => onChoose(l)),
            );
          })?.toList() ??
          [],
    );

    return view2;
  }

  onChoose(TeachingMaterialDTOListEntity l) async {
    var saveMaterial = await MaterialDao.saveMaterial(
        l.versionId, l.materialId, l.subjectId, l.gradeId, widget.type);
    if (saveMaterial.result) {
      Navigator.of(context).pop(true);
    } else {
      Fluttertoast.showToast(msg: '保存失败');
    }
  }
}
