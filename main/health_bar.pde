class HealthBar {
  int x, y, width, height, maxHealth;
  int currentHealth;

  // Constructor with parameters
  HealthBar(int x, int y, int width, int height, int maxHealth) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.maxHealth = maxHealth;
    this.currentHealth = maxHealth;  // Start with full health
  }

  // Method to display the health bar
  void display() {
    // Draw the background of the health bar
    fill(150);
    rect(x, y, width, height);

    // Draw the health portion of the bar
    fill(255, 0, 0); // Red color
    float healthWidth = map(currentHealth, 0, maxHealth, 0, width);
    rect(x, y, healthWidth, height);
  }

  // Method to update the health value
  void setHealth(int health) {
    this.currentHealth = health;
  }

  // Method to reduce health
  void reduceHealth(int amount) {
    this.currentHealth = max(0, this.currentHealth - amount);
  }

  // Method to increase health
  void increaseHealth(int amount) {
    this.currentHealth = min(this.maxHealth, this.currentHealth + amount);
  }
}
