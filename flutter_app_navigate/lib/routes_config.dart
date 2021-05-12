import 'package:flutter/material.dart';
import 'package:flutter_route_test/publish_blog_page.dart';
import 'package:flutter_route_test/second_test_page.dart';
import 'package:flutter_route_test/third_test_page.dart';

import 'common_page.dart';
import 'fourth_test_page.dart';

const secondPage = "secondPage";
const thirdPage = "thirdPage";
const fourthPage = "fourthPage";
const publishBlogPage = "publishBlogPage";
const commonPage = "commonPage";
const onGenerateRouteName = "onGenerateRouteName";
const onUnknownRouteName = "onUnknownRouteName";
const myRouteNames = [secondPage,thirdPage,fourthPage,publishBlogPage,commonPage];

Map<String, WidgetBuilder> myRoutes = {
  secondPage: (context) => SecondTestPage(),
  thirdPage: (context) => ThirdTestPage(),
  fourthPage: (context) => FourthTestPage(),
  publishBlogPage: (context) => PublishBlogPage(),
  commonPage: (context) => CommonPage(),
};
