class Bullet {
  PVector position;
  PVector velocity;
  int damage;

  // Constructor to initialize bullet with position, velocity, and damage
  Bullet(float x, float y, int damage) {
    this.position = new PVector(x, y);  // Initialize position
    this.velocity = new PVector(0, 0);  // Initialize velocity
    this.damage = damage;
  }

  // Update the bullet's position based on its velocity
  void update() {
    position.add(velocity);  // Move the bullet
  }
  void setVelocity(PVector direction, float speed) {
    velocity = direction.copy().mult(speed);  // Set velocity based on direction and speed
  }
  void display() {
    fill(0, 255, 0);  // Green color for the bullet
    ellipse(position.x, position.y, 10, 10);  // Draw bullet as a small circle
  }
  void updateAndDisplay() {
    update();  // Update player (movement, health, etc.)
    display(); // Display player

    // Update and display all bullets, and remove those that go off-screen
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      b.update();   // Update bullet position
      b.display();  // Display the bullet

      // Remove bullets that go off-screen
      if (b.isOffScreen()) {
        bullets.remove(i); // Remove bullet from list
      }
    }
  }

  // Check if the bullet collides with an enemy
  boolean collidesWith(Enemy enemy) {
    float bulletRadius = 5;  // Radius of the bullet
    float distance = dist(position.x, position.y, enemy.position.x, enemy.position.y);
    float combinedRadius = bulletRadius + enemy.size / 2;  // Combine the radius of bullet and enemy
    return distance < combinedRadius;  // Collision detection
  }


  // Check if the bullet is off the screen
  boolean isOffScreen() {
    return position.x < 0 || position.x > width || position.y < 0 || position.y > height;
  }
  // Check if the bullet is off the screen (optional)
  boolean isVisible() {
    return position.x >= 0 && position.x <= width && position.y >= 0 && position.y <= height;
  }
}
