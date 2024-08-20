import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_app/main.dart'; // Import your main app file
import 'package:movie_list_app/model/movie_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the getApplicationDocumentsDirectory method
  setUpAll(() async {
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        final directory = Directory.systemTemp.createTempSync();
        return directory.path;
      }
      return null;
    });

    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(MovieAdapter());
    await Hive.openBox<Movie>('movies');
  });

  tearDownAll(() async {
    await Hive.box<Movie>('movies').clear();
    await Hive.deleteBoxFromDisk('movies');
  });

  testWidgets('Movie list app displays correctly', (WidgetTester tester) async {
    // Build the movie list app and trigger a frame
    await tester.pumpWidget(MovieListApp());

    final addMovieFinder = find.text('Add Movie');


    // Find the 'Add Movie' button
    final Finder addMovieButton = find.text('Add Movie');

    // Verify the button is found
    expect(addMovieButton, findsOneWidget);

    // Perform actions or assertions
    await tester.tap(addMovieButton);
    await tester.pump();

    // Verify that the "Add Movie" button is present
    expect(find.text('Add Movie'), findsOneWidget);
    expect(addMovieFinder, findsOneWidget);


    // Verify that the movie list is initially empty
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
    await tester.tap(addMovieFinder);
    await tester.pump();


  });

  testWidgets('Adding a movie updates the list', (WidgetTester tester) async {
    await tester.pumpWidget(MovieListApp());

    final Finder addMovieButton = find.text('Add Movie');


    // Tap the "Add Movie" button
    await tester.tap(find.text('Add Movie'));


    await tester.pumpAndSettle();
    expect(addMovieButton, findsOneWidget);
    // Tap the button
    await tester.tap(addMovieButton);

    // Rebuild the widget tree after the tap
    await tester.pump();
    await tester.pump(); // Initial pump
    await tester.pump(Duration(milliseconds: 100)); // Additional pump

    // Fill in the movie title and description
    await tester.enterText(find.byKey(Key('movieTitle')), 'Inception');
    await tester.enterText(find.byKey(Key('movieDescription')), 'A mind-bending thriller by Christopher Nolan.');

    // Submit the form
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify the movie is added to the list

    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('A mind-bending thriller by Christopher Nolan.'), findsOneWidget);
  });
}