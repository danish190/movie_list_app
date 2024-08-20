import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller /movie_controller.dart';
import '../model/movie_model.dart';
import 'add_movie_screen.dart';


class MovieListScreen extends StatelessWidget {
  final MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies List'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Get.to(() => AddMovieScreen());
              if (result != null && result is Map<String, String>) {
                movieController.addMovie(result['title']!, result['description']!);
              }
            },
          )
        ],
      ),
      body: Obx(() {
        if (movieController.movieList.isEmpty) {
          return Center(child: Text('No movies added yet.'));
        }
        return ListView.builder(
          itemCount: movieController.movieList.length,
          itemBuilder: (context, index) {
            final movie = movieController.movieList[index];
            return Dismissible(
              key: Key(movie.title),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                movieController.removeMovie(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${movie.title} removed')),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(movie.title),
                  subtitle: Text(movie.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          movie.isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: movie.isFavourite ? Colors.red : null,
                        ),
                        onPressed: () => movieController.toggleFavourite(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => movieController.removeMovie(index),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}