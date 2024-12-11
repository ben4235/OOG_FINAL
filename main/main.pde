Player player;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;

int playerScore = 0;
boolean upgradeMenu = false;
Upgrade[] upgrades = new Upgrade[3];

int lastUpgradeScore = 0;  // Track the last score at which upgrades were given
int upgradeThreshold = 200; // Initial score required for the first upgrade
int upgradeIncrement = 25; // Increase in score requirement for subsequent upgrades

// Player Health Bar Constants
int playerMaxHealth = 100;
int playerHealth = 100;


boolean upgradeTriggered = false;

float spawnInterval = 120; // Starting interval for enemy spawn (in frames)
float minSpawnInterval = 20; // Minimum interval for spawning
float spawnDecayRate = 0.1; // Rate at which the interval decreases
float decayRate = 0.1; // Controls how fast the interval decreases

// Track when enemy health was last updated
int lastIncreaseTime = 0; // Time in seconds
int baseHealth = 10;           // Starting health for enemies
int healthIncrementRate = 10;   // Health increase per interval
int updateInterval = 15; // Time interval (in seconds) for increasing health
int damIncrementRate = 1;   // Health increase per interval
float spdIncrementRate = 0.1;   // Speed increase per interval
int damage = 5; // Base damage for enemies
float speed = 1; // Base speed for enemies

boolean gameOver = false;  // Track whether the game is over
int highScore = 0;         // Track the permanent high score
int sessionHighScore = 0;  // Track the session high score

// File name to store the high score
String highScoreFile = "highscore.txt";

// Define initial values
float initialSpawnInterval = 300;  // Initial spawn interval (in frames or seconds)
float initialSpawnDecayRate = 0.05; // Initial spawn decay rate (how much the spawn interval decreases over time)
int initialBulletDamage = 10;      // Default bullet damage
float initialAttackSpeed = 1.0;    // Default attack speed
int initialPlayerHealth = 100;     // Default player health
int initialScore = 0;              // Default score (could be 0 or any other starting value)


void setup() {
  size(1280, 720);
  player = new Player();
  bullets = new ArrayList<>();
  enemies = new ArrayList<>();
  // Check if the highscore file exists, otherwise create it
  File highScoreFileObj = new File(dataPath(highScoreFile));


  // If the file doesn't exist, create it with initial score 0
  if (!highScoreFileObj.exists()) {
    println("High score file not found. Creating a new one.");
    String[] initialScore = {str(highScore)};
    saveStrings(highScoreFile, initialScore);
  }
  // Load the high score from the file when the game starts
  loadHighScore();
}

void draw() {
  background(30);

  if (playerHealth > 0) {
    // Game is still active
    // Draw the health bar
    if (upgradeMenu) {
      displayUpgradeMenu(); // Display the upgrade menu
    } else {

      drawHealthBar();
      player.display();

      updateEnemies();
      updateBullets();
      checkCollisions();

      // Display score
      fill(255);
      textSize(32);
      textAlign(CENTER, CENTER);  // Center the text both horizontally and vertically
      text("Score: " + playerScore, width/2, 40 + 20);

      if (playerScore >= upgradeThreshold && !upgradeMenu) {
        upgradeMenu = true;
        presentUpgrade();

        upgradeIncrement = upgradeIncrement + upgradeIncrement + 100;
        // Increase the threshold for the next upgrade
        upgradeThreshold += upgradeIncrement;
        println(upgradeThreshold);
      }
    }
  } else {
    // Game over screen
    displayGameOverScreen();
  }
}

void displayGameOverScreen() {
  background(0, 50, 100);
  textAlign(CENTER, CENTER);
  textSize(48);
  fill(255);
  text("GAME OVER", width / 2, height / 3);

  textSize(24);
  text("Your Score: " + playerScore, width / 2, height / 2);
  text("High Score: " + highScore, width / 2, height / 2 + 40);

  textSize(16);
  text("Press 'R' to Restart", width / 2, height / 2 + 80);
}


void loadHighScore() {
  // Try to load the high score from the file
  String[] scoreData = loadStrings(highScoreFile);

  if (scoreData != null && scoreData.length > 0) {
    try {
      highScore = Integer.parseInt(scoreData[0]);
      println("Loaded high score: " + highScore);
    }
    catch (NumberFormatException e) {
      println("Error loading high score.");
    }
  } else {
    println("Error: High score file is empty or not formatted correctly.");
  }
}

void saveHighScore() {
  // Convert the high score to a string array and save it to the file
  String[] scoreData = {str(highScore)};

  // Print to console to check what is being saved
  println("Saving high score: " + highScore);

  // Save the score to the file
  saveStrings(highScoreFile, scoreData);

  // Verify that the high score is saved
  println("High score saved to file: " + highScore);
}


