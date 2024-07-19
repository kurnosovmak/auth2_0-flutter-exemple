class Channel {
  final int id;
  final String title;
  final String description;
  final String slug;
  final String created_at;
  final bool is_subscribe;

  Channel(
      {required this.id,
      required this.title,
      required this.description,
      required this.slug,
      required this.created_at,
      required this.is_subscribe});
}
