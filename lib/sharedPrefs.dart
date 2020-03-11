import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './pokemon.dart';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    PokeHub result;
    if (prefs.containsKey("favoritePokemons")) {
      result = PokeHub.fromJson(json.decode(prefs.getString(key)));
    } else {
      result = new PokeHub.fromList(new List<Pokemon>());
    }
    return result;
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}