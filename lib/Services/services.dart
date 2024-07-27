import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:welivewithquran/Models/category.dart';
import 'package:welivewithquran/models/ebook_org.dart';
import 'package:welivewithquran/models/search_query.dart' as sea;
import 'package:welivewithquran/models/surah.dart';

import '../constant.dart';

String search = apiUrl + "find=";
String category = "cat_id=";
String home = "home";
String surahs = "surah_list";
String details = "app_details";

class DataServices {
  static Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*',
    // 'Content-Type': 'application/json',
    // headers: {'app-id': '6218809d412af5bac4',
    // 'Authorization': '<Your token>'
  };

  static Future<List<Ebook>?> getEbooks(query) async {
    String url = apiUrl + query;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  static Future<List<Ebook>?> getFeaturedEbooks() async {
    String url = apiUrl + home;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      return fromJsonAPI(json.decode(response.body));
    } else {
      print('getFeaturedEbooks');
      return null;
    }
  }

  static Future<List<Ebook>?> getPopularEbooks() async {
    String url = apiUrl + home;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      ///data successfully
      return fromJsonPopularAPI(json.decode(response.body));
    } else {
      ///error
      return null;
    }
  }

  static Future<List<Ebook>?> getRandomEbooks() async {
    String url = apiUrl + home;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      ///data successfully
      return fromJsonPopularAPI(
        json.decode(response.body),
      );
    } else {
      ///error
      return null;
    }
  }

  static Future<List<Ebook>?> getEbooksFromCat(String id) async {
    String url = apiUrl + category + id;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      ///data successfully
      return fromJson(json.decode(response.body));
    } else {
      ///error
      return null;
    }
  }

  static Future<List<sea.SearchQuery>?> searchBooks(String query) async {
    String url = search + query;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      ///data successfully
      return sea.fromJsonAPI(json.decode(response.body));
    } else {
      ///error
      return null;
    }
  }

  static Future<List<sea.SearchQuery>?> searchBooksSpecific(String query, Surah surah) async {
    String url = apiUrl + "srch=$query" + "&surah=${surah.surah}";
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      ///data successfully
      return sea.fromJsonAPI(json.decode(response.body));
    } else {
      ///error
      return null;
    }
  }

  static Future<String?> getPageImage(int pageNum, String surah) async {
    String url = apiUrl + "surah_id=$surah&pid=$pageNum";
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      ///data successfully
      return json.decode(response.body)["EBOOK_APP"][0]["page_img"];
    } else {
      ///error
      return null;
    }
  }

  static Future<List<Category>?> getCategories() async {
    String url = apiUrl + 'cat_list';
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      return fromCatsJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  static Future<List<Surah>?> getSurahs() async {
    String url = apiUrl + surahs;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      return fromSurahsJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  static Future<Map<String, String>?> getAppDetails() async {
    String url = apiUrl + details;
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Map<String, String>.from(data['EBOOK_APP'][0]);
    } else {
      return null;
    }
  }

  static getAppInfo() async {
    final response = await http.get(Uri.parse(apiUrl), headers: requestHeaders);
    return fromJson(json.decode(response.body));
  }
}
