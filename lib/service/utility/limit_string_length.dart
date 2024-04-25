String limit_string_length(String input) {
  if (input.length > 20) {
    return input.substring(0, 27) + '...';
  } else {
    return input;
  }
}