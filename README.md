# mobile_application_development_course_project

TR

Proje Yapısı:

main.dart: Uygulamanın ana dosyası.
DataModel: Verileri yönetmek için kullanılan state management sınıfı.
AnaKategoriEkrani: Yemek kategorilerini listeleyen ana ekran.
AltKategoriEkrani: Seçilen kategoriye ait yemekleri listeleyen ekran.
YemekDetayEkrani: Seçilen yemeğin detaylarını gösteren ekran.

Yapılanlar:

API Entegrasyonu: TheMealDB API'sini kullanarak yemek kategorileri, yemekler ve yemek detayları çekildi.
State Management: Provider kullanarak state management yapısı oluşturuldu.
Navigasyon: Flutter'ın Navigator widget'ı kullanılarak ekranlar arası geçişler sağlandı.
Animasyonlar: Hero widget'ı kullanılarak geçiş animasyonları eklendi.
Liste ve Detay Görünümü: ListView widget'ı ile kategoriler ve yemekler listelendi, FutureBuilder ile API çağrıları asenkron olarak yönetildi.


EN

Project Structure:

main.dart: The main file of the application.
DataModel: State management class used to manage data.
AnaKategoriEkrani: Main screen that lists meal categories.
AltKategoriEkrani: Screen that lists meals in the selected category.
YemekDetayEkrani: Screen that shows details of the selected meal.

Features:

API Integration: Fetched meal categories, meals, and meal details using TheMealDB API.
State Management: Created a state management structure using Provider.
Navigation: Implemented screen transitions using Flutter's Navigator widget.
Animations: Added transition animations using the Hero widget.
List and Detail View: Listed categories and meals using the ListView widget, and managed asynchronous API calls with FutureBuilder.