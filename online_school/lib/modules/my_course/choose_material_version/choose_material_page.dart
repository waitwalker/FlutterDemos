import 'dart:io';
import 'package:online_school/common/dao/original_dao/material_dao.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/material_list_model.dart';
import 'package:online_school/model/material_model.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// @name ChooseMaterialPage
/// @description 选择教材版本页面
/// @author liuca
/// @date 2020-05-25
///
class ChooseMaterialPage extends StatefulWidget {
  // 1 ai；2 自学
  var type;
  var subjectId;
  var gradeId;
  var materialId;
  final MaterialDataEntity materialDataEntity;

  ChooseMaterialPage({this.type, this.subjectId, this.gradeId, this.materialId, this.materialDataEntity});

  @override
  _ChooseMaterialPageState createState() => _ChooseMaterialPageState();
}

class _ChooseMaterialPageState extends State<ChooseMaterialPage> {
  MaterialListModel data;

  @override
  void initState() {
    Global.init();
    var response = MaterialDao.getMaterials(widget.subjectId, widget.gradeId, widget.type);
    response.then((r) {
      data = r.model;

      if (data == null) setState(() {

      });

      int currentVersionIndex;
      int currentMaterialIndex;
      DataEntity currentVersion;
      TeachingMaterialDTOListEntity tmpM;
      for (int i = 0; i < data.data.length; i ++) {
        DataEntity material = data.data[i];
        print("version name:${material.versionName}");
        if (material.versionName == widget.materialDataEntity.defVersionName) {
          currentVersion = material;
          currentVersionIndex = i;
          currentVersion.isSelected = true;
          for (int j = 0; j < material.teachingMaterialDTOList.length; j++) {
            TeachingMaterialDTOListEntity teachingMaterialDTOListEntity = material.teachingMaterialDTOList[j];
            print("material name:${teachingMaterialDTOListEntity.materialName}");
            if (teachingMaterialDTOListEntity.materialName == widget.materialDataEntity.defMaterialName) {
              tmpM = teachingMaterialDTOListEntity;
              tmpM.isSelected = true;
              currentMaterialIndex = j;
              break;
            }
          }
        }
      }

      currentVersion.teachingMaterialDTOList[currentMaterialIndex] = tmpM;
      data.data[currentVersionIndex] = currentVersion;

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
        child: ListView.builder(itemBuilder: _itemBuilder, itemCount: data == null ? 0 : data.data.length,),
      ),
    );
  }

  ///
  /// @name _itemBuilder
  /// @description list view item构建
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020/5/25
  ///
  Widget _itemBuilder(BuildContext context, int materialIndex) {
    DataEntity currentMaterial = data.data[materialIndex];
    currentMaterial.currentMaterialIndex = materialIndex;
    List<TeachingMaterialDTOListEntity> teachingMaterialDTOList = currentMaterial.teachingMaterialDTOList;
    if (currentMaterial.isSelected == null) {
      currentMaterial.isSelected = false;
    }

    /// 选中效果
    if (currentMaterial.isSelected) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: (){
              currentMaterial.isSelected = !currentMaterial.isSelected;
              data.data[materialIndex] = currentMaterial;
              setState(() {

              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 56.0 : 44.0,
                  width: SingletonManager.sharedInstance.screenWidth -  15 * 2 - 24,
                  child: Text(currentMaterial.versionName,
                    style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 20 : 16, color: Color(MyColors.black333)),
                    overflow: TextOverflow.ellipsis,),
                  alignment: Alignment.centerLeft,),
                Icon(currentMaterial.isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20, color: Colors.grey,),
              ],
            ),
          ),
          Container(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: teachingMaterialDTOList.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: SingletonManager.sharedInstance.screenWidth > 500.0 ? 6.5 : 3.0,
              ),
              itemBuilder: (BuildContext context, int index){
                TeachingMaterialDTOListEntity version = teachingMaterialDTOList[index];
                bool isSelectedVersion = false;
                if (version.isSelected == null) {
                  version.isSelected = false;
                }
                isSelectedVersion = version.isSelected;
                String versionName = version.materialName;
                double fontSize = 12.0;
                if (versionName.length <= 6) {
                  fontSize = 14.0;
                } else {
                  fontSize = 12.0;
                }
                return InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelectedVersion ? Color(0xff1A9BFB) : Color(0xffF0F0F0),
                      borderRadius: BorderRadius.all(Radius.circular(3),),
                    ),
                    child: Text(versionName, style: TextStyle(fontSize: fontSize, color: isSelectedVersion ? Colors.white : Colors.black),),
                  ),
                  onTap: () async {
                    // 先将版本的选中效果替换
                    List<DataEntity> tmpMaterialList = [];
                    for (DataEntity material in data.data) {
                      List<TeachingMaterialDTOListEntity> tmpList = [];
                      for (TeachingMaterialDTOListEntity teachingMaterial in material.teachingMaterialDTOList) {
                        teachingMaterial.isSelected = false;
                        tmpList.add(teachingMaterial);
                      }
                      material.teachingMaterialDTOList = tmpList;
                      tmpMaterialList.add(material);
                    }

                    TeachingMaterialDTOListEntity teachingMaterial = version;
                    teachingMaterial.isSelected = true;
                    currentMaterial.teachingMaterialDTOList[index] = teachingMaterial;
                    data.data[materialIndex] = currentMaterial;
                    setState(() {

                    });

                    var saveMaterial = await MaterialDao.saveMaterial(
                        teachingMaterial.versionId, teachingMaterial.materialId, teachingMaterial.subjectId, teachingMaterial.gradeId, widget.type);
                    if (saveMaterial.result) {
                      Navigator.of(context).pop(true);
                    } else {
                      Fluttertoast.showToast(msg: '保存失败');
                    }
                  },
                );
              },),
          ),
        ],
      );
    } else {
      return InkWell(
        onTap: (){
          currentMaterial.isSelected = !currentMaterial.isSelected;
          data.data[materialIndex] = currentMaterial;
          setState(() {

          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 56.0 : 44.0,
                  width: SingletonManager.sharedInstance.screenWidth -  15 * 2 - 24,
                  child: Text(currentMaterial.versionName,
                    style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 20 : 16, color: Color(MyColors.black333)),
                    overflow: TextOverflow.ellipsis,),
                  alignment: Alignment.centerLeft,),
                Icon(currentMaterial.isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20, color: Colors.grey,),
              ],
            ),
          ],
        ),
      );
    }
  }
}
