import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _authEnabledKey = 'auth_enabled';
  static const String _lastAuthKey = 'last_auth';
  
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  Future<bool> isAuthEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authEnabledKey) ?? false;
  }
  
  Future<void> setAuthEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authEnabledKey, enabled);
  }
  
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }
  
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
  
  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your expense data',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      
      if (didAuthenticate) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_lastAuthKey, DateTime.now().millisecondsSinceEpoch);
      }
      
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> shouldAuthenticate() async {
    if (!await isAuthEnabled()) return false;
    
    final prefs = await SharedPreferences.getInstance();
    final lastAuth = prefs.getInt(_lastAuthKey);
    
    if (lastAuth == null) return true;
    
    final lastAuthTime = DateTime.fromMillisecondsSinceEpoch(lastAuth);
    final now = DateTime.now();
    
    // Require authentication if more than 5 minutes have passed
    return now.difference(lastAuthTime).inMinutes > 5;
  }
}