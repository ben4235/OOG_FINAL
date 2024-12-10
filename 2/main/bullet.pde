class Bullet {
  PVector position;
  PVector velocity;
  float radius = 5;

  Bullet(PVector startPos, PVector direction) {
    position = startPos.copy(); // Start at player's position
    velocity = direction.copy().mult(10); // Scale direction vector for speed
  }

  void update() {
    position.add(velocity); // Update the bullet's position
  }

  void display() {
    fill(0, 255, 0); // Green color for the bullet
    ellipse(position.x, position.y, radius * 2, radius * 2); // Draw bullet as a circle
  }
  // Check if the bullet is off the screen
  boolean offScreen() {
    return position.x < 0 || position.x > width || position.y < 0 || position.y > height;
  }
}
