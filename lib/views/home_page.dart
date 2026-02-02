import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import 'widgets/news_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService client = ApiService();
  late Future<List<Article>> newsFuture;

  @override
  void initState() {
    super.initState();
    // Memanggil API saat pertama kali aplikasi dibuka
    newsFuture = client.getNews();
  }

  // Fungsi untuk menyegarkan berita (Pull to Refresh)
  Future<void> _refreshNews() async {
    setState(() {
      newsFuture = client.getNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Background abu muda agar kartu terlihat kontras
      appBar: AppBar(
        title: const Text(
          "Berita Indonesia",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _refreshNews,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: FutureBuilder<List<Article>>(
          future: newsFuture,
          builder: (context, snapshot) {
            // Kondisi saat loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }
            // Kondisi jika terjadi error (misal: API Key salah atau internet mati)
            else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Oops! Terjadi kesalahan:\n${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _refreshNews,
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                ),
              );
            }
            // Kondisi jika data berhasil diambil tapi kosong
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Tidak ada berita ditemukan."));
            }
            // Kondisi sukses: Menampilkan list berita
            else {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return NewsCard(article: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
