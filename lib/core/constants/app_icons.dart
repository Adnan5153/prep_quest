import 'package:flutter/material.dart';

/// Central registry of icon data used across the application.
///
/// Widget code must reference these constants instead of building raw
/// [IconData] literals, so icon-set swaps (Material to Cupertino, brand
/// set, etc.) only touch this file.
class AppIcons {
  const AppIcons._();

  // ----- Navigation -----
  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData playground = Icons.map_outlined;
  static const IconData playgroundFilled = Icons.map;
  static const IconData profile = Icons.person_outline;
  static const IconData profileFilled = Icons.person;

  // ----- Actions -----
  static const IconData bookmark = Icons.bookmark_border;
  static const IconData bookmarkFilled = Icons.bookmark;
  static const IconData search = Icons.search;
  static const IconData settings = Icons.settings_outlined;
  static const IconData close = Icons.close_rounded;

  // ----- Status -----
  static const IconData success = Icons.check_circle_outline;
  static const IconData error = Icons.error_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData info = Icons.info_outline;
  static const IconData notification = Icons.notifications_outlined;
  static const IconData locked = Icons.lock_outline;

  // ----- Gamification -----
  static const IconData streak = Icons.local_fire_department_outlined;
  static const IconData xp = Icons.bolt_outlined;
  static const IconData heart = Icons.favorite_border;
  static const IconData trophy = Icons.emoji_events_outlined;
  static const IconData star = Icons.star_rounded;
  static const IconData starOutline = Icons.star_outline_rounded;
  static const IconData starHalf = Icons.star_half_rounded;
  static const IconData gem = Icons.diamond_rounded;
  static const IconData gemOutline = Icons.diamond_outlined;
  static const IconData coinIcon = Icons.monetization_on_rounded;
  static const IconData badgeStar = Icons.workspace_premium_rounded;
  static const IconData mission = Icons.flag_rounded;
  static const IconData missionOutline = Icons.flag_outlined;
  static const IconData lockFilled = Icons.lock_rounded;
  static const IconData checkCircle = Icons.check_circle_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData sparkle = Icons.auto_awesome_rounded;
  static const IconData calendar = Icons.calendar_today_rounded;
  static const IconData clock = Icons.schedule_rounded;
  static const IconData fireFilled = Icons.local_fire_department_rounded;
  static const IconData crown = Icons.workspace_premium_rounded;

  // ----- Playground bottom sheet extras -----
  static const IconData play = Icons.play_arrow_rounded;
  static const IconData book = Icons.menu_book_rounded;
  static const IconData library = Icons.local_library_rounded;
  static const IconData note = Icons.note_alt_rounded;
  static const IconData target = Icons.gps_fixed_rounded;
  static const IconData shield = Icons.shield_rounded;
  static const IconData award = Icons.emoji_events_rounded;
  static const IconData arrowForward = Icons.arrow_forward_rounded;
  static const IconData refresh = Icons.refresh_rounded;

  // ----- Search -----
  static const IconData searchRecent = Icons.history_rounded;
  static const IconData searchTrending = Icons.trending_up_rounded;
  static const IconData searchFilter = Icons.tune_rounded;
  static const IconData searchEmpty = Icons.search_off_rounded;

  // ----- Bookmarks -----
  static const IconData bookmarkSort = Icons.sort_rounded;
  static const IconData bookmarkOffline = Icons.cloud_off_rounded;
  static const IconData bookmarkDetail = Icons.open_in_new_rounded;
  static const IconData bookmarkNote = Icons.sticky_note_2_rounded;
  static const IconData bookmarkQuestion = Icons.help_outline_rounded;
  static const IconData bookmarkLesson = Icons.menu_book_rounded;
  static const IconData bookmarkAiResponse = Icons.auto_awesome_rounded;

  // ----- Notes -----
  static const IconData notes = Icons.note_alt_outlined;
  static const IconData notesFilled = Icons.note_alt_rounded;
  static const IconData noteAdd = Icons.add_comment_outlined;
  static const IconData noteEdit = Icons.edit_outlined;
  static const IconData noteDelete = Icons.delete_outline;
  static const IconData noteShare = Icons.share_outlined;
  static const IconData noteSearch = Icons.search_rounded;
  static const IconData notePin = Icons.push_pin_outlined;
  static const IconData notePinFilled = Icons.push_pin_rounded;
  static const IconData noteFavorite = Icons.favorite_border;
  static const IconData noteFavoriteFilled = Icons.favorite_rounded;
  static const IconData noteHighlight = Icons.format_color_fill_rounded;
  static const IconData noteAi = Icons.auto_awesome_outlined;
  static const IconData noteAiFilled = Icons.auto_awesome_rounded;
  static const IconData noteSort = Icons.sort_rounded;
  static const IconData noteFilter = Icons.tune_rounded;
  static const IconData notePalette = Icons.palette_outlined;
  static const IconData noteAttachment = Icons.link_rounded;
  static const IconData noteBack = Icons.arrow_back_rounded;
  static const IconData noteMore = Icons.more_vert_rounded;
  static const IconData noteContent = Icons.description_outlined;
  static const IconData noteList = Icons.view_agenda_outlined;
  static const IconData noteGrid = Icons.grid_view_rounded;
  static const IconData noteClock = Icons.schedule_rounded;
  static const IconData noteEmpty = Icons.note_add_outlined;
}
