class Player {
  // player position
  float x, y;
  // player size
  float size;
  // shooting availability
  boolean canShoot;
  // reload time in milliseconds
  int reloadTime;
  // to check the time of last shot
  int lastShotTime;
  // upgrade attributes
  int bulletDamage;
  int bulletsShot;

  // player constructor
  Player(float x, float y, float size, int reloadTime) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.canShoot = true;
    this.reloadTime = reloadTime;
    this.lastShotTime = 0;
    this.bulletDamage = 1;
    this.bulletsShot = 1;
  }

  // display the player
  void display() {
    fill(0, 255, 0);
    // draw the player as a circle
    ellipse(x, y, size, size);
    displayReloadBar();
  }

  // shooting
  void shoot() {
    if (canShoot) {
      for (int i = 0; i < bulletsShot; i++) {
        // shoot towards the mouse direction
        bullets.add(new Bullet(x, y, mouseX + random(-10, 10), mouseY + random(-10, 10), bulletDamage));
      }
      // disable the shooting
      canShoot = false;
      // record the time of the last shot
      lastShotTime = millis();
    }
  }

  // to take care of reloading
  void update() {
    // check if reload is back up since last shot fired
    if (!canShoot && millis() - lastShotTime >= reloadTime) {
      canShoot = true;
    }
  }

  // display the reload bar under the player
  void displayReloadBar() {
    if (!canShoot) {
      float reloadProgress = (float)(millis() - lastShotTime) / reloadTime;
      fill(255, 0, 0);
      rect(x - size / 2, y + size / 2 + 10, size, 5); // background bar
      fill(0, 255, 0);
      rect(x - size / 2, y + size / 2 + 10, size * reloadProgress, 5); // progress bar
    }
  }
}
