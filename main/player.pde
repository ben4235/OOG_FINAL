class Player {
  //player position
  float x, y;
  //player size
  float size;
  //shooting availability
  boolean canShoot;
  //reload time in milliseconds
  int reloadTime;
  //to check the time of last shot
  int lastShotTime;

  //player constructor
  Player(float x, float y, float size, int reloadTime) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.canShoot = true;
    this.reloadTime = reloadTime;
    this.lastShotTime = 0;
  }

  //display the player
  void display() {
    fill(0, 255, 0);
    //draw the player as a circle
    ellipse(x, y, size, size);
  }

  //shooting
  void shoot() {
    if (canShoot) {
      //shoot towards the mouse direction
      bullets.add(new Bullet(x, y, mouseX, mouseY));
      println("shooting");
      //disable the shooting
      canShoot = false;
      //record the time of the last shot
      lastShotTime = millis();
    }
  }

  //to take care of reloading
  void update() {
    //check if reload is back up since last shot fired
    if (!canShoot && millis() - lastShotTime >= reloadTime) {
      canShoot = true;
    }
  }
}
