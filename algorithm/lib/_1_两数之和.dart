

/// https://leetcode.cn/problems/two-sum/


List<int> twoSum(List<int> nums, int target) {
  Map<int, int> map = {};
  for (int i = 0; i < nums.length; i++) {
    map[nums[i]] = i;
  }
  print("map:$map");
  for (int i = nums.length - 1; i >=0; i--) {
    int cur = nums[i];
    int other = target - cur;
    if (map.containsKey(other) && i != map[other]) {
      return [i,map[other]!];
    }
  }
  return [];
}