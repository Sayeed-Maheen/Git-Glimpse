class OnbordingContent {
  String title;

  String discription;
  String image;

  OnbordingContent(
      {required this.title, required this.image, required this.discription});
}

List<OnbordingContent> contents = [
  OnbordingContent(
      image: 'assets/images/onboarding1.png',
      title: 'Netro Creative',
      discription:
          "We Design & Develop Awesome product that has impact on sales and user experience. We work in search of excellence and impact!"),
  OnbordingContent(
      image: 'assets/images/onboarding2.png',
      title: 'Services at your\nDoorstep',
      discription:
          "We provide services like UI design, UX Design, Redesign, Graphics Design, Miscellaneous, Web Development and Mobile Development! "),
  OnbordingContent(
      image: 'assets/images/onboarding3.png',
      title: "AI Assistant\nSmartest of All",
      discription: "Your new AI-powered assistant is here to help customers know about the website!!"),
];
