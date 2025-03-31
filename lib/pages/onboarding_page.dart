import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  OnBoardingPage({Key? key}) : super(key: key);

  void _onIntroEnd(context) {
    // Navigate to your main app screen or save a flag in shared prefs
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => HomePage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "This is the first step of your journey.",
          image: Image.asset('assets/image1.png', height: 250),
        ),
        PageViewModel(
          title: "Explore",
          body: "Find cool features and enjoy your experience.",
          image: Image.asset('assets/image2.png', height: 250),
        ),
        PageViewModel(
          title: "Get Started",
          body: "Let’s dive in and start using the app.",
          image: Image.asset('assets/image3.png', height: 250),
          footer: ElevatedButton(
            onPressed: () => _onIntroEnd(context),
            child: Text("Start Now"),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can also skip
      showSkipButton: true,
      skip: Text("Skip"),
      next: Icon(Icons.arrow_forward),
      done: Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
