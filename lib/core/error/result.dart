import 'failure.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  const Result.success(this.data) : failure = null;
  const Result.failure(this.failure) : data = null;

  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;

  void fold(void Function(T data) onSuccess, void Function(Failure failure) onFailure) {
    if (isSuccess) {
      onSuccess(data as T);
    } else {
      onFailure(failure!);
    }
  }
}
