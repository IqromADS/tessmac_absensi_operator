import 'dart:convert';
import 'dart:io';
import 'package:absensi_operator/app/data/attendancesOverview.dart';
import 'package:absensi_operator/app/data/checkin.dart';
import 'package:absensi_operator/app/data/checkout.dart';
import 'package:absensi_operator/app/data/getIdAttendances.dart';
import 'package:absensi_operator/app/data/history.dart';
import 'package:absensi_operator/app/data/inspectionResponse.dart';
import 'package:absensi_operator/app/data/jadwal.dart';
import 'package:absensi_operator/app/data/notif.dart';
import 'package:absensi_operator/app/data/user.dart';
import 'package:absensi_operator/app/data/vehiclePlates.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://ticketing.patloggps.com/api";
  // LOGIN
  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] != 'success') {
          throw Exception(
              'Login failed with message: ${jsonResponse['message']}');
        }

        final loginResponse = LoginResponse.fromJson(jsonResponse);

        await SharedPreferencesHelper.saveToken(loginResponse.token);
        if (loginResponse.data != null) {
          await SharedPreferencesHelper.saveUserId(loginResponse.data!.idUser);
          await SharedPreferencesHelper.saveUserName(loginResponse.data!.nama);
          await SharedPreferencesHelper.saveUserPhone(
              loginResponse.data!.phone.toString());
          await SharedPreferencesHelper.saveUserEmail(
              loginResponse.data!.email);
          await SharedPreferencesHelper.saveUserProfilePic(
              loginResponse.data!.profilPic);
          await SharedPreferencesHelper.savelating(
              loginResponse.data!.lokasi.latitude);
          await SharedPreferencesHelper.savelong(
              loginResponse.data!.lokasi.longitude);
          await SharedPreferencesHelper.saveTerminalName(
              loginResponse.data!.terminalName);
          await SharedPreferencesHelper.saveUserRole(
              loginResponse.data!.roleName);
          await SharedPreferencesHelper.saveRadius(loginResponse.data!.radius);
        }

        return loginResponse;
      } else {
        print('Failed to login, status code: ${response.statusCode}');
        throw Exception('Failed to login: ${response.body}');
      }
    } on SocketException {
      throw Exception(
          'Tidak ada koneksi internet. Silakan periksa jaringan Anda.');
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Error occurred: $e');
    }
  }

  // Fungsi API yang memerlukan autentikasi
  Future<dynamic> getProtectedData(String endpoint) async {
    final token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No token found or token is empty');
    }

    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        await SharedPreferencesHelper.clear();
      } else {
        throw Exception('Failed to logout: ${response.body}');
      }
    } catch (e) {
      throw ('Error occurred: $e');
    }
  }

  // GET JADWAL
  Future<List<Jadwal>> getJadwalById(String id) async {
    final url = Uri.parse('$baseUrl/getjadwal/$id');
    final token = await SharedPreferencesHelper.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'] as List;
        return data.map((item) => Jadwal.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch jadwal: ${response.body}');
      }
    } catch (e) {
      print('Error during fetching jadwal: $e');
      throw Exception('Error occurred: $e');
    }
  }

