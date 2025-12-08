// lib/services/hardware_services.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:navic_ss/models/gnss_satellite.dart';

// ============ HELPER FUNCTIONS ============

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  if (value is num) return value != 0;
  return false;
}

String _parseString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

List<dynamic> _convertJavaList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return List<dynamic>.from(value);
  }
  return [];
}

List<String> _convertJavaStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return List<String>.from(value.whereType<String>());
  }
  return [];
}

Map<String, dynamic> _convertJavaMap(dynamic value) {
  if (value == null) return {};
  if (value is Map) {
    final Map<String, dynamic> result = {};
    for (final entry in value.entries) {
      final key = entry.key.toString();
      final val = entry.value;
      
      if (val is Map) {
        result[key] = _convertJavaMap(val);
      } else if (val is List) {
        result[key] = _convertJavaList(val);
      } else if (val is num) {
        result[key] = val.toDouble();
      } else if (val is String) {
        result[key] = val;
      } else if (val is bool) {
        result[key] = val;
      } else {
        result[key] = val?.toString() ?? '';
      }
    }
    return result;
  }
  return {};
}

// ============ GNSS SATELLITE CONVERSION ============

List<GnssSatellite> _convertToGnssSatellites(List<dynamic> javaList) {
  final List<GnssSatellite> converted = [];
  
  for (final item in javaList) {
    if (item is Map) {
      try {
        final Map<String, dynamic> satMap = {};
        
        for (final entry in item.entries) {
          final key = entry.key.toString();
          final value = entry.value;
          
          // Convert Java types to Dart types
          if (value == null) {
            satMap[key] = null;
          } else if (value is num) {
            satMap[key] = value.toDouble();
          } else if (value is bool) {
            satMap[key] = value;
          } else if (value is String) {
            satMap[key] = value;
          } else if (value is List) {
            satMap[key] = _convertJavaList(value);
          } else if (value is Map) {
            satMap[key] = _convertJavaMap(value);
          } else {
            satMap[key] = value.toString();
          }
        }
        
        // Create GnssSatellite from map
        final satellite = GnssSatellite.fromMap(satMap);
        converted.add(satellite);
        
      } catch (e) {
        print('⚠️ Error converting satellite: $e');
      }
    }
  }
  
  return converted;
}

List<Map<String, dynamic>> _convertJavaSatelliteList(List<dynamic> javaList) {
  final List<Map<String, dynamic>> converted = [];
  
  for (final item in javaList) {
    if (item is Map) {
      final Map<String, dynamic> sat = {};
      
      for (final entry in item.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        
        // Convert Java types to Dart types
        if (value == null) {
          sat[key] = null;
        } else if (value is num) {
          sat[key] = value.toDouble();
        } else if (value is bool) {
          sat[key] = value;
        } else if (value is String) {
          sat[key] = value;
        } else if (value is List) {
          sat[key] = _convertJavaList(value);
        } else if (value is Map) {
          sat[key] = _convertJavaMap(value);
        } else {
          sat[key] = value.toString();
        }
      }
      
      converted.add(sat);
    }
  }
  
  return converted;
}

// ============ DATA CLASSES ============

class NavicDetectionResult {
  final bool isSupported;
  final bool isActive;
  final int satelliteCount;
  final int totalSatellites;
  final int usedInFixCount;
  final String detectionMethod;
  final double confidenceLevel;
  final double averageSignalStrength;
  final String chipsetType;
  final String chipsetVendor;
  final String chipsetModel;
  final bool hasL5Band;
  final String positioningMethod;
  final String primarySystem;
  final Map<String, dynamic> l5BandInfo;
  final List<dynamic> allSatellites;
  final String? message;
  final List<String> verificationMethods;
  final double acquisitionTimeMs;
  final List<dynamic> satelliteDetails;

  // NEW: Added GnssSatellite lists
  List<GnssSatellite> get gnssSatellites => _convertToGnssSatellites(allSatellites);
  List<GnssSatellite> get gnssSatelliteDetails => _convertToGnssSatellites(satelliteDetails);

  const NavicDetectionResult({
    required this.isSupported,
    required this.isActive,
    required this.satelliteCount,
    required this.totalSatellites,
    required this.usedInFixCount,
    required this.detectionMethod,
    required this.confidenceLevel,
    required this.averageSignalStrength,
    required this.chipsetType,
    required this.chipsetVendor,
    required this.chipsetModel,
    required this.hasL5Band,
    required this.positioningMethod,
    required this.primarySystem,
    required this.l5BandInfo,
    required this.allSatellites,
    this.message,
    this.verificationMethods = const [],
    this.acquisitionTimeMs = 0.0,
    this.satelliteDetails = const [],
  });