void endGame() {
  // After the game ends, check if the score is higher than the saved high score
  if (playerScore > highScore) {
    highScore = playerScore;  // Update the high score
    saveHighScore();  // Save the new high score
    println("New high score: " + highScore);
  }

  // Display the game over screen with the high score
  displayGameOverScreen();
}

void drawHealthBar() {
  fill(255, 0, 0);
  float healthBarWidth = map(playerHealth, 0, playerMaxHealth, 0, width * 0.8);
  rect(width * 0.1, 10, healthBarWidth, 20);
  noFill();
  stroke(255);
  rect(width * 0.1, 10, width * 0.8, 20);
}

void updateBullets() {
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    // Remove bullets that are out of bounds or have hit an enemy
    if (b.position.x < 0 || b.position.x > width || b.position.y < 0 || b.position.y > height) {
      bullets.remove(i);
    }
  }
}


void updateEnemies() {
  // Gradually decrease spawn interval based on time elapsed
  float elapsedSeconds = frameCount / 60.0; // Time since start in seconds
  // Ensure the spawn interval doesn't decrease too quickly
  spawnInterval = max(minSpawnInterval, 300 / (1 + spawnDecayRate * elapsedSeconds));

  // Check if it's time to increase the health of newly spawned enemies
  if (elapsedSeconds - lastIncreaseTime >= updateInterval) {
    baseHealth += healthIncrementRate;
    damage += damIncrementRate;
    speed += spdIncrementRate;
    lastIncreaseTime = (int) elapsedSeconds;
    println("Increased base health for new enemies to: " + baseHealth);
  }

  // Spawn enemies based on the current interval
  if (frameCount % (int)spawnInterval == 0) {
    float x, y;

    // Randomly decide which edge to spawn the enemy from
    int spawnSide = (int) random(4); // 0: top, 1: bottom, 2: left, 3: right

    switch (spawnSide) {
    case 0: // Spawn from the top
      x = random(0, width);
      y = -20;
      break;
    case 1: // Spawn from the bottom
      x = random(0, width);
      y = height + 20;
      break;
    case 2: // Spawn from the left
      x = -20;
      y = random(0, height);
      break;
    case 3: // Spawn from the right
      x = width + 20;
      y = random(0, height);
      break;
    default:
      x = random(0, width);
      y = random(0, height);
    }

    // Create a new enemy with dynamically updated health
    Enemy newEnemy = new Enemy(x, y, damage, speed, baseHealth);
    enemies.add(newEnemy);

    // Debugging: Print the enemy's stats
    println("Enemy spawned: Health = " + newEnemy.health + ", Damage = " + newEnemy.damage + ", Speed = " + newEnemy.speed);
  }

  // Update all enemies
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();

    if (dist(e.position.x, e.position.y, player.position.x, player.position.y) < e.radius + player.radius) {
      playerHealth -= e.damage; // Deduct player's health based on enemy's damage
      enemies.remove(i);
      // Game over condition
      if (playerHealth <= 0) {
        gameOver = true;  // Set the game-over flag
        println("Game Over!");
      }
    }
  }
}




void checkCollisions() {
  // Temporary lists to handle removals
  ArrayList<Enemy> enemiesToRemove = new ArrayList<>();
  ArrayList<Bullet> bulletsToRemove = new ArrayList<>();

  // Check collisions between player and enemies
  for (Enemy e : enemies) {
    float distToPlayer = dist(player.position.x, player.position.y, e.position.x, e.position.y);
    if (distToPlayer < player.radius + e.radius) {
      playerHealth -= 10; // Deduct health if player collides with enemy
    }

    // Check collisions between bullets and enemies
    for (Bullet b : bullets) {
      float distToBullet = dist(b.position.x, b.position.y, e.position.x, e.position.y);


      if (distToBullet < b.radius + e.radius) {
        println("damage to enemy");
        e.health -= player.bulletDamage; // Apply bullet damage
        bulletsToRemove.add(b); // Mark bullet for removal
        println("Enemy health after damage: " + e.health);

        if (e.health <= 0) {
          println("Enemy removed. Player score: " + playerScore);
          enemiesToRemove.add(e); // Mark enemy for removal
          playerScore += 100; // Increase player score
          break; // Exit bullet loop once collision is handled
        }
      }
    }
  }

  // Remove marked bullets and enemies after iteration
  bullets.removeAll(bulletsToRemove);
  enemies.removeAll(enemiesToRemove);
  // Check if the player's health is zero
  if (playerHealth <= 0) {
    gameOver = true;  // Set the game-over flag
    println("Game Over!");
    endGame();  // Call endGame to save the high score
  }
}


