import 'package:go_router/go_router.dart';

class NavigationService {
  final GoRouter router;

  NavigationService(this.router);

  void go(String location) => router.go(location);

  void push(String location) => router.push(location);

  void replace(String location) => router.go(location);
}
