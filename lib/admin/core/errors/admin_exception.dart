sealed class AdminException implements Exception {
  const AdminException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType($message)';
}

class AdminAuthException extends AdminException {
  const AdminAuthException(super.message, {super.cause});
}

class AdminAuthorizationException extends AdminException {
  const AdminAuthorizationException(super.message, {super.cause});
}

class AdminValidationException extends AdminException {
  const AdminValidationException(super.message, {this.field});
  final String? field;

  @override
  String toString() => 'AdminValidationException($message, field=$field)';
}

class AdminConflictException extends AdminException {
  const AdminConflictException(super.message, {this.currentVersion, super.cause});
  final Object? currentVersion;
}

class AdminNotFoundException extends AdminException {
  const AdminNotFoundException(super.message, {super.cause});
}

class AdminNetworkException extends AdminException {
  const AdminNetworkException(super.message, {super.cause});
}

class AdminSchemaException extends AdminException {
  const AdminSchemaException(super.message, {this.schemaId, super.cause});
  final String? schemaId;
}

class AdminAssetException extends AdminException {
  const AdminAssetException(super.message, {this.assetId, super.cause});
  final String? assetId;
}

class AdminPublishException extends AdminException {
  const AdminPublishException(super.message, {this.workflowState, super.cause});
  final String? workflowState;
}
