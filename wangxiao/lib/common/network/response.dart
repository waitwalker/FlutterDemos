/**
 * 网络结果数据
 */
class ResponseData {
  var data;
  bool result;
  int code;
  var headers;
  var model;

  ResponseData(this.data, this.result, this.code, {this.headers, this.model});
}
