import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dossier_repository_impl.dart';
import '../domain/dossier_repository.dart';
import '../domain/dossier_summary.dart';

class DossierListState {
  final List<DossierSummary> items;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;
  final int page;
  final int pages;
  final int total;
  final DossierFilter filter;

  const DossierListState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.page = 1,
    this.pages = 1,
    this.total = 0,
    this.filter = const DossierFilter(),
  });

  bool get hasMore => page < pages;

  DossierListState copyWith({
    List<DossierSummary>? items,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
    bool clearError = false,
    int? page,
    int? pages,
    int? total,
    DossierFilter? filter,
  }) =>
      DossierListState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: clearError ? null : (error ?? this.error),
        page: page ?? this.page,
        pages: pages ?? this.pages,
        total: total ?? this.total,
        filter: filter ?? this.filter,
      );
}

class DossierListController extends AutoDisposeNotifier<DossierListState> {
  @override
  DossierListState build() {
    // Premier fetch differé : on declenche au build du widget via .refresh().
    Future.microtask(refresh);
    return const DossierListState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true, page: 1);
    try {
      final repo = ref.read(dossierRepositoryProvider);
      final res = await repo.list(page: 1, filter: state.filter);
      state = state.copyWith(
        items: res.items,
        page: res.page,
        pages: res.pages,
        total: res.total,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final repo = ref.read(dossierRepositoryProvider);
      final next = state.page + 1;
      final res = await repo.list(page: next, filter: state.filter);
      state = state.copyWith(
        items: [...state.items, ...res.items],
        page: res.page,
        pages: res.pages,
        total: res.total,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  void setFilter(DossierFilter filter) {
    state = state.copyWith(filter: filter);
    refresh();
  }

  void replace(DossierSummary updated) {
    state = state.copyWith(
      items: [
        for (final d in state.items)
          if (d.id == updated.id) updated else d,
      ],
    );
  }

  void removeById(int id) {
    state = state.copyWith(
      items: state.items.where((d) => d.id != id).toList(),
    );
  }
}

final dossierListControllerProvider =
    AutoDisposeNotifierProvider<DossierListController, DossierListState>(
        DossierListController.new);
