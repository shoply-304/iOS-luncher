class LauncherApp {
  final String packageName;
  final String label;

  const LauncherApp({
    required this.packageName,
    required this.label,
  });

  factory LauncherApp.fromMap(Map<dynamic, dynamic> map) {
    return LauncherApp(
      packageName: map['packageName']?.toString() ?? '',
      label: map['label']?.toString() ?? '',
    );
  }
}
