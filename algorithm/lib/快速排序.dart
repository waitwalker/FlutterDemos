
void quickSort(List<int> nums) {
  int pivot = nums[0];
  int begin = 0;
  int end = nums.length - 1;
  while (begin < end) {
    while (begin < end) {
      if (nums[end] > pivot) {
        end--;
      } else {
        nums[begin] = nums[end];
        begin++;
        break;
      }
    }

    while (begin < end) {
      if (nums[begin] < pivot) {
        begin++;
      } else {
        nums[end] = nums[begin];
        end--;
        break;
      }
    }
  }
  nums[begin] = pivot;
  print(nums);
}