import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';

import '../styles.dart';

class VideoCompletedDialog extends StatelessWidget {

  final LessonVideo desc;

  VideoCompletedDialog(this.desc) ;

  static Future<bool> showDialogImpl(BuildContext context, LessonVideo desc) async {
    bool reponse = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return VideoCompletedDialog(desc);
        });

    return reponse ?? false;
  }

  void closeDialog(BuildContext context, bool ok) {
    Navigator.of(context).pop(ok);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      // width: 400,
      height: 400,
      decoration: BoxDecoration(
          color: Colors.indigoAccent, borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: <Widget>[
          Positioned(top: 30, left: 0, right: 0, child: _buildMark()),
          Positioned(top: 160, left: 0, right: 0, child: _buildMessage()),
          Positioned(bottom: 90, left: 30, right: 30, child: _buildOKButton(context)),
          Positioned(
              bottom: 30, left: 30, right: 30, child: _buildCancelButton(context))
        ],
      ),
    );
  }

  Widget _buildMessage() {
    String title = '${desc.title}';

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Styles.font16Text,
      ),
    );
  }

  Widget _buildMark() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Icon(
        Icons.check,
        size: 50,
      ),
    );
  }

  Widget _buildOKButton(BuildContext context) {

    String title = '강의를 완료하였습니다';

    return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          height: 45,
          decoration:  BoxDecoration(
              color: Styles.greenButtonColor, borderRadius: BorderRadius.circular(4)),
          child: Text(
            title,
            style: Styles.font14Text,
          ),
          //color: Styles.greenButtonColor,
        ),
        onTap: () {
          closeDialog(context, true);
        });
  }

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration:  BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(4)),

          child: Text(
            "아직 강의를 완료하지 않았습니다",
            style: Styles.font14Text,
          ),
          //color: Colors.black45,
        ),
        onTap: () {
          closeDialog(context, false);
        });
  }
}
