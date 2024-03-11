class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String description;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temperature,
    required this.description
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json["name"],
      temperature: (json["main"]['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description']
    );
  }
}
