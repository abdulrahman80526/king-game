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

// ================= HOME =================
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

    // 🔝 TOP AD
    topAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/8093357442',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => topLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();

    // 🔻 BOTTOM AD
    bottomAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => bottomLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    topAd.dispose();
    bottomAd.dispose();
    super.dispose();
  }

  Widget adBox(BannerAd ad) {
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
            letterSpacing: 1.5,
          ),
        ),
      ),

      body: Column(
        children: [

          // 🔝 TOP AD
          if (topLoaded) adBox(topAd),

          // 🟢 MAIN UI
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyanAccent,
                          Colors.greenAccent,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "XO",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Choose Game Mode",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
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
      bottomNavigationBar: bottomLoaded
          ? adBox(bottomAd)
          : const SizedBox(),
    );
  }
}

// ================= GAME SCREEN =================
class GameScreen extends StatelessWidget {
  final bool isRobot;

  const GameScreen({super.key, required this.isRobot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: const Color(0xff11212D),
        centerTitle: true,
        title: Text(
          isRobot ? "Human vs Robot" : "Human vs Human",
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.cyanAccent,
                    Colors.greenAccent,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  isRobot ? "🤖" : "👥",
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              isRobot
                  ? "Play Against Robot"
                  : "Play With Friend",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              isRobot
                  ? "You will play against AI opponent."
                  : "Two players can play on same device.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {},
              child: const Text("Start Game"),
            ),
          ],
        ),
      ),
    );
  }
}
  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    topAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => topLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();

    bottomAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => bottomLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    topAd?.dispose();
    bottomAd?.dispose();
    super.dispose();
  }

  Widget buildAd(BannerAd? ad, bool loaded) {
    if (!loaded || ad == null) return const SizedBox();
    return Container(
      color: Colors.white,
      child: SizedBox(height: 50, child: AdWidget(ad: ad)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: const Color(0xff11212D),
        title: const Text(
          "TIC TAC ShowDown",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        children: [

          buildAd(topAd, topLoaded),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(isRobot: false),
                        ),
                      );
                    },
                    child: const Text("Human VS Human"),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(isRobot: true),
                        ),
                      );
                    },
                    child: const Text("Human VS Robot"),
                  ),
                ],
              ),
            ),
          ),

          buildAd(bottomAd, bottomLoaded),
        ],
      ),
    );
  }
}

// ================= GAME =================
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
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
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
        if (!mounted) return;
        showResult(result);
      });
      return;
    }

    if (widget.isRobot && !isXTurn && !gameOver) {
      Future.delayed(const Duration(milliseconds: 400), robotMove);
    }
  }

  void robotMove() {
    if (gameOver) return;

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
              color: Colors.white,
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
        title: Text(widget.isRobot
            ? "Human vs Robot"
            : "Human vs Human"),
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          Text(
            gameOver ? "Game Finished" : (isXTurn ? "X Turn" : "O Turn"),
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
  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    topAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => topLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();

    bottomAd = BannerAd(
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => bottomLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    topAd?.dispose();
    bottomAd?.dispose();
    super.dispose();
  }

  Widget adBox(BannerAd? ad) {
    if (ad == null) return const SizedBox();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(4),
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
        title: const Text(
          "TIC TAC ShowDown",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          if (topLoaded) adBox(topAd),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(isRobot: false),
                        ),
                      );
                    },
                    child: const Text("Human VS Human"),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(isRobot: true),
                        ),
                      );
                    },
                    child: const Text("Human VS Robot"),
                  ),
                ],
              ),
            ),
          ),

          if (bottomLoaded) adBox(bottomAd),
        ],
      ),
    );
  }
}

