import 'dart:io';

void main() {
  String name = 'saclychan';
  int age = 34;
  double height = 1.69;
  final String jobs = "Flutter Developer, Daddy";
  List<String> skills = ["eat", "drink", "coding", "pop", "sleep"];
  Map<String, int> powerStats = {
    "strength": 120,
    "mana": 200,
    "agility": 100
  };

  print("===============================");
  print("      RPG CHARACTER PROFILE    ");
  print("===============================");
  print("👤 Name:    $name");
  print("🎂 Age:     $age");
  print("📏 Height:  ${height}m");
  print("💼 Job:     $jobs");
  print("-------------------------------");
  
  // Dùng thư viện dart:io để in trên cùng một dòng (không tự động xuống dòng)
  stdout.write("⚔️  Skills:  ");
  
  // Dùng hàm .join() để ghép các phần tử trong List thay vì chạy vòng lặp thủ công
  print(skills.join(", "));
  
  print("-------------------------------");
  print("🔥 Power Stats:");
  
  // Dùng .forEach để duyệt qua các key-value trong Map một cách chuyên nghiệp
  powerStats.forEach((key, value) {
    print("   - ${key.toUpperCase()}: $value");
  });
  
  print("===============================");
}
