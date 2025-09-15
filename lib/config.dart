import 'dart:io';

class Config {
  static Future<String> getLocalIp() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address; // e.g. 192.168.1.5
          }
        }
      }
    } catch (e) {
      print("⚠️ Failed to detect local IP: $e");
    }
    return "127.0.0.1";
  }

  static Future<String> get baseUrl async {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000/api";
    } else if (Platform.isIOS) {
      return "http://127.0.0.1:3000/api";
    } else {
      final ip = await getLocalIp();
      return "http://$ip:3000/api";
    }
  }

  static Future<String> get socketUrl async {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    } else if (Platform.isIOS) {
      return "http://127.0.0.1:3000";
    } else {
      final ip = await getLocalIp();
      return "http://$ip:3000";
    }
  }
}
