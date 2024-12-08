class Bullet {
  // bullet position
  float x, y;
  // velocity in x/y direction
  float vx, vy;
  // speed of the bullet
  float speed = 5;
  // bullet size
  float size = 10;
  // bullet damage
  int damage;

  // bullet constructor
  Bullet(float x, float y, float targetX, float targetY, int damage) {
    this.x = x;
    this.y = y;
    this.damage = damage;

    // calculate vector for direction
    float dx = targetX - x;
    float dy = targetY - y;
    // calculate the magnitude of the vector
    float magnitude = dist(0, 0, dx, dy);

    // normalize the direction vector + multiply by speed
    this.vx = (dx / magnitude) * speed;
    this.vy = (dy / magnitude) * speed;
  }

  // display bullet
  void display() {
    fill(255, 255, 0);
    ellipse(x, y, size, size);
  }

  // update bullet position
  void update() {
    // x position
    x += vx;
    // y position
    y += vy;
  }

  // check if bullet is off-screen
  boolean isOffScreen() {
    return x < 0 || x > width || y < 0 || y > height;
  }
}
