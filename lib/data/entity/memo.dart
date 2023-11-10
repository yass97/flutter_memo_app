import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'memo.freezed.dart';
part 'memo.g.dart';

@freezed
class Memo with _$Memo {
  const factory Memo({
    required String id,
    required String title,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Memo;

  factory Memo.fromJson(Map<String, Object?> json) => _$MemoFromJson(json);

  factory Memo.create(String title, String description) {
    return Memo(
      id: const Uuid().v8(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
