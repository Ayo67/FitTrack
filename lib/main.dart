void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return SafeArea(
            child: GetMaterialApp(
              onInit: () {
                Get.put(AuthController());
                Get.put(BottomBarController());
              },
              debugShowCheckedModeBanner: false,
              home: BottomBarScreen(),
            ),
          );
        });
  }
}