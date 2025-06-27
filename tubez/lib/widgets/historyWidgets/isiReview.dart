import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tubez/client/FilmClient.dart';
import 'package:tubez/client/ReviewClient.dart';
import 'dart:convert';
import 'package:tubez/client/UserClient.dart';
import 'package:tubez/entity/Review.dart'; // Untuk encode JSON

class IsiReview extends StatefulWidget {
  final String image;
  final String title;
  final String status;
  final int studio;
  final String date;
  final String total;
  final bool isReview;
  final int ticketCount;
  final int idFilm; // Tambahkan idFilm
  final BigInt idHistory; // Tambahkan idHistory
  final void Function(bool) onReview;

  const IsiReview({
    super.key,
    required this.image,
    required this.title,
    required this.status,
    required this.studio,
    required this.date,
    required this.total,
    required this.isReview,
    required this.ticketCount,
    required this.idFilm,
    required this.idHistory,
    required this.onReview,
  });

  @override
  _IsiReviewState createState() => _IsiReviewState();
}

class _IsiReviewState extends State<IsiReview> {
  final TextEditingController _reviewController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  double _rating = 5.0;
  bool _isLoading = false; // Untuk menampilkan loading saat submit
  late Review review;

  @override
  void initState() {
    super.initState();
    if (widget.isReview) {
      print('id history ${widget.idHistory}');
      ambilReview(widget.idHistory);
      print('test review ${_reviewController.text}');
    }
    _initializeSpeech();
  }

  Future<void> ambilReview(BigInt idHistory) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch data review based on idHistory
      review = await ReviewClient.fetchDataReview(idHistory);
      print('dsaasadsasd ${review.review}');
      setState(() {
        _reviewController.text = review.review;
        _rating = review.rating;
      });
    } catch (e) {
      print("Error fetching review: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (!available) {
      print('Speech recognition not available');
    }
  }

  void _startListening() async {
    if (!_isListening && await _speechToText.hasPermission) {
      setState(() {
        _isListening = true;
      });
      await _speechToText.listen(onResult: (result) {
        setState(() {
          _reviewController.text += result.recognizedWords;
          _reviewController.selection = TextSelection.fromPosition(
            TextPosition(offset: _reviewController.text.length),
          );
        });
      });
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Review tidak boleh kosong'),
      ));
      return;
    }

    setState(() {
      _isLoading = true; // Menampilkan loading saat submit
    });

    bool success = await ReviewClient.submitReview(
      widget.idFilm,
      widget.idHistory,
      _reviewController.text,
      _rating,
    );

    bool successUpdate = await ReviewClient.updateStatusHistory(
        widget.idHistory, "Completed", 1);

    bool updateRating = await FilmClient.updateRating(widget.idFilm);

    setState(() {
      _isLoading = false; // Menyembunyikan loading setelah selesai
    });

    if (success && successUpdate && updateRating) {
      widget.onReview(true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Review berhasil dikirim'),
      ));
      Navigator.pop(context); // Tutup modal jika sukses
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal mengirim review'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.image,
                      width: 100,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Status: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.status,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Studio: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.studio.toString(),
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Date: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.date,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Rating: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
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
              const SizedBox(height: 16),
              Slider(
                value: _rating,
                min: 1,
                max: 10,
                divisions: 90,
                label: _rating.toStringAsFixed(1),
                onChanged: widget.isReview
                    ? null
                    : (double value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                activeColor: Colors.amber,
                inactiveColor: Colors.amber,
              ),
              const SizedBox(height: 16),
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: widget.isReview
                      ? (TextField(
                          controller: _reviewController,
                          maxLines: 4,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          enabled: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _reviewController.text,
                            hintStyle: const TextStyle(color: Colors.white54),
                          ),
                        ))
                      : (TextField(
                          controller: _reviewController,
                          maxLines: 4,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Tulis ulasan Anda di sini...',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _isListening ? _stopListening : _startListening,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
