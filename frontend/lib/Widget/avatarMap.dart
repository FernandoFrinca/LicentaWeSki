import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'customTriangle.dart';

class avatarMap extends StatelessWidget {
  final String avatarImage;
  final double size;

  const avatarMap({
    super.key,
    required this.avatarImage,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0,3),
                spreadRadius: 2,
                blurRadius: 3
              )
            ]
          ),
          child:ClipOval(
              child:Image.network(
                avatarImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, color: Colors.white);
                },
              ),
          ),
        ),
        Transform.rotate(
          angle: 3.14159,
          child: ClipPath(
            clipper: customTriangle(),
            child: Container(
              width: size/5,
              height: size/5,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
          ),
        ),

      ],
    );
  }
}

Future<BitmapDescriptor> avatarMapToBitmapDescriptor({
  required BuildContext context,
  required String avatarImage,
  double size = 50.0,
}) async {

  final GlobalKey repaintKey = GlobalKey();


  final overlayEntry = OverlayEntry(
    builder: (_) => Center(
      child: Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 0,
          child: RepaintBoundary(
            key: repaintKey,
            child: avatarMap(
              avatarImage: avatarImage,
              size: size,
            ),
          ),
        ),
      ),
    ),
  );


  final overlay = Overlay.of(context, rootOverlay: true);
  overlay.insert(overlayEntry);


  await Future.delayed(const Duration(milliseconds: 50));


  final RenderRepaintBoundary boundary =
  repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

  final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

  final ByteData? byteData = (await image.toByteData(format: ui.ImageByteFormat.png));
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  overlayEntry.remove();


  return BitmapDescriptor.fromBytes(pngBytes);
}