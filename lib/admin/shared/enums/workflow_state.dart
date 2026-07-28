enum WorkflowState {
  draft('draft'),
  inReview('in_review'),
  testing('testing'),
  published('published'),
  archived('archived');

  const WorkflowState(this.wire);

  final String wire;

  static WorkflowState fromWire(String value) {
    return WorkflowState.values.firstWhere(
      (WorkflowState s) => s.wire == value,
      orElse: () => WorkflowState.draft,
    );
  }
}

enum WorldObjectKind {
  lessonNode('lesson_node'),
  bossGate('boss_gate'),
  academy('academy'),
  library('library'),
  tree('tree'),
  bush('bush'),
  mountain('mountain'),
  river('river'),
  bridge('bridge'),
  flag('flag'),
  cloud('cloud'),
  particleLayer('particle_layer'),
  rewardChest('reward_chest'),
  decoration('decoration');

  const WorldObjectKind(this.wire);

  final String wire;

  bool get isNavigable => this == lessonNode || this == bossGate || this == academy || this == library;
  bool get isStatic => !isNavigable;

  static WorldObjectKind fromWire(String value) {
    return WorldObjectKind.values.firstWhere(
      (WorldObjectKind k) => k.wire == value,
      orElse: () => WorldObjectKind.decoration,
    );
  }
}

enum AssetKind {
  image('image'),
  lottie('lottie'),
  audio('audio'),
  video('video'),
  font('font'),
  shader('shader'),
  custom('custom');

  const AssetKind(this.wire);

  final String wire;

  static AssetKind fromWire(String value) =>
      AssetKind.values.firstWhere((AssetKind k) => k.wire == value,
          orElse: () => AssetKind.image);
}

enum PathStyle {
  straight('straight'),
  bezier('bezier'),
  ribbon('ribbon'),
  bridge('bridge');

  const PathStyle(this.wire);

  final String wire;

  static PathStyle fromWire(String value) =>
      PathStyle.values.firstWhere((PathStyle p) => p.wire == value,
          orElse: () => PathStyle.bezier);
}

enum PathSegmentKind {
  line('line'),
  bezier('bezier'),
  arc('arc');

  const PathSegmentKind(this.wire);

  final String wire;

  static PathSegmentKind fromWire(String value) =>
      PathSegmentKind.values.firstWhere((PathSegmentKind s) => s.wire == value,
          orElse: () => PathSegmentKind.line);
}

enum ThemeWeather {
  sunny('sunny'),
  cloudy('cloudy'),
  rainy('rainy'),
  snowy('snowy'),
  foggy('foggy'),
  windy('windy'),
  stormy('stormy');

  const ThemeWeather(this.wire);

  final String wire;

  static ThemeWeather fromWire(String value) =>
      ThemeWeather.values.firstWhere((ThemeWeather w) => w.wire == value,
          orElse: () => ThemeWeather.sunny);
}

enum AnimationLoopMode {
  none('none'),
  loop('loop'),
  pingPong('ping_pong');

  const AnimationLoopMode(this.wire);

  final String wire;

  static AnimationLoopMode fromWire(String value) =>
      AnimationLoopMode.values.firstWhere((AnimationLoopMode m) => m.wire == value,
          orElse: () => AnimationLoopMode.none);
}

enum EventKind {
  season('season'),
  holiday('holiday'),
  tournament('tournament'),
  offer('offer'),
  anniversary('anniversary');

  const EventKind(this.wire);

  final String wire;

  static EventKind fromWire(String value) =>
      EventKind.values.firstWhere((EventKind e) => e.wire == value,
          orElse: () => EventKind.offer);
}

enum RewardCondition {
  levelCompleted('level_completed'),
  bossDefeated('boss_defeated'),
  streakReached('streak_reached'),
  perfectScore('perfect_score'),
  firstAttempt('first_attempt'),
  eventCompleted('event_completed');

  const RewardCondition(this.wire);

  final String wire;

  static RewardCondition fromWire(String value) =>
      RewardCondition.values.firstWhere((RewardCondition c) => c.wire == value,
          orElse: () => RewardCondition.levelCompleted);
}

enum ExamVertical {
  bcs('BCS', 'Bangladesh Civil Service'),
  bank('BANK', 'Bank Recruitment'),
  primary('PRIMARY', 'Primary Teacher'),
  ntrca('NTRCA', 'Teachers Registration'),
  medical('MEDICAL', 'Medical Admission'),
  government('GOVT', 'Government Jobs'),
  future('FUTURE', 'Future Cohort');

  const ExamVertical(this.code, this.label);

  final String code;
  final String label;

  static ExamVertical fromCode(String code) =>
      ExamVertical.values.firstWhere((ExamVertical e) => e.code == code,
          orElse: () => ExamVertical.future);
}

enum AdminRole {
  viewer('viewer'),
  author('author'),
  reviewer('reviewer'),
  publisher('publisher'),
  admin('admin'),
  auditor('auditor');

  const AdminRole(this.wire);

  final String wire;

  bool get canAuthor => index >= AdminRole.author.index;
  bool get canReview => index >= AdminRole.reviewer.index;
  bool get canPublish => index >= AdminRole.publisher.index;
  bool get canAdmin => index >= AdminRole.admin.index;
  bool get canAudit => index >= AdminRole.auditor.index;

  static AdminRole fromWire(String value) =>
      AdminRole.values.firstWhere((AdminRole r) => r.wire == value,
          orElse: () => AdminRole.viewer);
}

enum LocaleTag {
  bangla('bn'),
  english('en');

  const LocaleTag(this.code);

  final String code;

  static LocaleTag fromCode(String code) =>
      LocaleTag.values.firstWhere((LocaleTag l) => l.code == code,
          orElse: () => LocaleTag.english);
}

enum AuditAction {
  create('create'),
  update('update'),
  delete('delete'),
  submit('submit'),
  approve('approve'),
  reject('reject'),
  publish('publish'),
  archive('archive'),
  rollback('rollback'),
  branch('branch'),
  merge('merge'),
  upload('upload'),
  deprecate('deprecate'),
  roleAssign('role.assign'),
  roleRevoke('role.revoke');

  const AuditAction(this.wire);

  final String wire;

  static AuditAction fromWire(String value) =>
      AuditAction.values.firstWhere((AuditAction a) => a.wire == value,
          orElse: () => AuditAction.update);
}

enum FeatureFlagType {
  boolean('boolean'),
  string('string'),
  number('number'),
  json('json');

  const FeatureFlagType(this.wire);

  final String wire;

  static FeatureFlagType fromWire(String value) =>
      FeatureFlagType.values.firstWhere((FeatureFlagType t) => t.wire == value,
          orElse: () => FeatureFlagType.boolean);
}

enum LayerKind {
  sky('sky'),
  atmosphere('atmosphere'),
  world('world'),
  foreground('foreground'),
  hud('hud'),
  dialog('dialog');

  const LayerKind(this.wire);

  final String wire;

  static LayerKind fromWire(String value) =>
      LayerKind.values.firstWhere((LayerKind l) => l.wire == value,
          orElse: () => LayerKind.world);
}
