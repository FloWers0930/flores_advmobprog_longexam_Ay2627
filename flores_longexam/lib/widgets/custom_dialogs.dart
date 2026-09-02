import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flores_mobprog/constants.dart';

void customDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: fbDarkPrimary,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Okay'),
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => alertDialog);
}

void customOptionDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Function onYes,
}) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title, style: TextStyle(fontSize: 30.sp)),
    content: Text(content),
    actions: <Widget>[
      OutlinedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('No'),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: fbDarkPrimary,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          onYes();
        },
        child: const Text('Yes'),
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => alertDialog);
}

void customShowImageDialog(BuildContext context, {required String imageUrl}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (_, _, _) => const Icon(Icons.error),
                        )
                      : Image.asset(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
