'use strict';
const dart_sdk = require('dart_sdk');
const core = dart_sdk.core;
const _interceptors = dart_sdk._interceptors;
const dart = dart_sdk.dart;
const dartx = dart_sdk.dartx;
const packages__flutter__src__widgets__widget_span$46dart = require('packages/flutter/src/widgets/widget_span.dart');
const framework = packages__flutter__src__widgets__widget_span$46dart.src__widgets__framework;
const text = packages__flutter__src__widgets__widget_span$46dart.src__widgets__text;
const basic = packages__flutter__src__widgets__widget_span$46dart.src__widgets__basic;
const packages__flutter__src__material__icon_button$46dart = require('packages/flutter/src/material/icon_button.dart');
const scaffold = packages__flutter__src__material__icon_button$46dart.src__material__scaffold;
const app_bar = packages__flutter__src__material__icon_button$46dart.src__material__app_bar;
var home_page = Object.create(dart.library);
var JSArrayOfWidget = () => (JSArrayOfWidget = dart.constFn(_interceptors.JSArray$(framework.Widget)))();
const CT = Object.create(null);
var L0 = "package:flutterappmxjs/home_page.dart";
home_page.HomePage = class HomePage extends framework.StatefulWidget {
  createState() {
    return new home_page._HomeState.new();
  }
};
(home_page.HomePage.new = function() {
  home_page.HomePage.__proto__.new.call(this);
  ;
}).prototype = home_page.HomePage.prototype;
dart.addTypeTests(home_page.HomePage);
dart.addTypeCaches(home_page.HomePage);
dart.setMethodSignature(home_page.HomePage, () => ({
  __proto__: dart.getMethods(home_page.HomePage.__proto__),
  createState: dart.fnType(framework.State$(framework.StatefulWidget), [])
}));
dart.setLibraryUri(home_page.HomePage, L0);
home_page._HomeState = class _HomeState extends framework.State$(home_page.HomePage) {
  build(context) {
    return new scaffold.Scaffold.new({appBar: new app_bar.AppBar.new({title: new text.Text.new("主页")}), body: new basic.Column.new({children: JSArrayOfWidget().of([new text.Text.new("主页")])})});
  }
};
(home_page._HomeState.new = function() {
  home_page._HomeState.__proto__.new.call(this);
  ;
}).prototype = home_page._HomeState.prototype;
dart.addTypeTests(home_page._HomeState);
dart.addTypeCaches(home_page._HomeState);
dart.setMethodSignature(home_page._HomeState, () => ({
  __proto__: dart.getMethods(home_page._HomeState.__proto__),
  build: dart.fnType(framework.Widget, [framework.BuildContext])
}));
dart.setLibraryUri(home_page._HomeState, L0);
// Exports:
exports.home_page = home_page;

//# sourceMappingURL=home_page.dart.lib.js.map
