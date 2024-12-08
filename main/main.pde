HealthBar healthBar;
Player player;
// arrays to track the bullets and enemies
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
ArrayList<Upgrade> upgrades;
boolean upgradePrompt = false;
Upgrade currentUpgrade1, currentUpgrade2, currentUpgrade3;
// score counter
int score = 0;
int highScore = 0;
boolean gameOver = false;
boolean firstUpgradeGiven = false; // Track if the first upgrade has been given
int upgradeInterval = (int) (8 * Math.log(score + 1)); // Adjusted multiplier for balanced pace




void setup() {
  size(400, 400);

  //initialize upgrades
  upgrades = new ArrayList<Upgrade>();
  initializeUpgrades();

  // initialize the player and the healthbar
  healthBar = new HealthBar(20, 20, 140, 20, 100);
  // player in the center, reload time one second
  player = new Player(width / 2, height / 2, 30, 1000);

  // initialize the array for both bullets and enemies
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();

  // reset gameOver state
  gameOver = false;

  // Give the player the initial upgrade prompt
  promptUpgrade();
}

boolean paused = false;
boolean upgradeCooldown = false;
int lastUpgradeScore = 0;
int gracePeriodStartTime = 0; // Track the start time of the grace period
boolean inGracePeriod = false; // Track whether the grace period is active


void draw() {
  if (paused) {
    if (upgradePrompt) {
      // Check if the grace period is over
      if (inGracePeriod && millis() - gracePeriodStartTime > 1000) {
        inGracePeriod = false; // End grace period after 1 second
      }
      displayUpgradePrompt();
    }
    return;
  }

  // Refresh the screen at the start of draw
  background(0);

  if (gameOver) {
    displayGameOverScreen();
    return; // Exit the draw function
  }

  // Display + update health bar
  healthBar.display();

  // Display + update the player
  player.update();
  player.display();

  // Update + display bullets
  updateAndDisplayBullets();

  // Update and display the enemies
  updateAndDisplayEnemies();

  // Spawn enemies offscreen every 2 seconds
  if (frameCount % 120 == 0 && firstUpgradeGiven) {
    spawnEnemy();
  }

  // Draw score
  drawScore();

  // Check for upgrade prompt based on score and logarithmic progression
  int upgradeInterval = (int) (8 * Math.log(score + 1)); // Adjusted multiplier for a balanced pace
  if (score >= upgradeInterval && !upgradePrompt && firstUpgradeGiven && !upgradeCooldown && score != lastUpgradeScore) {
    promptUpgrade();
    lastUpgradeScore = score;
  }
}





void promptUpgrade() {
  upgradePrompt = true;
  paused = true;  // Pause the game when upgrade prompt is shown
  currentUpgrade1 = upgrades.get(int(random(upgrades.size())));
  currentUpgrade2 = upgrades.get(int(random(upgrades.size())));
  currentUpgrade3 = upgrades.get(int(random(upgrades.size())));
  upgradeCooldown = true;  // Set cooldown to prevent immediate re-prompt
  gracePeriodStartTime = millis(); // Start the grace period timer
  inGracePeriod = true; // Activate the grace period
}



void applyUpgrade(Upgrade upgrade) {
  upgrade.apply(player);
  paused = false; // Resume the game after an upgrade is applied
  upgradePrompt = false;  // End upgrade prompt
  firstUpgradeGiven = true;  // Ensure first upgrade given
  upgradeCooldown = false;  // Reset cooldown for future upgrades
}





void keyPressed() {
  if (gameOver && (key == 'r' || key == 'R')) {
    initializeGame();
    return;
  }

  // temporary to check healthbar
  if (key == 'd' || key == 'D') {
    healthBar.decreaseHealth(10);
  }
  if (key == 'r' || key == 'R' && !gameOver) {  // Ensure this doesn't interfere with the gameOver check
    healthBar.resetHealth();
  }

  // to shoot the enemies
  if (key == ' ') {
    player.shoot();
  }
}

