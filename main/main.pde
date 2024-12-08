ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
Player player;

void setup() {
  size(400, 400);

  //player in the center, reload time one second
  player = new Player(width / 2, height / 2, 30, 1000);

  //initialize the array for both bullets and enemies
  bullets = new ArrayList<Bullet>();
    enemies = new ArrayList<Enemy>();

  //spawn the first enemy
  spawnEnemy();

}
void draw() {
  //refresh the screen at the start of draw
  background(0);

  //display + update the player
  player.update();
  player.display();

  //update + display bullets
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();


    //remove bullets when they go offscreen
    if (b.isOffScreen()) {
      bullets.remove(i);
    }
  }
}



void keyPressed() {
  //to shoot the enemies
  if (key == ' ') {
    player.shoot();
  }
}

void mousePressed() {
  player.shoot();
}
