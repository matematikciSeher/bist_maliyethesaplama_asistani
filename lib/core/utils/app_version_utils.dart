/// Semantik sürüm karşılaştırması (`1.0.10` > `1.0.9`).
int compareVersions(String a, String b) {
  final pa = a.split('.').map((part) => int.tryParse(part) ?? 0).toList();
  final pb = b.split('.').map((part) => int.tryParse(part) ?? 0).toList();
  final length = pa.length > pb.length ? pa.length : pb.length;

  for (var i = 0; i < length; i++) {
    final va = i < pa.length ? pa[i] : 0;
    final vb = i < pb.length ? pb[i] : 0;
    if (va != vb) return va.compareTo(vb);
  }
  return 0;
}

bool isVersionAtLeast(String version, String minimum) {
  if (minimum.isEmpty) return false;
  return compareVersions(version, minimum) >= 0;
}
