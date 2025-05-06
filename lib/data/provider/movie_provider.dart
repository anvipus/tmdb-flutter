import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app_flutter/data/model/movie_model.dart';
import '../model/youtube_trailer.dart';

class MovieProvider {
  static const String baseUrl = 'api.themoviedb.org';
  // Ganti 'YOUR_API_KEY_HERE' dengan API key TMDB kamu
  static const String bearerToken  = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjI1MDAwZDIzNThkNDZhMDVjYWNjNDE4OGVjZTI3NCIsIm5iZiI6MTczNDQ4NTgxOC4zNjgsInN1YiI6IjY3NjIyNzNhMWMzNDZlZDFiZGZmZDViNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZWB2OA0ECkbwM7KblIuA1V9ZRgr5J4Zy6HLFuimm-zM';

  /// Mendapatkan daftar film populer
  Future<List<MovieModel>> getPopularMovies() async {
    // Gunakan Uri.https agar mudah menambahkan query parameter
    final uri = Uri.https(
      baseUrl,
      '/3/movie/popular',
      {
        'language': 'en-US',
        'page': '1',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      print('Error getPopularMovies: ${response.statusCode} - ${response.body}');
      throw Exception('Gagal memuat data film populer');
    }
  }

  /// Mendapatkan daftar film yang sedang tayang
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final uri = Uri.https(
      baseUrl,
      '/3/movie/now_playing',
      {
        'language': 'en-US',
        'page': '1',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      print('Error getNowPlayingMovies: ${response.statusCode} - ${response.body}');
      throw Exception('Gagal memuat data film yang sedang tayang');
    }
  }

  /// Mencari film berdasarkan kata kunci [query]
  Future<List<MovieModel>> searchMovies(String query) async {
    final uri = Uri.https(
      baseUrl,
      '/3/search/movie',
      {
        'language': 'en-US',
        'page': '1',
        'query': query,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      print('Error searchMovies: ${response.statusCode} - ${response.body}');
      throw Exception('Gagal mencari film');
    }
  }

  Future<YoutubeTrailer?> fetchYoutubeTrailer(int movieId) async {
    final uri = Uri.https(
      baseUrl,
      '/3/movie/$movieId/videos',
      {'language': 'en-US'},
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = YoutubeTrailerListData.fromJson(jsonDecode(response.body));

      final trailer = data.results?.firstWhere(
            (video) =>
        video.type?.toLowerCase() == 'trailer' &&
            video.site?.toLowerCase() == 'youtube' &&
            video.key != null,
        orElse: () => YoutubeTrailer(),
      );

      if (trailer?.key != null) return trailer;
    } else {
      print('Error fetching trailer: ${response.statusCode}');
    }

    return null;
  }
}
