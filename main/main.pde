HealthBar healthBar;
Player player;
//arrays to track the bullets and enemies
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
//score counter
int score = 0;
boolean gameOver = false;


void setup() {
  size(400, 400);

  //initialize the player and the healthbar
  healthBar = new HealthBar(20, 20, 140, 20, 100);
  //player in the center, reload time one second
  player = new Player(width / 2, height / 2, 30, 1000);

  //initialize the array for both bullets and enemies
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();

  //spawn the first enemy
  spawnEnemy();

  //reset gameOver state
  gameOver = false;
}


void draw() {
  //refresh the screen at the start of draw
  background(0);

  if (gameOver) {
    //display game over screen
    fill(255, 0, 0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Game Over", width / 2, height / 2);
    return; // exit the draw function
  }

  //display + update health bar
  healthBar.display();

  //display + update the player
  player.update();
  player.display();

  //update + display bullets
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    //check for enemy + bullet collision
    for (int j = enemies.size() - 1; j >= 0; j--) {
      Enemy e = enemies.get(j);
      //if bullet hits the enemy (remove the bullet)
      if (e.checkHit(b)) {
        bullets.remove(i);
        //if the enemy is dead (remove the enemy from the screen + add score)
        if (!e.isAlive()) {
          enemies.remove(j);
          score += 10;
        }
        //break the inner loop when hit is detected
        break;
      }
    }

    //remove bullets when they go offscreen
    if (b.isOffScreen()) {
      bullets.remove(i);
    }
  }

  //update and display the enemies
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    //update the enemies target/where its heading
    e.updatePlayerPos(player.x, player.y);
    //move enemy towards the player
    e.move();
    e.display();

    // check for collision with player
    if (e.collidesWith(player)) {
      enemies.remove(i);
      healthBar.decreaseHealth(10);
      if (healthBar.health == 0) {
        gameOver = true;
      }
    }
  }

  //spawn enemies offscreen every 2 seconds
  if (frameCount % 120 == 0) {
    spawnEnemy();
  }

  //draw score
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Score: " + score, 200, 350);

  rectMode(CORNERS);

  //draw the UI parts
  //draw the bullet reload bar
  fill(255);
  rect(180, 20, 380, 40);

  //draw the reload bar
  rect(20, 370, 380, 390);
}


//function spawning enemies off screen
void spawnEnemy() {
  enemies.add(new Enemy());
}

void keyPressed() {
  //temporary to check healthbar
  if (key == 'd' || key == 'D') {
    healthBar.decreaseHealth(10);
  }
  if (key == 'r' || key == 'R') {
    healthBar.resetHealth();
  }

  //to shoot the enemies
  if (key == ' ') {
    player.shoot();
  }
}
void mousePressed() {
  player.shoot();
}
