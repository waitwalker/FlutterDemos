import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity/blog_model.dart';
import 'not_found_page.dart';
import 'observer/navigator_manager.dart';
import 'publish_blog_page.dart';
import 'routes_config.dart';
import 'second_test_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigatorManager()),
      ],
      child: Consumer<NavigatorManager>(
        builder: (context, navigatorManager, _) {
          return MaterialApp(
            navigatorObservers: [navigatorManager],
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: "路由管理"),

            //路由映射
            routes: myRoutes,

            //指定哪个命名路由指向的页面作为首面，这个值生效时上面的home不生效
//            initialRoute: secondPage,

            //在使用命名路由跳转时，如果路由名称没有注册，找不到要跳转到哪里，此方法生效
            onGenerateRoute: (RouteSettings settings) {
              print('onGenerateRoute:$settings');
              if (onGenerateRouteName != settings.name) {
                return null;
              }
              return MaterialPageRoute(builder: (BuildContext context) {
                return NoFoundPage(settings.name);
              });
            },

            //在使用命名路由跳转时，如果路由名称没有注册，找不到要跳转到哪里，
            // 并且没有实现onGenerateRoute方法，或者onGenerateRoute方法返回null，此方法生效
            //如果这一个方法也是返回null，则控制台会输出错误信息
            onUnknownRoute: (RouteSettings settings) {
              print('onUnknownRoute:$settings');
              return MaterialPageRoute(builder: (BuildContext context) {
                return NoFoundPage(settings.name);
              });
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//博客列表
var blogLists = <BlogModel>[];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print('main build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          _buildSettingButton(context),
          _buildMoreButton(context),
        ],
      ),
      body: (blogLists == null || blogLists.isEmpty)
          ? _buildEmptyView()
          : _buildBlogListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _publishBlog(context);
        },
        tooltip: '发博客',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('main initState');
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('main didUpdateWidget');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('main didChangeDependencies');
  }

  @override
  void dispose() {
    super.dispose();
    print('main dispose');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('main deactivate');
  }
}

Widget _buildSettingButton(BuildContext context) {
  return GestureDetector(
    child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.settings,
        )),
    onTap: () {
      _navigatorToSetting(context);
    },
  );
}

Widget _buildMoreButton(BuildContext context) {
  return PopupMenuButton<String>(onSelected: (String routeName) {
    print('routeName:$routeName');
    Navigator.pushNamed(context, routeName);
  }, itemBuilder: (context) {
    var list = myRouteNames.map((String e) {
      return PopupMenuItem(
        value: e,
        child: Text(e),
      );
    }).toList();
    list.add(PopupMenuItem(
      value: onGenerateRouteName,
      child: Text("onGenerateRouteName"),
    ));

    list.add(PopupMenuItem(
      value: onUnknownRouteName,
      child: Text("onUnknownRouteName"),
    ));

    return list;
  });
}

void _navigatorToSetting(BuildContext context) async {
  var result = await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (BuildContext context) {
            return SecondTestPage();
          },
          settings:
              RouteSettings(name: "second", arguments: {"keepAlive": true})));
  print('_navigatorToSetting result:$result');
}

void _publishBlog(BuildContext context) async {
  //MaterialPageRoute 安卓风格 从下往上淡入 退出时相反
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return PublishBlogPage(); //为什么跳转后，会立马打印main build
  }));

//  var reslut = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
//    return PublishBlogPage();
////    return PublishBlogPage(blogModel: BlogModel(title:"默认标题",content: "这是默认内容"),);
//  }));
//  print('result:$reslut');

  //CupertinoPageRoute ios风格 进入时动画从右侧往左滑入，退出时相反
//  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
//    return PublishBlogPage();
//  })).then((result){
//  print('result:$result');
//  });

//  Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context,
//      Animation<double> animation, Animation<double> secondaryAnimation) {
//    return PublishBlogPage();
//    return new FadeTransition(
//      //使用渐隐渐入过渡,
//      opacity: animation,
//      child: PublishBlogPage(),
//    );
//  }));
  //PageRouteBuilder
//  Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context,
//      Animation<double> animation, Animation<double> secondaryAnimation) {
//    return new FadeTransition(
//      //使用渐隐渐入过渡,
//      opacity: animation,
//      child: PublishBlogPage(),
//    );
//  }));

  //PageRouteBuilder
//  Navigator.push(
//      context,
//      PageRouteBuilder(pageBuilder: (BuildContext context,
//          Animation<double> animation, Animation<double> secondaryAnimation) {
//        return PublishBlogPage();
//      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
//        var begin = Offset(0.0, 1.0);
//        var end = Offset.zero;
//        var curve = Curves.easeOutQuart;
//        var tween =
//            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//        return SlideTransition(
//          position: animation.drive(tween),
//          child: child,
//        );
//      }));
}

Widget _buildEmptyView() {
  return Center(
    child: Text("你还没有发表博客，点击按钮发表一编吧"),
  );
}

Widget _buildBlogListView() {
  return ListView.builder(
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return Text("index:$index");
      });
}
