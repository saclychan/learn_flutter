import 'dart:core';
import 'dart:math';

void main() {
  String rank = "master";
  String status = switch (rank) {
    "master" => "Bậc thấy",
    "padawan" => "Chicken",
    _ => "Understood",
  };

  print("Rank $rank - Status: $status");

  int grade = -1;
  if (grade <= 0) {
    print('You are not a student');
  } else if (grade <= 5) {
    print('You are Elementary/Primary school student');
  } else if (grade <= 9) {
    print('You are Junior high/Secondary school student');
  } else if (grade <= 12) {
    print('You are High school student');
  } else {
    print('You are University student or higher');
  }

  // if-case
  final json = {'name': "sacly", "age": 1};
  if (json case {"age": 1}) {
    print("Trẻ trâu");
  }

  // dynamic list
  List<String> years = [for (var i = 2026 - 1000; i < 2026; i++) 'Year $i'];
  print(years.join(', '));

  List<int> ages = [for (var i = 100; i > 0; i--) i];
  print(ages.join(', '));

  // do while/ while
  Random random = Random();
  int diceNumber;

  print("Rolling...\n");
  do {
    diceNumber = random.nextInt(6); // 0 - 5, not include 6
    diceNumber++; // if want 1-6, we need to add 1 to the result
    print('You rolled a $diceNumber');
  } while (diceNumber != 6);

  print("You got 6!");

  switch (rank) {
    case "master":
      print("Phù thủy");
      break;
    case "padawan":
      print("Gà mờ");
      break;
    default:
      print("Understood");
  }
}
