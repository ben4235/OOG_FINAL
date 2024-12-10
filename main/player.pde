class Player {
  PVector position;
  float size;
  int health;
  int bulletCount = 10;
  float reloadSpeed = 1000; // Initial reload speed in milliseconds
  float reloadTime = 1000.0;  // Reload time in milliseconds
  float x, y; // Declare x and y as float variables

  boolean isUpgradeAvailable = false;  // Declare the variable at the class level
  Upgrade currentUpgrade = null; // To keep track of the current upgrade being displayed
  ArrayList<Upgrade> availableUpgrades = new ArrayList<>();
  int reloadProgress; // Progress of reload (0 to 100)
  int bulletDamage = 10; // Initial bullet damage
  float bulletSpread;  // Variable to control the number of bullets shot
  long lastShotTime = 0;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  HealthBar healthBar;

  Player(float x, float y, float size, int health) {
    this.position = new PVector(x, y);
    this.size = size;
    this.health = health;
            // Initialize available upgrades
        availableUpgrades.add(new Upgrade("BulletDamage", 10));
        availableUpgrades.add(new Upgrade("ReloadSpeed", 100));
        availableUpgrades.add(new Upgrade("BulletSpread", 1));
  }

  void setHealthBar(HealthBar healthBar) {
    this.healthBar = healthBar; // Set health bar reference
  }

  void shoot() {
    if (millis() - lastShotTime >= reloadTime) {
      Bullet b = new Bullet(position.x, position.y, bulletDamage);
      PVector direction = new PVector(mouseX - position.x, mouseY - position.y); // Direction to mouse
      direction.normalize();  // Normalize the direction vector
      b.setVelocity(direction, 5);  // Set bullet speed

      bullets.add(b);
      lastShotTime = millis();
      System.out.println("Shooting bullet!");
    } else {
      System.out.println("Reloading...");
    }
  }

  void applyUpgrade(Upgrade upgrade) {
    if (upgrade == null) {
      println("Upgrade is null!");
      return;
    }

    println("Applying upgrade: " + upgrade.type);

    switch (upgrade.type) {
    case "BulletDamage":
      bulletDamage += upgrade.value;
      println("Bullet damage upgraded! Current damage: " + bulletDamage);
      break;
    case "ReloadSpeed":
      reloadTime = max(100, reloadTime - upgrade.value); // Decrease reload time
      println("Reload speed upgraded! Current reload time: " + reloadTime);
      break;
    case "BulletSpread":
      bulletSpread += upgrade.value;
      println("Bullet spread upgraded! Current spread: " + bulletSpread);
      break;
    default:
      println("Unknown upgrade type: " + upgrade.type);
    }
  }

  void displayUpgradePrompt() {
    background(0);
    fill(255);
    textSize(30);
    textAlign(CENTER, CENTER);
    text("Choose an Upgrade", width / 2, height / 2 - 150);

    float squareSize = 100;
    float gap = 20;
    float totalWidth = 3 * squareSize + 2 * gap;
    float startX = (width - totalWidth) / 2;
    float squareY = height / 2 - squareSize / 2;

    fill(200);
    rect(startX, squareY, squareSize, squareSize);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Damage", startX + squareSize / 2, squareY + squareSize / 2);

    fill(200);
    rect(startX + squareSize + gap, squareY, squareSize, squareSize);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Reload", startX + 1.5 * squareSize + gap, squareY + squareSize / 2);

    fill(200);
    rect(startX + 2 * (squareSize + gap), squareY, squareSize, squareSize);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Spread", startX + 2.5 * squareSize + 2 * gap, squareY + squareSize / 2);
  }

  void handleUpgradeSelection() {
    // Only check for mouse clicks if an upgrade is available
    if (mousePressed && isUpgradeAvailable) {
      float squareSize = 100;
      float gap = 20;
      float totalWidth = 3 * squareSize + 2 * gap;
      float startX = (width - totalWidth) / 2;
      float squareY = height / 2 - squareSize / 2;

      // BulletDamage upgrade (first option)
      if (mouseX >= startX && mouseX <= startX + squareSize &&
        mouseY >= squareY && mouseY <= squareY + squareSize) {
        applyUpgrade(new Upgrade("BulletDamage", 10));
        isUpgradeAvailable = false;  // Close the upgrade screen after selection
        return;
      }

      // ReloadSpeed upgrade (second option)
      else if (mouseX >= startX + squareSize + gap && mouseX <= startX + 2 * squareSize + gap &&
        mouseY >= squareY && mouseY <= squareY + squareSize) {
        applyUpgrade(new Upgrade("ReloadSpeed", 10));
        isUpgradeAvailable = false;
        return;
      }

      // BulletSpread upgrade (third option)
      else if (mouseX >= startX + 2 * (squareSize + gap) && mouseX <= startX + 3 * squareSize + 2 * gap &&
        mouseY >= squareY && mouseY <= squareY + squareSize) {
        applyUpgrade(new Upgrade("BulletSpread", 10));
        isUpgradeAvailable = false;
        return;
      }
    }
  }

  void offerUpgrade() {
    if (!isUpgradeAvailable) {
      displayUpgradePrompt();
      isUpgradeAvailable = true; // Keep the upgrade screen open until player selects an upgrade
    }
  }

  // Set bullet spread
  void setBulletSpread(float newBulletSpread) {
    this.bulletSpread = newBulletSpread;  // Update bulletSpread
  }

  void update() {
    if (score >= nextUpgradeScore && !isUpgradeAvailable) {
      nextUpgradeScore += 10;  // Increase the threshold for the next upgrade
      offerUpgrade();  // Show the upgrade prompt
    }

    // If upgrade screen is visible, check for selection
    if (isUpgradeAvailable) {
      handleUpgradeSelection();  // Handle mouse click for upgrade selection
    }

    // Handle player movement with arrow keys
    if (keyPressed) {
      if (keyCode == UP) {
        position.y -= 5;
      } else if (keyCode == DOWN) {
        position.y += 5;
      } else if (keyCode == LEFT) {
        position.x -= 5;
      } else if (keyCode == RIGHT) {
        position.x += 5;
      }
    }

    // Ensure player stays within bounds
    position.x = constrain(position.x, 0, width - size);
    position.y = constrain(position.y, 0, height - size);
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



  // Add the setReloadSpeed method
  void setReloadSpeed(float newReloadSpeed) {
    this.reloadSpeed = newReloadSpeed;  // Update reloadSpeed field
  }

  void decreaseHealth(int damage) {
    health -= damage;
    healthBar.setHealth(health); // Update health bar when health decreases
  }

  void displayReloadBar() {
    // Display the reload bar near the player
    int reloadBarWidth = 200;
    int reloadBarHeight = 20;
    rect(this.x - 100, this.y + this.size + 10, reloadBarWidth, reloadBarHeight);  // Position reload bar relative to player
  }

  void display() {
    fill(255, 0, 0);  // Red color for the player
    noStroke();
    ellipse(position.x, position.y, size, size);

    // Display the score
    fill(255);  // White color for the score text
    textSize(20);
    textAlign(CENTER, TOP);  // Center the text horizontally
    text("Score: " + score, width / 2, 70);  // Positioning the score in the middle below the health bar
  }
}
