class button {
  PVector pos;
  int Height;
  int Width;
  String buttonText;
  String subHeading;
  button(PVector p, int w, int h, String s, String l) {
    buttonText = s;
    Width = w;
    Height = h;
    pos = p;
    subHeading = l;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(buttonUpdate());
    rect(0, 0, Width, Height);
    fill(255);
    textAlign(CENTER);
    textSize(15);
    text(buttonText, Width/2, Height/2+5);
    textSize(13);
    text(subHeading, Width/2, Height/2+25);
    textSize(15);
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
