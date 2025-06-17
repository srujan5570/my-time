import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Time',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Time'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _clientIdController = TextEditingController();
  bool _isServiceRunning = false;
  String _uptime = '00:00:00';
  Timer? _uptimeTimer;
  DateTime? _startTime;
  String _ipAddress = 'Loading...';
  String _location = 'Loading...';
  String _country = 'Loading...';
  String _city = 'Loading...';
  bool _isCheckingIp = false;
  bool _isIpUnique = false;
  String? _ipCheckMessage;

  // Method channel for communicating with native code
  static const platform = MethodChannel('com.example.my_time/service');

  DateTime _getLast930PMIST() {
    final now = DateTime.now().toUtc().add(
      const Duration(hours: 5, minutes: 30),
    );
    DateTime last930 = DateTime(now.year, now.month, now.day, 21, 30);
    if (now.isBefore(last930)) {
      last930 = last930.subtract(const Duration(days: 1));
    }
    return last930.subtract(
      const Duration(hours: 5, minutes: 30),
    ); // back to UTC
  }

  DateTime _getNext930PMIST() {
    final now = DateTime.now().toUtc().add(
      const Duration(hours: 5, minutes: 30),
    );
    DateTime next930 = DateTime(now.year, now.month, now.day, 21, 30);
    if (!now.isBefore(next930)) {
      next930 = next930.add(const Duration(days: 1));
    }
    return next930.subtract(
      const Duration(hours: 5, minutes: 30),
    ); // back to UTC
  }

  Future<void> _checkIpUnique() async {
    setState(() {
      _isCheckingIp = true;
      _isIpUnique = false;
      _ipCheckMessage = null;
    });
    if (_ipAddress == 'Unknown' || _ipAddress.startsWith('Error')) {
      setState(() {
        _isCheckingIp = false;
        _isIpUnique = false;
        _ipCheckMessage = 'Could not fetch IP. Please try again.';
      });
      return;
    }
    try {
      final last930 = _getLast930PMIST();
      final next930 = _getNext930PMIST();
      final query =
          await FirebaseFirestore.instance
              .collection('ip_usage')
              .where('ip', isEqualTo: _ipAddress)
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: last930.toIso8601String(),
              )
              .where('timestamp', isLessThan: next930.toIso8601String())
              .get();
      setState(() {
        _isCheckingIp = false;
        _isIpUnique = query.docs.isEmpty;
        _ipCheckMessage =
            _isIpUnique
                ? null
                : 'This IP has already been used in the current window. Please change your IP.';
      });
    } catch (e) {
      setState(() {
        _isCheckingIp = false;
        _isIpUnique = false;
        _ipCheckMessage = 'Error checking IP uniqueness: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchIpInfo();
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _uptimeTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchIpInfo() async {
    setState(() {
      _ipAddress = 'Loading...';
      _location = 'Loading...';
      _country = 'Loading...';
      _city = 'Loading...';
      _isCheckingIp = true;
      _isIpUnique = false;
      _ipCheckMessage = null;
    });
    bool success = false;
    // Try ipapi.co first
    try {
      final response = await http.get(Uri.parse('https://ipapi.co/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _ipAddress = data['ip'] ?? 'Unknown';
          _country = data['country_name'] ?? 'Unknown';
          _city = data['city'] ?? 'Unknown';
          _location = '${data['latitude']}, ${data['longitude']}';
        });
        await _checkIpUnique();
        success = true;
      }
    } catch (_) {}
    // Fallback: ipify for IP, then ip-api.com for location
    if (!success) {
      try {
        final ipRes = await http.get(
          Uri.parse('https://api.ipify.org?format=json'),
        );
        if (ipRes.statusCode == 200) {
          final ipData = json.decode(ipRes.body);
          final ip = ipData['ip'] ?? 'Unknown';
          final locRes = await http.get(
            Uri.parse('http://ip-api.com/json/$ip'),
          );
          if (locRes.statusCode == 200) {
            final locData = json.decode(locRes.body);
            setState(() {
              _ipAddress = ip;
              _country = locData['country'] ?? 'Unknown';
              _city = locData['city'] ?? 'Unknown';
              _location = '${locData['lat']}, ${locData['lon']}';
            });
            await _checkIpUnique();
            success = true;
          }
        }
      } catch (_) {}
    }
    // If all fail
    if (!success) {
      setState(() {
        _ipAddress = 'Error: Could not fetch IP';
        _location = '-';
        _country = '-';
        _city = '-';
        _isCheckingIp = false;
        _isIpUnique = false;
        _ipCheckMessage =
            'Could not fetch IP from any service. Please check your internet connection or try again later.';
      });
    }
  }

  Future<void> _writeIpInfoToFirestore() async {
    try {
      final nowUtc = DateTime.now().toUtc();
      final nowIst = nowUtc.add(const Duration(hours: 5, minutes: 30));
      await FirebaseFirestore.instance.collection('ip_usage').add({
        'ip': _ipAddress,
        'country': _country,
        'city': _city,
        'location': _location,
        'timestamp': nowUtc.toIso8601String(),
        'timestamp_ist': nowIst.toIso8601String(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to write to Firestore: $e')),
      );
    }
  }

  void _startService() {
    if (_clientIdController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a client ID')));
      return;
    }
    setState(() {
      _isServiceRunning = true;
      _startTime = DateTime.now();
    });
    _uptimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_startTime != null) {
        final now = DateTime.now();
        final difference = now.difference(_startTime!);
        setState(() {
          _uptime =
              '${difference.inHours.toString().padLeft(2, '0')}:'
              '${(difference.inMinutes % 60).toString().padLeft(2, '0')}:'
              '${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
        });
        // Vibrate after 6 minutes (360 seconds)
        if (difference.inSeconds == 360) {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 3000); // 3 seconds long vibration
          }
        }
      }
    });
    // Write IP info to Firestore
    _writeIpInfoToFirestore();
    // Try to start the native service
    try {
      platform.invokeMethod('startService', {
        'clientId': _clientIdController.text,
      });
    } catch (e) {
      print('Error starting service: $e');
    }
  }

  void _stopService() {
    setState(() {
      _isServiceRunning = false;
      _startTime = null;
      _uptime = '00:00:00';
    });
    _uptimeTimer?.cancel();

    // Try to stop the native service
    try {
      platform.invokeMethod('stopService');
    } catch (e) {
      print('Error stopping service: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _clientIdController,
              decoration: InputDecoration(
                labelText: Platform.isIOS ? 'Client ID' : 'CastarSdk Client ID',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_ipCheckMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _ipCheckMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed:
                      (_isServiceRunning || !_isIpUnique || _isCheckingIp)
                          ? null
                          : _startService,
                  child:
                      _isCheckingIp
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            Platform.isIOS
                                ? 'Start Service'
                                : 'Start CastarSdk',
                          ),
                ),
                ElevatedButton(
                  onPressed: _isServiceRunning ? _stopService : null,
                  child: Text(
                    Platform.isIOS ? 'Stop Service' : 'Stop CastarSdk',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Uptime',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _uptime,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IP Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('IP Address: $_ipAddress'),
                    Text('Location: $_location'),
                    Text('Country: $_country'),
                    Text('City: $_city'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _fetchIpInfo,
                      child: const Text('Refresh IP Info'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
