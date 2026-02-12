import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/explore_viewmodel.dart';
import '../widgets/card_grid_item.dart';
import 'detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load cards on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreViewModel>().loadCards();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ExploreViewModel>().loadMoreCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.state) {
            case LoadingState.loading:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading cards...'),
                  ],
                ),
              );

            case LoadingState.success:
              return Stack(
                children: [
                  GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: viewModel.cards.length +
                        (viewModel.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == viewModel.cards.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final card = viewModel.cards[index];
                      return CardGridItem(
                        card: card,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(card: card),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  if (viewModel.isLoadingMore && !viewModel.hasMore)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );

            case LoadingState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${viewModel.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ExploreViewModel>().loadCards();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case LoadingState.idle:
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ExploreViewModel>().loadCards();
                  },
                  child: const Text('Load Cards'),
                ),
              );
          }
        },
      );
  }
}
