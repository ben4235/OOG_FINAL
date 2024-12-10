class UpgradeFactory {
  Upgrade createRandomUpgrade(Player player) {
    int choice = int(random(3));
    if (choice == 0) {
      return new Upgrade("Faster Reload", "Shoot bullets faster", 
        () -> player.bulletCooldown = max(5, player.bulletCooldown - 5));
    } else if (choice == 1) {
      return new Upgrade("More Damage", "Increase bullet damage", 
        () -> player.bulletDamage++);
    } else {
      return new Upgrade("More Bullets", "Fire additional bullets", 
        () -> player.bulletCount++);
    }
  }
}
