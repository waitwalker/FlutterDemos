import 'package:grid_section/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class GridListPage extends StatefulWidget {
  const GridListPage({super.key});

  @override
  _GridListPageState createState() => _GridListPageState();
}

class _GridListPageState extends State<GridListPage> {
  var sectionList = MockData.getExampleSections();
  @override
  void initState() {
    super.initState();
    print(sectionList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("GridListPage Example")),
        body: ExpandableListView(
          builder: SliverExpandableChildDelegate<String, ExampleSection>(
              sectionList: sectionList,
              sectionBuilder: _buildSection,
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
        ),);
  }

  Widget _buildSection(
      BuildContext context, ExpandableSectionContainerInfo containerInfo) {
    containerInfo
      ..header = _buildHeader(containerInfo)
      ..content = _buildContent(containerInfo);
    return ExpandableSectionContainer(
      info: containerInfo,
    );
  }

  Widget _buildHeader(ExpandableSectionContainerInfo containerInfo) {
    ExampleSection section = sectionList[containerInfo.sectionIndex];
    return InkWell(
        child: Container(
            color: Colors.lightBlue,
            height: 48,
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              section.header,
              style: TextStyle(color: Colors.white),
            )),
        onTap: () {
          //toggle section expand state
          setState(() {
            section.setSectionExpanded(!section.isSectionExpanded());
          });
        });
  }

  Widget _buildContent(ExpandableSectionContainerInfo containerInfo) {
    ExampleSection section = sectionList[containerInfo.sectionIndex];
    if (!section.isSectionExpanded()) {
      return Container();
    }
    return GridView.builder(
      itemCount: 10,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.lightGreen,
          child: Text("$index"),
        );
      },
    );
    // return GridView.count(
    //   crossAxisCount: 2,
    //   childAspectRatio: 3,
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   children: containerInfo.children,
    // );
  }
}
