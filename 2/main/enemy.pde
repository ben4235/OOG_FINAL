class Enemy {
  PVector position;
  float health = 100;
  float radius = 20;
  PVector velocity;

  // Constructor with three parameters
  Enemy(float x, int y, int speed) {
    position = new PVector(x, y); // Set the enemy's initial position
    velocity = new PVector(0, speed); // Set speed (moving downwards, adjust as needed)
  }

  void update() {
    position.add(velocity); // Update the enemy's position based on its velocity
  }

  void display() {
    fill(0, 255, 0); // Green color for the enemy
    ellipse(position.x, position.y, radius * 2, radius * 2); // Draw enemy as a circle
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      // Handle enemy death
    }
  }
  // Check if bullet hits the enemy
  boolean hit(Bullet b) {
    float distance = dist(position.x, position.y, b.position.x, b.position.y);
    return distance < radius + b.radius; // Check if the bullet intersects with the enemy
  }
  // offScreen method to check if the enemy is off the screen
  boolean offScreen() {
    return position.y > height || position.x < 0 || position.x > width;
  }
}
