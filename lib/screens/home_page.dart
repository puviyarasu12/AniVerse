import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../api_service.dart';
import 'profile_page.dart';
import 'animenews.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Anime> topAnime = [];
  List<Anime> seasonalAnime = [];
  List<Anime> topManga = [];
  List<Map<String, dynamic>> topCharacters = [];
  List<Anime> searchResults = [];
  List<Map<String, dynamic>> topNews = [];

  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      final anime = await ApiService.fetchTopAnime();
      final seasonal = await ApiService.fetchSeasonalAnime();
      final manga = await ApiService.fetchTopManga();
      final characters = await ApiService.fetchTopCharacters();
    // Example anime ID

      setState(() {
        topAnime = anime;
        seasonalAnime = seasonal;
        topManga = manga;
        topCharacters = characters;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void searchAnime(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }
    try {
      final results = await ApiService.searchAnime(query);
      setState(() => searchResults = results);
    } catch (e) {
      print('Search error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage()));
          },
        ),
        title: const Text("AniVerse", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: searchAnime,
              decoration: InputDecoration(
                hintText: "Search Anime...",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (searchResults.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Search Results", style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final anime = searchResults[index];
                        return animeCard(anime);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            const Text("Top Anime", style: sectionTitleStyle),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topAnime.length,
                itemBuilder: (context, index) => animeCard(topAnime[index]),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Seasonal Anime", style: sectionTitleStyle),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: seasonalAnime.length,
                itemBuilder: (context, index) => animeCard(seasonalAnime[index]),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Top Manga", style: sectionTitleStyle),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: topManga.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => animeCard(topManga[index]),
            ),
            const SizedBox(height: 24),
            const Text("Top Characters", style: sectionTitleStyle),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topCharacters.length,
                itemBuilder: (context, index) {
                  final char = topCharacters[index];
                  final image = char['images']?['jpg']?['image_url'] ?? '';
                  final name = char['name'] ?? 'Unknown';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(image),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 72,
                          child: Text(
                            name,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Anime News", style: sectionTitleStyle),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AnimeNewsPage()));
                  },
                  child: const Text("See All", style: TextStyle(color: Colors.deepPurpleAccent)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: topNews.take(3).map((news) {
                final title = news['title'] ?? 'No title';
                final image = news['images']?['jpg']?['image_url'] ?? '';
                final excerpt = news['excerpt'] ?? '';
                return Card(
                  color: Colors.white10,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: image.isNotEmpty ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover) : null,
                    title: Text(title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(excerpt, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
                    onTap: () {
                      // Optional: open full news
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Random anime logic
                },
                icon: const Icon(Icons.shuffle),
                label: const Text("Random Anime"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget animeCard(Anime anime) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(anime.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        color: Colors.black54,
        child: Text(
          anime.title,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

const sectionTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "Action",
      "Romance",
      "Comedy",
      "Drama",
      "Fantasy",
      "Horror",
      "Sci-Fi",
      "Slice of Life",
      "Sports",
      "Mystery"
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Categories"),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                print('${categories[index]} selected');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                categories[index],
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
