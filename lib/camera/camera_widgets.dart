import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:photo_job/camera/camera_store.dart';
import 'package:photo_job/core/app_page_view.dart';

class TakePhotoPage extends StatelessWidget {
  final CameraStore store;

  final void Function(BuildContext context) onEscape;
  final void Function(BuildContext context) onCancel;
  final void Function(BuildContext context) onAccept;

  TakePhotoPage(
      {Key key,
      @required this.store,
      @required this.onEscape,
      @required this.onAccept,
      @required this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      child: Column(children: <Widget>[
        Text(
          'How about a quick selfie?',
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Observer(
                  builder: (_) => store.isCameraReady
                      ? CircleAvatar(child: CameraPreview(store.controller))
                      : CircleAvatar(
                          color: Colors.grey,
                          child: Text(
                            'No Camera',
                            style: TextStyle(color: Colors.grey),
                          ))),
              Observer(
                builder: (_) => Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CircleAvatar(
                          borderWidth: 5,
                          color: store.isCameraReady
                              ? Colors.redAccent
                              : Colors.grey,
                          child: store.capturedPhotoFile != null
                              ? Image.file(File(store.capturedPhotoFile),
                                  fit: BoxFit.fitWidth)
                              : Text('Your Photo'),
                        ),
                      ),
                    ),
              )
            ],
          ),
        ),
        _buildActionButtonBar(context),
      ]),
    );
  }

  Observer _buildActionButtonBar(BuildContext context) {
    return Observer(
      builder: (_) => store.isCameraReady
          ? Column(
              children: <Widget>[
                CupertinoButton(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side: BorderSide(
                                    color: Colors.redAccent, width: 3)),
                            color: Colors.white),
                        child: Icon(
                          CupertinoIcons.photo_camera_solid,
                          size: 40,
                        )),
                    onPressed: store.takePicture),
                CupertinoButton(
                  child: Text('Looks good'),
                  onPressed: () => onAccept(context),
                )
              ],
            )
          : Container(),
    );
  }
}

class CircleAvatar extends StatelessWidget {
  CircleAvatar(
      {@required this.child,
      this.color = Colors.redAccent,
      this.backgroundColor = Colors.white,
      this.borderWidth = 10});

  final double borderWidth;

  final Color color;
  final Color backgroundColor;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: CircleBorder()),
        child: child,
      ),
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: borderWidth, color: color),
          shape: BoxShape.circle),
    );
  }
}
