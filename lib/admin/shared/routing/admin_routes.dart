abstract class AdminRoutes {
  const AdminRoutes._();

  static const String root = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String worlds = '/worlds';
  static const String worldEditor = '/worlds/:worldId/edit';
  static const String themes = '/themes';
  static const String themeEditor = '/themes/:themeId';
  static const String assets = '/assets';
  static const String translations = '/translations';
  static const String events = '/events';
  static const String rewards = '/rewards';
  static const String animations = '/animations';
  static const String users = '/users';
  static const String activity = '/activity';
  static const String settings = '/settings';

  static String worldEditorPath(String worldId) => '/worlds/$worldId/edit';
  static String themeEditorPath(String themeId) => '/themes/$themeId';
}
