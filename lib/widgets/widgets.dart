import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mydemo_tabnavi2/styles.dart';

/// A simple "close this modal" button that invokes a callback when pressed.
class okCircleButton extends StatefulWidget {
  final VoidCallback onPressed;
  double size;
  Color bgColor;
  IconData icon;

  okCircleButton({this.size, this.bgColor, this.icon, this.onPressed});

  @override
  okCircleButtonState createState() {
    return okCircleButtonState();
  }
}

class okCircleButtonState extends State<okCircleButton> {
  bool tapInProgress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) {
          setState(() => tapInProgress = true);
        },
        onTapUp: (details) {
          setState(() => tapInProgress = false);
          widget.onPressed();
        },
        onTapCancel: () {
          setState(() => tapInProgress = false);
        },
        child: ClipOval(
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size / 2.0),
              color: widget.bgColor,
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 20,
              ),
            ),
          ),
        ));
  }
}

class okCircleImage extends StatelessWidget {
  final double size;

  String imagePath;
  Color bgColor;

  okCircleImage.image({this.size, this.imagePath});

  okCircleImage.color({this.size, this.bgColor});

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (imagePath != null) {
      widget = Container(
          width: size,
          height: size,
          child: Image.asset(imagePath, fit: BoxFit.fitHeight));
    } else {
      widget = Container(
        width: size,
        height: size,
        color: bgColor,
      );
    }

    return ClipOval(child: widget);
  }
}

class okSelectableIcon extends StatefulWidget {
  final void Function(bool sel) onChangeState;

  final double iconSize;
  final bool initSelected;
  final IconData iconDataOn;
  final IconData iconDataOff;
  final Color iconColor;

  const okSelectableIcon(
      {this.iconDataOn,
      this.iconDataOff,
      this.initSelected,
      this.onChangeState,
      this.iconSize = 30,
      this.iconColor = Colors.blue});

  @override
  okSelectableIconState createState() {
    return okSelectableIconState();
  }
}

class okSelectableIconState extends State<okSelectableIcon> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.initSelected;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
            widget.onChangeState(selected);
          });
        },
        child: Container(
            width: widget.iconSize,
            height: widget.iconSize,
            child: Icon(
                selected ? widget.iconDataOn : widget.iconDataOff,
                size: widget.iconSize,
            color : widget.iconColor)));
  }
}

typedef ChangeStateCallback = void Function(bool on);

class okSelectableLabel extends StatefulWidget {
  final ChangeStateCallback onChangeState;
  final String label;
  final initSelected;

  const okSelectableLabel(this.label, this.initSelected, this.onChangeState);

  @override
  okSelectableLabelState createState() {
    return okSelectableLabelState();
  }
}

class okSelectableLabelState extends State<okSelectableLabel> {
  bool selected = false;

  @override
  void initState()
  {
    super.initState();
    selected = widget.initSelected;
  }

  @override
  Widget build(BuildContext context) {
    Widget label = Text(
      widget.label,
      textAlign: TextAlign.justify,
      style: Styles.font15Text,
    );

    Widget box = Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        decoration: BoxDecoration(
            color: selected ? Colors.blueAccent : Colors.grey,
            borderRadius: BorderRadius.circular(12)),
        child: label);

    Widget padding = Padding(
      padding: EdgeInsets.all(5),
      child: box,
    );

    return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
            widget.onChangeState(selected);
          });
        },
        child: padding);
  }
}

class okPressableWidget extends StatelessWidget{

  final Widget child;
  final void Function() onPressed;

  const okPressableWidget(this.child, this.onPressed);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onPressed,
      child: this.child,
    );
  }

}

abstract class CommonWidgets {
  static Widget buildRoundButton({String title, Color color}) {}
}


class okBoxText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color bgColor;

  okBoxText({this.text, this.style, this.bgColor}) ;

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor ,
        borderRadius: BorderRadius.circular(2.0)
      ),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: Text(text, style: style,)),
    );
  }

}


class okBoxLineText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color bgColor;

  okBoxLineText({this.text, this.style, this.bgColor}) ;

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: bgColor ,
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(color: Colors.white)
      ),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: Text(text, style: style,)),
    );
  }

}