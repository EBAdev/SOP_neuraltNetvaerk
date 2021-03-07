class button {
  PVector pos;
  int Height;
  int Width;
  String buttonText;
  button(PVector p, int w, int h, String s) {
    buttonText = s;
    Width = w;
    Height = h;
    pos = p;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(buttonUpdate());
    rect(0, 0, Width, Height);
    fill(255);
    textAlign(CENTER);
    textSize(16);
    text(buttonText,Width/2,Height/2+5);
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
