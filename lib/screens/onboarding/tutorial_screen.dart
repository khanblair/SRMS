import 'package:flutter/material.dart';
import 'package:srms/config/constants.dart';

class TutorialScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialScreen({super.key, required this.onComplete});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _tutorialPages = [
    {
      'title': 'Submit Requisitions',
      'description': 'Easily submit your monthly salary requests with course details',
      'icon': Icons.request_page,
    },
    {
      'title': 'Track Status',
      'description': 'Monitor your requisition status through the approval workflow',
      'icon': Icons.track_changes,
    },
    {
      'title': 'Upload Documents',
      'description': 'Attach supporting documents for verification',
      'icon': Icons.upload_file,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _tutorialPages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final page = _tutorialPages[index];
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        page['icon'],
                        size: 80,
                        color: Color(AppConstants.primaryColor),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        page['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page['description'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _tutorialPages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Color(AppConstants.primaryColor)
                      : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _currentPage == _tutorialPages.length - 1
                    ? widget.onComplete
                    : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                child: Text(
                  _currentPage == _tutorialPages.length - 1 ? 'Finish' : 'Next',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}