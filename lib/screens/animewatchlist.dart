import 'package:flutter/material.dart';

class AnimeDetailPage extends StatefulWidget {
  final String animeTitle;

  const AnimeDetailPage({super.key, required this.animeTitle});

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  bool isInWatchlist = false;

  void toggleWatchlist() {
    setState(() {
      isInWatchlist = !isInWatchlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.animeTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "${widget.animeTitle} Cover",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.animeTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Genre: Action, Adventure",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Episodes: 12",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Synopsis: This is a placeholder synopsis for the anime. It follows an epic adventure of a young hero in a fantastical world.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: toggleWatchlist,
              icon: Icon(isInWatchlist ? Icons.favorite : Icons.favorite_border),
              label: Text(isInWatchlist ? "Remove from Watchlist" : "Add to Watchlist"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final List<String> _watchlist = ["Anime 1", "Seasonal Anime 2", "Anime 3"];

  void _removeFromWatchlist(int index) {
    final removedAnime = _watchlist[index];
    setState(() {
      _watchlist.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$removedAnime" removed from watchlist'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _watchlist.insert(index, removedAnime);
            });
          },
        ),
      ),
    );
  }

  void _navigateToDetails(String animeTitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AnimeDetailPage(animeTitle: animeTitle),
      ),
    );
  }

  Widget _buildWatchlistItem(int index) {
    final anime = _watchlist[index];

    return Card(
      color: Colors.deepPurple[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          anime,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _removeFromWatchlist(index),
        ),
        onTap: () => _navigateToDetails(anime),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Watchlist"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _watchlist.isEmpty
            ? const Center(
          child: Text(
            "Your watchlist is empty",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        )
            : ListView.separated(
          itemCount: _watchlist.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) => _buildWatchlistItem(index),
        ),
      ),
    );
  }
}
