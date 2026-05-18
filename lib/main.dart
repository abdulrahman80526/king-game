import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

// ================= APP =================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// ================= HOME SCREEN =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd topAd;
  late BannerAd bottomAd;

  bool topLoaded = false;
  bool bottomLoaded = false;

  @override
  void initState() {
    super.initState();

    // TOP AD
    topAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/8093357442',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            topLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();

    // BOTTOM AD
    bottomAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            bottomLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    topAd.dispose();
    bottomAd.dispose();
    super.dispose();
  }

  Widget adWidget(BannerAd ad) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 50,
        child: AdWidget(ad: ad),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: const Color(0xff11212D),
        centerTitle: true,
        title: const Text(
          "TIC TAC ShowDown",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: Column(
        children: [

          // 🔝 TOP AD
          if (topLoaded) adWidget(topAd),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Icon(
                    Icons.gamepad,
                    size: 100,
                    color: Colors.cyanAccent,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Choose Game Mode",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const GameScreen(isRobot: false),
                        ),
                      );
                    },
                    child: const Text("Human VS Human"),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const GameScreen(isRobot: true),
                        ),
                      );
                    },
                    child: const Text("Human VS Robot"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🔻 BOTTOM AD
      bottomNavigationBar:
          bottomLoaded ? adWidget(bottomAd) : const SizedBox(),
    );
  }
}

// ================= GAME SCREEN =================
class GameScreen extends StatefulWidget {
  final bool isRobot;

  const GameScreen({super.key, required this.isRobot});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, "");
  bool isXTurn = true;
  bool gameOver = false;

  String checkWinner() {
    List<List<int>> win = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var w in win) {
      if (board[w[0]] != "" &&
          board[w[0]] == board[w[1]] &&
          board[w[1]] == board[w[2]]) {
        return board[w[0]];
      }
    }

    if (!board.contains("")) return "Draw";
    return "";
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      isXTurn = true;
      gameOver = false;
    });
  }

  void tap(int i) {
    if (board[i] != "" || gameOver) return;

    setState(() {
      board[i] = isXTurn ? "X" : "O";
      isXTurn = !isXTurn;
    });

    String result = checkWinner();

    if (result != "") {
      gameOver = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        showResult(result);
      });
      return;
    }

    if (widget.isRobot && !isXTurn && !gameOver) {
      Future.delayed(const Duration(milliseconds: 400), robotMove);
    }
  }

  void robotMove() {
    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        setState(() {
          board[i] = "O";
          isXTurn = true;
        });
        break;
      }
    }
  }

  void showResult(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(result == "Draw" ? "Match Draw" : "$result Wins"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Play Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Home"),
          ),
        ],
      ),
    );
  }

  Widget box(int i) {
    return GestureDetector(
      onTap: () => tap(i),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xff11212D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            board[i],
            style: const TextStyle(
              fontSize: 40,
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: const Color(0xff11212D),
        title: Text(
          widget.isRobot ? "Human vs Robot" : "Human vs Human",
          style: const TextStyle(color: Colors.cyanAccent),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          Text(
            gameOver ? "Game Over" : (isXTurn ? "X Turn" : "O Turn"),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, i) => box(i),
            ),
          ),

          ElevatedButton(
            onPressed: resetGame,
            child: const Text("Restart"),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
