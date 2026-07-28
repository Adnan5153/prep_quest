/// Public enums for the AI History section component.
///
/// Everything a consumer needs to describe *what* they want the
/// section to display lives here. The widget itself never fetches
/// data — it reads from these enums and from the typed model.
library;

/// Lifecycle of the data the section is rendering.
///
/// Consumers decide which state to show by selecting the matching
/// [AiHistoryState]. The widget performs no data fetching of its own.
enum AiHistoryState { ready, empty, loading, error }

/// The semantic type of an entry inside the AI history.
///
/// The value drives the leading avatar styling and the accent color
/// used on the card so consumers can quickly distinguish AI tutors
/// from prompt studio and exam simulations.
enum AiHistoryEntryType { tutor, prompt, exam, summary }
