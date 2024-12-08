class Player {
  //player position
  float x, y;
  //player size
  float size;


  Player(float x, float y, float size, int reloadTime) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  //display the player
  void display() {
    fill(0, 255, 0);
    //draw the player as a circle
    ellipse(x, y, size, size);
  }
}
