import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.collections_bookmark,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to Pokédex TCG',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Explore and manage your Pokémon Trading Card Game collection',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Search Cards'),
                      subtitle: const Text('Find specific Pokémon cards'),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.explore,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Explore'),
                      subtitle: const Text('Discover new cards'),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const _FeatureItem(
              icon: Icons.search,
              title: 'Smart Search',
              description: 'Easily search for cards by name',
            ),
            const SizedBox(height: 12),
            const _FeatureItem(
              icon: Icons.grid_on,
              title: 'Beautiful Grid',
              description: 'Browse cards in an elegant grid layout',
            ),
            const SizedBox(height: 12),
            const _FeatureItem(
              icon: Icons.info,
              title: 'Detailed Info',
              description: 'View comprehensive card details',
            ),
            const SizedBox(height: 12),
            const _FeatureItem(
              icon: Icons.add,
              title: 'Infinite Scroll',
              description: 'Load more cards as you scroll',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
