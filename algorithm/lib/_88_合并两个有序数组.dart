
/// [https://leetcode.cn/problems/merge-sorted-array/]
void merge(List<num> nums1, int m, List<num> nums2, int n) {
  /// 数组1数据的索引
  int i1 = m - 1;
  /// 数组2的索引
  int i2 = n - 1;
  int cur = nums1.length - 1;
  while (i2 >=0) {
    if (i1 > 0 && nums1[i1] > nums2[i2]) {
      nums1[cur] = nums1[i1];
      cur--;
      i1--;
    } else {
      nums1[cur] = nums2[i2];
      cur--;
      i2--;
    }
  }
}