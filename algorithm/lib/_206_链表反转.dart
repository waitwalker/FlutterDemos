

import 'package:algorithm/list_node.dart';

ListNode? reverseList(ListNode? head) {
  if (head == null) return null;
  ListNode? prev;
  while (head != null) {
    head = head.next;
  }
}