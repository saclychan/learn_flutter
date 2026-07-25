int calculateSalary({required int baseSalary, int bonus = 0, int tax = 0}) {
  return baseSalary + bonus - tax;
}

void main() {
  int salary = calculateSalary(baseSalary: 5000, bonus: 50000000, tax: 0);
  print('Lương của bạn là: $salary');
}
