Player player;

void setup() {
  size(400, 400);
  background(0);
  player = new Player(width / 2, height / 2, 30, 1000);
}
void draw() {
  player.display();
}
