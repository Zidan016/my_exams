import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static final LocalService _instance = LocalService._internal();
  factory LocalService() => _instance;

  late SharedPreferences _prefs;

  LocalService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setUsername(String username) async => await _prefs.setString('username', username);
  Future<void> setName(String name) async => await _prefs.setString('name', name);
  Future<void> setOneRole(String oneRole) async => await _prefs.setString('oneRole', oneRole);
  Future<void> setRememberMe(bool rememberMe) async => await _prefs.setBool('rememberMe', rememberMe);
  Future<void> setId(int id) async => await _prefs.setInt('id', id);
  Future<void> setAuth(String auth) async => await _prefs.setString('auth', auth);
  Future<void> setRole(List<String> value) async => await _prefs.setStringList('role', value);

  String getUsername() => _prefs.getString('username') ?? '';
  int getId() => _prefs.getInt('id') ?? 0;
  String getName() => _prefs.getString('name') ?? '';
  String getOneRole() => _prefs.getString('oneRole') ?? '';
  bool getRememberMe() => _prefs.getBool('rememberMe') ?? false;
  String getAuth() => _prefs.getString('auth') ?? '';
  List<String> getRole() => _prefs.getStringList('role') ?? [];
}
