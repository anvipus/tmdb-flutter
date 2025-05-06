import 'package:get/get.dart';
import 'package:movie_app_flutter/data/model/movie_model.dart';
import 'package:movie_app_flutter/data/provider/movie_provider.dart';

import '../../data/model/youtube_trailer.dart';

class HomeController extends GetxController {
  final MovieProvider movieProvider;
  HomeController({required this.movieProvider});

  // List film popular
  var popularMovies = <MovieModel>[].obs;
  // List film now playing
  var nowPlayingMovies = <MovieModel>[].obs;
  final Rx<YoutubeTrailer?> currentTrailer = Rx<YoutubeTrailer?>(null);

  // Loading state
  var isLoadingPopular = false.obs;
  var isLoadingNowPlaying = false.obs;
  var isTrailerLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularMovies();
    fetchNowPlayingMovies();
  }

  void fetchPopularMovies() async {
    try {
      isLoadingPopular.value = true;
      final movies = await movieProvider.getPopularMovies();
      popularMovies.assignAll(movies);
    } catch (e) {
      print("Error fetchPopularMovies: $e");
    } finally {
      isLoadingPopular.value = false;
    }
  }

  void fetchNowPlayingMovies() async {
    try {
      isLoadingNowPlaying.value = true;
      final movies = await movieProvider.getNowPlayingMovies();
      nowPlayingMovies.assignAll(movies);
    } catch (e) {
      print("Error fetchNowPlayingMovies: $e");
    } finally {
      isLoadingNowPlaying.value = false;
    }
  }

  Future<void> fetchTrailer(int movieId) async {
    isTrailerLoading.value = true;
    currentTrailer.value = null;

    final trailer = await movieProvider.fetchYoutubeTrailer(movieId);
    currentTrailer.value = trailer;

    isTrailerLoading.value = false;
  }
}
