public class Enemy {

    int maxHealth;  // Maximum health
    int health;     // Current health
    int damage;     // Damage the enemy deals
    float speed;    // Enemy movement speed

    PVector position;
    PVector velocity;
    float radius = 10;

    // Constructor
    Enemy(float x, float y, int damage, float speed, int maxHealth) {
        this.position = new PVector(x, y);
        this.velocity = new PVector(player.position.x - x, player.position.y - y).normalize().mult(speed);
        this.damage = damage;
        this.speed = speed;
        this.maxHealth = maxHealth;
        this.health = maxHealth;
    }

    // Update position
    void update() {
        position.add(velocity);
    }

    // Display the enemy and its health bar
    void display() {
        fill(0, 255, 0);
        ellipse(position.x, position.y, radius * 2, radius * 2);
        displayHealthBar();
    }

    void displayHealthBar() {
        float barWidth = map(health, 0, maxHealth, 0, radius * 2);
        fill(255, 0, 0);
        rect(position.x - radius, position.y - radius - 10, barWidth, 5);
        noFill();
        stroke(255);
        rect(position.x - radius, position.y - radius - 10, radius * 2, 5); // Outline
    }
}