void presentUpgrade() {
  upgrades[0] = new Upgrade(
    "Increase Damage",
    "Increases bullet damage by 5",
    () -> player.bulletDamage += 5
    );
  upgrades[1] = new Upgrade(
    "Faster Shooting",
    "Decreases attack cooldown by 50ms",
    () -> player.bulletCooldown = max(100, player.bulletCooldown - 50)
    );
  upgrades[2] = new Upgrade(
    "Spread Shot",
    "Adds 1 extra bullet per shot",
    () -> player.bulletSpread += 1
    );

  println("Upgrade options prepared: " + upgrades[0].name + ", " + upgrades[1].name + ", " + upgrades[2].name);
}


void displayUpgradeMenu() {
  background(0, 50, 100);
  textAlign(CENTER);
  textSize(24);
  fill(255);
  text("Choose an Upgrade", width / 2, height / 4);

  // Loop through each upgrade to display its button
  for (int i = 0; i < upgrades.length; i++) {
    float x = width / 2;
    float y = height / 2 + i * 60;

    // Combine name and description to calculate full text width
    String fullText = upgrades[i].name + ": " + upgrades[i].description;
    float fullTextWidth = textWidth(fullText);

    // Add padding around the text
    float buttonWidth = fullTextWidth + 40; // Padding for better spacing (20px on each side)
    float buttonHeight = 40;  // Fixed button height

    // Draw the button (rectangular background)
    fill(50, 50, 150);
    rect(x - buttonWidth / 2, y - buttonHeight / 2, buttonWidth, buttonHeight);

    // Center the text both horizontally and vertically
    fill(255);
    textAlign(CENTER, CENTER);  // Center both horizontally and vertically
    text(fullText, x, y); // Display the full text (name + description)
  }
}

void mousePressed() {
  if (upgradeMenu) {
    for (int i = 0; i < upgrades.length; i++) {
      float x = width / 2;
      float y = height / 2 + i * 60;
      if (mouseX > x - 150 && mouseX < x + 150 && mouseY > y - 20 && mouseY < y + 20) {
        upgrades[i].effect.run();  // Apply the selected upgrade effect
        upgradeMenu = false;       // Exit the upgrade menu
        println("Selected upgrade: " + upgrades[i].name);
        break;
      }
    }
  } else {
    // Fire bullets when the mouse is clicked (not during the upgrade menu)
    player.fireBullet();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    resetGame();  // Call the reset method when 'R' is pressed
  }
}

void resetGame() {
  lastUpgradeScore = 0;  // Track the last score at which upgrades were given
  frameCount = 0;
  playerMaxHealth = 100;

  spawnInterval = 120; // Starting interval for enemy spawn (in frames)
  minSpawnInterval = 20; // Minimum interval for spawning
  spawnDecayRate = 0.1; // Rate at which the interval decreases
  decayRate = 0.1; // Controls how fast the interval decreases

  lastIncreaseTime = 0; // Time in seconds
  baseHealth = 10;           // Starting health for enemies
  healthIncrementRate = 10;   // Health increase per interval
  updateInterval = 15; // Time interval (in seconds) for increasing health
  damIncrementRate = 1;   // Health increase per interval
  spdIncrementRate = 0.1;   // Speed increase per interval
  damage = 5; // Base damage for enemies
  speed = 1; // Base speed for enemies

  gameOver = false;  // Track whether the game is over

  initialSpawnInterval = 300;  // Initial spawn interval (in frames or seconds)
  initialSpawnDecayRate = 0.1; // Initial spawn decay rate (how much the spawn interval decreases over time)
  initialBulletDamage = 10;      // Default bullet damage
  initialAttackSpeed = 1.0;    // Default attack speed
  initialPlayerHealth = 100;     // Default player health
  initialScore = 0;              // Default score (could be 0 or any other starting value)

  playerScore = initialScore;
  playerHealth = initialPlayerHealth;

  spawnInterval = initialSpawnInterval;
  spawnDecayRate = initialSpawnDecayRate;
  baseHealth = 10;  // Reset base health for enemies
  damage = 5;       // Reset damage for enemies
  speed = 1;        // Reset speed for enemies

  // Reset upgrade system values
  upgradeThreshold = 200;  // Reset the upgrade threshold
  upgradeIncrement = 25;   // Reset the upgrade increment
  upgradeTriggered = false; // Ensure no upgrades are triggered prematurely

  // Reset enemy stats
  lastIncreaseTime = 0; // Reset the timer for enemy stat increase

  // Clear enemies and bullets
  enemies.clear();
  bullets.clear();

  // Reinitialize the player
  player = new Player();  // Ensures that the player object is fully reset

  // Reset game over state
  gameOver = false;

  // Reset the upgrade menu flag
  upgradeMenu = false;

  //// Restart the game loop
  //loop();  // Restart the game loop (if you are using a loop)
}
