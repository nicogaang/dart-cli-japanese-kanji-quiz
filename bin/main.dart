import 'dart:io';
import 'package:dart_cli_japanese_kanji_quiz/dictionary_api_client.dart';

Future<void> main() async {
  stdout.write('Search for Kanji : ');
  //final line = stdin.readLineSync().toString();
  final line = '馬鹿';
  //final firstLine = line[0];
  final api = DictionaryApiClient();
  try {
    final kanjis = await api.fetchDictionary(line);
    for (var kanji in kanjis) {
      print(kanji);
    }
  } on DictionaryApiException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}
