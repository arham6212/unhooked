import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetValueLoader<T> extends ConsumerWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) dataBuilder;
  final Widget? loading;
  final Widget Function(Object error, StackTrace stack)? errorBuilder;

  const WidgetValueLoader({
    super.key,
    required this.value,
    required this.dataBuilder,
    this.loading,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return value.when(
      data: (data) => dataBuilder(data),
      loading: () =>
      loading ??
          const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
      errorBuilder?.call(error, stack) ??
          Center(child: Text('Error: $error')),
    );
  }
}