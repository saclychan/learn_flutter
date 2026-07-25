/// Bản chuẩn (Sample) cho Mini Pet Project: API Data Parser
/// Hướng dẫn cách dùng Map và Record Destructuring

List<({String name, double cpu, double ram})> parseServerData(Map<String, dynamic> response) {
  // Kiểm tra an toàn xem status có thành công không
  if (response['status'] != 200) {
    return [];
  }

  // Ép kiểu phần data thành Map lồng nhau
  final Map<String, dynamic> rawData = response['data'];
  List<({String name, double cpu, double ram})> results = [];

  // Duyệt qua các entries của Map
  for (var entry in rawData.entries) {
    final serverName = entry.key;
    final metrics = entry.value as Map<String, dynamic>;
    
    // Đóng gói vào Record
    results.add((
      name: serverName, 
      cpu: metrics['cpu'], 
      ram: metrics['ram']
    ));
  }

  return results;
}

void main() {
  Map<String, dynamic> apiResponse = {
    "status": 200,
    "data": {
      "server1": {"cpu": 85.5, "ram": 16.0},
      "server2": {"cpu": 45.0, "ram": 32.0},
      "server3": {"cpu": 92.0, "ram": 8.0},
    }
  };

  final servers = parseServerData(apiResponse);

  print('--- HỆ THỐNG CẢNH BÁO SERVER ---');
  for (var server in servers) {
    // Dùng Record Destructuring để bóc tách cực nhanh
    final (:name, :cpu, :ram) = server;
    
    if (cpu > 80.0) {
      print('🔥 CẢNH BÁO TÀI NGUYÊN: Server $name đang quá tải (CPU: $cpu%, RAM: $ram GB)');
    } else {
      print('✅ Ổn định: Server $name (CPU: $cpu%)');
    }
  }
}
