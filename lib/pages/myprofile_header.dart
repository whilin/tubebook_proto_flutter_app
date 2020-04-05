
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles.dart';

class MyProfileHeader extends StatefulWidget {
  @override
  _MyProfileHeaderState createState() => _MyProfileHeaderState();
}

class _MyProfileHeaderState extends State<MyProfileHeader> {
  ImageProvider _myPhotoProvier;

  String _myName = '';

  void initState() {
    super.initState();
    _myPhotoProvier = AssetImage('assets/images/person-placeholder.jpg');
    loadSavedProfilePhoto();
    getMyName();
  }

  void didUpdateWidget(Widget oldWidget){
    super.didUpdateWidget(oldWidget);
    loadSavedProfilePhoto();
    getMyName();
  }
  //File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024);

    var imageBytes = await image.readAsBytes();
    final directory = await getApplicationDocumentsDirectory();
    var photoFile = File('${directory.path}/profile_photo.jpg');
    await photoFile.writeAsBytes(imageBytes);

    setState(() {
      //_image = image;
      _myPhotoProvier = FileImage(image);
    });
  }

  Future loadSavedProfilePhoto() async {
    final directory = await getApplicationDocumentsDirectory();
    var photoFile = File('${directory.path}/profile_photo.jpg');

    if (await photoFile.exists()) {
      setState(() {
        _myPhotoProvier = FileImage(photoFile);
      });
    }
  }

  void setMyName(String newName) async {
    _myName = newName;
    var inst = await SharedPreferences.getInstance();
    inst.setString('player_name', _myName);
    setState(() {

    });
  }

  void getMyName() async {
    var inst = await SharedPreferences.getInstance();
    var name = inst.get('player_name');
    _myName = name ?? '';
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        top: true,
        child: Container(
          // height: 100,
          //color: Colors.red,
            child: Column(
              children: <Widget>[
                GestureDetector(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _myPhotoProvier,
                    ),
                    onTap: () {
                      getImage();
                    }),
                //Text('_____', style: Styles.font20Text),
                _buildInputName(),
              ],
            )));
  }

  Widget _buildInputName() {
    return SizedBox(
        width: 200,
        child: Stack(
          // alignment: Alignment.bottomCenter,
            children: [
              TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  textAlign: TextAlign.center,
                  style: Styles.font20Text,
                  controller: TextEditingController(text: _myName),
                  onTap: () {},
                  onSubmitted: (text) {
                    setMyName(text);
                  }),
              //Divider(),
            ]));
  }
}