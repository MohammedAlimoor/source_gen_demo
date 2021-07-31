class FeatureFamcare {
  final String label;

  const FeatureFamcare({this.label});
}

class FCApi {
  final String url;
  final Map<dynamic, dynamic> header;
  final String method;

  const FCApi({this.url = '', this.header, this.method});
}
