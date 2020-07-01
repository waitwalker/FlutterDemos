/// Download task utils

/// String url = 'http://cdn5.hd.etiantian.net/ffd894324daf10e288b01a22a8771d95/5C868504/etthd/cyyw000021/400.mp4';
/// getMp4UrlId(url)
/// output: cyyw000021
getMp4UrlId(Uri uri) {
  if (uri.isScheme('http') || uri.isScheme('https')) {
    List<String> segments = uri.pathSegments;
    if (segments.length == 5) {
      return segments[3];
    }
  }
  return null;
}

main(List<String> args) {
  String url =
      'http://cdn5.hd.etiantian.net/ffd894324daf10e288b01a22a8771d95/5C868504/etthd/cyyw000021/400.mp4';
  print(getMp4UrlId(Uri.parse(url)));

  /// output cyyw000021
}
