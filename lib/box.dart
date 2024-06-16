class Box {
  int x;
  int y;
  Player player;

  Box(this.x, this.y, this.player);

  String getText() {
    if (player == Player.X) {
      return 'X';
    }
    if (player == Player.O) {
      return 'O';
    }
    return '';
  }
}

enum Player { none, X, O }
