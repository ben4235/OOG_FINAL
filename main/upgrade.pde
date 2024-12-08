class Upgrade {
  String type;
  float amount;

  Upgrade(String type, float amount) {
    this.type = type;
    this.amount = amount;
  }

  void apply(Player player) {
    if (type.equals("Attack Speed")) {
      player.reloadTime -= amount;
      if (player.reloadTime < 100) player.reloadTime = 100; // Minimum reload time
    } else if (type.equals("Damage")) {
      player.bulletDamage += amount;
    } else if (type.equals("Bullets Shot")) {
      player.bulletsShot += amount;
    }
  }
}
