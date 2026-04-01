import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/widget_value_loader.dart';
import '../../domain/entities/quote.dart';
import '../providers/quote_provider.dart';
import 'home_constants.dart';
import 'home_widgets.dart';

class QuoteCard extends ConsumerStatefulWidget {
  const QuoteCard({super.key});

  @override
  ConsumerState<QuoteCard> createState() => QuoteCardState();
}

class QuoteCardState extends ConsumerState<QuoteCard> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final quotesAsync = ref.watch(quotesProvider);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(kCardRadiusSmall),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded),
          const SizedBox(width: 12),

          Expanded(
            child: WidgetValueLoader<List<Quote>>(
              value: quotesAsync,
              dataBuilder: (list) {
                if (list.isEmpty) return const Text("No quotes");

                final quote = list[index % list.length];

                return Text(quote.content);
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
