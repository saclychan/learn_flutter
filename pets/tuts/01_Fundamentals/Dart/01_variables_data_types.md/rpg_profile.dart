void main() {
  String name = 'saclychan';
  int age = 34;
  double height = 1.69;
  final String jobs = "Flutter Developer, Daddy";
  List<String> skills = ["eat", 'drink', 'coding', 'pop', 'sleep'];
  Map<String, int> powerStats = {"strength": 120, "mana": 200, "agility": 100};

  print("+++++------++++++");
  print('Name is ${name}, age: ${age}, he tall ${height}m, Job: $jobs');
  print("Skills: ");
  String skillsString = "";
  for (int i = 0; i < skills.length; i++) {
    skillsString += "${skills[i]} ";
  }
  print("${skillsString} ");
  // print show enter in terminal, how to print without enter
  print("+++++------++++++");
}
