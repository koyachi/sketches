import 'package:web_scraper/web_scraper.dart';

int calculate() {
  return 10;
}

Future<String> getTodaysTokyoWeather() async {
  final webScraper = WebScraper('https://weather.yahoo.co.jp');

  if (await webScraper.loadWebPage('/weather/jp/13/4410.html')) {
    var titles = webScraper.getElementTitle(
        '#main > div.forecastCity > table > tbody > tr > td:nth-child(1) > div > p.pict');
    return titles.first.trim();
  } else {
    return '';
  }
}
