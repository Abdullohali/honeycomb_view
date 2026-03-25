import 'package:flutter/material.dart';
import 'package:honeycomb_view/honeycomb_view.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HoneyComb Example',
      theme: ThemeData.dark(),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _controller = HoneyCombController();
  int? _lastTapped;

  // Demo rasmlar
  final List<String> _images = List.generate(
    300,
    (i) => 'https://picsum.photos/seed/${i + 1}/300/300',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // ── Asosiy widget ──────────────────────────────
      body: HoneyCombView(
        images: _images,
        controller: _controller,
        itemSize: 160,
        spacing: 12,
        rows: 15,
        columns: 20,
        maxDistance: 280,
        minScale: 0.55,
        minOpacity: 0.35,
        onItemTap: (index) {
          setState(() => _lastTapped = index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rasm #$index bosildi'),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.white12,
            ),
          );
        },
      ),

      // ── Markazga qaytish tugmasi ───────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white10,
        onPressed: _controller.scrollToCenter,
        child: const Icon(Icons.center_focus_strong, color: Colors.white),
      ),
    );
  }
}
