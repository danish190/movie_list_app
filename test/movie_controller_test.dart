import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_app/controller%20/movie_controller.dart';
import 'package:movie_list_app/model/movie_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the getApplicationDocumentsDirectory method
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      final directory = Directory.systemTemp.createTempSync();
      return directory.path;
    }
    return null;
  });

  group('MovieController Tests', () {
    late MovieController movieController;

    setUpAll(() async {
      await Hive.initFlutter();
      Hive.registerAdapter(MovieAdapter());
      await Hive.openBox<Movie>('movies');
    });


    tearDownAll(() async {
      await Hive.deleteBoxFromDisk('movies');
    });

    setUp(() {
      movieController = MovieController();
      movieController.onInit();
    });

    tearDown(() async {
      await Hive.box<Movie>('movies').clear();
    });

    test('Initial movie list should be empty', () {
      expect(movieController.movieList.length, 0);
    });

    test('Add movie to the list', () {
      movieController.addMovie('Inception', 'A mind-bending thriller by Christopher Nolan.');

      expect(movieController.movieList.length, 1);
      expect(movieController.movieList[0].title, 'Inception');
      expect(movieController.movieList[0].description, 'A mind-bending thriller by Christopher Nolan.');
      expect(movieController.movieList[0].isFavourite, false);
    });

    test('Remove movie from the list', () {
      movieController.addMovie('Inception', 'A mind-bending thriller by Christopher Nolan.');
      movieController.addMovie('Interstellar', 'A space exploration epic by Christopher Nolan.');

      expect(movieController.movieList.length, 2);

      movieController.removeMovie(0);

      expect(movieController.movieList.length, 1);
      expect(movieController.movieList[0].title, 'Interstellar');
    });

    test('Toggle favourite status', () {
      movieController.addMovie('Inception', 'A mind-bending thriller by Christopher Nolan.');

      expect(movieController.movieList[0].isFavourite, false);

      movieController.toggleFavourite(0);

      expect(movieController.movieList[0].isFavourite, true);

      movieController.toggleFavourite(0);

      expect(movieController.movieList[0].isFavourite, false);
    });
  });
}