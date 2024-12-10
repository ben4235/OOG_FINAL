// variables (too many variables)
HealthBar healthBar;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
ArrayList<Upgrade> upgrades;
boolean upgradePrompt = false;
int highScore = 0;
boolean gameOver = false;
boolean firstUpgradeGiven = false;
int upgradeThreshold = 100; // Smaller increment for upgrades
int nextUpgradeScore = upgradeThreshold;
boolean paused = false;
boolean upgradeCooldown = false;
int lastUpgradeScore = 0;
int gracePeriodStartTime = 0;
boolean inGracePeriod = false;
int bulletDamage = 1;
int score = 0; // The player's score
int damageUpgradeThreshold = 500; // Score threshold for damage upgrade
int reloadSpeedUpgradeThreshold = 1000; // Score threshold for reload speed upgrade
int spreadUpgradeThreshold = 1500; // Score threshold for bullet spread upgrade



boolean damageUpgraded = false; // To track if the upgrade has already been given
boolean reloadSpeedUpgraded = false;
boolean spreadUpgraded = false;
//variables for the stars
int numStars = 200;
float[] starX = new float[numStars];
float[] starY = new float[numStars];
float[] starBrightness = new float[numStars];

//variables for the galaxy
int numGalaxy = 20;
float[] galaxyX = new float[numGalaxy];
float[] galaxyy = new float[numGalaxy];
float[] galaxyBaseSize = new float[numGalaxy];
color[] galaxyColor = new color[numGalaxy];

//variables for the shooting stars
int numShootingStars = 5;
float[] shootingStarX = new float[numShootingStars];
float[] shootingStarY = new float[numShootingStars];
float[] shootingStarSpeedX = new float[numShootingStars];
float[] shootingStarSpeedY = new float[numShootingStars];
boolean[] shootingStarActive = new boolean[numShootingStars];

//variables for the enemy spawning
float spawnInterval = 2000;
int lastSpawnTime = 0;

Upgrade currentUpgrade1 = new Upgrade("Damage Boost", 1);  // Increase damage by 1
Upgrade currentUpgrade2 = new Upgrade("Attack Speed", 200);  // Reduce reload time by 200ms
Upgrade currentUpgrade3 = new Upgrade("Bullet Count", 1);  // Increase bullet count by 1

ArrayList<Upgrade> availableUpgrades = new ArrayList<>();

void setup() {
  size(1250, 750);

  // Define the square size, gap, and startX for positioning
  float squareSize = 100;
  float gap = 20;
  float totalWidth = 3 * squareSize + 2 * gap;
  float startX = (width - totalWidth) / 2;  // Position the first upgrade box
  float squareY = height / 2 - squareSize / 2; // Define squareY here

  availableUpgrades.add(new Upgrade("BulletDamage", 10));
  availableUpgrades.add(new Upgrade("ReloadSpeed", 100));
  availableUpgrades.add(new Upgrade("BulletSpread", 1));
  // Loop through upgrades to display or use them
  for (int i = 0; i < availableUpgrades.size(); i++) {
    Upgrade upgrade = availableUpgrades.get(i);
    println("Upgrade: " + upgrade.type + ", Value: " + upgrade.value);
  }

  // Initialize the stars
  for (int i = 0; i < numStars; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
    starBrightness[i] = random(150, 255);
  }

  // Initialize the galaxy
  for (int i = 0; i < numGalaxy; i++) {
    galaxyX[i] = random(width);
    galaxyy[i] = random(height);
    galaxyBaseSize[i] = random(50, 300);
    galaxyColor[i] = color(random(50, 255), random(50, 255), random(50, 255), 10);
  }

  // Initialize the shooting stars
  for (int i = 0; i < numShootingStars; i++) {
    resetShootingStar(i);
  }

  upgrades = new ArrayList<Upgrade>();
  initializeUpgrades();

  // Initialize the player and the healthbar
  healthBar = new HealthBar(10, 10, 1230, 40, 1000);
  player = new Player(width / 2, height / 2, 30, 1000);
  player.setHealthBar(healthBar);  // Link health bar to player
  Upgrade[] upgradesArray = availableUpgrades.toArray(new Upgrade[0]);


  // Initialize the array for both the bullets and for the enemies
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();

  // Reset the gameOver state
  gameOver = false;

  // Initialize the array inside the setup() method or any method
  Upgrade[] availableUpgrades = {
    new Upgrade("Damage Boost", 1),
    new Upgrade("Attack Speed", 200),
    new Upgrade("Bullet Count", 1)
  };

  // Draw upgrade options
  for (int i = 0; i < availableUpgrades.length; i++) {
    fill(200);
    rect(startX + i * (squareSize + gap), squareY, squareSize, squareSize);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(availableUpgrades[i].name, startX + i * (squareSize + gap) + squareSize / 2, squareY + squareSize / 2);
  }
  // Iterate through the array
  for (int i = 0; i < upgradesArray.length; i++) {
    Upgrade upgrade = upgradesArray[i];
    println("Upgrade: " + upgrade.type + ", Value: " + upgrade.value);
  }
  // Give the player the initial upgrade prompt
  promptUpgrade();
  initializeUpgrades();
  println("Setup completed");
}



