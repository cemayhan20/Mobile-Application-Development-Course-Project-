import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_application_development_course_project/main.dart';

void main() {
  testWidgets('Ana Kategori Ekranı başlığını ve veri yüklemesini kontrol et', (WidgetTester tester) async {
    // Uygulamayı oluştur ve bir frame tetikle.
    await tester.pumpWidget(const MyApp());

    // Ana Kategori Ekranı başlığını kontrol et.
    expect(find.text('Yemek Kategorileri'), findsOneWidget);

    // Veri yüklendiğinde ListView'i kontrol et.
    // İlk olarak, verilerin yüklenmesini bekle.
    await tester.pumpAndSettle();

    // Verilerin yüklendiğini ve ListView'in görüntülendiğini kontrol et.
    expect(find.byType(ListView), findsOneWidget);
  });
}
