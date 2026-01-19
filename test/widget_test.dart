import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neon_lecture/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: NeonLectureApp(),
      ),
    );

    // Wait for initial animations to render
    await tester.pump(const Duration(seconds: 2));

    // Verify that the onboarding title appears
    expect(find.text('LISTEN & LEARN'), findsOneWidget);
    expect(
        find.text(
            'Real-time high-accuracy transcription of your live lectures.'),
        findsOneWidget);
  });
}
