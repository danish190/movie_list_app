import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:movie_list_app/model/movie_model.dart';

void main() {
  group('Movie Model Tests', () {
    test('Movie creation and initial values', () {
      final movie = Movie(
        title: 'Inception',
        description: 'A mind-bending thriller by Christopher Nolan.', isFavourite: false,
      );

      expect(movie.title, 'Inception');
      expect(movie.description, 'A mind-bending thriller by Christopher Nolan.');
      expect(movie.isFavourite, false);
    });

    test('Toggle favourite status', () {
      final movie = Movie(
        title: 'Inception',
        description: 'A mind-bending thriller by Christopher Nolan.', isFavourite: false,
      );

      // Initially not a favourite
      expect(movie.isFavourite, false);

      // Mark as favourite
      movie.isFavourite = true;
      expect(movie.isFavourite, true);

      // Unmark as favourite
      movie.isFavourite = false;
      expect(movie.isFavourite, false);
    });

    test('Update movie details', () {
      final movie = Movie(
        title: 'Inception',
        description: 'A mind-bending thriller by Christopher Nolan.', isFavourite: false,
      );

      // Update title
      movie.title = 'Interstellar';
      expect(movie.title, 'Interstellar');

      // Update description
      movie.description = 'A space exploration epic by Christopher Nolan.';
      expect(movie.description, 'A space exploration epic by Christopher Nolan.');
    });
  });
}