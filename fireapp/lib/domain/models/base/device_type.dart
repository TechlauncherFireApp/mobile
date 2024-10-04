enum DeviceType {
  android(name: "android"),
  ios(name: "ios"),
  unknown(name: "unknown");

  const DeviceType({
    required this.name
  });

  final String name;
}