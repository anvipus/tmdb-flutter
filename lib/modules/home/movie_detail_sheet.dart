import 'dart:ui';
import 'package:flutter/material.dart';

class MovieDetailSheet extends StatelessWidget {
  final dynamic movie;
  final String? trailerUrl;
  final String? keyYoutube;

  const MovieDetailSheet({
    Key? key,
    required this.movie,
    this.trailerUrl,
    this.keyYoutube
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16), // space for close & drag
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster with margin top only
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://img.youtube.com/vi/$keyYoutube/mqdefault.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.play_circle_fill,
                          size: 64,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Overview
                  Text(
                    movie.overview,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Watch Trailer (non-interaktif)
                  if (trailerUrl != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.ondemand_video, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            'Watch Trailer',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Drag handle
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Tombol close
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(),
                iconSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
