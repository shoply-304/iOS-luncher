import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ControlCenter extends StatelessWidget {
  const ControlCenter({super.key});

  static const _channel = MethodChannel('ios_launcher/system');

  Future<void> _open(String method) async {
    try {
      await _channel.invokeMethod(method);
    } catch (_) {}
  }

  Widget tile(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            height: 82,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(.12)
                  : Colors.black.withOpacity(.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.82),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1C1D21).withOpacity(.96)
                  : Colors.white.withOpacity(.96),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 18),
                Row(children: [
                  tile(context, Icons.wifi, 'Wi‑Fi', () => _open('openWifi')),
                  tile(context, Icons.bluetooth, 'Bluetooth', () => _open('openBluetooth')),
                ]),
                Row(children: [
                  tile(context, Icons.flight, 'Airplane', () => _open('openNetwork')),
                  tile(context, Icons.settings_brightness, 'Display', () => _open('openDisplay')),
                ]),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.brightness_6),
                    const SizedBox(width: 10),
                    Expanded(child: Slider(value: .65, onChanged: (_) {})),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.volume_up),
                    const SizedBox(width: 10),
                    Expanded(child: Slider(value: .75, onChanged: (_) {})),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _open('openSystemSettings'),
                    icon: const Icon(Icons.settings),
                    label: const Text('Android Settings'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
