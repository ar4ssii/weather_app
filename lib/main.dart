import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

void main() {
  runApp(const MyApp());
}
class AnimatedWeatherIcon extends StatefulWidget {
  final IconData iconData;
  final String? weatherCondition;

  const AnimatedWeatherIcon({Key? key, required this.iconData, this.weatherCondition})
      : super(key: key);

  @override
  _AnimatedWeatherIconState createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulsatingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _pulsatingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.weatherCondition?.toLowerCase()) {
      case 'clear':
      case 'snow':
        return RotationTransition(
          turns: _controller,
          child: Icon(
            widget.iconData,
            size: 100,
            color: Colors.grey[700],
          ),
        );
      case 'clouds':
      case 'rain':
      case 'drizzle':
      case 'mist':
        return FadeTransition(
          opacity: _opacityAnimation,
          child: Icon(
            widget.iconData,
            size: 100,
            color: Colors.grey[700],
          ),
        );
      case 'thunderstorm':
        return ScaleTransition(
          scale: _pulsatingAnimation,
          child: Icon(
            widget.iconData,
            size: 100,
            color: Colors.grey[700],
          ),
        );
      default:
        return Icon(
          widget.iconData,
          size: 100,
          color: Colors.grey[700],
        );
    }
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
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Simple Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _weatherService = WeatherService('ef288eea93121e9009e1c4c9e8343167');
  Weather? _weather;
  final TextEditingController _searchController = TextEditingController();

  _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
      setState(() {
        _weather = null; // Set weather to null to indicate no data available
      });
    }
  }

  _showCitySearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search City'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter city name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String cityName = _searchController.text;
                _fetchWeather(cityName);
                Navigator.of(context).pop();
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather('Arayat'); // Initial city
  }

  IconData _getWeatherIcon(String? description) {
    switch (description?.toLowerCase()) {
      case 'clear':
        return FontAwesomeIcons.sun;
      case 'clouds':
        return FontAwesomeIcons.cloud;
      case 'rain':
        return FontAwesomeIcons.cloudRain;
      case 'snow':
        return FontAwesomeIcons.snowflake;
      case 'thunderstorm':
        return FontAwesomeIcons.cloudBolt;
      case 'mist':
        return FontAwesomeIcons.smog;
      case 'drizzle':
        return FontAwesomeIcons.cloudRain;
    // Add more cases for other weather conditions as needed
      default:
        return FontAwesomeIcons.questionCircle; // Default icon
    }
  }

  final TextStyle _darkGrayTextStyle =
  TextStyle(fontSize: 18, color: Colors.grey[700], fontFamily: 'Poppins');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showCitySearchDialog(context);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.grey[700]),
                  Text(
                    _weather?.cityName ?? 'Invalid City Name or City Name is incorrect',
                    style: _darkGrayTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedWeatherIcon(
                    iconData: _getWeatherIcon(_weather?.mainCondition),
                    weatherCondition: _weather?.mainCondition,
                  ),
                  Text(
                    '${_weather?.temperature.round() ?? '0'}°C',
                    style: TextStyle(fontSize: 50, color: Colors.grey[700], fontFamily: 'Poppins'),
                  ),
                  Text(_weather?.description ?? 'loading information',
                    style: TextStyle(fontSize: 30, color: Colors.grey[700], fontFamily: 'Poppins'),)
                ],
              ),
            ),
            Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather?.mainCondition ?? 'loading information',
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
