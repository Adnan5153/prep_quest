sealed class AiSummarySection {
  const AiSummarySection();
}

class AiSummaryTextSection extends AiSummarySection {
  const AiSummaryTextSection(this.text);
  final String text;
}

class AiSummaryBulletListSection extends AiSummarySection {
  const AiSummaryBulletListSection(this.items);
  final List<String> items;
}

class AiSummaryNumberedListSection extends AiSummarySection {
  const AiSummaryNumberedListSection(this.items);
  final List<String> items;
}

class AiSummaryKeyTakeawaysSection extends AiSummarySection {
  const AiSummaryKeyTakeawaysSection(this.items);
  final List<String> items;
}

class AiSummaryCodeSection extends AiSummarySection {
  const AiSummaryCodeSection({required this.code, this.language});
  final String code;
  final String? language;
}

class AiSummaryHighlightSection extends AiSummarySection {
  const AiSummaryHighlightSection({required this.text, required this.terms});
  final String text;
  final List<String> terms;
}

class AiSummaryMetadata {
  const AiSummaryMetadata({
    this.category,
    this.model,
    this.timestamp,
    this.readingTime,
    this.wordCount,
  });

  final String? category;
  final String? model;
  final String? timestamp;
  final String? readingTime;
  final String? wordCount;

  bool get hasAny =>
      category != null ||
      model != null ||
      timestamp != null ||
      (readingTime != null && readingTime!.isNotEmpty) ||
      (wordCount != null && wordCount!.isNotEmpty);
}
