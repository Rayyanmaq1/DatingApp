import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';

popUp(context) {
  Future.delayed(Duration(seconds: 5), () {
    return showSecondOverlay(context);
  });
  showOverlay(context);
}

showSecondOverlay(context) {
  OverlayState overlayState = Overlay.of(context);

  OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.09,
                child: CustomPaint(
                  painter: TrianglePainter(
                    strokeColor: greyColor,
                    strokeWidth: 10,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  child: Container(
                    height: SizeConfig.heightMultiplier * 2,
                    width: SizeConfig.widthMultiplier * 8,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.21,
                left: MediaQuery.of(context).size.width * 0.09,
                child: Material(
                  child: Container(
                    color: greyColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/PopUp1.jpg'),
                              )),
                              decoration: BoxDecoration(
                                color: purpleColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: greyColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Store Is now here',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.heightMultiplier * 1.7),
                                  ),
                                  Text(
                                    'Access to the new Function has been Changed From perivous Version',
                                    style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize:
                                            SizeConfig.heightMultiplier * 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: SizeConfig.widthMultiplier * 45,
                    height: SizeConfig.heightMultiplier * 44,
                  ),
                ),
              ),
            ],
          ));
  Future.delayed(Duration(seconds: 4), () {
    overlayEntry.remove();
  });
  Future.delayed(Duration(milliseconds: 500), () {
    overlayState.insert(overlayEntry);
  });
}

showOverlay(BuildContext context) async {
  OverlayState overlayState = Overlay.of(context);

  OverlayEntry overlayEntryFirst = OverlayEntry(
      builder: (context) => Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.13,
                left: MediaQuery.of(context).size.width * 0.1,
                child: CustomPaint(
                  painter: TrianglePainter(
                    strokeColor: greyColor,
                    strokeWidth: 10,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  child: Container(
                    height: SizeConfig.heightMultiplier * 2,
                    width: SizeConfig.widthMultiplier * 8,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.14,
                left: MediaQuery.of(context).size.width * 0.1,
                child: Material(
                  child: Container(
                    color: greyColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/PopUp2.jpg'),
                              )),
                              decoration: BoxDecoration(
                                color: purpleColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: greyColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Account is now here',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.heightMultiplier * 1.7),
                                  ),
                                  Text(
                                    'Access to the new Function has been Changed From perivous Version',
                                    style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize:
                                            SizeConfig.heightMultiplier * 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: SizeConfig.widthMultiplier * 45,
                    height: SizeConfig.heightMultiplier * 44,
                  ),
                ),
              ),
            ],
          ));
  Future.delayed(Duration(seconds: 4), () {
    overlayEntryFirst.remove();
  });
  Future.delayed(Duration(milliseconds: 500), () {
    overlayState.insert(overlayEntryFirst);
  });
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
