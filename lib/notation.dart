import 'package:flutter/material.dart';
import 'package:flutter_game/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notation extends StatefulWidget {
  const Notation({super.key});

  @override
  State<Notation> createState() => _NotationState();
}

class _NotationState extends State<Notation> {
  List<String> playerIndex = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List<String>? playerOX;
  bool isLoading = false;
  void _load() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getStringList('list') != null) {
        playerOX = prefs.getStringList('list') ?? [];
      }
      print('제발좀 되라고 : $playerOX');
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  int indexs = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('틱택토 게임'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bottom.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        playerOX?[indexs] != null
                            ? '마지막에 저장된 기보'
                            : '저장된 기보가 없습니다.',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          height: 375,
                          child: GridView.builder(
                            itemCount: 9, // 보여지는 개수(네모칸 수)
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3줄씩
                            ),
                            itemBuilder: (context, index) {
                              indexs = index;

                              return Container(
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(5, 8),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  border: Border.all(
                                    width: 0.3,
                                    color: Colors.black,
                                  ),
                                  image: const DecorationImage(
                                    image: AssetImage('images/tree.png'),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    playerOX?[index] ?? playerIndex[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 46,
                                      color: playerOX?[index] == 'O'
                                          ? Colors.black
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                prefs.remove('list');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Notation(),
                                    ),
                                    (route) => false);
                              });
                            },
                            child: const Text('기보삭제'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ),
                                  (route) => false);
                            },
                            child: const Text(
                              '나가기',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
