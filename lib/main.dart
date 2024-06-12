import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnaKategoriEkrani(),
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
  Future<void> fetchCategories(BuildContext context) async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['categories'];
      Provider.of<DataModel>(context, listen: false).setData(data);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yemek Kategorileri'),
      ),
      body: FutureBuilder(
        future: fetchCategories(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final data = Provider.of<DataModel>(context).data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]['strCategory']),
                  subtitle: Text(data[index]['strCategoryDescription'], maxLines: 2, overflow: TextOverflow.ellipsis),
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

  AltKategoriEkrani({required this.kategori});

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
        title: Text(kategori),
      ),
      body: FutureBuilder(
        future: fetchMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final meals = snapshot.data;
            return ListView.builder(
              itemCount: meals?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Hero(
                    tag: 'hero-tag-${meals?[index]['idMeal']}',
                    child: Text(meals?[index]['strMeal']),
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

  YemekDetayEkrani({required this.yemekAdi, required this.id});

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
        title: Text(yemekAdi),
      ),
      body: FutureBuilder(
        future: fetchMealDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final mealDetail = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: 'hero-tag-$id',
                    child: Image.network(mealDetail?['strMealThumb']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      mealDetail?['strInstructions'],
                      style: TextStyle(fontSize: 16),
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

