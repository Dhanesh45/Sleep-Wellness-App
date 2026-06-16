import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_ui/main.dart';

void main() {
  testWidgets('App renders setup screen when Supabase is not ready', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(supabaseReady: false));

    // Verify that the setup screen text exists.
    expect(find.text('Supabase Setup'), findsOneWidget);
    expect(find.text('Supabase credentials are invalid'), findsOneWidget);
  });
}
