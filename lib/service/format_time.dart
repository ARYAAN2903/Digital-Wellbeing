String formatTime(int milliseconds) {
  int seconds = (milliseconds / 1000).truncate();
  int minutes = (seconds / 60).truncate();
  int hours = (minutes / 60).truncate();

  String formattedTime = '';
  if (hours > 0) {
    formattedTime += '$hours hours ';
    minutes %= 60; // Correct minutes for hours
  }
  if (minutes > 0) {
    formattedTime += '$minutes minutes ';
  }
  formattedTime += '${seconds % 60} seconds';

  return formattedTime;
}