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
    // The API returns the card object at the top level of the element
    // (we pass each element of `data` into this factory). Parse accordingly.
    List<String> attacks = [];
    if (json['attacks'] != null && json['attacks'] is List) {
      attacks = (json['attacks'] as List)
          .map((attack) => (attack['name'] ?? '') as String)
          .where((s) => s.isNotEmpty)
          .toList();
    }

    final types = (json['types'] as List?)?.cast<String>();

    return PokemonCard(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      image: json['images'] != null ? (json['images']['small'] ?? '') : '',
      hp: json['hp'] ?? 'N/A',
      type: (types != null && types.isNotEmpty) ? types.first : 'Unknown',
      rarity: json['rarity'] ?? 'N/A',
      attacks: attacks,
      description: json['flavorText'] ?? '',
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
