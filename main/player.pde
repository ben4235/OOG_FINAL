class Player {
  PVector position;
  float radius = 20;
  int bulletDamage = 10;
  int bulletSpread = 1;
  float bulletCooldown = 500;
  float lastShotTime = 0;
  int health;

  Player() {
    position = new PVector(width / 2, height / 2);  // Initialize player position
    println("Player position initialized: " + position);  // Debugging: check player position
  }

  void reset() {
    health = 100;  // Reset health
    position.set(width / 2, height / 2);  // Reset position (or wherever you want the player to start)
  }

  void fireBullet() {
    // Calculate the direction toward the mouse position
    PVector mainDirection = new PVector(mouseX - position.x, mouseY - position.y);
    mainDirection.normalize(); // Normalize the vector to get a unit direction

    // Check if enough time has passed since the last shot
    if (millis() - lastShotTime >= bulletCooldown) {
      // Always fire the main bullet (straight toward the mouse)
      bullets.add(new Bullet(position, mainDirection.copy().mult(5)));
      println(bulletDamage);

      // If bulletSpread is greater than 1, fire additional bullets around the main direction
      if (bulletSpread > 1) {
        int sideBullets = bulletSpread - 1; // Remaining bullets to fire on left and right

        // Spread bullets symmetrically to the left and right
        for (int i = 1; i <= sideBullets / 2; i++) {
          // Calculate spread angle for left and right bullets
          float angle = PI / 12 * i; // Adjust the angle spread (15° per side bullet)

          // Left bullet
          PVector leftDirection = mainDirection.copy();
          leftDirection.rotate(-angle); // Rotate counter-clockwise
          bullets.add(new Bullet(position, leftDirection.mult(5)));

          // Right bullet
          PVector rightDirection = mainDirection.copy();
          rightDirection.rotate(angle); // Rotate clockwise
          bullets.add(new Bullet(position, rightDirection.mult(5)));
        }

        // If the spread is odd, we need to fire an additional bullet (the middle bullet on the opposite side)
        if (sideBullets % 2 != 0) {
          float angle = PI / 12 * (sideBullets / 2 + 1);

          // Extra bullet on one side (right side in this case)
          PVector rightDirection = mainDirection.copy();
          rightDirection.rotate(angle); // Rotate clockwise
          bullets.add(new Bullet(position, rightDirection.mult(5)));
        }
      }

      // Update the time of the last shot
      lastShotTime = millis();
    }
  }

  void display() {
    fill(0, 0, 255);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}
