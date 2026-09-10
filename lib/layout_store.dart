import 'package:shared_preferences/shared_preferences.dart';

class LayoutStore {
  static const _iconSizeKey = 'iconSize';
  static const _labelsKey = 'showLabels';
  static const _darkKey = 'darkMode';
  static const _gridKey = 'gridColumns';

  static Future<double> iconSize() async {
    final p = await SharedPreferences.getInstance();
    return p.getDouble(_iconSizeKey) ?? 58;
  }

  static Future<void> setIconSize(double value) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble(_iconSizeKey, value);
  }

  static Future<bool> showLabels() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_labelsKey) ?? true;
  }

  static Future<void> setShowLabels(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_labelsKey, value);
  }

  static Future<bool> darkMode() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_darkKey) ?? true;
  }

  static Future<void> setDarkMode(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_darkKey, value);
  }

  static Future<int> gridColumns() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_gridKey) ?? 4;
  }

  static Future<void> setGridColumns(int value) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_gridKey, value);
  }
}
