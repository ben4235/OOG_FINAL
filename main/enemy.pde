class Enemy {
  PVector position;  // Use PVector for position
  PVector velocity;  // Use PVector for velocity (movement)
  float speed;
  float size;  // Radius of the enemy
  int health;

  Enemy(float x, float y, float speed, int health) {
    this.position = new PVector(x, y);  // Initialize position
    this.velocity = new PVector(0, 0);  // Initialize velocity
    this.speed = speed;
    this.health = health;
  }

  void update(Player player) {
    // Calculate direction vector from enemy to player
    PVector direction = PVector.sub(player.position, this.position);  // Get vector from enemy to player
    direction.normalize();  // Normalize to make it a unit vector (magnitude of 1)

    // Set velocity based on direction and speed
    this.velocity = direction.copy().mult(speed);

    // Update position based on velocity
    this.position.add(velocity);
  }

  void display() {
    fill(255, 0, 0);  // Red color for the enemy
    noStroke();
    ellipse(position.x, position.y, 20, 20);  // Draw enemy as a circle
  }

  boolean checkHit(Bullet bullet, ArrayList<Bullet> bullets) {
    if (dist(position.x, position.y, bullet.position.x, bullet.position.y) < 10) {
      health -= bullet.damage;  // Decrease health by bullet damage
      bullets.remove(bullet);  // Remove the bullet from the list
      return true;  // Return true if the bullet hits
    }
    return false;  // Return false if the bullet doesn't hit
  }
  // Method to handle taking damage
  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      // Handle enemy death (e.g., remove from list)
      System.out.println("Enemy destroyed!");
    }
  }
  boolean collidesWith(Enemy enemy) {
    float bulletRadius = 5;
    float distance = dist(position.x, position.y, enemy.position.x, enemy.position.y);
    float combinedRadius = bulletRadius + enemy.size / 2;

    return distance < combinedRadius;
  }

  void checkCollisions() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy enemy = enemies.get(j);
        if (b.collidesWith(enemy)) {
          enemy.takeDamage(b.damage);
          bullets.remove(i); // Remove bullet
          if (enemy.health <= 0) {
            enemies.remove(j); // Remove enemy if health is 0 or less
          }
          break; // Break inner loop if collision detected
        }
      }
    }
  }
  
boolean checkCollisionWithPlayer(Player player) {
    float distance = dist(this.position.x, this.position.y, player.position.x, player.position.y);
    float collisionThreshold = this.size / 2 + player.size / 2;
    return distance < collisionThreshold;
}



  boolean isAlive() {
    return health > 0;
  }
}
