part of 'profile_cubit.dart';

class ProfileState {
  FormSubmissionStatus status;
  bool loadFromCache;

  ProfileState({
    this.status = const InitialFormStatus(),
    this.loadFromCache = true,
  });

  ProfileState copyWith({
    FormSubmissionStatus? status,
    bool? loadFromCache,
  }) {
    return ProfileState(
      status: status ?? this.status,
      loadFromCache: loadFromCache ?? this.loadFromCache,
    );
  }

  @override
  String toString() => 'ProfileState(status: $status, loadFromCache: $loadFromCache)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProfileState &&
      other.status == status &&
      other.loadFromCache == loadFromCache;
  }

  @override
  int get hashCode => status.hashCode ^ loadFromCache.hashCode;
}