void resetShootingStar(int index) {
  shootingStarX[index] = random(width);
  shootingStarY[index] = random(height / 2);
  shootingStarSpeedX[index] = random(5, 10);
  shootingStarSpeedY[index] = random(2, 5);
  shootingStarActive[index] = false;
}


void initializeGame() {
  //initialize the player and the players healthbar
  healthBar = new HealthBar(10, 10, 1230, 40, 1000);
  player = new Player(width / 2, height / 2, 30, 1000);
  //link health bar to player
  player.setHealthBar(healthBar);
  //initialize the array for both the bullets and for the enemies
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();
  //reset the gameOver state
  gameOver = false;
  firstUpgradeGiven = false;
  //reset the score
  score = 0;
  //give the player the initial upgrade prompt
  promptUpgrade();
}


Player player = new Player(100, 100, 50, 100);


void draw() {

  // Display and update the health bar
  healthBar.display();
  // Draw the galaxy background
  drawGalaxyBackground();
  // Display and update the player
  player.update();
  player.display();
  player.displayReloadBar();  // Inside the Player class, it uses player.x and player.y
  checkCollisions();

  if (paused) {
    if (upgradePrompt) {
      displayUpgradePrompt();  // Show upgrade choices
    }
    return;
  }

  // Score tracking and upgrade logic
  if (score >= nextUpgradeScore && !upgradePrompt && !upgradeCooldown) {
    promptUpgrade();
    upgradeThreshold = 100;  // Set a smaller increment for the next upgrade
    nextUpgradeScore = score + upgradeThreshold;
  }

  if (score >= reloadSpeedUpgradeThreshold && !reloadSpeedUpgraded) {
    upgradeBulletReloadSpeed();
    reloadSpeedUpgraded = true;
  }

  if (score >= spreadUpgradeThreshold && !spreadUpgraded) {
    upgradeBulletSpread();
    spreadUpgraded = true;
  }



  if (gameOver) {
    displayGameOverScreen();
    return;  // Exit the draw function if the game is over
  }
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
  }


    player.updateAndDisplay();  // Update player and display bullets
    // Update and display enemies (if you have enemies)
    for (Enemy enemy : enemies) {
      enemy.update(player);  // Update enemy movement
      enemy.display();       // Display enemy
    }

    // Update and display bullets and enemies
    player.updateAndDisplay();  // This calls the method from the player class to handle bullets

    updateAndDisplayEnemies();

    // Spawn enemies off-screen
    if (millis() - lastSpawnTime > spawnInterval) {
      spawnEnemy();
      lastSpawnTime = millis();
      spawnInterval = max(500, 2000 - score * 5);
    }

    // Check if it's time for an upgrade
    if (score >= nextUpgradeScore && !upgradePrompt && !upgradeCooldown) {
      promptUpgrade();
    }
    upgradeThreshold += 10;
    nextUpgradeScore = score + upgradeThreshold;
  


  Upgrade[] availableUpgrades = {
    new Upgrade("Damage Boost", 1),
    new Upgrade("Attack Speed", 200),
    new Upgrade("Bullet Count", 1),
    new Upgrade("Reload Speed", 0.8f),
    new Upgrade("Bullet Spread", 1)
  };
}
void displayHealthBar() {
    // Background of the health bar
    noStroke();
    fill(50);
    rect(10, 10, 200, 20); // Static background width

    // Foreground representing health
    fill(255, 0, 0);
    rect(10, 10, player.health * 2, 20); // Health bar width based on health

    // Outline for clarity
    noFill();
    stroke(255);
    rect(10, 10, 200, 20); // Full bar outline
}

