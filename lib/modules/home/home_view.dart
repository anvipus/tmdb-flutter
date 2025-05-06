import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app_flutter/modules/home/home_controller.dart';
import 'package:movie_app_flutter/modules/home/movie_detail_sheet.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie DB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print('Search icon clicked!');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingPopular.value || controller.isLoadingNowPlaying.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Popular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.popularMovies.length,
                  itemBuilder: (context, index) {
                    final movie = controller.popularMovies[index];
                    return GestureDetector(
                      onTap: () async {
                        await controller.fetchTrailer(movie.id);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (_) => Obx(() {
                            if (controller.isTrailerLoading.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final trailer = controller.currentTrailer.value;
                            return MovieDetailSheet(
                              movie: movie,
                              trailerUrl: trailer != null
                                  ? 'https://www.youtube.com/watch?v=${trailer.key}'
                                  : null,
                              keyYoutube: trailer?.key ?? '',
                            );
                          }),
                        );
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: movie.posterPath.isNotEmpty
                                  ? Image.network(
                                'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                width: 140,
                                height: 120,
                                fit: BoxFit.fill,
                              )
                                  : Container(
                                width: 140,
                                height: 120,
                                color: Colors.grey,
                                child: const Center(child: Text('No Image')),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    movie.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.overview,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text('Now Playing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.builder(
                itemCount: controller.nowPlayingMovies.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final movie = controller.nowPlayingMovies[index];
                  return GestureDetector(
                    onTap: () async {
                      await controller.fetchTrailer(movie.id);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => Obx(() {
                          if (controller.isTrailerLoading.value) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final trailer = controller.currentTrailer.value;
                          return MovieDetailSheet(
                            movie: movie,
                            trailerUrl: trailer != null
                                ? 'https://www.youtube.com/watch?v=${trailer.key}'
                                : null,
                            keyYoutube: trailer?.key ?? '',
                          );
                        }),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: movie.posterPath.isNotEmpty
                                ? Image.network(
                              'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey,
                              child: const Center(child: Text('No Image')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  movie.overview,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
