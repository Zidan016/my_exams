class PaginationHelper<T> {
  final List<T> fullList;
  List<T> filteredList;
  final int itemsPerPage;
  int currentPage = 0;
  bool isLoadingMore = false;
  final bool Function(T, String)? filterFunc;

  PaginationHelper({
    required this.fullList,
    this.itemsPerPage = 10,
    this.filterFunc,
  }) : filteredList = List.from(fullList);

  void reset() {
    currentPage = 0;
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredList = List.from(fullList);
    } else if (filterFunc != null) {
      filteredList = fullList.where((item) => filterFunc!(item, query)).toList();
    }
    reset();
  }

  bool get hasMore => currentPage * itemsPerPage < filteredList.length;

  List<T> loadMore() {
    if (isLoadingMore || !hasMore) return [];

    isLoadingMore = true;
    currentPage++;

    final start = (currentPage - 1) * itemsPerPage;
    final end = start + itemsPerPage;

    final pageData = filteredList.sublist(
      start,
      end > filteredList.length ? filteredList.length : end,
    );

    isLoadingMore = false;
    return pageData;
  }

  /// Total halaman
  int get totalPages => (filteredList.length / itemsPerPage).ceil();
}
