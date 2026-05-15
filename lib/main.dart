import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// 🏠 HOME SCREEN
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd topAd;
  late BannerAd bottomAd;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    topAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => isLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: AdRequest(),
    );

    bottomAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => isLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: AdRequest(),
    );

    topAd.load();
    bottomAd.load();
  }

  @override
  void dispose() {
    topAd.dispose();
    bottomAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: Color(0xff11212D),
        centerTitle: true,
        title: Text(
          "TIC TAC ShowDown",
          style: TextStyle(
            color: Color(0xff4DEEEA),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // 🔝 TOP AD
            if (isLoaded)
              SizedBox(
                height: 50,
                child: AdWidget(ad: topAd),
              ),

            // 🟢 UI
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose Game Mode",
                      style:
                          TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                GameScreen(isRobot: false),
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
                            builder: (_) =>
                                GameScreen(isRobot: true),
                          ),
                        );
                      },
                      child: Text("Human VS Robot"),
                    ),
                  ],
                ),
              ),
            ),

            // 🔻 BOTTOM AD
            if (isLoaded)
              SizedBox(
                height: 50,
                child: AdWidget(ad: bottomAd),
              ),
          ],
        ),
      ),
    );
  }
}

// 🎮 GAME SCREEN
class GameScreen extends StatefulWidget {
  final bool isRobot;

  GameScreen({required this.isRobot});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BannerAd topAd;
  late BannerAd bottomAd;
  bool isLoaded = false;

  List<String> board = List.filled(9, "");
  bool isXTurn = true;

  @override
  void initState() {
    super.initState();

    topAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => isLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: AdRequest(),
    );

    bottomAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => isLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: AdRequest(),
    );

    topAd.load();
    bottomAd.load();
  }

  @override
  void dispose() {
    topAd.dispose();
    bottomAd.dispose();
    super.dispose();
  }

  void tapBox(int i) {
    if (board[i] != "") return;

    setState(() {
      board[i] = isXTurn ? "X" : "O";
      isXTurn = !isXTurn;
    });
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
                  ? Color(0xff4DEEEA)
                  : Color(0xff00C897),
            ),
          ),
        ),
      ),
    );
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      isXTurn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff06141B),

      appBar: AppBar(
        backgroundColor: Color(0xff11212D),
        title: Text(
          widget.isRobot ? "Human vs Robot" : "Human vs Human",
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // 🔝 TOP AD
            if (isLoaded)
              SizedBox(height: 50, child: AdWidget(ad: topAd)),

            // 🎮 GAME
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isXTurn ? "X Turn" : "O Turn",
                    style:
                        TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 9,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (_, i) => buildBox(i),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: resetGame,
                    child: Text("Restart"),
                  )
                ],
              ),
            ),

            // 🔻 BOTTOM AD
            if (isLoaded)
              SizedBox(height: 50, child: AdWidget(ad: bottomAd)),
          ],
        ),
      ),
    );
  }
}
