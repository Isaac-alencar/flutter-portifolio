import "package:flutter/material.dart";

SnackBar createSnackBar(String label, VoidCallback onPressed, int duration) {
  return SnackBar(
    content: Text("Task deleted with sucessfully"),
    action: SnackBarAction(
      label: label,
      onPressed: onPressed,
    ),
    duration: Duration(seconds: duration),
  );
}
