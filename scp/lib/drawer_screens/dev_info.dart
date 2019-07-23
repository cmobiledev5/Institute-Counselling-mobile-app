import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final String ABOUT_TEXT="Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

class DevInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(25, 39, 45, 1),
          title: Text(
            "Developer Info",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'PfDin',
                fontWeight: FontWeight.w600),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Center(
                child: Text(
                  "ABOUT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PfDin',
                    color: Color.fromRGBO(74, 232, 190, 1),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25, top: 20,bottom: 30),
              child: Text(ABOUT_TEXT,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'PfDin',
                  color: Color.fromRGBO(25, 39, 45, 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  "DEVELOPERS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PfDin',
                    color: Color.fromRGBO(74, 232, 190, 1),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                contactCard(context, "Chinmay Kabi", "https://github.com/Chinmay-KB"),
                contactCard(context, "Smarak Das", "https://github.com/Thesmader"),
                contactCard(context, "Ankesh Anku", "https://github.com/ankank30"),

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget contactCard(BuildContext context,String name,String contact){
    var queryWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          if(contact!=""){
            _launchURL(contact);
          }
          else{}
        },
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: textScaleFactor*20,
                        fontFamily: 'PfDin',
                        fontWeight: FontWeight.w800
                    ),),
                ),

                Text(contact,
                  style: TextStyle(
                      fontSize: textScaleFactor*15,
                      fontFamily: 'PfDin',
                      fontWeight: FontWeight.w800
                  ),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