  factory NavicDetectionResult.fromMap(Map<String, dynamic> map) {
    // Handle Java Object types properly
    return NavicDetectionResult(
      isSupported: _parseBool(map['isSupported']),
      isActive: _parseBool(map['isActive']),
      satelliteCount: _parseInt(map['satelliteCount']),
      totalSatellites: _parseInt(map['totalSatellites']),
      usedInFixCount: _parseInt(map['usedInFixCount']),
      detectionMethod: _parseString(map['detectionMethod']),
      confidenceLevel: _parseDouble(map['confidenceLevel']),
      averageSignalStrength: _parseDouble(map['averageSignalStrength']),
      chipsetType: _parseString(map['chipsetType']),
      chipsetVendor: _parseString(map['chipsetVendor']),
      chipsetModel: _parseString(map['chipsetModel']),
      hasL5Band: _parseBool(map['hasL5Band']),
      positioningMethod: _parseString(map['positioningMethod']),
      primarySystem: _parseString(map['primarySystem']),
      l5BandInfo: _convertJavaMap(map['l5BandInfo']),
      allSatellites: _convertJavaList(map['allSatellites']),
      message: map['message'] as String?,
      verificationMethods: _convertJavaStringList(map['verificationMethods']),
      acquisitionTimeMs: _parseDouble(map['acquisitionTimeMs']),
      satelliteDetails: _convertJavaList(map['satelliteDetails']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isSupported': isSupported,
      'isActive': isActive,
      'satelliteCount': satelliteCount,
      'totalSatellites': totalSatellites,
      'usedInFixCount': usedInFixCount,
      'detectionMethod': detectionMethod,
      'confidenceLevel': confidenceLevel,
      'averageSignalStrength': averageSignalStrength,
      'chipsetType': chipsetType,
      'chipsetVendor': chipsetVendor,
      'chipsetModel': chipsetModel,
      'hasL5Band': hasL5Band,
      'positioningMethod': positioningMethod,
      'primarySystem': primarySystem,
      'l5BandInfo': l5BandInfo,
      'allSatellites': allSatellites,
      'message': message,
      'verificationMethods': verificationMethods,
      'acquisitionTimeMs': acquisitionTimeMs,
      'satelliteDetails': satelliteDetails,
    };
  }

  @override
  String toString() {
    return 'NavicDetectionResult(isSupported: $isSupported, isActive: $isActive, '
        'satelliteCount: $satelliteCount, totalSatellites: $totalSatellites, '
        'hasL5Band: $hasL5Band, positioningMethod: $positioningMethod)';
  }
}

class PermissionResult {
  final bool granted;
  final String message;
  final Map<String, bool>? permissions;

  const PermissionResult({
    required this.granted,
    required this.message,
    this.permissions,
  });

  factory PermissionResult.fromMap(Map<String, dynamic> map) {
    return PermissionResult(
      granted: _parseBool(map['granted']),
      message: _parseString(map['message']),
      permissions: map['permissions'] as Map<String, bool>?,
    );
  }

  @override
  String toString() {
    return 'PermissionResult(granted: $granted, message: $message)';
  }
}

// ============ NAVIC HARDWARE SERVICE ============

class NavicHardwareService {
  static const MethodChannel _channel = MethodChannel('navic_support');
  
  // Callback handlers
  static Function(Map<String, dynamic>)? _permissionResultCallback;
  static Function(Map<String, dynamic>)? _satelliteUpdateCallback;
  static Function(Map<String, dynamic>)? _locationUpdateCallback;
  static Function(Map<String, dynamic>)? _satelliteMonitorCallback;

