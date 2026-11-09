class Artisan {
  final String id;
  final String name;
  final String craftSpecialty;
  final String region;
  final String village;
  final String cooperativeName;
  final String story;
  final String imageUrl;
  final int yearsOfExperience;
  final bool isWomenLed;

  const Artisan({
    required this.id,
    required this.name,
    required this.craftSpecialty,
    required this.region,
    required this.village,
    required this.cooperativeName,
    required this.story,
    required this.imageUrl,
    required this.yearsOfExperience,
    this.isWomenLed = true,
  });
}
