/// What kind of source record this bookmark points at.
///
/// Drives the destination widget (lesson reader, question detail, AI
/// history entry, or note editor) and the icon shown next to each
/// bookmark tile.
enum BookmarkItemType { question, lesson, aiResponse, note }
