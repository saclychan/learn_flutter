void main() {
  //
  List<int> scores = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  for (int score in scores) {
    print("Score is $score: ");
    if (score >= 8)
      print("Giỏi");
    else if (score >= 5)
      print("Khá");
    else
      print("Yếu");
  }

  int shout = 10;
  while (shout > 0) {
    print("Shout ${shout}");
    shout--;
  }

  int shout2 = 10;
  while (shout2 > 0) {
    print("Shout2 ${shout2}");
    shout2 = shout2 - 1;
  }
}
