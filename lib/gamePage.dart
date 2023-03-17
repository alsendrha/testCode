import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_game/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool? checked;
  List<String> playerOX = ['', '', '', '', '', '', '', '', ''];
  List<int> matchIndex = [];
  String resultDeclation = '';
  final random = Random();
  String player1 = 'O';
  String player2 = 'X';
  int? selectedIndex;
  double smallSized = 20;
  double fontSized = 64;
  int oScore = 0;
  int xScore = 0;
  int filledBox = 0;
  bool winnerFound = false;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    checked = random.nextBool();
  }

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: smallSized),
                  child: SizedBox(
                    height: 415,
                    child: GridView.builder(
                      itemCount: 9, // 보여지는 개수(네모칸 수)
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3줄씩
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _tapped(index);
                          },
                          child: Container(
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
                              image: DecorationImage(
                                image: matchIndex.contains(index)
                                    ? const AssetImage('images/color.png')
                                    : const AssetImage('images/tree.png'),
                              ),
                              // color: matchIndex.contains(index)
                              //     ? Colors.blue
                              //     : Colors.orange,
                            ),
                            child: Center(
                              child: Text(
                                playerOX[index],
                                style: TextStyle(
                                  fontSize: fontSized,
                                  fontWeight: FontWeight.bold,
                                  color: playerOX[index] == 'O'
                                      ? Colors.black
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 80,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),
                      onPressed: () {
                        _clearBoard();
                      },
                      child: const Text(
                        '새로고침',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                boardBig();
                              });
                            },
                            child: const Icon(Icons.arrow_upward_rounded),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                boardSmall();
                              });
                            },
                            child: const Icon(Icons.arrow_downward_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextButton(
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            playerBack();
          });
        },
        child: const Icon(Icons.undo),
      ),
    );
  }

  void _tapped(index) {
    setState(() {
      if ((checked! && playerOX[index] == '') ||
          (!checked! && playerOX[index] == '')) {
        playerOX[index] = checked! ? player1 : player2;
        filledBox++;
        checked = !checked!; // 랜덤으로 설정하지 않고 다음 플레이어의 순서를 결정
        selectedIndex = index;
        _checkWinner();
      }
    });
  }

  void playerBack() {
    if (selectedIndex != null) {
      playerOX[selectedIndex!] = ''; // 마지막에 선택된 칸 초기화
      filledBox--;
      checked = !checked!;
      selectedIndex = null; // 마지막에 선택된 칸 초기화
    }
  }

  void boardSmall() {
    smallSized += 5;
    fontSized -= 6;
    fontSized = fontSized.clamp(50, 64);
    smallSized = smallSized.clamp(0, 40);
  }

  void boardBig() {
    smallSized -= 5;
    fontSized += 6;
    fontSized = fontSized.clamp(50, 70);
    smallSized = smallSized.clamp(5, 15);
  }

  saved() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setStringList('list', playerOX);
    Fluttertoast.showToast(msg: '저장되었습니다.');
  }

  void _checkWinner() {
    /*
      0  1  2
      3  4  5
      6  7  8   
    */
    // 승패 결정 가로줄
    if (playerOX[0] == playerOX[1] &&
        playerOX[0] == playerOX[2] &&
        playerOX[0] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[0]} 가 이겼습니다!';
        winnerDialog(playerOX[0]);
        matchIndex.addAll([0, 1, 2]);
        updateScore(playerOX[0]);
      });
    }

    if (playerOX[3] == playerOX[4] &&
        playerOX[3] == playerOX[5] &&
        playerOX[3] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[3]} 가 이겼습니다!';
        winnerDialog(playerOX[3]);
        matchIndex.addAll([3, 4, 5]);
        updateScore(playerOX[3]);
      });
    }

    if (playerOX[6] == playerOX[7] &&
        playerOX[6] == playerOX[8] &&
        playerOX[6] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[6]} 가 이겼습니다!';
        winnerDialog(playerOX[6]);
        matchIndex.addAll([6, 7, 8]);
        updateScore(playerOX[6]);
      });
    }

    // 세로줄
    if (playerOX[0] == playerOX[3] &&
        playerOX[0] == playerOX[6] &&
        playerOX[0] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[0]} 가 이겼습니다!';
        winnerDialog(playerOX[0]);
        matchIndex.addAll([0, 3, 6]);
        updateScore(playerOX[0]);
      });
    }

    if (playerOX[1] == playerOX[4] &&
        playerOX[1] == playerOX[7] &&
        playerOX[1] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[1]} 가 이겼습니다!';
        winnerDialog(playerOX[1]);
        matchIndex.addAll([1, 4, 7]);
        updateScore(playerOX[1]);
      });
    }

    if (playerOX[2] == playerOX[5] &&
        playerOX[2] == playerOX[8] &&
        playerOX[2] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[2]} 가 이겼습니다!';
        winnerDialog(playerOX[2]);
        matchIndex.addAll([2, 5, 8]);
        updateScore(playerOX[2]);
      });
    }

    // 대각선
    if (playerOX[0] == playerOX[4] &&
        playerOX[0] == playerOX[8] &&
        playerOX[0] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[0]} 가 이겼습니다!';
        winnerDialog(playerOX[0]);
        matchIndex.addAll([0, 4, 8]);
        updateScore(playerOX[0]);
      });
    }

    if (playerOX[2] == playerOX[4] &&
        playerOX[2] == playerOX[6] &&
        playerOX[2] != '') {
      setState(() {
        resultDeclation = 'player ${playerOX[2]} 가 이겼습니다!';
        winnerDialog(playerOX[2]);
        matchIndex.addAll([2, 4, 6]);
        updateScore(playerOX[2]);
      });
    }
    if (!winnerFound && filledBox == 9) {
      winnerDialog(!winnerFound && filledBox == 9);
      resultDeclation = '무승부 입니다';
    }
  }

  void updateScore(winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const GamePage(),
        ),
        (route) => false);
  }

  winnerDialog(winner) {
    if (winner is String) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            title: const Text('게임 종료'),
            content: Text('플레이어 $winner 가 승리했습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GamePage(),
                      ),
                      (route) => false);
                },
                child: const Text('다시하기'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                      (route) => false);
                },
                child: const Text('그만하기'),
              ),
              TextButton(
                onPressed: () async {
                  saved();
                },
                child: const Text('저장'),
              ),
            ],
          );
        },
      );
    } else if (!winnerFound && filledBox == 9) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            title: const Text('게임 종료'),
            content: const Text('무승부입니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GamePage(),
                      ),
                      (route) => false);
                },
                child: const Text('다시하기'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                      (route) => false);
                },
                child: const Text('그만하기'),
              ),
              TextButton(
                onPressed: () async {
                  saved();
                },
                child: const Text('저장'),
              ),
            ],
          );
        },
      );
    }
  }
}
