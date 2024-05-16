bool checkWin(List<String> board) {
  for (int i = 0; i < 3; i += 1) {
    if (board[i * 3] == board[i * 3 + 1] && board[i * 3] == board[i * 3 + 2]) {
      if (board[i * 3] != "") return true;
    }
  }

  for (int i = 0; i < 3; i += 1) {
    if (board[i] == board[i + 3] && board[i] == board[i + 6]) {
      if (board[i] != "") return true;
    }
  }

  if ((board[0] == board[4] && board[0] == board[8]) ||
      (board[2] == board[4] && board[2] == board[6])) {
    if (board[4] != "") return true;
  }
  return false;
}

bool checkTie(List<String> board, bool isWin) {
  if (board.any((element) => element == "" && !isWin)) {
    return false;
  }
  return true;
}
