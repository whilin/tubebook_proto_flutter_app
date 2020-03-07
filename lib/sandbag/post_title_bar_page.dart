import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostTitleBarPage extends StatelessWidget {
  double _imageHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: <Widget>[_buildImage(context), _buildTopHeader()],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Image.network(
            'https://images.pexels.com/photos/1531677/pexels-photo-1531677.jpeg?cs=srgb&dl=gray-concrete-post-tunnel-1531677.jpg&fm=jpg',
            fit: BoxFit.cover,
            height: _imageHeight,
            width: MediaQuery.of(context).size.width,
            colorBlendMode: BlendMode.srcOver,
            color: Colors.black12));
  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.menu, size: 32.0, color: Colors.white),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, size.height * 0.75);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
