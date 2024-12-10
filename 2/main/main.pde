Player player;
ArrayList<Enemy> enemies;
ArrayList<Bullet> bullets;
int playerScore = 0; // Example score variable

int score = 0;
int spawnTimer = 60;
int spawnRate = 60; // Enemies spawn every second
int waveTimer = 0;
boolean upgradePresented = false;

boolean upgradeMenu = false;
Upgrade[] upgrades = new Upgrade[3];

void setup() {
  size(800, 600);
  player = new Player();
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<>();
}

void draw() {

  if (!upgradeMenu) {
    background(30);
    player.update();
    player.display();

    updateEnemies();
    updateBullets();
    checkCollisions();

    fill(255);
    textSize(16);
    text("Score: " + score, 10, 20);

    if (mousePressed) {
      PVector direction = new PVector(mouseX - player.position.x, mouseY - player.position.y);
      direction.normalize(); // Normalize to get direction
      bullets.add(new Bullet(player.position, direction)); // Add bullet to the array
    }

    // Update and display bullets
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      b.update();
      b.display();
      // Check for collisions with enemies
      for (int j = 0; j < enemies.size(); j++) {
        Enemy e = enemies.get(j);
        if (dist(b.position.x, b.position.y, e.position.x, e.position.y) < b.radius + e.radius) {
          // Bullet hit the enemy
          e.takeDamage(player.bulletDamage); // Apply bullet damage to enemy
          bullets.remove(i); // Remove bullet after collision
          break; // Exit the loop once the bullet hits an enemy
        }
      }
      // Remove the bullet if it's off the screen
      if (b.offScreen()) {
        bullets.remove(i);
      }

  // Increment score for demonstration
  playerScore++;

  // Check if score is high enough to trigger an upgrade
  if (playerScore >= 1000 && !upgradePresented) {
    presentUpgrade(); // Show upgrade options to player
    upgradePresented = true; // Flag to ensure upgrade is only presented once
  }
    }
  }
}
void updateBullets() {
  // Iterate through bullets in reverse order so we can remove them without affecting the iteration
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    // Check for collisions with enemies
    for (int j = 0; j < enemies.size(); j++) {
      Enemy e = enemies.get(j);
      if (dist(b.position.x, b.position.y, e.position.x, e.position.y) < b.radius + e.radius) {
        // Bullet hit the enemy
        e.takeDamage(player.bulletDamage); // Apply bullet damage to enemy
        bullets.remove(i); // Remove bullet after collision
        break; // Exit the loop once the bullet hits an enemy
      }
    }

    // Remove bullet if it's off the screen
    if (b.offScreen()) {
      bullets.remove(i);
    }
  }
}

// Spawn enemies and make them stronger over time
void updateEnemies() {
  if (frameCount % spawnRate == 0) {
    enemies.add(new Enemy(random(width), 0, 1 + waveTimer / 600)); // Add new enemy with position and speed

    spawnTimer--;
  }
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();
    if (e.offScreen()) enemies.remove(i);
  }
  waveTimer++;
  if (waveTimer % 600 == 0 && spawnRate > 20) spawnRate -= 5; // Speed up spawns
}



void presentUpgrade() {
  // Create an array of possible upgrades
  Upgrade[] availableUpgrades = new Upgrade[3];
  availableUpgrades[0] = new Upgrade("bulletCooldown", 50); // Reduce cooldown by 50ms
  availableUpgrades[1] = new Upgrade("bulletDamage", 5); // Increase damage by 5
  availableUpgrades[2] = new Upgrade("bulletSpread", 1); // Add a spread to bullets

  // Display upgrades (you could display them as buttons or text)
  text("Upgrade Choices:", width / 2, height / 2 - 100);
  for (int i = 0; i < availableUpgrades.length; i++) {
    text(availableUpgrades[i].name, width / 2, height / 2 + i * 30);
  }

  // Wait for player input (e.g., mouse click) to select an upgrade
  if (mousePressed) {
    for (int i = 0; i < availableUpgrades.length; i++) {
      // Check if the mouse is hovering over the upgrade choice
      if (mouseY > height / 2 + i * 30 - 15 && mouseY < height / 2 + i * 30 + 15) {
        // Apply the selected upgrade to the player
        availableUpgrades[i].applyUpgrade(player);
        upgradePresented = false; // Reset so upgrades can be triggered again
      }
    }
  }
}




// Check collisions between bullets and enemies
void checkCollisions() {
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    for (int j = bullets.size() - 1; j >= 0; j--) {
      Bullet b = bullets.get(j);
      if (e.hit(b)) {
        e.takeDamage(player.bulletDamage);
        bullets.remove(j);
        if (e.health <= 0) {
          enemies.remove(i);
          score++;
          break;
        }
      }
    }
  }
}


void displayUpgradeMenu() {
  background(0, 50, 100);
  textAlign(CENTER);
  textSize(20);
  fill(255);
  text("Choose an Upgrade", width / 2, height / 4);

  for (int i = 0; i < 3; i++) {
    upgrades[i].display(width / 2, height / 2 + i * 50);
  }
}

void mousePressed() {
  if (upgradeMenu) {
    for (int i = 0; i < 3; i++) {
      float x = width / 2; // Center x position of upgrades
      float y = height / 2 + i * 50; // y positions based on index
      if (upgrades[i].isHovered(mouseX, mouseY, x, y)) {
        upgrades[i].apply(player); // Apply the selected upgrade
        upgradeMenu = false; // Close the menu
        break;
      }
    }
  }
}
