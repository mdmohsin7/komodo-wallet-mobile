import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:komodo_dex/utils/log.dart';
import 'package:package_info/package_info.dart';

class UpdatesProvider extends ChangeNotifier {
  UpdatesProvider() {
    _init();
  }

  bool isFetching = false;
  UpdateStatus status;
  String currentVersion;
  String newVersion;

  // TODO(yurii): change url to actual app version checker endpoint
  final String url = 'http://yurii-khi.com/version.html';

  Future<void> check() => _check();

  Future<void> _init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;

    notifyListeners();
  }

  Future<void> _check() async {
    isFetching = true;
    newVersion = null;
    status = null;
    notifyListeners();

    http.Response response;
    Map<String, dynamic> json;

    try {
      response = await http.post(
        url,
        body: jsonEncode({
          'currentVersion': currentVersion,
        }),
      );

      json = jsonDecode(response.body);
    } catch (e) {
      Log('updates_provider:47', '_check] $e');

      isFetching = false;
      status = UpdateStatus.upToDate;
      notifyListeners();
      return;
    }

    final String jsonVersion = json['newVersion'];
    if (jsonVersion != null) {
      if (jsonVersion.compareTo(currentVersion) > 0) {
        newVersion = jsonVersion;
      } else {
        isFetching = false;
        status = UpdateStatus.upToDate;
        notifyListeners();
        return;
      }
    }

    switch (json['status']) {
      case 'upToDate':
        {
          status = UpdateStatus.upToDate;
          break;
        }
      case 'available':
        {
          status = UpdateStatus.available;
          break;
        }
      case 'recommended':
        {
          status = UpdateStatus.recommended;
          break;
        }
      case 'required':
        {
          status = UpdateStatus.required;
          break;
        }
      default:
        status =
            newVersion == null ? UpdateStatus.upToDate : UpdateStatus.available;
    }

    isFetching = false;
    notifyListeners();
  }
}

enum UpdateStatus {
  upToDate,
  available,
  recommended,
  required,
}
