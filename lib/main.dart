import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class News {
  final String title;
  final String content;

  News(this.title, this.content);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.deepPurple,
      canvasColor: Colors.white),
      home: NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<News> newsList = [
    News('Tiêu đề 1', 'Nội dung 1'),
    News('Tiêu đề 2', 'Nội dung 2'),
    // Add more news items
  ];

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa tin tức này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                deleteNews(index);
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void addNews(News news) {
    setState(() {
      newsList.add(news);
    });
  }

  void editNews(int index, News news) {
    setState(() {
      newsList[index] = news;
    });
  }

  void deleteNews(int index) {
    setState(() {
      newsList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Báo mới')),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(newsList[index].title),
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.delete_forever_sharp, color: Colors.white),
            ),
            direction: DismissDirection.startToEnd,
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Xác nhận xóa'),
                    content: Text('Bạn có chắc chắn muốn xóa tin tức này?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false), // Hủy việc xóa
                        child: Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true), // Đồng ý xóa
                        child: Text('Xóa'),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                deleteNews(index);
              }
            },
            child: ListTile(
              title: Text(newsList[index].title),
              subtitle: Text(newsList[index].content),
              onTap: () {
                _navigateToEditScreen(context, index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNewsScreen()),
    );

    if (result != null && result is News) {
      addNews(result);
    }
  }

  void _navigateToEditScreen(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNewsScreen(newsList[index])),
    );

    if (result != null && result is News) {
      editNews(index, result);
    }
  }
}

class AddNewsScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm tin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Nội dung'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                News news = News(titleController.text, contentController.text);
                Navigator.pop(context, news);
              },
              child: Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditNewsScreen extends StatefulWidget {
  final News news;

  EditNewsScreen(this.news);

  @override
  _EditNewsScreenState createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.news.title);
    contentController = TextEditingController(text: widget.news.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa tin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Nội dung'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                News editedNews =
                News(titleController.text, contentController.text);
                Navigator.pop(context, editedNews);
              },
              child: Text('Lưu lại'),
            ),
          ],
        ),
      ),
    );
  }
}
