// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) {
  return _LeaderboardEntry.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntry {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  double get averageAccuracy => throw _privateConstructorUsedError;
  int get totalBattlesWon => throw _privateConstructorUsedError;
  double get winRate => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntryCopyWith<$Res> {
  factory $LeaderboardEntryCopyWith(
    LeaderboardEntry value,
    $Res Function(LeaderboardEntry) then,
  ) = _$LeaderboardEntryCopyWithImpl<$Res, LeaderboardEntry>;
  @useResult
  $Res call({
    String userId,
    String displayName,
    String profileImageUrl,
    int grade,
    int rank,
    int totalScore,
    double averageAccuracy,
    int totalBattlesWon,
    double winRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res, $Val extends LeaderboardEntry>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? grade = null,
    Object? rank = null,
    Object? totalScore = null,
    Object? averageAccuracy = null,
    Object? totalBattlesWon = null,
    Object? winRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImageUrl: null == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            grade: null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                      as int,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
            averageAccuracy: null == averageAccuracy
                ? _value.averageAccuracy
                : averageAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            totalBattlesWon: null == totalBattlesWon
                ? _value.totalBattlesWon
                : totalBattlesWon // ignore: cast_nullable_to_non_nullable
                      as int,
            winRate: null == winRate
                ? _value.winRate
                : winRate // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaderboardEntryImplCopyWith<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  factory _$$LeaderboardEntryImplCopyWith(
    _$LeaderboardEntryImpl value,
    $Res Function(_$LeaderboardEntryImpl) then,
  ) = __$$LeaderboardEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String displayName,
    String profileImageUrl,
    int grade,
    int rank,
    int totalScore,
    double averageAccuracy,
    int totalBattlesWon,
    double winRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$LeaderboardEntryImplCopyWithImpl<$Res>
    extends _$LeaderboardEntryCopyWithImpl<$Res, _$LeaderboardEntryImpl>
    implements _$$LeaderboardEntryImplCopyWith<$Res> {
  __$$LeaderboardEntryImplCopyWithImpl(
    _$LeaderboardEntryImpl _value,
    $Res Function(_$LeaderboardEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? grade = null,
    Object? rank = null,
    Object? totalScore = null,
    Object? averageAccuracy = null,
    Object? totalBattlesWon = null,
    Object? winRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$LeaderboardEntryImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageUrl: null == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        grade: null == grade
            ? _value.grade
            : grade // ignore: cast_nullable_to_non_nullable
                  as int,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
        averageAccuracy: null == averageAccuracy
            ? _value.averageAccuracy
            : averageAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        totalBattlesWon: null == totalBattlesWon
            ? _value.totalBattlesWon
            : totalBattlesWon // ignore: cast_nullable_to_non_nullable
                  as int,
        winRate: null == winRate
            ? _value.winRate
            : winRate // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardEntryImpl implements _LeaderboardEntry {
  const _$LeaderboardEntryImpl({
    required this.userId,
    required this.displayName,
    required this.profileImageUrl,
    required this.grade,
    required this.rank,
    required this.totalScore,
    required this.averageAccuracy,
    required this.totalBattlesWon,
    required this.winRate,
    required this.lastUpdated,
  });

  factory _$LeaderboardEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntryImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String profileImageUrl;
  @override
  final int grade;
  @override
  final int rank;
  @override
  final int totalScore;
  @override
  final double averageAccuracy;
  @override
  final int totalBattlesWon;
  @override
  final double winRate;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'LeaderboardEntry(userId: $userId, displayName: $displayName, profileImageUrl: $profileImageUrl, grade: $grade, rank: $rank, totalScore: $totalScore, averageAccuracy: $averageAccuracy, totalBattlesWon: $totalBattlesWon, winRate: $winRate, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardEntryImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.averageAccuracy, averageAccuracy) ||
                other.averageAccuracy == averageAccuracy) &&
            (identical(other.totalBattlesWon, totalBattlesWon) ||
                other.totalBattlesWon == totalBattlesWon) &&
            (identical(other.winRate, winRate) || other.winRate == winRate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    displayName,
    profileImageUrl,
    grade,
    rank,
    totalScore,
    averageAccuracy,
    totalBattlesWon,
    winRate,
    lastUpdated,
  );

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      __$$LeaderboardEntryImplCopyWithImpl<_$LeaderboardEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntryImplToJson(this);
  }
}

abstract class _LeaderboardEntry implements LeaderboardEntry {
  const factory _LeaderboardEntry({
    required final String userId,
    required final String displayName,
    required final String profileImageUrl,
    required final int grade,
    required final int rank,
    required final int totalScore,
    required final double averageAccuracy,
    required final int totalBattlesWon,
    required final double winRate,
    required final DateTime lastUpdated,
  }) = _$LeaderboardEntryImpl;

  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntryImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String get profileImageUrl;
  @override
  int get grade;
  @override
  int get rank;
  @override
  int get totalScore;
  @override
  double get averageAccuracy;
  @override
  int get totalBattlesWon;
  @override
  double get winRate;
  @override
  DateTime get lastUpdated;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RankingData _$RankingDataFromJson(Map<String, dynamic> json) {
  return _RankingData.fromJson(json);
}

/// @nodoc
mixin _$RankingData {
  String get rankingId => throw _privateConstructorUsedError;
  String get rankingType =>
      throw _privateConstructorUsedError; // global, grade_level, friend_group
  int get grade => throw _privateConstructorUsedError; // null if global
  List<LeaderboardEntry> get entries => throw _privateConstructorUsedError;
  DateTime get updatedDate => throw _privateConstructorUsedError;

  /// Serializes this RankingData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RankingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingDataCopyWith<RankingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingDataCopyWith<$Res> {
  factory $RankingDataCopyWith(
    RankingData value,
    $Res Function(RankingData) then,
  ) = _$RankingDataCopyWithImpl<$Res, RankingData>;
  @useResult
  $Res call({
    String rankingId,
    String rankingType,
    int grade,
    List<LeaderboardEntry> entries,
    DateTime updatedDate,
  });
}

/// @nodoc
class _$RankingDataCopyWithImpl<$Res, $Val extends RankingData>
    implements $RankingDataCopyWith<$Res> {
  _$RankingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rankingId = null,
    Object? rankingType = null,
    Object? grade = null,
    Object? entries = null,
    Object? updatedDate = null,
  }) {
    return _then(
      _value.copyWith(
            rankingId: null == rankingId
                ? _value.rankingId
                : rankingId // ignore: cast_nullable_to_non_nullable
                      as String,
            rankingType: null == rankingType
                ? _value.rankingType
                : rankingType // ignore: cast_nullable_to_non_nullable
                      as String,
            grade: null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                      as int,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardEntry>,
            updatedDate: null == updatedDate
                ? _value.updatedDate
                : updatedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RankingDataImplCopyWith<$Res>
    implements $RankingDataCopyWith<$Res> {
  factory _$$RankingDataImplCopyWith(
    _$RankingDataImpl value,
    $Res Function(_$RankingDataImpl) then,
  ) = __$$RankingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String rankingId,
    String rankingType,
    int grade,
    List<LeaderboardEntry> entries,
    DateTime updatedDate,
  });
}

/// @nodoc
class __$$RankingDataImplCopyWithImpl<$Res>
    extends _$RankingDataCopyWithImpl<$Res, _$RankingDataImpl>
    implements _$$RankingDataImplCopyWith<$Res> {
  __$$RankingDataImplCopyWithImpl(
    _$RankingDataImpl _value,
    $Res Function(_$RankingDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rankingId = null,
    Object? rankingType = null,
    Object? grade = null,
    Object? entries = null,
    Object? updatedDate = null,
  }) {
    return _then(
      _$RankingDataImpl(
        rankingId: null == rankingId
            ? _value.rankingId
            : rankingId // ignore: cast_nullable_to_non_nullable
                  as String,
        rankingType: null == rankingType
            ? _value.rankingType
            : rankingType // ignore: cast_nullable_to_non_nullable
                  as String,
        grade: null == grade
            ? _value.grade
            : grade // ignore: cast_nullable_to_non_nullable
                  as int,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardEntry>,
        updatedDate: null == updatedDate
            ? _value.updatedDate
            : updatedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RankingDataImpl implements _RankingData {
  const _$RankingDataImpl({
    required this.rankingId,
    required this.rankingType,
    required this.grade,
    required final List<LeaderboardEntry> entries,
    required this.updatedDate,
  }) : _entries = entries;

  factory _$RankingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingDataImplFromJson(json);

  @override
  final String rankingId;
  @override
  final String rankingType;
  // global, grade_level, friend_group
  @override
  final int grade;
  // null if global
  final List<LeaderboardEntry> _entries;
  // null if global
  @override
  List<LeaderboardEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final DateTime updatedDate;

  @override
  String toString() {
    return 'RankingData(rankingId: $rankingId, rankingType: $rankingType, grade: $grade, entries: $entries, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingDataImpl &&
            (identical(other.rankingId, rankingId) ||
                other.rankingId == rankingId) &&
            (identical(other.rankingType, rankingType) ||
                other.rankingType == rankingType) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.updatedDate, updatedDate) ||
                other.updatedDate == updatedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rankingId,
    rankingType,
    grade,
    const DeepCollectionEquality().hash(_entries),
    updatedDate,
  );

  /// Create a copy of RankingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingDataImplCopyWith<_$RankingDataImpl> get copyWith =>
      __$$RankingDataImplCopyWithImpl<_$RankingDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingDataImplToJson(this);
  }
}

abstract class _RankingData implements RankingData {
  const factory _RankingData({
    required final String rankingId,
    required final String rankingType,
    required final int grade,
    required final List<LeaderboardEntry> entries,
    required final DateTime updatedDate,
  }) = _$RankingDataImpl;

  factory _RankingData.fromJson(Map<String, dynamic> json) =
      _$RankingDataImpl.fromJson;

  @override
  String get rankingId;
  @override
  String get rankingType; // global, grade_level, friend_group
  @override
  int get grade; // null if global
  @override
  List<LeaderboardEntry> get entries;
  @override
  DateTime get updatedDate;

  /// Create a copy of RankingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingDataImplCopyWith<_$RankingDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserRanking _$UserRankingFromJson(Map<String, dynamic> json) {
  return _UserRanking.fromJson(json);
}

/// @nodoc
mixin _$UserRanking {
  String get userId => throw _privateConstructorUsedError;
  int get globalRank => throw _privateConstructorUsedError;
  int get gradeRank => throw _privateConstructorUsedError;
  int get friendGroupRank => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  double get winRate => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this UserRanking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRankingCopyWith<UserRanking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRankingCopyWith<$Res> {
  factory $UserRankingCopyWith(
    UserRanking value,
    $Res Function(UserRanking) then,
  ) = _$UserRankingCopyWithImpl<$Res, UserRanking>;
  @useResult
  $Res call({
    String userId,
    int globalRank,
    int gradeRank,
    int friendGroupRank,
    int totalScore,
    double winRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$UserRankingCopyWithImpl<$Res, $Val extends UserRanking>
    implements $UserRankingCopyWith<$Res> {
  _$UserRankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? globalRank = null,
    Object? gradeRank = null,
    Object? friendGroupRank = null,
    Object? totalScore = null,
    Object? winRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            globalRank: null == globalRank
                ? _value.globalRank
                : globalRank // ignore: cast_nullable_to_non_nullable
                      as int,
            gradeRank: null == gradeRank
                ? _value.gradeRank
                : gradeRank // ignore: cast_nullable_to_non_nullable
                      as int,
            friendGroupRank: null == friendGroupRank
                ? _value.friendGroupRank
                : friendGroupRank // ignore: cast_nullable_to_non_nullable
                      as int,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
            winRate: null == winRate
                ? _value.winRate
                : winRate // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserRankingImplCopyWith<$Res>
    implements $UserRankingCopyWith<$Res> {
  factory _$$UserRankingImplCopyWith(
    _$UserRankingImpl value,
    $Res Function(_$UserRankingImpl) then,
  ) = __$$UserRankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int globalRank,
    int gradeRank,
    int friendGroupRank,
    int totalScore,
    double winRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$UserRankingImplCopyWithImpl<$Res>
    extends _$UserRankingCopyWithImpl<$Res, _$UserRankingImpl>
    implements _$$UserRankingImplCopyWith<$Res> {
  __$$UserRankingImplCopyWithImpl(
    _$UserRankingImpl _value,
    $Res Function(_$UserRankingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? globalRank = null,
    Object? gradeRank = null,
    Object? friendGroupRank = null,
    Object? totalScore = null,
    Object? winRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$UserRankingImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        globalRank: null == globalRank
            ? _value.globalRank
            : globalRank // ignore: cast_nullable_to_non_nullable
                  as int,
        gradeRank: null == gradeRank
            ? _value.gradeRank
            : gradeRank // ignore: cast_nullable_to_non_nullable
                  as int,
        friendGroupRank: null == friendGroupRank
            ? _value.friendGroupRank
            : friendGroupRank // ignore: cast_nullable_to_non_nullable
                  as int,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
        winRate: null == winRate
            ? _value.winRate
            : winRate // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRankingImpl implements _UserRanking {
  const _$UserRankingImpl({
    required this.userId,
    required this.globalRank,
    required this.gradeRank,
    required this.friendGroupRank,
    required this.totalScore,
    required this.winRate,
    required this.lastUpdated,
  });

  factory _$UserRankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRankingImplFromJson(json);

  @override
  final String userId;
  @override
  final int globalRank;
  @override
  final int gradeRank;
  @override
  final int friendGroupRank;
  @override
  final int totalScore;
  @override
  final double winRate;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'UserRanking(userId: $userId, globalRank: $globalRank, gradeRank: $gradeRank, friendGroupRank: $friendGroupRank, totalScore: $totalScore, winRate: $winRate, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRankingImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.globalRank, globalRank) ||
                other.globalRank == globalRank) &&
            (identical(other.gradeRank, gradeRank) ||
                other.gradeRank == gradeRank) &&
            (identical(other.friendGroupRank, friendGroupRank) ||
                other.friendGroupRank == friendGroupRank) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.winRate, winRate) || other.winRate == winRate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    globalRank,
    gradeRank,
    friendGroupRank,
    totalScore,
    winRate,
    lastUpdated,
  );

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRankingImplCopyWith<_$UserRankingImpl> get copyWith =>
      __$$UserRankingImplCopyWithImpl<_$UserRankingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRankingImplToJson(this);
  }
}

abstract class _UserRanking implements UserRanking {
  const factory _UserRanking({
    required final String userId,
    required final int globalRank,
    required final int gradeRank,
    required final int friendGroupRank,
    required final int totalScore,
    required final double winRate,
    required final DateTime lastUpdated,
  }) = _$UserRankingImpl;

  factory _UserRanking.fromJson(Map<String, dynamic> json) =
      _$UserRankingImpl.fromJson;

  @override
  String get userId;
  @override
  int get globalRank;
  @override
  int get gradeRank;
  @override
  int get friendGroupRank;
  @override
  int get totalScore;
  @override
  double get winRate;
  @override
  DateTime get lastUpdated;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRankingImplCopyWith<_$UserRankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BattleLeaderboard _$BattleLeaderboardFromJson(Map<String, dynamic> json) {
  return _BattleLeaderboard.fromJson(json);
}

/// @nodoc
mixin _$BattleLeaderboard {
  String get leaderboardId => throw _privateConstructorUsedError;
  String get periodType =>
      throw _privateConstructorUsedError; // weekly, monthly, all_time
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;
  List<LeaderboardEntry> get battleWinners =>
      throw _privateConstructorUsedError;
  List<LeaderboardEntry> get highestScorers =>
      throw _privateConstructorUsedError;

  /// Serializes this BattleLeaderboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BattleLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattleLeaderboardCopyWith<BattleLeaderboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattleLeaderboardCopyWith<$Res> {
  factory $BattleLeaderboardCopyWith(
    BattleLeaderboard value,
    $Res Function(BattleLeaderboard) then,
  ) = _$BattleLeaderboardCopyWithImpl<$Res, BattleLeaderboard>;
  @useResult
  $Res call({
    String leaderboardId,
    String periodType,
    DateTime periodStart,
    DateTime periodEnd,
    List<LeaderboardEntry> battleWinners,
    List<LeaderboardEntry> highestScorers,
  });
}

/// @nodoc
class _$BattleLeaderboardCopyWithImpl<$Res, $Val extends BattleLeaderboard>
    implements $BattleLeaderboardCopyWith<$Res> {
  _$BattleLeaderboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BattleLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaderboardId = null,
    Object? periodType = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? battleWinners = null,
    Object? highestScorers = null,
  }) {
    return _then(
      _value.copyWith(
            leaderboardId: null == leaderboardId
                ? _value.leaderboardId
                : leaderboardId // ignore: cast_nullable_to_non_nullable
                      as String,
            periodType: null == periodType
                ? _value.periodType
                : periodType // ignore: cast_nullable_to_non_nullable
                      as String,
            periodStart: null == periodStart
                ? _value.periodStart
                : periodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            periodEnd: null == periodEnd
                ? _value.periodEnd
                : periodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            battleWinners: null == battleWinners
                ? _value.battleWinners
                : battleWinners // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardEntry>,
            highestScorers: null == highestScorers
                ? _value.highestScorers
                : highestScorers // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BattleLeaderboardImplCopyWith<$Res>
    implements $BattleLeaderboardCopyWith<$Res> {
  factory _$$BattleLeaderboardImplCopyWith(
    _$BattleLeaderboardImpl value,
    $Res Function(_$BattleLeaderboardImpl) then,
  ) = __$$BattleLeaderboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leaderboardId,
    String periodType,
    DateTime periodStart,
    DateTime periodEnd,
    List<LeaderboardEntry> battleWinners,
    List<LeaderboardEntry> highestScorers,
  });
}

/// @nodoc
class __$$BattleLeaderboardImplCopyWithImpl<$Res>
    extends _$BattleLeaderboardCopyWithImpl<$Res, _$BattleLeaderboardImpl>
    implements _$$BattleLeaderboardImplCopyWith<$Res> {
  __$$BattleLeaderboardImplCopyWithImpl(
    _$BattleLeaderboardImpl _value,
    $Res Function(_$BattleLeaderboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BattleLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaderboardId = null,
    Object? periodType = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? battleWinners = null,
    Object? highestScorers = null,
  }) {
    return _then(
      _$BattleLeaderboardImpl(
        leaderboardId: null == leaderboardId
            ? _value.leaderboardId
            : leaderboardId // ignore: cast_nullable_to_non_nullable
                  as String,
        periodType: null == periodType
            ? _value.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        periodStart: null == periodStart
            ? _value.periodStart
            : periodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodEnd: null == periodEnd
            ? _value.periodEnd
            : periodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        battleWinners: null == battleWinners
            ? _value._battleWinners
            : battleWinners // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardEntry>,
        highestScorers: null == highestScorers
            ? _value._highestScorers
            : highestScorers // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BattleLeaderboardImpl implements _BattleLeaderboard {
  const _$BattleLeaderboardImpl({
    required this.leaderboardId,
    required this.periodType,
    required this.periodStart,
    required this.periodEnd,
    required final List<LeaderboardEntry> battleWinners,
    required final List<LeaderboardEntry> highestScorers,
  }) : _battleWinners = battleWinners,
       _highestScorers = highestScorers;

  factory _$BattleLeaderboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattleLeaderboardImplFromJson(json);

  @override
  final String leaderboardId;
  @override
  final String periodType;
  // weekly, monthly, all_time
  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;
  final List<LeaderboardEntry> _battleWinners;
  @override
  List<LeaderboardEntry> get battleWinners {
    if (_battleWinners is EqualUnmodifiableListView) return _battleWinners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_battleWinners);
  }

  final List<LeaderboardEntry> _highestScorers;
  @override
  List<LeaderboardEntry> get highestScorers {
    if (_highestScorers is EqualUnmodifiableListView) return _highestScorers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highestScorers);
  }

  @override
  String toString() {
    return 'BattleLeaderboard(leaderboardId: $leaderboardId, periodType: $periodType, periodStart: $periodStart, periodEnd: $periodEnd, battleWinners: $battleWinners, highestScorers: $highestScorers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattleLeaderboardImpl &&
            (identical(other.leaderboardId, leaderboardId) ||
                other.leaderboardId == leaderboardId) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            const DeepCollectionEquality().equals(
              other._battleWinners,
              _battleWinners,
            ) &&
            const DeepCollectionEquality().equals(
              other._highestScorers,
              _highestScorers,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leaderboardId,
    periodType,
    periodStart,
    periodEnd,
    const DeepCollectionEquality().hash(_battleWinners),
    const DeepCollectionEquality().hash(_highestScorers),
  );

  /// Create a copy of BattleLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattleLeaderboardImplCopyWith<_$BattleLeaderboardImpl> get copyWith =>
      __$$BattleLeaderboardImplCopyWithImpl<_$BattleLeaderboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BattleLeaderboardImplToJson(this);
  }
}

abstract class _BattleLeaderboard implements BattleLeaderboard {
  const factory _BattleLeaderboard({
    required final String leaderboardId,
    required final String periodType,
    required final DateTime periodStart,
    required final DateTime periodEnd,
    required final List<LeaderboardEntry> battleWinners,
    required final List<LeaderboardEntry> highestScorers,
  }) = _$BattleLeaderboardImpl;

  factory _BattleLeaderboard.fromJson(Map<String, dynamic> json) =
      _$BattleLeaderboardImpl.fromJson;

  @override
  String get leaderboardId;
  @override
  String get periodType; // weekly, monthly, all_time
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;
  @override
  List<LeaderboardEntry> get battleWinners;
  @override
  List<LeaderboardEntry> get highestScorers;

  /// Create a copy of BattleLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattleLeaderboardImplCopyWith<_$BattleLeaderboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadingLeaderboard _$ReadingLeaderboardFromJson(Map<String, dynamic> json) {
  return _ReadingLeaderboard.fromJson(json);
}

/// @nodoc
mixin _$ReadingLeaderboard {
  String get leaderboardId => throw _privateConstructorUsedError;
  String get periodType => throw _privateConstructorUsedError;
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;
  List<ReadingLeaderboardEntry> get topReaders =>
      throw _privateConstructorUsedError;

  /// Serializes this ReadingLeaderboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingLeaderboardCopyWith<ReadingLeaderboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingLeaderboardCopyWith<$Res> {
  factory $ReadingLeaderboardCopyWith(
    ReadingLeaderboard value,
    $Res Function(ReadingLeaderboard) then,
  ) = _$ReadingLeaderboardCopyWithImpl<$Res, ReadingLeaderboard>;
  @useResult
  $Res call({
    String leaderboardId,
    String periodType,
    DateTime periodStart,
    DateTime periodEnd,
    List<ReadingLeaderboardEntry> topReaders,
  });
}

/// @nodoc
class _$ReadingLeaderboardCopyWithImpl<$Res, $Val extends ReadingLeaderboard>
    implements $ReadingLeaderboardCopyWith<$Res> {
  _$ReadingLeaderboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaderboardId = null,
    Object? periodType = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? topReaders = null,
  }) {
    return _then(
      _value.copyWith(
            leaderboardId: null == leaderboardId
                ? _value.leaderboardId
                : leaderboardId // ignore: cast_nullable_to_non_nullable
                      as String,
            periodType: null == periodType
                ? _value.periodType
                : periodType // ignore: cast_nullable_to_non_nullable
                      as String,
            periodStart: null == periodStart
                ? _value.periodStart
                : periodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            periodEnd: null == periodEnd
                ? _value.periodEnd
                : periodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            topReaders: null == topReaders
                ? _value.topReaders
                : topReaders // ignore: cast_nullable_to_non_nullable
                      as List<ReadingLeaderboardEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingLeaderboardImplCopyWith<$Res>
    implements $ReadingLeaderboardCopyWith<$Res> {
  factory _$$ReadingLeaderboardImplCopyWith(
    _$ReadingLeaderboardImpl value,
    $Res Function(_$ReadingLeaderboardImpl) then,
  ) = __$$ReadingLeaderboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leaderboardId,
    String periodType,
    DateTime periodStart,
    DateTime periodEnd,
    List<ReadingLeaderboardEntry> topReaders,
  });
}

/// @nodoc
class __$$ReadingLeaderboardImplCopyWithImpl<$Res>
    extends _$ReadingLeaderboardCopyWithImpl<$Res, _$ReadingLeaderboardImpl>
    implements _$$ReadingLeaderboardImplCopyWith<$Res> {
  __$$ReadingLeaderboardImplCopyWithImpl(
    _$ReadingLeaderboardImpl _value,
    $Res Function(_$ReadingLeaderboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaderboardId = null,
    Object? periodType = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? topReaders = null,
  }) {
    return _then(
      _$ReadingLeaderboardImpl(
        leaderboardId: null == leaderboardId
            ? _value.leaderboardId
            : leaderboardId // ignore: cast_nullable_to_non_nullable
                  as String,
        periodType: null == periodType
            ? _value.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        periodStart: null == periodStart
            ? _value.periodStart
            : periodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodEnd: null == periodEnd
            ? _value.periodEnd
            : periodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        topReaders: null == topReaders
            ? _value._topReaders
            : topReaders // ignore: cast_nullable_to_non_nullable
                  as List<ReadingLeaderboardEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingLeaderboardImpl implements _ReadingLeaderboard {
  const _$ReadingLeaderboardImpl({
    required this.leaderboardId,
    required this.periodType,
    required this.periodStart,
    required this.periodEnd,
    required final List<ReadingLeaderboardEntry> topReaders,
  }) : _topReaders = topReaders;

  factory _$ReadingLeaderboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingLeaderboardImplFromJson(json);

  @override
  final String leaderboardId;
  @override
  final String periodType;
  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;
  final List<ReadingLeaderboardEntry> _topReaders;
  @override
  List<ReadingLeaderboardEntry> get topReaders {
    if (_topReaders is EqualUnmodifiableListView) return _topReaders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topReaders);
  }

  @override
  String toString() {
    return 'ReadingLeaderboard(leaderboardId: $leaderboardId, periodType: $periodType, periodStart: $periodStart, periodEnd: $periodEnd, topReaders: $topReaders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingLeaderboardImpl &&
            (identical(other.leaderboardId, leaderboardId) ||
                other.leaderboardId == leaderboardId) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            const DeepCollectionEquality().equals(
              other._topReaders,
              _topReaders,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leaderboardId,
    periodType,
    periodStart,
    periodEnd,
    const DeepCollectionEquality().hash(_topReaders),
  );

  /// Create a copy of ReadingLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingLeaderboardImplCopyWith<_$ReadingLeaderboardImpl> get copyWith =>
      __$$ReadingLeaderboardImplCopyWithImpl<_$ReadingLeaderboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingLeaderboardImplToJson(this);
  }
}

abstract class _ReadingLeaderboard implements ReadingLeaderboard {
  const factory _ReadingLeaderboard({
    required final String leaderboardId,
    required final String periodType,
    required final DateTime periodStart,
    required final DateTime periodEnd,
    required final List<ReadingLeaderboardEntry> topReaders,
  }) = _$ReadingLeaderboardImpl;

  factory _ReadingLeaderboard.fromJson(Map<String, dynamic> json) =
      _$ReadingLeaderboardImpl.fromJson;

  @override
  String get leaderboardId;
  @override
  String get periodType;
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;
  @override
  List<ReadingLeaderboardEntry> get topReaders;

  /// Create a copy of ReadingLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingLeaderboardImplCopyWith<_$ReadingLeaderboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadingLeaderboardEntry _$ReadingLeaderboardEntryFromJson(
  Map<String, dynamic> json,
) {
  return _ReadingLeaderboardEntry.fromJson(json);
}

/// @nodoc
mixin _$ReadingLeaderboardEntry {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  int get totalReadingMinutes => throw _privateConstructorUsedError;
  int get passagesCompleted => throw _privateConstructorUsedError;
  double get averageComprehensionScore => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;

  /// Serializes this ReadingLeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingLeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingLeaderboardEntryCopyWith<ReadingLeaderboardEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingLeaderboardEntryCopyWith<$Res> {
  factory $ReadingLeaderboardEntryCopyWith(
    ReadingLeaderboardEntry value,
    $Res Function(ReadingLeaderboardEntry) then,
  ) = _$ReadingLeaderboardEntryCopyWithImpl<$Res, ReadingLeaderboardEntry>;
  @useResult
  $Res call({
    String userId,
    String displayName,
    String profileImageUrl,
    int totalReadingMinutes,
    int passagesCompleted,
    double averageComprehensionScore,
    int rank,
  });
}

/// @nodoc
class _$ReadingLeaderboardEntryCopyWithImpl<
  $Res,
  $Val extends ReadingLeaderboardEntry
>
    implements $ReadingLeaderboardEntryCopyWith<$Res> {
  _$ReadingLeaderboardEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingLeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? totalReadingMinutes = null,
    Object? passagesCompleted = null,
    Object? averageComprehensionScore = null,
    Object? rank = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImageUrl: null == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            totalReadingMinutes: null == totalReadingMinutes
                ? _value.totalReadingMinutes
                : totalReadingMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            passagesCompleted: null == passagesCompleted
                ? _value.passagesCompleted
                : passagesCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            averageComprehensionScore: null == averageComprehensionScore
                ? _value.averageComprehensionScore
                : averageComprehensionScore // ignore: cast_nullable_to_non_nullable
                      as double,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingLeaderboardEntryImplCopyWith<$Res>
    implements $ReadingLeaderboardEntryCopyWith<$Res> {
  factory _$$ReadingLeaderboardEntryImplCopyWith(
    _$ReadingLeaderboardEntryImpl value,
    $Res Function(_$ReadingLeaderboardEntryImpl) then,
  ) = __$$ReadingLeaderboardEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String displayName,
    String profileImageUrl,
    int totalReadingMinutes,
    int passagesCompleted,
    double averageComprehensionScore,
    int rank,
  });
}

/// @nodoc
class __$$ReadingLeaderboardEntryImplCopyWithImpl<$Res>
    extends
        _$ReadingLeaderboardEntryCopyWithImpl<
          $Res,
          _$ReadingLeaderboardEntryImpl
        >
    implements _$$ReadingLeaderboardEntryImplCopyWith<$Res> {
  __$$ReadingLeaderboardEntryImplCopyWithImpl(
    _$ReadingLeaderboardEntryImpl _value,
    $Res Function(_$ReadingLeaderboardEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingLeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? totalReadingMinutes = null,
    Object? passagesCompleted = null,
    Object? averageComprehensionScore = null,
    Object? rank = null,
  }) {
    return _then(
      _$ReadingLeaderboardEntryImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageUrl: null == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        totalReadingMinutes: null == totalReadingMinutes
            ? _value.totalReadingMinutes
            : totalReadingMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        passagesCompleted: null == passagesCompleted
            ? _value.passagesCompleted
            : passagesCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        averageComprehensionScore: null == averageComprehensionScore
            ? _value.averageComprehensionScore
            : averageComprehensionScore // ignore: cast_nullable_to_non_nullable
                  as double,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingLeaderboardEntryImpl implements _ReadingLeaderboardEntry {
  const _$ReadingLeaderboardEntryImpl({
    required this.userId,
    required this.displayName,
    required this.profileImageUrl,
    required this.totalReadingMinutes,
    required this.passagesCompleted,
    required this.averageComprehensionScore,
    required this.rank,
  });

  factory _$ReadingLeaderboardEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingLeaderboardEntryImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String profileImageUrl;
  @override
  final int totalReadingMinutes;
  @override
  final int passagesCompleted;
  @override
  final double averageComprehensionScore;
  @override
  final int rank;

  @override
  String toString() {
    return 'ReadingLeaderboardEntry(userId: $userId, displayName: $displayName, profileImageUrl: $profileImageUrl, totalReadingMinutes: $totalReadingMinutes, passagesCompleted: $passagesCompleted, averageComprehensionScore: $averageComprehensionScore, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingLeaderboardEntryImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.totalReadingMinutes, totalReadingMinutes) ||
                other.totalReadingMinutes == totalReadingMinutes) &&
            (identical(other.passagesCompleted, passagesCompleted) ||
                other.passagesCompleted == passagesCompleted) &&
            (identical(
                  other.averageComprehensionScore,
                  averageComprehensionScore,
                ) ||
                other.averageComprehensionScore == averageComprehensionScore) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    displayName,
    profileImageUrl,
    totalReadingMinutes,
    passagesCompleted,
    averageComprehensionScore,
    rank,
  );

  /// Create a copy of ReadingLeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingLeaderboardEntryImplCopyWith<_$ReadingLeaderboardEntryImpl>
  get copyWith =>
      __$$ReadingLeaderboardEntryImplCopyWithImpl<
        _$ReadingLeaderboardEntryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingLeaderboardEntryImplToJson(this);
  }
}

abstract class _ReadingLeaderboardEntry implements ReadingLeaderboardEntry {
  const factory _ReadingLeaderboardEntry({
    required final String userId,
    required final String displayName,
    required final String profileImageUrl,
    required final int totalReadingMinutes,
    required final int passagesCompleted,
    required final double averageComprehensionScore,
    required final int rank,
  }) = _$ReadingLeaderboardEntryImpl;

  factory _ReadingLeaderboardEntry.fromJson(Map<String, dynamic> json) =
      _$ReadingLeaderboardEntryImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String get profileImageUrl;
  @override
  int get totalReadingMinutes;
  @override
  int get passagesCompleted;
  @override
  double get averageComprehensionScore;
  @override
  int get rank;

  /// Create a copy of ReadingLeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingLeaderboardEntryImplCopyWith<_$ReadingLeaderboardEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
