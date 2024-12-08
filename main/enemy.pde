class Enemy {
  // position of enemy
  PVector position;
  // direction and speed of movement
  PVector velocity;
  // enemy size
  float size = 30;
  // enemy health
  int health = 10;
  // enemy movement speed
  float speed = 1;
  // position of player
  PVector playerPos;

  // constructor for spawning enemies off-screen
  Enemy() {
    // initialize player position
    playerPos = new PVector(width / 2, height / 2);
    // enemy has no velocity starting out
    velocity = new PVector(0, 0);

    float spawnEdge = random(4);
    if (spawnEdge < 1) {
      // Spawn along the top edge
      position = new PVector(random(0, width), random(-size, 0));
    } else if (spawnEdge < 2) {
      // Spawn along the bottom edge
      position = new PVector(random(0, width), random(height, height + size));
    } else if (spawnEdge < 3) {
      // Spawn along the left edge
      position = new PVector(random(-size, 0), random(0, height));
    } else {
      // Spawn along the right edge
      position = new PVector(random(width, width + size), random(0, height));
    }
  }

  // display the enemy
  void display() {
    // enemy is red
    fill(255, 0, 0);
    // enemy is circle for now
    ellipse(position.x, position.y, size, size);
  }

  // update the player's position for the enemy movement direction
  void updatePlayerPos(float px, float py) {
    // update the players position
    playerPos.set(px, py);
  }

  // move the enemy towards the player using PVector
  void move() {
    // vector from enemy to player
    PVector direction = PVector.sub(playerPos, position);
    // normalize the direction to get a unit vector
    direction.normalize();
    // scale the direction by speed
    direction.mult(speed);

    // update the enemy position by adding the velocity
    position.add(direction);
  }

  // check if the enemy has been hit by a bullet
  boolean checkHit(Bullet b) {
    float distance = dist(position.x, position.y, b.x, b.y);
    if (distance < size / 2 + b.size / 2) {
      // decrease the health if hit
      health -= 5;
      // bullet hit the enemy
      return true;
    }
    return false;
  }

  // check to see if the enemy is still alive
  boolean isAlive() {
    return health > 0;
  }
<<<<<<< HEAD

  // check collision with the player
  boolean collidesWith(Player p) {
    float distance = dist(position.x, position.y, p.x, p.y);
    return distance < (size / 2 + p.size / 2);
  }
=======
>>>>>>> enemies
}
