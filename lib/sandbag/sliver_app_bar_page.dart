import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'post_title_bar_page.dart';

class SliverAppBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: CustomScrollView(slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: MySliverAppBar(
              expandedHeight: 200
            ),
          ),
      SliverAppBar(
        expandedHeight: 160.0,
        floating: true,
        pinned: false,
        actions: [IconButton(icon: Icon(Icons.close), onPressed: () {})],
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
//        flexibleSpace: Placeholder(),
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
          titlePadding : EdgeInsets.only(bottom: 0),
            title: CircleAvatar(
              minRadius: 0,
              maxRadius: 40,
              backgroundColor: Colors.amber,
            ), //Text('Title'),
            background: ClipPath(
                clipper: DialogonalClipper(),
                child: Image.network(
                  'https://images.pexels.com/photos/1531677/pexels-photo-1531677.jpeg?cs=srgb&dl=gray-concrete-post-tunnel-1531677.jpg&fm=jpg',
                  fit: BoxFit.cover,
                )),
            collapseMode: CollapseMode.parallax),
      ),
      SliverList(
        delegate:SliverChildBuilderDelegate ((context, index) {
          return ListTile(title : Text('title $index'));
        }),
      )
//      SliverFillRemaining(
//        child: Center(
//            child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[Text('You have pushed...'), Text('Hello')],
//        )),
//      )
    ]));
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Image.network(
          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          fit: BoxFit.cover,
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              "MySliverAppBar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: FlutterLogo(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
