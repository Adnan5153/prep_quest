sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  R get right => (this as Right<L, R>).value;
  L get left => (this as Left<L, R>).value;

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) =>
      switch (this) {
        Left<L, R>(:final value) => onLeft(value),
        Right<L, R>(:final value) => onRight(value),
      };

  R getOrElse(R Function() orElse) =>
      switch (this) {
        Left<L, R>() => orElse(),
        Right<L, R>(:final value) => value,
      };
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;
}
