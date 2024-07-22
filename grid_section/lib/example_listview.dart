import 'package:grid_section/mock_data.dart';
import 'package:grid_section/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class ExampleListView extends StatefulWidget {
  @override
  _ExampleListViewState createState() => _ExampleListViewState();
}

class _ExampleListViewState extends State<ExampleListView> {
  var sectionList = MockData.getExampleSections();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //In this example, we create a custom model class(ExampleSection).
    //class ExampleSection implements ExpandableListSection<String> {}
    //so: SliverExpandableChildDelegate<String, ExampleSection>()
    return Scaffold(
        appBar: CustomAppBar(title: "ListView Example"),
        body: ExpandableListView(
          builder: SliverExpandableChildDelegate<String, ExampleSection>(
              sectionList: sectionList,
              headerBuilder: _buildHeader,
              itemBuilder: (context, sectionIndex, itemIndex, index) {
                String item = sectionList[sectionIndex].items[itemIndex];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("$index"),
                  ),
                  title: Text(item),
                );
              }),
        ));
  }

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList[sectionIndex];
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
}