  static void initialize() {
    _channel.setMethodCallHandler(_handleMethodCall);
    print('✅ NavicHardwareService initialized');
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    print('📱 MethodChannel received: ${call.method}');
    
    try {
      switch (call.method) {
        case 'onPermissionResult':
          final result = call.arguments as Map<String, dynamic>;
          print('🔑 Permission result received');
          _permissionResultCallback?.call(result);
          break;
        case 'onSatelliteUpdate':
          final data = call.arguments as Map<String, dynamic>;
          print('🛰️ Satellite update received: ${data.length} items');
          _satelliteUpdateCallback?.call(data);
          break;
        case 'onLocationUpdate':
          final data = call.arguments as Map<String, dynamic>;
          print('📍 Location update received');
          _locationUpdateCallback?.call(data);
          break;
        case 'onSatelliteMonitorUpdate':
          final data = call.arguments as Map<String, dynamic>;
          print('📡 Satellite monitor update received');
          _satelliteMonitorCallback?.call(data);
          break;
        default:
          print('⚠️ Unknown method call: ${call.method}');
      }
    } catch (e) {
      print('❌ Error handling method call ${call.method}: $e');
    }
    return null;
  }

  // ============ MAIN NAVIC DETECTION ============

  /// Check NavIC hardware support - main method
  static Future<NavicDetectionResult> checkNavicHardware() async {
    try {
      print('🔍 Calling checkNavicHardware on Java side');
      final result = await _channel.invokeMethod('checkNavicHardware');
      print('✅ checkNavicHardware response received');
      
      if (result is Map) {
        final resultMap = Map<String, dynamic>.from(result);
        return NavicDetectionResult.fromMap(resultMap);
      } else {
        print('❌ Unexpected response type from checkNavicHardware: ${result.runtimeType}');
        return _getErrorResult('Invalid response type: ${result.runtimeType}');
      }
    } on PlatformException catch (e) {
      print('❌ PlatformException in checkNavicHardware: ${e.message}');
      return _getErrorResult(e.message ?? 'PlatformException');
    } catch (e) {
      print('❌ Error in checkNavicHardware: $e');
      return _getErrorResult(e.toString());
    }
  }

  static NavicDetectionResult _getErrorResult(String errorMessage) {
    return NavicDetectionResult(
      isSupported: false,
      isActive: false,
      satelliteCount: 0,
      totalSatellites: 0,
      usedInFixCount: 0,
      detectionMethod: 'ERROR',
      confidenceLevel: 0.0,
      averageSignalStrength: 0.0,
      chipsetType: 'ERROR',
      chipsetVendor: 'ERROR',
      chipsetModel: 'ERROR',
      hasL5Band: false,
      positioningMethod: 'ERROR',
      primarySystem: 'GPS',
      l5BandInfo: {},
      allSatellites: [],
      message: 'Error: $errorMessage',
    );
  }

  // ============ PERMISSION METHODS ============

  /// Check location permissions
  static Future<PermissionResult> checkLocationPermissions() async {
    try {
      final result = await _channel.invokeMethod('checkLocationPermissions');
      final resultMap = Map<String, dynamic>.from(result as Map);
      return PermissionResult.fromMap(resultMap);
    } on PlatformException catch (e) {
      print('Error checking permissions: ${e.message}');
      return PermissionResult(
        granted: false,
        message: e.message ?? 'Permission check failed',
      );
    }
  }

  /// Request location permissions
  static Future<PermissionResult> requestLocationPermissions() async {
    try {
      final result = await _channel.invokeMethod('requestLocationPermissions');
      final resultMap = Map<String, dynamic>.from(result as Map);
      return PermissionResult.fromMap(resultMap);
    } on PlatformException catch (e) {
      print('Error requesting permissions: ${e.message}');
      return PermissionResult(
        granted: false,
        message: e.message ?? 'Permission request failed',
      );
    }
  }

  // ============ REAL-TIME MONITORING ============

  /// Start real-time detection
  static Future<Map<String, dynamic>> startRealTimeDetection() async {
    try {
      final result = await _channel.invokeMethod('startRealTimeDetection');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error starting real-time detection: ${e.message}');
      return {'success': false, 'message': 'Failed to start: ${e.message}'};
    }
  }

  /// Stop real-time detection
  static Future<Map<String, dynamic>> stopRealTimeDetection() async {
    try {
      final result = await _channel.invokeMethod('stopRealTimeDetection');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error stopping real-time detection: ${e.message}');
      return {'success': false, 'message': 'Failed to stop: ${e.message}'};
    }
  }

  // ============ LOCATION UPDATES ============

  /// Start location updates
  static Future<bool> startLocationUpdates() async {
    try {
      final result = await _channel.invokeMethod('startLocationUpdates');
      final Map<String, dynamic> data = Map<String, dynamic>.from(result as Map);
      return data['success'] as bool? ?? false;
    } on PlatformException catch (e) {
      print('Error starting location updates: ${e.message}');
      return false;
    }
  }