void promptUpgrade() {
  // Pause the game
  paused = true;
  upgradePrompt = true;

  // Randomly shuffle or pick 3 upgrades
  Upgrade[] chosenUpgrades = new Upgrade[3];
  for (int i = 0; i < 3; i++) {
    chosenUpgrades[i] = availableUpgrades.get((int) random(availableUpgrades.size()));
  }

  currentUpgrade1 = chosenUpgrades[0];
  currentUpgrade2 = chosenUpgrades[1];
  currentUpgrade3 = chosenUpgrades[2];
}
void upgradeBulletDamage() {
  bulletDamage += 2; // Increase bullet damage
  println("Bullet damage upgraded!");
}

void upgradeBulletReloadSpeed() {
  player.setReloadSpeed(player.reloadSpeed * 0.8); // Decrease reload time (faster reload)
  println("Bullet reload speed upgraded!");
}

void upgradeBulletSpread() {
  player.setBulletSpread(player.bulletSpread + 1);  // Increase number of bullets shot
  println("Bullet spread upgraded!");
}


void drawGalaxyBackground() {
  //clear the screen
  background(0);
  //draw galaxy with dynamic sizes
  for (int i = 0; i < numGalaxy; i++) {
    float dynamicSize = galaxyBaseSize[i] + sin(frameCount * 0.02 + i) * 20;
    fill(galaxyColor[i]);
    noStroke();
    ellipse(galaxyX[i], galaxyy[i], dynamicSize, dynamicSize);
  }
  //draw stars
  for (int i = 0; i < numStars; i++) {
    fill(255, 255, 255, starBrightness[i]);
    noStroke();
    ellipse(starX[i], starY[i], 2, 2);
  }
  //draw shooting stars
  for (int i = 0; i < numShootingStars; i++) {
    if (shootingStarActive[i]) {
      fill(255);
      stroke(255);
      line(shootingStarX[i], shootingStarY[i], shootingStarX[i] - shootingStarSpeedX[i] * 5, shootingStarY[i] - shootingStarSpeedY[i] * 5);
      shootingStarX[i] += shootingStarSpeedX[i];
      shootingStarY[i] += shootingStarSpeedY[i];
      //reset shooting star if it goes off screen
      if (shootingStarX[i] > width || shootingStarY[i] > height) {
        resetShootingStar(i);
        shootingStarActive[i] = random(1000) > 980;
      }
    } else if (random(10000) > 9995) {
      shootingStarActive[i] = true;
    }
  }
}

