

class StreamProvider {

  Stream<int> createStream() async* {
    List<int> res = [1,43,67,7865,356,356,4675,685,865];
    for(int i = 0; i < res.length;i++) {
      yield res[i];
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}