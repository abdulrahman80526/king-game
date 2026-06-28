import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (isMobile) {
    try {
      MobileAds.instance.initialize();
    } catch (e) {
      debugPrint("AdMob initialization failed: $e");
    }
  }
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
  BannerAd? topAd;
  BannerAd? bottomAd;

  bool topLoaded = false;
  bool bottomLoaded = false;
  bool showDifficultyMenu = false; // Controls state of the AI sub-menu

  @override
  void initState() {
    super.initState();

    if (isMobile) {
      topAd = BannerAd(
        adUnitId: 'ca-app-pub-8454932729334320/8093357442',
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => topLoaded = true),
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            topAd = null;
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
            bottomAd = null;
          },
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    topAd?.dispose();
    bottomAd?.dispose();
    super.dispose();
  }

  Widget adWidget(BannerAd ad) {
    return SizedBox(height: 50, child: AdWidget(ad: ad));
  }

  void navigateToGame(bool isRobot, String difficulty) {
    try {
      debugPrint("Navigating to GameScreen: isRobot=$isRobot, difficulty=$difficulty");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(isRobot: isRobot, difficulty: difficulty),
        ),
      );
    } catch (e, stack) {
      debugPrint("Navigation error: $e");
      debugPrint(stack.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06141B),
      appBar: AppBar(
        backgroundColor: const Color(0xff11212D),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        centerTitle: true,
        title: const Text(
          "TIC TAC ShowDown",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          if (topLoaded && topAd != null) adWidget(topAd!),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon/ic_icon.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
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
                    const SizedBox(height: 35),
                    if (!showDifficultyMenu) ...[
                      // Main Options Menu
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(220, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => navigateToGame(false, "None"),
                        child: const Text(
                          "Human VS Human",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(220, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showDifficultyMenu = true;
                          });
                        },
                        child: const Text(
                          "Human VS Robot",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ] else ...[
                      // Dynamic AI Difficulty Sub-Menu
                      const Text(
                        "Select AI Difficulty",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          foregroundColor: Colors.black,
                          minimumSize: const Size(200, 42),
                        ),
                        onPressed: () => navigateToGame(true, "Easy"),
                        child: const Text(
                          "Easy Mode",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(200, 42),
                        ),
                        onPressed: () => navigateToGame(true, "Medium"),
                        child: const Text(
                          "Medium Mode",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 42),
                        ),
                        onPressed: () => navigateToGame(true, "Hard"),
                        child: const Text(
                          "Hard (Unbeatable)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showDifficultyMenu = false;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                          size: 18,
                        ),
                        label: const Text(
                          "Back to Main Menu",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (bottomLoaded && bottomAd != null) ? adWidget(bottomAd!) : const SizedBox(),
    );
  }
}

// ================= GAME SCREEN =================
class GameScreen extends StatefulWidget {
  final bool isRobot;
  final String difficulty;

  const GameScreen({
    super.key,
    required this.isRobot,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, "");
  bool isXTurn = true;
  bool gameOver = false;
  BannerAd? bottomAd;
  bool bottomLoaded = false;

  @override
  void initState() {
    super.initState();
    if (isMobile) {
      bottomAd = BannerAd(
        adUnitId: 'ca-app-pub-8454932729334320/9615839716',
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            if (mounted) setState(() => bottomLoaded = true);
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            bottomAd = null;
          },
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    bottomAd?.dispose();
    super.dispose();
  }

  final List<List<int>> winLines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6], // Diagonals
  ];

  String checkWinner(List<String> currentBoard) {
    for (var w in winLines) {
      if (currentBoard[w[0]] != "" &&
          currentBoard[w[0]] == currentBoard[w[1]] &&
          currentBoard[w[1]] == currentBoard[w[2]]) {
        return currentBoard[w[0]];
      }
    }
    if (!currentBoard.contains("")) return "Draw";
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

    String result = checkWinner(board);
    if (result != "") {
      endTheGame(result);
      return;
    }

    if (widget.isRobot && !isXTurn && !gameOver) {
      Future.delayed(const Duration(milliseconds: 350), processRobotMove);
    }
  }

  // Master controller managing logic switches based on difficulty metrics
  void processRobotMove() {
    int selectedMove = -1;

    if (widget.difficulty == "Easy") {
      selectedMove = getRandomMove();
    } else if (widget.difficulty == "Medium") {
      selectedMove = getMediumMove();
    } else if (widget.difficulty == "Hard") {
      selectedMove = getUnbeatableMinimaxMove();
    }

    if (selectedMove != -1) {
      setState(() {
        board[selectedMove] = "O";
        isXTurn = true;
      });

      String result = checkWinner(board);
      if (result != "") {
        endTheGame(result);
      }
    }
  }

  // 🔹 STRATEGY 1: Pure Random (Easy)
  int getRandomMove() {
    List<int> emptyIndices = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] == "") emptyIndices.add(i);
    }
    return emptyIndices.isNotEmpty ? (emptyIndices..shuffle()).first : -1;
  }

  // 🔸 STRATEGY 2: Smart Win/Block Check (Medium)
  int getMediumMove() {
    // 1. Can the Robot win instantly this turn?
    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        board[i] = "O";
        if (checkWinner(board) == "O") {
          board[i] = ""; // Clear testing state
          return i;
        }
        board[i] = "";
      }
    }

    // 2. Is human one move away from winning? Block them!
    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        board[i] = "X";
        if (checkWinner(board) == "X") {
          board[i] = "";
          return i;
        }
        board[i] = "";
      }
    }

    // 3. Otherwise pick a random available square
    return getRandomMove();
  }

  // 🔥 STRATEGY 3: Flawless Evaluation Tree Computation (Hard/Unbeatable)
  int getUnbeatableMinimaxMove() {
    int bestScore = -1000;
    int optimalMove = -1;

    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        board[i] = "O";
        int score = minimax(board, 0, false);
        board[i] = "";
        if (score > bestScore) {
          bestScore = score;
          optimalMove = i;
        }
      }
    }
    return optimalMove;
  }

  int minimax(List<String> simulationBoard, int depth, bool isMaximizing) {
    String state = checkWinner(simulationBoard);
    if (state == "O") return 10 - depth;
    if (state == "X") return depth - 10;
    if (state == "Draw") return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (simulationBoard[i] == "") {
          simulationBoard[i] = "O";
          int score = minimax(simulationBoard, depth + 1, false);
          simulationBoard[i] = "";
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (simulationBoard[i] == "") {
          simulationBoard[i] = "X";
          int score = minimax(simulationBoard, depth + 1, true);
          simulationBoard[i] = "";
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  void endTheGame(String outcome) {
    setState(() {
      gameOver = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      showResultDialog(outcome);
    });
  }

  void showResultDialog(String outcome) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff11212D),
        title: const Text(
          "Game Over",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          outcome == "Draw" ? "It's a Tie!" : "$outcome Wins!",
          style: const TextStyle(color: Colors.cyanAccent, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text(
              "Play Again",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Home Menu",
              style: TextStyle(color: Colors.white70),
            ),
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Center(
          child: Text(
            board[i],
            style: TextStyle(
              fontSize: 42,
              color: board[i] == "X" ? Colors.cyanAccent : Colors.greenAccent,
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
        iconTheme: const IconThemeData(
          color: Colors.cyanAccent,
        ), // Bright neon back arrow indicator
        title: Text(
          widget.isRobot ? "Robot (${widget.difficulty})" : "Human vs Human",
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            gameOver
                ? "Match Concluded"
                : (isXTurn
                      ? "X"
                      : (widget.isRobot ? "Robot calculating..." : "O")),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (_, i) => box(i),
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
              foregroundColor: Colors.white,
              minimumSize: const Size(140, 40),
            ),
            onPressed: resetGame,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text(
              "Restart",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 35),
        ],
      ),
      bottomNavigationBar: (bottomLoaded && bottomAd != null)
          ? SizedBox(
              height: 50,
              child: AdWidget(ad: bottomAd!),
            )
          : const SizedBox(),
    );
  }
}