void drawBackground() {
  background(0);
  //draw animated circles
  for (int i = 0; i < 50; i++) {
    float x = noise(frameCount * 0.01 + i) * width;
    float y = noise(frameCount * 0.01 + i + 100) * height;
    float size = noise(frameCount * 0.01 + i + 200) * 50;
    fill(255, 100, 100, 100);
    noStroke();
    ellipse(x, y, size, size);
  }
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
void mousePressed() {
  if (upgradePrompt) {
    // Check if the player clicks on an upgrade option
    float squareSize = 100;
    float gap = 20;
    float startX = (width - 3 * squareSize - 2 * gap) / 2;
    float squareY = height / 2 - squareSize / 2;

    if (mouseX > startX && mouseX < startX + squareSize && mouseY > squareY && mouseY < squareY + squareSize) {
      player.applyUpgrade(currentUpgrade1);  // Apply the first upgrade
    } else if (mouseX > startX + squareSize + gap && mouseX < startX + 2 * squareSize + gap && mouseY > squareY && mouseY < squareY + squareSize) {
      player.applyUpgrade(currentUpgrade2);  // Apply the second upgrade
    } else if (mouseX > startX + 2 * (squareSize + gap) && mouseX < startX + 3 * squareSize + 2 * gap && mouseY > squareY && mouseY < squareY + squareSize) {
      player.applyUpgrade(currentUpgrade3);  // Apply the third upgrade
    }

    // Resume the game after an upgrade is chosen
    upgradePrompt = false;
    paused = false;
  } else {
    player.shoot();  // Corrected to call shoot on the player object
  }
}



//player upgrade values
void initializeUpgrades() {
  upgrades = new ArrayList<Upgrade>();
  upgrades.add(new Upgrade("Damage\n Boost", 1));
  upgrades.add(new Upgrade("Attack\n Speed", 200));
  upgrades.add(new Upgrade("Bullet\n Count", 1));
}




void displayUpgradePrompt() {
  background(0);
  fill(255);
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Choose an Upgrade", width / 2, height / 2 - 150);

  // Define the variables here
  float squareSize = 100;
  float gap = 20;
  float totalWidth = 3 * squareSize + 2 * gap;
  float startX = (width - totalWidth) / 2;
  float squareY = height / 2 - squareSize / 2;

  for (int i = 0; i < availableUpgrades.size(); i++) {
    Upgrade upgrade = availableUpgrades.get(i);
    println("Upgrade: " + upgrade.type + ", Value: " + upgrade.value);
  }
}



void displayGameOverScreen() {
  fill(255, 0, 0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Game Over", width / 2, height / 2 - 60);
  textSize(20);
  text("Score: " + score, width / 2, height / 2);
  text("High Score: " + highScore, width / 2, height / 2 + 30);
  text("Press 'R' to Restart", width / 2, height / 2 + 60);
}

void updateAndDisplay() {

  // Update and display all bullets
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();  // Update bullet position
    b.display();  // Display bullet on the screen

    // Check for collisions with enemies
    for (Enemy enemy : enemies) {
      if (enemy.checkHit(b, bullets)) {  // Pass bullets list to checkHit()
        System.out.println("Enemy hit!");
        if (!enemy.isAlive()) {
          enemies.remove(enemy);
          System.out.println("Enemy destroyed!");
          score += 10;
        }
        break; // Exit loop once the bullet has hit an enemy
      }
    }

    // Remove bullets that go off-screen
    if (!b.isVisible()) {
      bullets.remove(i);
    }
  }
}




void updateAndDisplayEnemies() {
  // Update and display regular enemies
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update(player);
    e.display();

    // Check if the enemy collides with the player
    if (e.checkCollisionWithPlayer(player)) {
      player.decreaseHealth(10);  // Decrease player's health by 10
      healthBar.setHealth(player.health);  // Update the health bar
      enemies.remove(i); // Remove enemy upon collision
    }

    // Check if the enemy is dead
    if (!e.isAlive()) {
      enemies.remove(i);
      score += 10;
    }
  }
}


void drawStarfieldBackground() {
  background(0);  // Clear the screen
  // Draw stars
  for (int i = 0; i < numStars; i++) {
    fill(255);
    noStroke();
    ellipse(starX[i], starY[i], 2, 2);
  }
}

void spawnEnemy() {
  float spawnBuffer = 50;  // Buffer to spawn enemies off-screen
  float x, y;
  int edge = floor(random(4));
  // Choose a random edge to spawn the enemy
  switch (edge) {
  case 0: // Top
    x = random(width);
    y = -spawnBuffer;
    break;
  case 1: // Right
    x = width + spawnBuffer;
    y = random(height);
    break;
  case 2: // Bottom
    x = random(width);
    y = height + spawnBuffer;
    break;
  case 3: // Left
    x = -spawnBuffer;
    y = random(height);
    break;
  default:
    x = random(width);
    y = random(height);
  }

  // Gradually increase enemy speed and health based on the score
  float enemySpeed = 1 + score / 1000.0;
  int enemyHealth = 5 + score / 50;
  // Spawn a single enemy type
  enemies.add(new Enemy(x, y, enemySpeed, enemyHealth));
}
