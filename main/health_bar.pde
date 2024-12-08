class HealthBar {
  //position and size
  float x, y, barWidth, barHeight; 
  //current + maxhealth
  int health, maxHealth;

  //healthbar constructor
  HealthBar(float x, float y, float barWidth, float barHeight, int maxHealth) {
    this.x = x;
    this.y = y;
    this.barWidth = barWidth;
    this.barHeight = barHeight;
    this.maxHealth = maxHealth;
    //initialize health to max
    this.health = maxHealth;
  }

  //display healthbar
  void display() {
    //draw the background of the health bar
    fill(200);
    rect(x, y, x + barWidth, y + barHeight);

    //calculate width of the health bar
    float healthWidth = map(health, 0, maxHealth, 0, barWidth);

    //draw the health bar
    fill(255, 0, 0);
    rect(x, y, x + healthWidth, y + barHeight);

    //draw health text
    fill(255);
    textAlign(BASELINE);
    textSize(20);
    text("Health: " + health, x, y + barHeight + 20);
  }

  //decrease health
  void decreaseHealth(int amount) {
    health -= amount;
    //make sure health does not go below 0, need to change later to be loss state
    if (health < 0) health = 0;
  }

  //reset the health to the max
  void resetHealth() {
    health = maxHealth;
  }
}
