import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class AnimatedSunnyIcon extends StatefulWidget {
  @override
  _AnimatedSunnyIconState createState() => _AnimatedSunnyIconState();
}

class _AnimatedSunnyIconState extends State<AnimatedSunnyIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        FontAwesomeIcons.sun,
        size: 150, // Adjust the size as needed
        color: Colors.amber,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Weather App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simple Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextStyle _darkGrayTextStyle = TextStyle(fontSize: 18, color: Colors.grey[700],fontFamily: 'Poppins',);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins',),
        ),
      ),
      body: Center(
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center contents of the first column horizontally
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[700]),
                    Text('Arayat', style: _darkGrayTextStyle),
                  ],
                ),
              ),
              Expanded(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSunnyIcon(),
                    Text(
                      '16°C',
                      style:  TextStyle(fontSize: 50, color: Colors.grey[700],fontFamily: 'Poppins',),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center contents of the first column horizontally
                  children: [
                    Text(
                      'Malamig parang siya',
                      style: _darkGrayTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
