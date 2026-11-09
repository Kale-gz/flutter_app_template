import 'dart:io';
import 'package:image/image.dart' as img;

/// A simple code-generated placeholder. Replace the PNGs with your own artwork.
void main() {
  Directory('assets/icons').createSync(recursive: true);
  for (final layer in [
    'app_icon',
    'app_icon_foreground',
    'app_icon_monochrome',
  ]) {
    final image = img.Image(width: 1024, height: 1024, numChannels: 4);
    img.fill(
      image,
      color: layer == 'app_icon'
          ? img.ColorRgba8(36, 87, 197, 255)
          : img.ColorRgba8(0, 0, 0, 0),
    );
    final white = img.ColorRgba8(255, 255, 255, 255);
    // A window with three bars, kept inside the adaptive icon safe area.
    img.fillRect(image, x1: 332, y1: 332, x2: 692, y2: 402, color: white);
    img.fillRect(image, x1: 332, y1: 477, x2: 562, y2: 547, color: white);
    img.fillRect(image, x1: 332, y1: 622, x2: 692, y2: 692, color: white);
    File('assets/icons/$layer.png').writeAsBytesSync(img.encodePng(image));
  }
}
