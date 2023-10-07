class Meta<T> {
  final List<T> data;
  final int total;
  final int page;
  final int limit;

  Meta({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory Meta.empty() => Meta(
        data: [],
        total: 0,
        page: 0,
        limit: 0,
      );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        data: json["data"] != null
            ? List<T>.from(json["data"].map((x) => x))
            : [],
        total: json["total"] ?? 0,
        page: json["page"] ?? 0,
        limit: json["limit"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "total": total,
        "page": page,
        "limit": limit,
      };
}
