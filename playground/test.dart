
void main()
{
  String isoTime = "PT15M51S";
  List<String> _list = isoTime.split(RegExp('[A-Z]+'));

 // isoTime.allMatches(string);

  final iReg = RegExp(r'(\d+)');

  var list = iReg.allMatches(isoTime).map((m) => m.group(0)).toList();


  for(var s in list)
    {
      print("-->"+s);
    }

}