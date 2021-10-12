import 'dart:io';

import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class LocationUtils {
  static const _platform = const MethodChannel('google_map_location_picker');
  static Map<String, String> _appHeaderCache = {};

  static Future<Map<String, String>> getAppHeaders() async {
    if (_appHeaderCache.isEmpty) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      if (Platform.isIOS) {
        _appHeaderCache = {
          "X-Ios-Bundle-Identifier": packageInfo.packageName,
        };
      } else if (Platform.isAndroid) {
        try {
          String? sha1;
          try {
            sha1 = await _platform.invokeMethod(
                'getSigningCertSha1', packageInfo.packageName);
          } on PlatformException {
            _appHeaderCache = {};
          }

          _appHeaderCache = {
            "X-Android-Package": packageInfo.packageName,
            "X-Android-Cert": sha1!,
          };
        } catch (e) {
          print('Error with sha1' + e.toString());
        }
      }
    }
    // todo figure out how to fix generated code error, then push

    return _appHeaderCache;
  }
}
