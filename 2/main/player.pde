// Player class
class Player {
  PVector position;
  float radius = 20;
  PVector velocity;
  int bulletDamage = 10; // Add bulletDamage field with an initial value
  float bulletCooldown = 500; // Cooldown time in milliseconds
  float lastShotTime = 0; // Time of the last shot

  Player() {
    position = new PVector(width / 2, height - 50); // Center the player horizontally, near the bottom
    velocity = new PVector(0, 0);
  }

  void update() {
    position.add(velocity);

    // Handle cooldown logic (decrement time passed since last shot)
    if (millis() - lastShotTime >= bulletCooldown) {
      // Player can shoot again
      if (mousePressed) {
        shoot();
        lastShotTime = millis(); // Update last shot time
      }
    }
  }
  void shoot() {
    // Shoot bullet towards the mouse position
    PVector direction = new PVector(mouseX - position.x, mouseY - position.y);
    direction.normalize(); // Normalize direction to get consistent speed
    bullets.add(new Bullet(position, direction)); // Add bullet to the array
  }
  void display() {
    fill(255, 0, 0); // Red color for the player
    ellipse(position.x, position.y, radius * 2, radius * 2); // Draw player as a circle
  }
}
