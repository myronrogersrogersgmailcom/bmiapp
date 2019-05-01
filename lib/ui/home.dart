import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
//import 'package:bmiapp/ui/speech_recognition.dart';

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class Bmi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BmiState();
  }
}

class BmiState extends State<Bmi> {
  //speech
  String transcription = '';
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  int REQ_CODE;
  static const int REQ_CODE_AGE = 99;
  static const int REQ_CODE_HEIGHT = 98;
  static const int REQ_CODE_WEIGHT = 97;
 // FocusNode ageFocusNode;
 // FocusNode weightFocusNode;
 // FocusNode heightFocusNode;
  int pass = 0;
 //String text;
// String previousText;
  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
   // ageFocusNode = FocusNode();
   // weightFocusNode = FocusNode();
  //  heightFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
  //  ageFocusNode.dispose();
  //  weightFocusNode.dispose();
  //  heightFocusNode.dispose();
    super.dispose();
  }

  // speech
  final TextEditingController _ageController = new TextEditingController();
  final TextEditingController _heightController = new TextEditingController();
  final TextEditingController _weightController = new TextEditingController();
  double inches = 0.0;
  double result = 0.0;
  String _resultReading = "";
  bool _icon1 = false;

  String _finalResult = "";
  void _doIt() {
    debugPrint("Alright!");
  }

  void _onPress() {
    print("Search Tapped!");
    setState(() {
      switch (_icon1) {
        case true:
          {
            print("Excellent");
            _icon1 = false;
            stop();
            //  _isListening ? () => stop() : null;
          }
          break;
        case false:
          {
            print("Good");
            _icon1 = true;
            REQ_CODE = REQ_CODE_AGE;
            setState(() => _ageController.text = "");
            setState(() => _heightController.text = "");
            setState(() => _weightController.text = "");

         //   FocusScope.of(context).requestFocus(ageFocusNode);

            start();
           }
          break;
      }
    });
  }

  void _turnOff() {
    print("Search Tapped!");
    setState(() {
      print("Excellent");
      _icon1 = false;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);

    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);

    //  _speech.setErrorHandler(errorHandler);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  void _calculateBMI() {
    //Resourse 1: https://www.bcbst.com/providers/MPMTools/BMICalculator.shtm
    //Resource 2:  http://www.epic4health.com/bmiformula.html

//
//    BMI	Weight Status
//    Below 18.5	Underweight
//    18.5 – 24.9	Normal
//    25.0 – 29.9	Overweight
//    30.0 and Above	Obese

    setState(() {
      int age = int.parse(_ageController.text);
      double height = double.parse(_heightController.text);
      inches = height * 12;
      double weight = double.parse(_weightController.text);

      if ((_ageController.text.isNotEmpty || age > 0) &&
          ((_heightController.text.isNotEmpty || inches > 0) &&
              (_weightController.text.isNotEmpty || weight > 0))) {
        result = weight / (inches * inches) * 703; // our BMI

        //Do the reading
        if (double.parse(result.toStringAsFixed(1)) < 18.5) {
          _resultReading = "Underweight";
          print(_resultReading);
        } else if (double.parse(result.toStringAsFixed(1)) >= 18.5 &&
            result < 25) {
          _resultReading = "Great Shape!"; // Normal
          print(_resultReading);
        } else if (double.parse(result.toStringAsFixed(1)) >= 25.0 &&
            result < 30) {
          _resultReading = "Overweight";
        } else if (double.parse(result.toStringAsFixed(1)) >= 30.0) {
          _resultReading = "Obese";
        }
      } else {
        result = 0.0;
      }
    });

    _finalResult = "Your BMI: ${result.toStringAsFixed(1)}";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('BMI'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: <Widget>[
          _icon1
              ? new IconButton(icon: new Icon(Icons.mic), onPressed: _onPress)
              : new IconButton(
                  icon: new Icon(Icons.mic_off), onPressed: _onPress),

        ],
      ),
      body: new Container(
        alignment: Alignment.topCenter,
        child: new ListView(
          padding: const EdgeInsets.all(2.0),
          children: <Widget>[
            new Image.asset(
              'images/bmilogo.png',
              height: 85.0,
              width: 75.0,
            ),
            new Container(
              margin: const EdgeInsets.all(3.0),
              height: 300.0,
              width: 290.0,
              color: Colors.grey.shade300,
              child: new Column(
                children: <Widget>[
                  new TextField(
                 //   focusNode: ageFocusNode,
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        labelText: 'Age',
                        hintText: 'e.g: 34',
                        icon: new Icon(Icons.person_outline)),
                  ),

                  new TextField(
                 //     focusNode: heightFocusNode,
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: 'Height in feet  ',
                          hintText: 'e.g 6.5',
                          icon: new Icon(Icons.insert_chart))),
                  new Text(
                    "  *( Say 6 point 5 if the Height is 6\'5\" ) ",
                    style: new TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0),
                  ),
                  new TextField(
                   //   focusNode: weightFocusNode,
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: 'Weight in lbs',
                          hintText: 'e.g 180',
                          icon: new Icon(Icons.line_weight))),

                  new Padding(padding: new EdgeInsets.all(10.6)),

                  //calculate button
                ],
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "$_finalResult ",
                  style: new TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 19.9),
                ),
                new Padding(padding: const EdgeInsets.all(5.0)),
                new Text(
                  "$_resultReading ",
                  style: new TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 19.9),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  void start() => _speech
      .listen(locale: selectedLang.code)
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
        debugPrint("STOP REQUESTED!");
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) {

  }

 void onRecognitionComplete(String text) => setState(() {

   if (text != "") {
     if (REQ_CODE == REQ_CODE_WEIGHT) {
       setState(() => _weightController.text = text);
       _isListening = false;
       _turnOff();
       _calculateBMI();
     }
   if (REQ_CODE == REQ_CODE_HEIGHT) {
     setState(() => _heightController.text = text);
     REQ_CODE = REQ_CODE_WEIGHT;

     start();
   }
   if (REQ_CODE == REQ_CODE_AGE) {
     setState(() => _ageController.text = text);
     debugPrint(text);
     REQ_CODE = REQ_CODE_HEIGHT;

     start();
   }
 }

  } );

  void errorHandler() => activateSpeechRecognizer();
}
