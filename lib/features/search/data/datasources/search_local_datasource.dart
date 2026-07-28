import '../../domain/enums/search_category.dart';
import '../models/recent_search_model.dart';
import '../models/search_item_model.dart';
import '../models/trending_search_model.dart';

/// Deterministic in-memory datasource used until search indexing is wired.
///
/// Holds the entire indexed corpus in memory and filters synchronously.
/// Mirrors the structure of `NotificationLocalDataSource` so it slots
/// into the same remote-first / local-fallback repository pattern.
class SearchLocalDataSource {
  SearchLocalDataSource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  List<SearchItemModel>? _itemCache;
  List<RecentSearchModel>? _recentCache;
  final List<TrendingSearchModel> _trending = _seedTrending();

  List<SearchItemModel> readAllItems() {
    _ensureItemCache();
    return List<SearchItemModel>.unmodifiable(_itemCache!);
  }

  List<SearchItemModel> searchItems(
    String query,
    Set<SearchCategory> categories,
  ) {
    _ensureItemCache();
    final String needle = query.trim().toLowerCase();
    final Set<SearchCategory> filter = categories.isEmpty
        ? <SearchCategory>{SearchCategory.lessons, SearchCategory.questions, SearchCategory.topics, SearchCategory.books, SearchCategory.aiHistory}
        : categories;
    return _itemCache!
        .where((SearchItemModel row) {
          if (!filter.contains(row.category)) return false;
          if (needle.isEmpty) return true;
          return row.title.toLowerCase().contains(needle) ||
              row.subtitle.toLowerCase().contains(needle);
        })
        .toList(growable: false);
  }

  List<RecentSearchModel> readRecent({int limit = 10}) {
    _ensureRecentCache();
    return List<RecentSearchModel>.unmodifiable(
      _recentCache!.take(limit),
    );
  }

  void writeRecent(List<RecentSearchModel> rows) {
    _recentCache = List<RecentSearchModel>.from(rows);
  }

  List<TrendingSearchModel> readTrending({int limit = 8}) {
    return List<TrendingSearchModel>.unmodifiable(
      _trending.take(limit),
    );
  }

  void _ensureItemCache() {
    if (_itemCache != null) return;
    _itemCache = List<SearchItemModel>.unmodifiable(_seedItems());
  }

  void _ensureRecentCache() {
    _recentCache ??= List<RecentSearchModel>.unmodifiable(_seedRecent());
  }

