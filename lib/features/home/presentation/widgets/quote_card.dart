import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/widget_value_loader.dart';
import '../../domain/entities/quote.dart';
import '../providers/quote_provider.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/app_card.dart';

class QuoteCard extends ConsumerStatefulWidget {
  const QuoteCard({super.key});

  @override
  ConsumerState<QuoteCard> createState() => QuoteCardState();
}

class QuoteCardState extends ConsumerState<QuoteCard> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final quotesAsync = ref.watch(quotesProvider);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded),
          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: WidgetValueLoader<List<Quote>>(
              value: quotesAsync,
              dataBuilder: (list) {
                if (list.isEmpty) return const Text("No quotes");

                final quote = list[index % list.length];

                return Text(quote.content, style: AppTypography.bodyMedium);
              },
            ),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                index++; // ✅ local change only
              });
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }
}
