class Upgrade {
  String name;
  String description;
  Runnable effect;

  Upgrade(String name, String description, Runnable effect) {
    this.name = name;
    this.description = description;
    this.effect = effect;
  }

  void display(float x, float y) {
    fill(255);
    rect(x - 150, y - 20, 300, 40, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    text(name, x, y);
  }

  boolean isHovered(float mx, float my, float x, float y) {
    return mx > x - 150 && mx < x + 150 && my > y - 20 && my < y + 20;
  }
}