// CHECK-IN
  Future<CheckInResponse> postCheckInWithImage({
    required String imagePath,
    required String checkInLocation,
    required String idDevice,
    required String idUser,
    required String checkInDate,
  }) async {
    if (imagePath.isEmpty ||
        checkInLocation.isEmpty ||
        idDevice.isEmpty ||
        idUser.isEmpty ||
        checkInDate.isEmpty) {
      throw Exception('Check-In: Invalid parameters provided.');
    }

    final url = Uri.parse('$baseUrl/checkin');
    final String? token = await SharedPreferencesHelper.getToken();

    final request = http.MultipartRequest('POST', url);

    try {
      request.files
          .add(await http.MultipartFile.fromPath('check_in_photo', imagePath));
      request.fields.addAll({
        'check_in_location': checkInLocation,
        'id_device': idDevice,
        'id_user': idUser,
        'check_in_date': checkInDate,
      });
      request.headers['Authorization'] = token != null ? 'Bearer $token' : '';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Validasi format JSON
        final decodedResponse = jsonDecode(responseBody);
        if (decodedResponse is Map<String, dynamic>) {
          if (decodedResponse.containsKey('data') &&
              decodedResponse['data'] is Map<String, dynamic>) {
            return CheckInResponse.fromJson(decodedResponse);
          } else {
            throw Exception('Unexpected JSON structure for "data" field.');
          }
        } else {
          throw Exception('Unexpected JSON format.');
        }
      } else {
        throw Exception('Check-In Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during check-in: $e');
      throw Exception('Check-In Error: $e');
    }
  }

  // CHECKOUT
  Future<CheckOutResponse> postCheckout({
    String? imagePath,
    String? checkOutLocation,
    required String idDevice,
    required String idUser,
    required String idAttendance,
    String? checkOutDate,
  }) async {
    final url = Uri.parse('$baseUrl/checkout');
    final String? token = await SharedPreferencesHelper.getToken();
    final String? idAttendance =
        await SharedPreferencesHelper.getCheckInAttendanceId();

    if (idAttendance == null || idAttendance.isEmpty) {
      throw Exception(
          'Checkout: No idAttendance found. Please check-in first.');
    }

    if (idDevice.isEmpty || idUser.isEmpty) {
      throw Exception('Check-Out: Invalid parameters provided.');
    }

    final request = http.MultipartRequest('POST', url);

    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('check_out_photo', imagePath),
        );
      }

      if (checkOutLocation != null && checkOutLocation.isNotEmpty) {
        request.fields['check_out_location'] = checkOutLocation;
      }

      request.fields.addAll({
        'id_device': idDevice,
        'id_user': idUser,
        'check_out_date': checkOutDate ?? '',
        'id_attendance': idAttendance,
      });
      request.headers['Authorization'] = token != null ? 'Bearer $token' : '';

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        final jsonResponse = jsonDecode(responseBody);

        return CheckOutResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Check-Out Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during check-out: $e');
      throw Exception('Check-Out Error: $e');
    }
  }

  // HISTORY
  Future<List<History>> getHistoryById(String userId) async {
    final url = Uri.parse('$baseUrl/gethistory/$userId');
    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data
            .map((e) => History.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch history: ${response.body}');
      }
    } catch (e) {
      print('Error fetching history: $e');
      throw Exception('Error occurred: $e');
    }
  }

  // GET ATTENDANCE OVERVIEW
  Future<AttendancesResponseOverView> getAttendanceByIdOverview(
      String userId) async {
    final url = Uri.parse('$baseUrl/attendance/$userId');
    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        return AttendancesResponseOverView.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch attendance: ${response.body}');
      }
    } catch (e) {
      print('Error fetching attendance: $e');
      throw Exception('Error occurred: $e');
    }
  }

  // GET ID ATTENDANCE ABSEN
  Future<AttendanceResponseAbsent> getAttendanceAbsent(int userId) async {
    final url = Uri.parse('$baseUrl/getattendance/$userId');
    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      print('HTTP Response: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse['data'];

        if (data != null) {
          final jamKeluar = data['jam_keluar'];
          if (jamKeluar != null) {
            await SharedPreferencesHelper.saveJamKeluar(jamKeluar);
          }
        } else {
          print('Data is null, no attendance data found.');
        }

        return AttendanceResponseAbsent.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch attendance data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
      throw Exception('Error occurred: $e');
    }
  }

  // GET NOTIFICATION CHECK-IN
  Future<NotificationResponse> getNotifCheckIn(String userId) async {
    final url = Uri.parse('$baseUrl/notifcheckin/$userId');
    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response body CI: ${response.body}');
        return NotificationResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch notification: ${response.body}');
      }
    } catch (e) {
      print('Error fetching notification: $e');
      throw Exception('Error occurred: $e');
    }
  }

  // GET NOTIF CHECKOUT
  Future<NotificationResponse> getNotifCheckOut(String userId) async {
    final url = Uri.parse('$baseUrl/notifcheckout/$userId');
    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response body CO: ${response.body}');
        return NotificationResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch notification: ${response.body}');
      }
    } catch (e) {
      print('Error fetching notification: $e');
      throw Exception('Error occurred: $e');
    }
  }

  // GET VEHICLE PLATES
  Future<List<VehiclePlates>> getVehiclePlatesById(String userId) async {
    final url = Uri.parse('$baseUrl/getvehicle-plates/$userId');
    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Response body get vehicle plates : ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'] as List;
        return data.map((item) => VehiclePlates.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch vehicle plates: ${response.body}');
      }
    } catch (e) {
      print('Error fetching vehicle plates: $e');
      throw Exception('Error occurred: $e');
    }
  }

  Future<InspectionResponse> postInspection({
    required String idUser,
    required String plat,
    required String frontCameraPath,
    required String rightCameraPath,
    required String leftCameraPath,
    required String personCameraPath,
    required String frontTruckPath,
    required String condition,
  }) async {
    final url = Uri.parse('$baseUrl/inspection');
    final String? token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {'Authorization': 'Bearer $token'};

    final request = http.MultipartRequest('POST', url);

    try {
      // Tambahkan file jika ada path yang diberikan
      if (frontCameraPath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('frontCamera', frontCameraPath));
      }
      if (rightCameraPath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('rightCamera', rightCameraPath));
      }
      if (leftCameraPath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('leftCamera', leftCameraPath));
      }
      if (personCameraPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'personCamera', personCameraPath));
      }
      if (frontTruckPath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('frontTruck', frontTruckPath));
      }

      // Tambahkan data lainnya
      request.fields.addAll({
        'id_user': idUser,
        'plat': plat,
        'condition': condition,
      });

      request.headers.addAll(headers);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Log respons body
      print('Response body inspection: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);

        // Parsing response JSON ke model
        return InspectionResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to post inspection: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting inspection: $e');
      throw Exception('Error occurred while posting inspection: $e');
    }
  }
}
