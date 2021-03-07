class button {
  PVector pos;
  int Height;
  int Width;
  button(PVector p, int w, int h) {
    Width = w;
    Height = h;
    pos = p;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(buttonUpdate());
    rect(0, 0, Width, Height);
    popMatrix();
  }

  color buttonUpdate() { // #038BFF passive // #4DADFF hover // #95CEFF active
    if (mouseIsOnButton()) {
      if (mousePressed) {
        return  color(#95CEFF);
      } else {
        return color(#4DADFF);
      }
    } else {
      return color(#038BFF);
    }
  }

  boolean mouseIsOnButton() {
    if (mouseX >= pos.x && mouseX <= pos.x+Width && mouseY >= pos.y && mouseY <=pos.y+Height) {
      return true;
    } else {
      return false;
    }
  }
}
