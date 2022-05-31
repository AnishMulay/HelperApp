import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle normal = GoogleFonts.montserrat(fontSize: 17);

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xff7851a9),
  accentColor: Colors.purpleAccent,
  scaffoldBackgroundColor: Color(0xfff1f1f1)
);

ThemeData dark = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xff004225),
    accentColor: Colors.green,
);

class ThemeNotifier extends ChangeNotifier {
    final String key = "theme";
    late SharedPreferences _pref;
    late bool _darkTheme;
    bool get darkTheme => _darkTheme;
    ThemeNotifier() {
        _darkTheme = false;
        _loadFromPrefs();
    }
    toggleTheme(){
        _darkTheme = !_darkTheme;
        _saveToPrefs();
        notifyListeners();
    }

    _initPrefs() async {
        // ignore: unnecessary_null_comparison
        if(_pref == null)
            _pref  = await SharedPreferences.getInstance();
    }
    _loadFromPrefs() async {
        await _initPrefs();
        _darkTheme = _pref.getBool(key) ?? true;
        notifyListeners();
    }
    _saveToPrefs() async {
        await _initPrefs();
        _pref.setBool(key, _darkTheme);
    }
}


