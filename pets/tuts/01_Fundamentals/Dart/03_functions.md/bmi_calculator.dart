double calculateBMI({required double height, required double weight}) {
  return weight / (height * height);
}

String evaluateBMI(double bmiValue) {
  if (bmiValue < 18.5) {
    return "Thiếu cân";
  } else if (bmiValue <= 24.9) {
    return "Bình thường";
  } else {
    return "Thừa cân";
  }
}

// class
class Student {
  final double height;
  final double weight;
  Student(this.height, this.weight);
}

void main() {
  Map<String, ({double height, double weight})> employees = {
    "ha": (height: 1.69, weight: 70.0),
    "sun": (height: 1.1, weight: 20.0),
  };

  for (var employee in employees.entries) {
    final (height: height, :weight) = employee.value; // Record destructuring
    final bmi = calculateBMI(height: height, weight: weight);
    String evaluate = evaluateBMI(bmi);
    print('${employee.key} is $evaluate');
  }

  // Map lồng
  Map<String, Map<String, double>> students = {
    "HA": {"height": 1.69, "weight": 70.0},
  };
  for (var student in students.entries) {
    final name = student.key;
    final p = student.value;
    final height = p["height"]!;
    final weight = p['weight']!;
    final bmi = calculateBMI(height: height, weight: weight);
    final bmiResult = evaluateBMI(bmi);
    print('name $name bmiResult: $bmiResult');
  }

  final s1 = Student(1.69, 50);
  final bmi = calculateBMI(height: s1.height, weight: s1.weight);
  final result = evaluateBMI(bmi);
  print("s1 result $result");
}
