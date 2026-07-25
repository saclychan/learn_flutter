/// Bản chuẩn (Sample) cho Mini Pet Project: BMI Calculator
/// Thể hiện tư duy viết code của Senior Developer.

// 1. Dùng Data Class để đóng gói dữ liệu (Tránh truyền tham số lắt nhắt)
class Person {
  final String name;
  final double height;
  final double weight;

  Person({required this.name, required this.height, required this.weight});
}

// 2. Hàm tính toán chỉ tập trung ĐÚNG 1 việc (Single Responsibility)
double calculateBMI({required double height, required double weight}) {
  return weight / (height * height);
}

// 3. Sử dụng Arrow Function kết hợp Switch Expression (Dart 3) 
// để code ngắn gọn, không dùng block {} lồng if-else cồng kềnh.
String evaluateBMI(double bmi) => switch (bmi) {
      < 18.5 => "Thiếu cân",
      < 25.0 => "Bình thường",
      _ => "Thừa cân",
    };

// Hàm phụ trợ để xử lý logic in (Tách biệt tính toán và hiển thị)
void printPersonBMI(Person person) {
  final bmi = calculateBMI(height: person.height, weight: person.weight);
  final evaluation = evaluateBMI(bmi);
  
  // toStringAsFixed(1) làm tròn đến 1 chữ số thập phân
  print('${person.name} - BMI: ${bmi.toStringAsFixed(1)} -> $evaluation');
}

void main() {
  final people = [
    Person(name: 'Luke Skywalker', height: 1.70, weight: 65),
    Person(name: 'Darth Vader', height: 2.02, weight: 120),
    Person(name: 'Yoda', height: 0.66, weight: 17),
  ];

  // 4. Áp dụng Tear-off cho gọn gàng 
  // Thay vì viết: people.forEach((p) => printPersonBMI(p));
  print('--- Kết Quả Đo BMI ---');
  people.forEach(printPersonBMI);
}
