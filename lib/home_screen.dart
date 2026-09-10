import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'control_center.dart';
import 'settings_screen.dart';
import 'layout_store.dart';
import 'wallpaper_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _channel = MethodChannel('ios_launcher/system');

  List<LauncherApp> apps = [];
  double iconSize = 58;
  bool labels = true;
  bool dark = true;
  int columns = 4;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await _channel.invokeMethod<List<dynamic>>('installedApps');
      apps = (raw ?? []).map((e) => LauncherApp.fromMap(Map<dynamic, dynamic>.from(e))).toList();
    } catch (_) {}
    iconSize = await LayoutStore.iconSize();
    labels = await LayoutStore.showLabels();
    dark = await LayoutStore.darkMode();
    columns = await LayoutStore.gridColumns();
    if (mounted) setState(() {});
  }

  Future<void> _launch(LauncherApp app) async {
    await _channel.invokeMethod('launchApp', {'packageName': app.packageName});
  }

  Color _iconColor(int i) {
    final colors = [
      Colors.blue, Colors.green, Colors.orange, Colors.purple,
      Colors.red, Colors.teal, Colors.indigo, Colors.pink,
    ];
    return colors[i % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final chunks = <List<LauncherApp>>[];
    final perPage = columns * 5;
    for (var i = 0; i < apps.length; i += perPage) {
      chunks.add(apps.sublist(i, i + perPage > apps.length ? apps.length : i + perPage));
    }
    if (chunks.isEmpty) chunks.add([]);

    return Theme(
      data: dark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      child: Scaffold(
        body: Container(
          decoration: WallpaperService.decoration(dark: dark),
          child: SafeArea(
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) < -700) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const ControlCenter(),
                  );
                }
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
                    child: Row(
                      children: [
                        Text(
                          TimeOfDay.now().format(context),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Settings',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SettingsScreen()),
                            );
                            _load();
                          },
                          icon: const Icon(Icons.tune),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      itemCount: chunks.length,
                      onPageChanged: (v) => setState(() => page = v),
                      itemBuilder: (_, index) {
                        final list = chunks[index];
                        return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 20,
                            childAspectRatio: .78,
                          ),
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final app = list[i];
                            return InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => _launch(app),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: iconSize,
                                    height: iconSize,
                                    decoration: BoxDecoration(
                                      color: _iconColor(i),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 12, offset: Offset(0, 5), color: Colors.black26),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      app.label.isEmpty ? '?' : app.label.characters.first.toUpperCase(),
                                      style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                  ),
                                  if (labels) ...[
                                    const SizedBox(height: 7),
                                    Text(
                                      app.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (chunks.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        chunks.length,
                        (i) => Container(
                          width: i == page ? 7 : 5,
                          height: i == page ? 7 : 5,
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == page ? Colors.white : Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.14),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Search apps')),
                        IconButton(
                          onPressed: _load,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
