
import 'package:flutter/material.dart';

class NoFoundPage extends StatelessWidget {
  final String fromName;

  NoFoundPage(this.fromName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("404:$fromName"),
      ),
      body: Center(
        child: Text('''
很抱歉，您要访问的页面不存在！
        温馨提示：

请检查您访问的网址是否正确
如果您不能确认访问的网址，
请浏览百度更多页面查看更多网址。
回到顶部重新发起搜索
如有任何意见或建议，请及时反馈给我们。
        '''),
      ),
    );
  }
}