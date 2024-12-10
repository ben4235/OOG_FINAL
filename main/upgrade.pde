class Upgrade {
  String name;
  String type;   // Type of upgrade (e.g., BulletDamage, ReloadSpeed, etc.)
  float value;   // Change the type to float

  // Constructor to initialize name and value
  Upgrade(String name, float value) {
    this.name = name;
    this.value = value;   // No need for conversion now since both are float
    this.type = name;     // You can directly set the type from the name
  }
}
