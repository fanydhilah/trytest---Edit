import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:tts/tts.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatAppp extends StatefulWidget {
  ChatAppp({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _ChatApppState createState() => _ChatApppState();
}

class _ChatApppState extends State<ChatAppp> {
  // speech to text
  stt.SpeechToText _speech;
  bool _isListening = false; //speech to text
  String _text = "";
  // String speak;
  String qry;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // final FlutterTts flutterTts = FlutterTts();

  response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/newagent-kalbgl-c0fb323bfb4c.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.indonesian);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });

    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

//   INI LIBRARY TTS
//   speak() async {
//   Tts.setLanguage('jv-ID');
//   Tts.speak(messsages.text);
// }

  // INI LIBRARY FLUTTER_TTS
  // void _speak(query) async {
  //   print(await flutterTts.getLanguages);
  //   await flutterTts.setLanguage('jv-ID');
  //   await flutterTts.speak(query.toString());
  // }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Jawa Bot",
          ),
          backgroundColor: Colors.cyan[900],
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.15), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  "Dinten Niki, ${DateFormat("Hm").format(DateTime.now())}",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(10.0),
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 5.0,
              color: Colors.greenAccent,
            ),
            Container(
                child: ListTile(
              leading: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.greenAccent,
                  size: 35,
                ),
                onPressed: () {
                  //tombol mic
                  _listen();
                  if (_text == "") {
                    print("empty message");
                  } else {
                    setState(() {
                      messsages.insert(0, {"data": 1, "message": _text});
                      response(_text);
                      // _speak(response(_text));
                      _text = '';
                    });
                  }
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
              ),
              title: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1)),
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: TextField(
                      controller: messageInsert,
                      decoration: InputDecoration(
                        hintText: "Send Your Message",
                        hintStyle: TextStyle(color: Colors.black26),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )),
                  ],
                ),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.send, size: 30, color: Colors.greenAccent),
                  onPressed: () {
                    //tombol kirim
                    if (messageInsert.text.isEmpty) {
                      print("empty message");
                    } else {
                      setState(() {
                        messsages.insert(
                            0, {"data": 1, "message": messageInsert.text});
                      });
                      response(messageInsert.text);
                      // speak = response(messageInsert.text);
                      // _speak(speak);
                      messageInsert.clear();
                    }
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  }),
            )),
            SizedBox(
              height: 15.0,
            )
          ]),
        ));
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(15.0),
                color: data == 0
                    ? Color.fromRGBO(23, 157, 139, 1)
                    : Colors.orangeAccent,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _listen() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (!_isListening) {
      if (available) {
        setState(() {
          _isListening = true;
          _speech.listen(
            onResult: (val) => setState(() {
              _text = val.recognizedWords;
            }),
          );
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }
}