void mousePressed() {
  if (upgradePrompt) {
    if (inGracePeriod) {
      return; // Ignore clicks during the grace period
    }

    float squareSize = 100;
    float gap = 20;
    float startX = (width - 3 * squareSize - 2 * gap) / 2;
    float squareY = height / 2 - squareSize / 2;

    if (mouseX > startX && mouseX < startX + squareSize && mouseY > squareY && mouseY < squareY + squareSize) {
      applyUpgrade(currentUpgrade1);
    } else if (mouseX > startX + squareSize + gap && mouseX < startX + 2 * squareSize + gap && mouseY > squareY && mouseY < squareY + squareSize) {
      applyUpgrade(currentUpgrade2);
    } else if (mouseX > startX + 2 * (squareSize + gap) && mouseX < startX + 3 * squareSize + 2 * gap && mouseY > squareY && mouseY < squareY + squareSize) {
      applyUpgrade(currentUpgrade3);
    }
    upgradePrompt = false;
    firstUpgradeGiven = true;
    paused = false; // Resume the game after an upgrade is applied
  } else {
    player.shoot();
  }
}





// initialize game elements
void initializeGame() {
  // initialize the player and the healthbar
  healthBar = new HealthBar(20, 20, 140, 20, 100);
  // player in the center, reload time one second
  player = new Player(width / 2, height / 2, 30, 1000);

  // initialize the array for both bullets and enemies
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();

  // reset gameOver state
  gameOver = false;
  firstUpgradeGiven = false;

  // reset score
  score = 0;

  // Give the player the initial upgrade prompt
  promptUpgrade();
}

void initializeUpgrades() {
  upgrades.add(new Upgrade("Attack Speed", 200)); // 200 milliseconds decrease
  upgrades.add(new Upgrade("Damage", 1));         // 1 point increase
  upgrades.add(new Upgrade("Bullets Shot", 1));   // 1 extra bullet
}

void displayUpgradePrompt() {
  background(0);
  fill(255);
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Choose an Upgrade", width / 2, height / 2 - 150);

  // Set the rectangle mode to CORNER
  rectMode(CORNER);

  // Define square size
  float squareSize = 100;
  // Define the gap between squares
  float gap = 20;
  // Calculate the total width occupied by the squares and gaps
  float totalWidth = 3 * squareSize + 2 * gap;
  // Define starting x position to center the squares
  float startX = (width - totalWidth) / 2;
  // Define y position for squares
  float squareY = height / 2 - squareSize / 2;

  // Draw upgrade option 1
  fill(200);
  rect(startX, squareY, squareSize, squareSize);
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(currentUpgrade1.type, startX + squareSize / 2, squareY + squareSize / 2);

  // Draw upgrade option 2
  fill(200);
  rect(startX + squareSize + gap, squareY, squareSize, squareSize);
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(currentUpgrade2.type, startX + 1.5 * squareSize + gap, squareY + squareSize / 2);

  // Draw upgrade option 3
  fill(200);
  rect(startX + 2 * (squareSize + gap), squareY, squareSize, squareSize);
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(currentUpgrade3.type, startX + 2.5 * squareSize + 2 * gap, squareY + squareSize / 2);
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

void updateAndDisplayBullets() {
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    // check for enemy + bullet collision
    for (int j = enemies.size() - 1; j >= 0; j--) {
      Enemy e = enemies.get(j);
      // if bullet hits the enemy (remove the bullet)
      if (e.checkHit(b)) {
        bullets.remove(i);
        // if the enemy is dead (remove the enemy from the screen + add score)
        if (!e.isAlive()) {
          enemies.remove(j);
          score += 10;
        }
        // break the inner loop when hit is detected
        break;
      }
    }

    // remove bullets when they go offscreen
    if (b.isOffScreen()) {
      bullets.remove(i);
    }
  }
}

void updateAndDisplayEnemies() {
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    // update the enemies target/where its heading
    e.updatePlayerPos(player.x, player.y);
    // move enemy towards the player
    e.move();
    e.display();

    // check for collision with player
    if (e.collidesWith(player)) {
      enemies.remove(i);
      healthBar.decreaseHealth(10);
      if (healthBar.health == 0) {
        gameOver = true;
        if (score > highScore) {
          highScore = score;
        }
      }
    }
  }
}

void drawScore() {
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Score: " + score, 200, 350);
}

// Function spawning enemies off screen
void spawnEnemy() {
  enemies.add(new Enemy());
}
