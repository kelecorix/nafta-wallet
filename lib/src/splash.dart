import 'package:flutter/material.dart' hide FilledButton;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isPasswordSkip = true;

  @override
  void initState() {
    super.initState();
    navigatorScreen();
  }

  void navigatorScreen() async {
    bool isPasswordSet = (sharedPref.getBool('isPasswordSet') ?? true);
    try {
      oracleRateG = await acmeClient.valueFromOracle();
    } catch (e) {
      print(e.toString());
      oracleRateG = 50000;
    }

    Future.delayed(Duration(seconds: 2)).then((val) async {
      if (!isPasswordSet) {
        isPasswordSkip = (sharedPref.getBool('isPasswordSkip') ?? false);
        if (!isPasswordSkip) {
          var res = await initHiveDatabase(context);
          context.read<WalletProvider>().initTokens();
          loadScreen();
          return;
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MPasswordScreenMain(
                  isFrom: 'fromEnterPassword',
                )));
      } else {
        //context.read<WalletProvider>().initTokens();
        loadScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          color: Color(0xff00a6fb),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              height: 1,
            ),
            Hero(
              tag: "logo",
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    Assets.imagesAcmeLogoSingular,
                    height: 140.0,
                    width: 140.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.6.w),
              child: Image.asset(
                Assets.imagesAcmeLogoWideWhiteRastr,
                height: 110.0,
                width: screenWidth - 100,
              ),
            ),
          ]),
        ));
  }

  bool isPinCodeEnabled = false;
  bool isBioAuthDone = false;

  void loadScreen() {
    final provider = context.read<WalletProvider>();
    final adiProvider = context.read<ADIProvider>();

    isPinCodeEnabled = sharedPref.getBool("isPinCodeEnabled") ?? false;
    mBalance = sharedPref.getInt("balance") ?? 0;

    /// reload last set language here
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final languageProvider = context.read<LanguageProvider>();
      languageProvider.fetchLocale().then((value) {});
    });

    bool isFirstLoad = (sharedPref.getBool('isFirstLoad') ?? true);
    bool isCreateWalletProposedOnFirst = (sharedPref.getBool('isCreateWalletProposedOnFirst') ?? false);

  }

  // Call this method when user come back on web(not set password yet)
  Future<bool> initHiveDatabase(BuildContext context) async {


    return true;
  }
}
