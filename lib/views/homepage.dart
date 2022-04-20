import 'package:flutter/material.dart';
import '../components/category_card.dart';
import '../components/data.dart';
import '../components/news.dart';
import '../components/widgets.dart';
import '../models/article.dart';
import '../models/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _loading;
  List<Article> newslist = [];

  List<CategoryModel> categories = [];

  //Function to fetch the news from the API and store in a list of Article
  Future<void> getNews() async {
    News news = News();
    await news.getNews();

    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    super.initState();

    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Creating a beautiful AppBar
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Flutter Daily News',
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.orange],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                //Till the loading is set to true, i.e. The data is being fetched
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            imageAssetUrl: categories[index].imageAssetUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: ListView.builder(
                        itemCount: newslist.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NewsTile(
                            imgUrl: newslist[index].urlToImage ?? "",
                            title: newslist[index].title ?? "",
                            desc: newslist[index].description ?? "",
                            content: newslist[index].content ?? "",
                            posturl: newslist[index].articleUrl ?? "",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
