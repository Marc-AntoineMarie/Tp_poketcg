class PokemonCard {
  final String id;
  final String name;
  final String image;
  final String hp;
  final String type;
  final String rarity;
  final List<String> attacks;
  final String description;

  PokemonCard({
    required this.id,
    required this.name,
    required this.image,
    required this.hp,
    required this.type,
    required this.rarity,
    required this.attacks,
    required this.description,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    List<String> attacks = [];
    if (json['data']?['attacks'] != null) {
      attacks = (json['data']['attacks'] as List)
          .map((attack) => attack['name'] as String)
          .toList();
    }

    return PokemonCard(
      id: json['id'] ?? '',
      name: json['data']?['name'] ?? 'Unknown',
      image: json['data']?['images']?['small'] ?? '',
      hp: json['data']?['hp'] ?? 'N/A',
      type: (json['data']?['types'] as List?)?.first ?? 'Unknown',
      rarity: json['data']?['rarity'] ?? 'N/A',
      attacks: attacks,
      description: json['data']?['flavorText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'hp': hp,
        'type': type,
        'rarity': rarity,
        'attacks': attacks,
        'description': description,
      };
}
