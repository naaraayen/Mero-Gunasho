import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../exeception_handler/http_exception.dart';

class Authentication with ChangeNotifier {
  late String? _tokenId;
  late String? _userId;
  late DateTime _expiryDate;

  String? get tokenId {
    if (_tokenId != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _userId != null) {
      return _tokenId;
    }
    return null;
  }

  String? get userId {
    if (tokenId != null) {
      return _userId;
    }
    return null;
  }

  Future<void> authenticate(
      String authMode, String email, String password) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$authMode?key=AIzaSyDpYRmu1Aywx9QtXikZZmoeaH4s6smfmZE');
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _tokenId = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
    } catch (error) {
      rethrow;
    }
  }

  // Sign Up User
  Future<void> signUp(String email, String password) async {
    return authenticate('signUp', email, password);
  }

  // Sign In User
  Future<void> signIn(String email, String password) async {
    return authenticate('signInWithPassword', email, password);
  }
}
