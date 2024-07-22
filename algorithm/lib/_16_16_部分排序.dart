
/// https://leetcode.cn/problems/sub-sort-lcci/
/// 突破点寻找最远的逆序对

List<int> subSort(List<int> array) {
  if (array.isEmpty) {
    return [-1,-1];
  }
  /// 先从左扫到右
  int max = array[0];
  /// 用来记录最右的那个逆序对位置
  int r = -1;
  for (int i = 1; i < array.length;i++) {
    if (array[i] < max) {
      r = i;
    } else {
      max = array[i];
    }
  }

  /// 提前结束
  if (r == -1) {
    return [-1,-1];
  }

  /// 先从右扫到左 寻找逆序对
  int min = array[array.length - 1];
  /// 用来记录最右的那个逆序对位置
  int l = -1;
  for (int i = array.length - 2; i >= 0;i--) {
    if (array[i] > min) {
      l = i;
    } else {
      min = array[i];
    }
  }
  return [l,r];
}