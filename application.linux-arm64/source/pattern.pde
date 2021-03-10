class pattern {
  int matrixSize = 2; //3x3
  int fieldSize = floor(600/matrixSize);
  FloatList pattern = new FloatList(); 
  int inputSize = matrixSize;
  IntList ins = new IntList();
  double [] inputs;
  IntList ans = new IntList();
  double [] answers;
  // this IntList also works as networkinputs


  void createPattern() {
    pattern.clear();
    for (int i = 0; i < matrixSize*matrixSize; i++) {
      int roll = floor(random(0, 2));
      pattern.append(roll);
    }
  }
  void showPattern() {
    int fieldNum = 0;

    //horisontal bevægelse
    for (int i = 0; i < matrixSize; i++) {
      //vertikal bevægelse
      for (int j = 0; j < matrixSize; j++) {
        stroke(0);
        if (pattern.get(fieldNum) == 1) {
          fill(0);
        } else if (pattern.get(fieldNum) == 0) {
          fill(255);
        }
        rectMode(CORNERS);
        rect(fieldSize*i, fieldSize*j, fieldSize+fieldSize*i, fieldSize+fieldSize*j);
        fieldNum++;
      }
    }
  }

  int shape = 0;
  void getShape() {
    int sum = 0;
    for (int i = 0; i < pattern.size(); i++) {
      sum += pattern.get(i);
      //ins.append(int(pattern.get(i)));
    }
    if (sum == 2) {
      shape = 1;
    } else if (sum == 3) {
      shape  = 2;
    } else {
      shape  = 3;
    }
    //ans.append(shape);
  }

  void constructTrainingData() {
    getShape();
    inputs = new double[4];
    answers = new double [3];

    for (int i = 0; i < pattern.size(); i++) {
      inputs[i] = pattern.get(i);
    }
    for (int j = 0; j < 3; j++) {
      if ( j == shape-1) {
        answers[j] = 1;
      } else {
        answers[j] = 0;
      }
    }
  }
}
