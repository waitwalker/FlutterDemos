
/// [https://leetcode.cn/problems/sort-colors/]
/// 很多要去扫描一遍，差不多要借助双指针或者三指针来实现
/// 遇到1直接跳过
/// 遇到0跟左指针交换数据，
/// 遇到2跟右指针交换数据

void sortColors(List<int> nums) {
  int i = 0;
  int l = 0;
  int r = nums.length - 1;

  while (i <= r) {
    int cur = nums[i];
    if (cur == 0) {
      swap(nums, i, l);
      l++;
      i++;
    } else if (cur == 1) {
      i++;
    } else {
      swap(nums, i, r);
      r--;
    }
  }
}

void swap(List<int> nums, int i, int j) {
  int tmp = nums[i];
  nums[i] = nums[j];
  nums[j] = tmp;
}