  /// Stop location updates
  static Future<bool> stopLocationUpdates() async {
    try {
      final result = await _channel.invokeMethod('stopLocationUpdates');
      final Map<String, dynamic> data = Map<String, dynamic>.from(result as Map);
      return data['success'] as bool? ?? false;
    } on PlatformException catch (e) {
      print('Error stopping location updates: ${e.message}');
      return false;
    }
  }

  // ============ SATELLITE MONITORING ============

  /// Start satellite monitoring
  static Future<Map<String, dynamic>> startSatelliteMonitoring() async {
    try {
      final result = await _channel.invokeMethod('startSatelliteMonitoring');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error starting satellite monitoring: ${e.message}');
      return {'success': false, 'message': 'Failed to start: ${e.message}'};
    }
  }

  /// Stop satellite monitoring
  static Future<Map<String, dynamic>> stopSatelliteMonitoring() async {
    try {
      final result = await _channel.invokeMethod('stopSatelliteMonitoring');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error stopping satellite monitoring: ${e.message}');
      return {'success': false, 'message': 'Failed to stop: ${e.message}'};
    }
  }

  // ============ SATELLITE DATA METHODS ============

  /// Get all satellites
  static Future<Map<String, dynamic>> getAllSatellites() async {
    try {
      final result = await _channel.invokeMethod('getAllSatellites');
      final data = Map<String, dynamic>.from(result as Map);
      
      // Convert satellites to GnssSatellite objects
      if (data.containsKey('satellites') && data['satellites'] is List) {
        final satellites = data['satellites'] as List<dynamic>;
        final gnssSatellites = _convertToGnssSatellites(satellites);
        data['gnssSatellites'] = gnssSatellites;
      }
      
      return data;
    } on PlatformException catch (e) {
      print('Error getting all satellites: ${e.message}');
      return {'hasData': false, 'satellites': [], 'message': e.message};
    }
  }

  /// Get all satellites in range
  static Future<Map<String, dynamic>> getAllSatellitesInRange() async {
    try {
      final result = await _channel.invokeMethod('getAllSatellitesInRange');
      final data = Map<String, dynamic>.from(result as Map);
      
      // Convert satellites list to proper format
      if (data.containsKey('satellites')) {
        final satellites = data['satellites'];
        if (satellites is List) {
          // Keep both formats for compatibility
          data['satellites'] = _convertJavaSatelliteList(satellites);
          data['gnssSatellites'] = _convertToGnssSatellites(satellites);
        }
      }
      
      return data;
    } on PlatformException catch (e) {
      print('Error getting satellites in range: ${e.message}');
      return {'hasData': false, 'satellites': [], 'message': e.message};
    }
  }

  // ============ GNSS CAPABILITIES ============

  /// Get GNSS capabilities
  static Future<Map<String, dynamic>> getGnssCapabilities() async {
    try {
      final result = await _channel.invokeMethod('getGnssCapabilities');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting GNSS capabilities: ${e.message}');
      return {};
    }
  }

  // ============ SYSTEM INFORMATION ============

