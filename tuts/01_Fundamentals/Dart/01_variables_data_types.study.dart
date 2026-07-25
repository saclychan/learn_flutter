void main() {
  // get current year
  int currentYear = DateTime.now().year;
  int age = currentYear - 1992;
  String name = 'Sacly';
  bool isDeveloper = true;
  double height = 1.75;
  // Dart not support float
  final job = isDeveloper ? "I am a developer" : "I am not a developer";
  print('I am $name, $age years old $job, my height is $height');
  // job = "new job"; Error: Can't assign to the final variable 'job'.
  var language = "Dart";
  print("Type Inference: $language");

  const pi = 3.14;
  print("Pi: $pi");

  const double pi2 = 3.14159;
  print("Pi 2: $pi2");

  print("====================List String====================");
  List<String> candies = ["Snickers", "Mars", "Twix"];
  for (String candy in candies) {
    print(candy);
  }

  print("======= Map key value=======");
  Map<String, int> phoneMap = {
    "Samsung": 123456789,
    "Apple": 987654321,
    "Xiaomi": 123456789,
  };

  for (var i in phoneMap.entries) {
    print("Key: ${i.key}, Value: ${i.value}");
  }
}
