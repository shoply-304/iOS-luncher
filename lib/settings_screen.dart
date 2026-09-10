import 'package:flutter/material.dart';
import 'layout_store.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double iconSize = 58;
  bool labels = true;
  bool dark = true;
  int columns = 4;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    iconSize = await LayoutStore.iconSize();
    labels = await LayoutStore.showLabels();
    dark = await LayoutStore.darkMode();
    columns = await LayoutStore.gridColumns();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Launcher Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Home Screen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Grid columns'),
            subtitle: Text('$columns columns'),
            trailing: DropdownButton<int>(
              value: columns,
              items: [3, 4, 5, 6].map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(),
              onChanged: (v) async {
                if (v == null) return;
                await LayoutStore.setGridColumns(v);
                setState(() => columns = v);
              },
            ),
          ),
          ListTile(
            title: const Text('Icon size'),
            subtitle: Slider(
              value: iconSize,
              min: 44,
              max: 76,
              onChanged: (v) async {
                setState(() => iconSize = v);
                await LayoutStore.setIconSize(v);
              },
            ),
          ),
          SwitchListTile(
            title: const Text('App labels'),
            value: labels,
            onChanged: (v) async {
              setState(() => labels = v);
              await LayoutStore.setShowLabels(v);
            },
          ),
          SwitchListTile(
            title: const Text('Dark appearance'),
            value: dark,
            onChanged: (v) async {
              setState(() => dark = v);
              await LayoutStore.setDarkMode(v);
            },
          ),
          const Divider(height: 32),
          const Text('System', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const ListTile(
            leading: Icon(Icons.home),
            title: Text('Default Home app'),
            subtitle: Text('Choose this launcher from Android Home settings.'),
          ),
        ],
      ),
    );
  }
}
