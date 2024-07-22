import 'package:grid_section/mock_data.dart';
import 'package:grid_section/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class ExampleCustomSection extends StatefulWidget {
  @override
  _ExampleCustomSectionState createState() => _ExampleCustomSectionState();
}

class _ExampleCustomSectionState extends State<ExampleCustomSection> {
  var sectionList = MockData.getExampleSections();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "CustomSection Example"),
        body: ExpandableListView(
          builder: SliverExpandableChildDelegate<String, ExampleSection>(
              sectionList: sectionList,
              sectionBuilder: _buildSection,
              sticky: false,
              itemBuilder: (context, sectionIndex, itemIndex, index) {
                String item = sectionList[sectionIndex].items[itemIndex];
                return SizedBox(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("$index"),
                    ),
                    title: Text(item),
                  ),
                );
              }),
        ));
  }

  Widget _buildSection(
    BuildContext context,
    ExpandableSectionContainerInfo containerInfo,
  ) {
    containerInfo
      ..header = _buildHeader(context, containerInfo)
      ..content = _buildContent(context, containerInfo);
    return ExpandableSectionContainer(
      info: containerInfo,
    );
  }

  Widget _buildHeader(
      BuildContext context, ExpandableSectionContainerInfo containerInfo) {
    ExampleSection section = sectionList[containerInfo.sectionIndex];
    return InkWell(
        child: Container(
            color: Colors.lightBlue,
            height: 48,
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              section.header,
              style: const TextStyle(color: Colors.white),
            )),
        onTap: () {
          setState(() {
            section.setSectionExpanded(!section.isSectionExpanded());
          });
        });
  }

  Widget _buildContent(
      BuildContext context, ExpandableSectionContainerInfo containerInfo) {
    ExampleSection section = sectionList[containerInfo.sectionIndex];
    if (!section.isSectionExpanded()) {
      return Container();
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: containerInfo.childDelegate!.builder as Widget Function(
          BuildContext, int),
      itemCount: containerInfo.childDelegate!.childCount,
    );
  }
}