  /// Get device info
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final result = await _channel.invokeMethod('getDeviceInfo');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting device info: ${e.message}');
      return {};
    }
  }

  /// Check if location is enabled
  static Future<Map<String, dynamic>> isLocationEnabled() async {
    try {
      final result = await _channel.invokeMethod('isLocationEnabled');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error checking location status: ${e.message}');
      return {};
    }
  }

  // ============ SETTINGS ============

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    try {
      final result = await _channel.invokeMethod('openLocationSettings');
      final Map<String, dynamic> data = Map<String, dynamic>.from(result as Map);
      return data['success'] as bool? ?? false;
    } on PlatformException catch (e) {
      print('Error opening location settings: ${e.message}');
      return false;
    }
  }

  // ============ ENHANCED SATELLITE METHODS (From Java) ============

  /// Get GNSS range statistics
  static Future<Map<String, dynamic>> getGnssRangeStatistics() async {
    try {
      final result = await _channel.invokeMethod('getGnssRangeStatistics');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting GNSS range statistics: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get detailed satellite info
  static Future<Map<String, dynamic>> getDetailedSatelliteInfo() async {
    try {
      final result = await _channel.invokeMethod('getDetailedSatelliteInfo');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting detailed satellite info: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get complete satellite summary
  static Future<Map<String, dynamic>> getCompleteSatelliteSummary() async {
    try {
      final result = await _channel.invokeMethod('getCompleteSatelliteSummary');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting complete satellite summary: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get satellite names
  static Future<Map<String, dynamic>> getSatelliteNames() async {
    try {
      final result = await _channel.invokeMethod('getSatelliteNames');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting satellite names: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get constellation details
  static Future<Map<String, dynamic>> getConstellationDetails() async {
    try {
      final result = await _channel.invokeMethod('getConstellationDetails');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting constellation details: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get signal strength analysis
  static Future<Map<String, dynamic>> getSignalStrengthAnalysis() async {
    try {
      final result = await _channel.invokeMethod('getSignalStrengthAnalysis');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting signal strength analysis: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get elevation azimuth data
  static Future<Map<String, dynamic>> getElevationAzimuthData() async {
    try {
      final result = await _channel.invokeMethod('getElevationAzimuthData');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting elevation azimuth data: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get carrier frequency info
  static Future<Map<String, dynamic>> getCarrierFrequencyInfo() async {
    try {
      final result = await _channel.invokeMethod('getCarrierFrequencyInfo');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting carrier frequency info: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get ephemeris almanac status
  static Future<Map<String, dynamic>> getEphemerisAlmanacStatus() async {
    try {
      final result = await _channel.invokeMethod('getEphemerisAlmanacStatus');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting ephemeris almanac status: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get satellite detection history
  static Future<Map<String, dynamic>> getSatelliteDetectionHistory() async {
    try {
      final result = await _channel.invokeMethod('getSatelliteDetectionHistory');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting satellite detection history: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get GNSS diversity report
  static Future<Map<String, dynamic>> getGnssDiversityReport() async {
    try {
      final result = await _channel.invokeMethod('getGnssDiversityReport');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting GNSS diversity report: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get real-time satellite stream
  static Future<Map<String, dynamic>> getRealTimeSatelliteStream() async {
    try {
      final result = await _channel.invokeMethod('getRealTimeSatelliteStream');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting real-time satellite stream: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  /// Get satellite signal quality
  static Future<Map<String, dynamic>> getSatelliteSignalQuality() async {
    try {
      final result = await _channel.invokeMethod('getSatelliteSignalQuality');
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Error getting satellite signal quality: ${e.message}');
      return {'hasData': false, 'message': e.message};
    }
  }

  // ============ CALLBACK SETUP METHODS ============

  /// Set permission result callback
  static void setPermissionResultCallback(Function(Map<String, dynamic>) callback) {
    print('🔑 Setting permission result callback');
    _permissionResultCallback = callback;
  }

  static void removePermissionResultCallback() {
    print('🔑 Removing permission result callback');
    _permissionResultCallback = null;
  }

  /// Set satellite update callback
  static void setSatelliteUpdateCallback(Function(Map<String, dynamic>) callback) {
    print('🛰️ Setting satellite update callback');
    _satelliteUpdateCallback = callback;
  }

  static void removeSatelliteUpdateCallback() {
    print('🛰️ Removing satellite update callback');
    _satelliteUpdateCallback = null;
  }

  /// Set location update callback
  static void setLocationUpdateCallback(Function(Map<String, dynamic>) callback) {
    print('📍 Setting location update callback');
    _locationUpdateCallback = callback;
  }

  static void removeLocationUpdateCallback() {
    print('📍 Removing location update callback');
    _locationUpdateCallback = null;
  }

  /// Set satellite monitor callback
  static void setSatelliteMonitorCallback(Function(Map<String, dynamic>) callback) {
    print('📡 Setting satellite monitor callback');
    _satelliteMonitorCallback = callback;
  }

  static void removeSatelliteMonitorCallback() {
    print('📡 Removing satellite monitor callback');
    _satelliteMonitorCallback = null;
  }

  // ============ UTILITY METHODS ============

  /// Test method to verify channel communication
  static Future<bool> testChannelConnection() async {
    try {
      await _channel.invokeMethod('checkNavicHardware');
      print('✅ Channel connection test successful');
      return true;
    } catch (e) {
      print('❌ Channel connection test failed: $e');
      return false;
    }
  }

  /// Get method channel name (for debugging)
  static String get channelName => 'navic_support';
}