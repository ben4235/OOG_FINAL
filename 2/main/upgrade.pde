class Upgrade {
  String name;
  float value;  // The value that represents how much the upgrade affects the game (e.g., 50ms reduction)
  String description;
  Runnable effect;

  Upgrade(String name, String description, Runnable effect) {
    this.name = name;
    this.description = description;
    this.effect = effect;
    this.value = value;
  }

  void display(float x, float y) {
    fill(255);
    textAlign(CENTER);
    text(name + ": " + description, x, y);
  }

  boolean isHovered(float mx, float my, float x, float y) {
    return mx > x - 100 && mx < x + 100 && my > y - 10 && my < y + 10;
  }

  void apply(Player p) {
    effect.run();
  }
  void applyUpgrade(Player player) {
    if (name.equals("bulletCooldown")) {
      // Apply the cooldown upgrade, ensuring it doesn't go below a minimum threshold
      player.bulletCooldown = max(100, player.bulletCooldown - value);
    }
    else if (name.equals("bulletDamage")) {
      // Apply bullet damage upgrade
      player.bulletDamage += value;
    }
    else if (name.equals("bulletSpread")) {
      // Apply bullet spread upgrade
      // Assuming you have a bullet spread logic to implement here
    }
  }
  // Non-static factory method
  Upgrade createRandomUpgrade(Player player) {
    int choice = int(random(3));
    if (choice == 0) {
      return new Upgrade("Faster Reload", "Shoot bullets faster",
        player.bulletCooldown = max(5, player.bulletCooldown - 5));
    }
    if (choice == 1) {
      return new Upgrade("More Damage", "Increase bullet damage",
        player.bulletDamage++);
    }
    return new Upgrade("More Bullets", "Fire additional bullets",
      player.bulletCount++);
  }
}
