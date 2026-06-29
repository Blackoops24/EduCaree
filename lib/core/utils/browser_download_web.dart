// ignore_for_file: deprecated_member_use

import 'dart:html' as html;

Future<bool> triggerBrowserDownload({
  required String fileName,
  required String base64Data,
}) async {
  final anchor = html.AnchorElement(
    href: 'data:application/octet-stream;base64,$base64Data',
  )
    ..setAttribute('download', fileName)
    ..click();
  anchor.remove();
  return true;
}