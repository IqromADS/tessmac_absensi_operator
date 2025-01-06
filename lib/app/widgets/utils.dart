import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Fungsi untuk menyimpan token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  // Fungsi untuk mengambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idUser');
  }

  static Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idUser', id);
  }

  // Fungsi untuk menyimpan nama pengguna
  static Future<void> saveUserName(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', nama);
  }

  // Fungsi untuk mengambil nama pengguna
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // Fungsi untuk menyimpan email pengguna
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  // Fungsi untuk mengambil email pengguna
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // Fungsi untuk menyimpan nomor telepon pengguna
  static Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phone);
  }

  // Fungsi untuk mengambil nomor telepon pengguna
  static Future<String?> getphone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  // Fungsi untuk menyimpan foto profil
  static Future<void> saveUserProfilePic(String profilePic) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profilePic', profilePic);
  }

  // Fungsi untuk mengambil foto profil
  static Future<String?> getUserProfilePic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profilePic');
  }

  // Fungsi untuk menyimpan role pengguna
  static Future<void> saveUserRole(String roleName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('roleName', roleName);
  }

  // Fungsi untuk mengambil role pengguna
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('roleName');
  }

  // Fungsi untuk menyimpan nama terminal
  static Future<void> saveTerminalName(String terminalName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('terminalName', terminalName);
  }

  // Fungsi untuk mengambil nama terminal
  static Future<String?> getTerminalName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('terminalName');
  }

  // Clear all stored preferences
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // This clears all data stored in SharedPreferences
  }

  // Fungsi untuk menyimpan lating terminal
  static Future<void> savelating(String latitude) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('latitude', latitude);
  }

  // Fungsi untuk mengambil lating terminal
  static Future<String?> getlatitude() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('latitude');
  }

  // Fungsi untuk menyimpan long terminal
  static Future<void> savelong(String longitude) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('longitude', longitude);
  }

  // Fungsi untuk mengambil long terminal
  static Future<String?> getlongitude() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('longitude');
  }

  // Fungsi untuk menyimpan radius terminal
  static Future<void> saveRadius(int radius) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt('radius', radius);
  }

  // Fungsi untuk mengambil radius terminal
  static Future<int?> getRadius() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt('radius');
  }

  static Future<void> saveCheckInAttendanceId(String idAttendance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idAttendance', idAttendance);
    print('Saved idAttendance: $idAttendance');
  }

  static Future<String?> getCheckInAttendanceId() async {
    final prefs = await SharedPreferences.getInstance();
    final idAttendance = prefs.getString('idAttendance');
    print('Retrieved idAttendance: $idAttendance');
    return idAttendance;
  }

  //hapus id attendance setelah check out
  static Future<void> removeCheckInAttendanceId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('idAttendance');
  }

  // save id device
  static Future<void> saveIdDevice(String idDevice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idDevice', idDevice);
    print('Saved idDevice: $idDevice');
  }

  // get id device
  static Future<String?> getIdDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final idDevice = prefs.getString('idDevice');
    print('Retrieved idDevice: $idDevice');
    return idDevice;
  }

  // Menyimpan jam keluar dalam format yang benar
  static Future<void> saveJamKeluar(String jamKeluar) async {
    final prefs = await SharedPreferences.getInstance();
    // Memastikan jamKeluar hanya berisi waktu yang valid tanpa format yang berulang
    final cleanedJamKeluar =
        jamKeluar.split(' ').last; // Hanya ambil bagian waktu yang relevan
    prefs.setString('jamKeluar', cleanedJamKeluar);
  }

  // Mengambil jam keluar dari SharedPreferences
  static Future<String?> getJamKeluar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jamKeluar');
  }

  // Menghapus jam keluar
  static Future<void> clearJamKeluar() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('jamKeluar');
  }

  // Simpan tanggal terakhir check-in/check-out
  static Future<void> saveLastAttendanceDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastAttendanceDate', date);
  }

// Ambil tanggal terakhir check-in/check-out
  static Future<String?> getLastAttendanceDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastAttendanceDate');
  }

// Hapus tanggal terakhir check-in/check-out
  static Future<void> removeLastAttendanceDate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('lastAttendanceDate');
  }
}
