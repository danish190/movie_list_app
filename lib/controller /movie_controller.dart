import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';

import '../model/movie_model.dart';

class MovieController extends GetxController{
  var movieList = <Movie>[].obs;

  late Box<Movie> movieBox;


  @override
  void onInit() {
    super.onInit();
    // Initialize Hive and load movies
    movieBox = Hive.box<Movie>('movies');
    loadMovies();
    
  }

  void loadMovies() {
    // Load movies from Hive and assign them to the observable list
    movieList.assignAll(movieBox.values.toList());
  }

  void addMovie(String title, String description) {
    final newMovie = Movie(title: title, description: description, isFavourite: false);
    movieBox.add(newMovie); // Save to Hive
    movieList.add(newMovie); // Update the observable list
  }

  void removeMovie(int index) {
    movieBox.deleteAt(index); // Remove from Hive
    movieList.removeAt(index); // Update the observable list
  }

  void toggleFavourite(int index) {
    final movie = movieList[index];
    movie.isFavourite = !movie.isFavourite;
    movie.save(); // Update in Hive
    movieList[index] = movie; // Trigger UI update by reassigning the object
  }

}