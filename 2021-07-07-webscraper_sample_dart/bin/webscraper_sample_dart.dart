import 'package:webscraper_sample_dart/webscraper_sample_dart.dart'
    as webscraper_sample_dart;

void main(List<String> arguments) async {
  print('Hello world: ${webscraper_sample_dart.calculate()}!');
  var weather = await webscraper_sample_dart.getTodaysTokyoWeather();
  print('tokyo is ${weather}');
}
