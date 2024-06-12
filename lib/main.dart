import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AnaKategoriEkrani(),
      ),
    );
  }
}

class DataModel extends ChangeNotifier {
  List<dynamic> _data = [];

  List<dynamic> get data => _data;

  void setData(List<dynamic> newData) {
    _data = newData;
    notifyListeners();
  }
}

class AnaKategoriEkrani extends StatelessWidget {
  const AnaKategoriEkrani({super.key});

  Future<void> fetchCategories(context) async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['categories'];
      Provider.of<DataModel>(listen: false, context).setData(data);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yemek Kategorileri',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchCategories(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final data = Provider.of<DataModel>(context).data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(data[index]['strCategoryThumb']),
                    ),
                    title: Text(
                      data[index]['strCategory'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data[index]['strCategoryDescription'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AltKategoriEkrani(
                            kategori: data[index]['strCategory'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AltKategoriEkrani extends StatelessWidget {
  final String kategori;

  const AltKategoriEkrani({super.key, required this.kategori});

  Future<List<dynamic>> fetchMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$kategori'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'];
    } else {
      throw Exception('Failed to load meals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kategori,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final meals = snapshot.data;
            return ListView.builder(
              itemCount: meals?.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: Hero(
                      tag: 'hero-tag-${meals?[index]['idMeal']}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(meals?[index]['strMealThumb']),
                      ),
                    ),
                    title: Text(
                      meals?[index]['strMeal'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YemekDetayEkrani(
                            yemekAdi: meals?[index]['strMeal'],
                            id: meals?[index]['idMeal'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class YemekDetayEkrani extends StatelessWidget {
  final String yemekAdi;
  final String id;

  const YemekDetayEkrani({super.key, required this.yemekAdi, required this.id});

  Future<Map<String, dynamic>> fetchMealDetail() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'][0];
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'hero-tag-$id-title',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              yemekAdi,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchMealDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final mealDetail = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'hero-tag-$id',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(mealDetail?['strMealThumb']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      mealDetail?['strMeal'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.orange),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      mealDetail?['strInstructions'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
