import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class EditReview extends StatefulWidget {
  const EditReview({Key? key}) : super(key: key);

  @override
  _EditReviewState createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> with WidgetsBindingObserver {
  final TextEditingController _reviewController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();

  double _bottomInset = 0.0;
  double _rating = 5.0; // Nilai default rating (bisa diubah sesuai kebutuhan)
  bool _speechEnable = false;
  String _wordSpoken = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Mengamati perubahan widget (keyboard)
    initSpeech();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Mengatur padding saat keyboard muncul atau menghilang
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _bottomInset = bottomInset;
    });
  }

  void initSpeech() async {
    _speechEnable = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordSpoken = "${result.recognizedWords}";
      _reviewController.text +=
          "" + _wordSpoken; // Tambahkan hasil suara ke TextField
      _reviewController.selection = TextSelection.fromPosition(
        // Menjaga kursor di posisi akhir
        TextPosition(offset: _reviewController.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(bottom: _bottomInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 18.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/spiderman.jpg',
                        height: 150.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SPIDER-MAN : INTO THE SPIDER-VERSE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'Completed\n',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'Studio: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '1\n',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'Date: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '07-10-2024\n\n',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'Rating: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Menampilkan rating yang dipilih
                                TextSpan(
                                  text: '${_rating.toStringAsFixed(1)}/10.0',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                // Slider untuk mengatur rating
                Slider(
                  value: _rating,
                  min: 1,
                  max: 10,
                  divisions: 100,
                  label: _rating.toStringAsFixed(1),
                  onChanged: (double value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  activeColor: Colors.amber,
                  inactiveColor: Colors.grey,
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _reviewController,
                    maxLines: null,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write your review here...',
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Menutup keyboard
                            FocusScope.of(context).unfocus();

                            // Cetak review dan rating yang diinputkan
                            print(
                                'Review Submitted: ${_reviewController.text}');
                            print('Rating Submitted: $_rating/10.0');

                            // Menutup modal
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Send',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      height: 48.0,
                      width: 48.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _speechToText.isListening
                                ? _stopListening()
                                : _startListening();
                          },
                          icon: Icon(
                            _speechToText.isNotListening
                                ? Icons.mic_off
                                : Icons.mic,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showEditReview(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const EditReview(),
  );
}
