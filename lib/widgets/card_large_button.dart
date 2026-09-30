import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

class CardLargeButton extends StatefulWidget {
  final String text;
  final bool? uppercase;
  final AsyncCallback? onTap;

  const CardLargeButton({super.key, required this.text, this.uppercase = false, this.onTap});

  @override
  State<CardLargeButton> createState() => _CardLargeButtonState();
}

class _CardLargeButtonState extends State<CardLargeButton> {
  final BehaviorSubject<bool> streamLoading = BehaviorSubject<bool>.seeded(false);
  AsyncCallback? onTap;

  @override
  void initState() {
    super.initState();
    if (widget.onTap != null) {
      onTap = widget.onTap!;
    }
  }

  @override
  void dispose() {
    streamLoading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onTap != null && !streamLoading.value) {
          streamLoading.add(true);
          await onTap!().whenComplete(() {
            streamLoading.add(false);
          });
          if (!streamLoading.isClosed) {
            streamLoading.add(false);
          }
        }
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Color.fromARGB(255, 183, 217, 190),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          child: StreamBuilder<bool>(
            stream: streamLoading,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                );
              } else {
                return Text(
                  widget.uppercase != null && widget.uppercase! ? widget.text.toUpperCase() : widget.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.fugazOne().fontFamily,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