  List<SearchItemModel> _seedItems() {
    final DateTime now = _clock();
    return <SearchItemModel>[
      const SearchItemModel(
        id: 'lesson-bcs-constitution',
        category: SearchCategory.lessons,
        title: 'Constitution of Bangladesh',
        subtitle: 'Foundations, articles, and amendment history',
        routeName: '/lessons',
        secondaryRouteName: '/lessons/detail',
        iconName: 'book',
      ),
      const SearchItemModel(
        id: 'lesson-bcs-economics',
        category: SearchCategory.lessons,
        title: 'Microeconomics Fundamentals',
        subtitle: 'Demand, supply, elasticity and market structures',
        routeName: '/lessons',
        secondaryRouteName: '/lessons/detail',
        iconName: 'book',
      ),
      const SearchItemModel(
        id: 'lesson-bcs-history',
        category: SearchCategory.lessons,
        title: 'Liberation War of 1971',
        subtitle: 'Key events, sectors and post-independence nation building',
        routeName: '/lessons',
        secondaryRouteName: '/lessons/detail',
        iconName: 'book',
      ),
      const SearchItemModel(
        id: 'lesson-bank-mathematics',
        category: SearchCategory.lessons,
        title: 'Profit, Loss and Discount',
        subtitle: 'Commercial math drills for bank recruitment',
        routeName: '/lessons',
        secondaryRouteName: '/lessons/detail',
        iconName: 'book',
      ),
      const SearchItemModel(
        id: 'lesson-english-grammar',
        category: SearchCategory.lessons,
        title: 'Tenses and Voice',
        subtitle: 'Active/passive voice transformation rules',
        routeName: '/lessons',
        secondaryRouteName: '/lessons/detail',
        iconName: 'book',
      ),
      const SearchItemModel(
        id: 'question-bcs-prelims-2024',
        category: SearchCategory.questions,
        title: 'BCS Prelims 2024 Set A',
        subtitle: '100 questions with explanations',
        routeName: '/quiz/overview',
        iconName: 'note',
      ),
      const SearchItemModel(
        id: 'question-bank-quant',
        category: SearchCategory.questions,
        title: 'Quantitative Aptitude — Mixed',
        subtitle: '50 mixed-difficulty numerical problems',
        routeName: '/quiz/overview',
        iconName: 'note',
      ),
      const SearchItemModel(
        id: 'question-english-vocab',
        category: SearchCategory.questions,
        title: 'English Vocabulary Drills',
        subtitle: 'Synonyms, antonyms and idioms',
        routeName: '/quiz/overview',
        iconName: 'note',
      ),
      const SearchItemModel(
        id: 'question-gk-bangladesh',
        category: SearchCategory.questions,
        title: 'Bangladesh GK Speed Test',
        subtitle: 'Fast-fire general knowledge questions',
        routeName: '/quiz/overview',
        iconName: 'note',
      ),
      const SearchItemModel(
        id: 'topic-polity',
        category: SearchCategory.topics,
        title: 'Polity & Governance',
        subtitle: '38 chapters, 240 lessons',
        routeName: '/lessons',
        iconName: 'library',
      ),
      const SearchItemModel(
        id: 'topic-economics',
        category: SearchCategory.topics,
        title: 'Economics',
        subtitle: '21 chapters, 145 lessons',
        routeName: '/lessons',
        iconName: 'library',
      ),
      const SearchItemModel(
        id: 'topic-mathematics',
        category: SearchCategory.topics,
        title: 'Mathematics',
        subtitle: '32 chapters, 210 lessons',
        routeName: '/lessons',
        iconName: 'library',
      ),
      const SearchItemModel(
        id: 'topic-english',
        category: SearchCategory.topics,
        title: 'English Language',
        subtitle: '18 chapters, 120 lessons',
        routeName: '/lessons',
        iconName: 'library',
      ),
      const SearchItemModel(
        id: 'topic-bangladesh',
        category: SearchCategory.topics,
        title: 'Bangladesh Affairs',
        subtitle: 'History, geography, culture',
        routeName: '/lessons',
        iconName: 'library',
      ),
      const SearchItemModel(
        id: 'topic-international',
        category: SearchCategory.topics,
        title: 'International Affairs',
        subtitle: 'UN, world organisations, current events',
        routeName: '/lessons',
        iconName: 'library',
      ),
      const SearchItemModel(
        id: 'book-math-handbook',
        category: SearchCategory.books,
        title: 'Quick Math Handbook',
        subtitle: 'Formulas, shortcuts, solved examples',
        routeName: '/review',
        iconName: 'book',
      ),
      const SearchItemModel(
        id: 'book-english-grammar',
        category: SearchCategory.books,
        title: 'English Grammar in Use',
        subtitle: 'Reference book with practice sets',
        routeName: '/review',
        iconName: 'book',
      ),
      const SearchItemModel(
        id: 'book-gk-compendium',
        category: SearchCategory.books,
        title: 'Bangladesh GK Compendium',
        subtitle: 'Comprehensive general knowledge reference',
        routeName: '/review',
        iconName: 'book',
      ),
      SearchItemModel(
        id: 'ai-chat-constitution',
        category: SearchCategory.aiHistory,
        title: 'Explain the basic structure of the constitution',
        subtitle: 'AI Tutor conversation',
        routeName: '/ai-tutor/history',
        iconName: 'sparkle',
        updatedAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
      ),
      SearchItemModel(
        id: 'ai-chat-economics',
        category: SearchCategory.aiHistory,
        title: 'Walk me through elasticity of demand',
        subtitle: 'AI Tutor conversation',
        routeName: '/ai-tutor/history',
        iconName: 'sparkle',
        updatedAtIso: now.subtract(const Duration(days: 2)).toIso8601String(),
      ),
      SearchItemModel(
        id: 'ai-chat-math-shortcuts',
        category: SearchCategory.aiHistory,
        title: 'Shortcut methods for percentage problems',
        subtitle: 'AI Tutor conversation',
        routeName: '/ai-tutor/history',
        iconName: 'sparkle',
        updatedAtIso: now.subtract(const Duration(days: 3)).toIso8601String(),
      ),
      SearchItemModel(
        id: 'ai-chat-english-tense',
        category: SearchCategory.aiHistory,
        title: 'When do I use the past perfect tense?',
        subtitle: 'AI Tutor conversation',
        routeName: '/ai-tutor/history',
        iconName: 'sparkle',
        updatedAtIso: now.subtract(const Duration(days: 4)).toIso8601String(),
      ),
      SearchItemModel(
        id: 'ai-chat-bangladesh-war',
        category: SearchCategory.aiHistory,
        title: 'Summarise the 1971 war timeline',
        subtitle: 'AI Tutor conversation',
        routeName: '/ai-tutor/history',
        iconName: 'sparkle',
        updatedAtIso: now.subtract(const Duration(days: 5)).toIso8601String(),
      ),
    ];
  }

  List<RecentSearchModel> _seedRecent() {
    final DateTime now = _clock();
    return <RecentSearchModel>[
      RecentSearchModel(
        query: 'constitution',
        queriedAtIso: now.subtract(const Duration(hours: 1)).toIso8601String(),
        categoryAtTime: SearchCategory.lessons,
      ),
      RecentSearchModel(
        query: 'percentage shortcuts',
        queriedAtIso: now.subtract(const Duration(hours: 3)).toIso8601String(),
        categoryAtTime: SearchCategory.aiHistory,
      ),
      RecentSearchModel(
        query: 'BCS prelims',
        queriedAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
        categoryAtTime: SearchCategory.questions,
      ),
    ];
  }

  static List<TrendingSearchModel> _seedTrending() {
    return const <TrendingSearchModel>[
      TrendingSearchModel(
        label: 'BCS Constitution',
        query: 'constitution',
        rank: 1,
        category: SearchCategory.lessons,
      ),
      TrendingSearchModel(
        label: 'Percentage shortcuts',
        query: 'percentage shortcuts',
        rank: 2,
        category: SearchCategory.books,
      ),
      TrendingSearchModel(
        label: 'Tenses',
        query: 'tenses',
        rank: 3,
        category: SearchCategory.lessons,
      ),
      TrendingSearchModel(
        label: 'BCS Prelims 2024',
        query: 'BCS prelims 2024',
        rank: 4,
        category: SearchCategory.questions,
      ),
      TrendingSearchModel(
        label: 'Economics demand supply',
        query: 'economics demand supply',
        rank: 5,
        category: SearchCategory.lessons,
      ),
      TrendingSearchModel(
        label: '1971 Liberation War',
        query: 'liberation war 1971',
        rank: 6,
        category: SearchCategory.lessons,
      ),
      TrendingSearchModel(
        label: 'English idioms',
        query: 'english idioms',
        rank: 7,
        category: SearchCategory.lessons,
      ),
      TrendingSearchModel(
        label: 'Bangladesh GK',
        query: 'bangladesh gk',
        rank: 8,
        category: SearchCategory.topics,
      ),
    ];
  }
}