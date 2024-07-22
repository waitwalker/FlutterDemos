import 'package:algorithm/list_node.dart';

ListNode? removeElements(ListNode? head, int val) {
  if (head == null) return null;
  /// 新链表的头节点
  ListNode? newHead;

  /// 新链表的尾节点
  ListNode? newTail;

  while (head != null) {
    if (head.val == val) {
      if (newTail == null) {
        newHead = head;
        newTail = head;
      } else {
        newTail.next = head;
        newTail = head;
      }
    }
    head = head.next;
  }
  if (newTail == null) {
    return null;
  } else {
    newTail.next = null;
  }
  return newHead;
}
