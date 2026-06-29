import 'browser_download_stub.dart'
    if (dart.library.html) 'browser_download_web.dart' as impl;

Future<bool> triggerBrowserDownload({
  required String fileName,
  required String base64Data,
}) {
  return impl.triggerBrowserDownload(fileName: fileName, base64Data: base64Data);
}