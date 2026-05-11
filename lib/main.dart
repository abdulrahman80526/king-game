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

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd bannerAd;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8454932729334320/9615839716',
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );

    bannerAd.load();
  }

  @override
  void dispose() {
    bannerAd.dispose();
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
            fontSize: 24,
          ),
        ),
      ),

      // 🟢 MAIN CONTENT
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4DEEEA),
                    Color(0xff00C897),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "XO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Choose Game Mode",
              style: TextStyle(
                color: Color(0xffEAFDFC),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff00C897),
              ),
              onPressed: () {},
              child: Text("Human VS Human"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff4DEEEA),
              ),
              onPressed: () {},
              child: Text("Human VS Robot"),
            ),
          ],
        ),
      ),

      // 🔥 BANNER AD AT BOTTOM
      bottomNavigationBar: isLoaded
          ? Container(
              width: bannerAd.size.width.toDouble(),
              height: bannerAd.size.height.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : SizedBox(),
    );
  }
}