// ================= GAME =================
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
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
    ];

    for (var w in win) {
      String a = board[w[0]];
      String b = board[w[1]];
      String c = board[w[2]];

      if (a != "" && a == b && b == c) {
        return a;
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

  void showResult(String result) {
    gameOver = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(
          result == "Draw" ? "Match Draw" : "$result Wins",
        ),
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

  void tapBox(int i) {
    if (board[i] != "" || gameOver) return;

    setState(() {
      board[i] = isXTurn ? "X" : "O";
      isXTurn = !isXTurn;
    });

    String result = checkWinner();

    if (result != "") {
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
    if (gameOver) return;

    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        setState(() {
          board[i] = "O";
          isXTurn = true;
        });

        String result = checkWinner();

        if (result != "") {
          Future.delayed(const Duration(milliseconds: 300), () {
            showResult(result);
          });
        }
        break;
      }
    }
  }

  Widget buildBox(int i) {
    return GestureDetector(
      onTap: () => tapBox(i),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xff11212D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            board[i],
            style: TextStyle(
              fontSize: 40,
              color: board[i] == "X"
                  ? Colors.cyan
                  : Colors.greenAccent,
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          Text(
            gameOver
                ? "Game Finished"
                : (isXTurn ? "X Turn" : "O Turn"),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, i) => buildBox(i),
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
}    topAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => topLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();

    bottomAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => bottomLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    topAd?.dispose();
    bottomAd?.dispose();
    super.dispose();
  }

  Widget adBox(BannerAd? ad) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(4),
      child: SizedBox(
        height: 50,
        child: ad == null ? SizedBox() : AdWidget(ad: ad),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: Color(0xff11212D),
        title: Text(
          "TIC TAC ShowDown",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: Column(
        children: [

          if (topLoaded) adBox(topAd),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(isRobot: false),
                        ),
                      );
                    },
                    child: Text("Human VS Human"),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(isRobot: true),
                        ),
                      );
                    },
                    child: Text("Human VS Robot"),
                  ),
                ],
              ),
            ),
          ),

          if (bottomLoaded) adBox(bottomAd),
        ],
      ),
    );
  }
}

// ================= GAME =================
class GameScreen extends StatefulWidget {
  final bool isRobot;

  GameScreen({required this.isRobot});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, "");
  bool isXTurn = true;
  bool gameOver = false;

  String checkWinner() {
    List<List<int>> win = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6]
    ];

    for (var p in win) {
      String a = board[p[0]];
      String b = board[p[1]];
      String c = board[p[2]];

      if (a != "" && a == b && b == c) {
        return a;
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

  void showResult(String result) {
    gameOver = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Game Over"),
        content: Text(result == "Draw"
            ? "Match Draw"
            : "$result Wins"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: Text("Play Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Home"),
          ),
        ],
      ),
    );
  }

  void tapBox(int i) {
    if (board[i] != "" || gameOver) return;

    setState(() {
      board[i] = isXTurn ? "X" : "O";
      isXTurn = !isXTurn;
    });

    String result = checkWinner();

    if (result != "") {
      Future.delayed(Duration(milliseconds: 300), () {
        showResult(result);
      });
      return;
    }

    if (widget.isRobot && !isXTurn && !gameOver) {
      Future.delayed(Duration(milliseconds: 400), robotMove);
    }
  }

  void robotMove() {
    if (gameOver) return;

    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        setState(() {
          board[i] = "O";
          isXTurn = true;
        });

        String result = checkWinner();
        if (result != "") {
          Future.delayed(Duration(milliseconds: 300), () {
            showResult(result);
          });
        }
        break;
      }
    }
  }

  Widget buildBox(int i) {
    return GestureDetector(
      onTap: () => tapBox(i),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color(0xff11212D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            board[i],
            style: TextStyle(
              fontSize: 40,
              color: board[i] == "X"
                  ? Colors.cyan
                  : Colors.greenAccent,
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
      backgroundColor: Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: Color(0xff11212D),
        title: Text(
          widget.isRobot
              ? "Human vs Robot"
              : "Human vs Human",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          SizedBox(height: 10),

          Text(
            gameOver ? "Game Finished" : (isXTurn ? "X Turn" : "O Turn"),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),

          SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, i) => buildBox(i),
            ),
          ),

          ElevatedButton(
            onPressed: resetGame,
            child: Text("Restart"),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
