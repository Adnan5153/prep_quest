/// Color palette applied to a note card.
///
/// The presentation layer resolves each value to a concrete
/// `Color` via `AppColors` so this enum stays Flutter-import-free.
enum NoteColor { defaultColor, yellow, green, blue, pink, purple }

extension NoteColorX on NoteColor {
  String get displayLabel {
    switch (this) {
      case NoteColor.defaultColor:
        return 'Default';
      case NoteColor.yellow:
        return 'Yellow';
      case NoteColor.green:
        return 'Green';
      case NoteColor.blue:
        return 'Blue';
      case NoteColor.pink:
        return 'Pink';
      case NoteColor.purple:
        return 'Purple';
    }
  }
}
