class Bullet {
  PVector position;
  PVector velocity;
  float radius = 5;
  int damage; // Set bullet damage

  Bullet(PVector startPos, PVector direction) {
    position = startPos.copy();  // Start position
    velocity = direction.copy();  // Direction velocity
    damage = 10;  // Set the bullet damage (initial value)

    // Debugging bullet position and velocity
    println("Bullet created at position: " + position + " with velocity: " + velocity);
  }

  void update() {
    position.add(velocity);  // Update bullet position
  }

  void display() {
    fill(255, 255, 0);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }

  boolean offScreen() {
    return position.x < 0 || position.x > width || position.y < 0 || position.y > height;
  }
}
