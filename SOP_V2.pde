pattern p;
button b1;
button b2;
NeuralNetwork NN;
int trainingSetSize = 500;
int testingSetSize = 500;
boolean test = false;
boolean train = false;
void setup() {
  size(1000, 600);
  p = new pattern();  
  b1 = new button(new PVector(700, 200), 100, 50);
   b2 = new button(new PVector(700, 300), 100, 50);
  background();
  p.createPattern();
  p.showPattern();
  NN = new NeuralNetwork(4, 4, 3);
  NN.setActivationFunction(ActivationFunction.SIGMOID);
}

void draw() {
  background();
  p.showPattern();

  if (train && !test) {
    for (int i = 0; i < trainingSetSize; i++) {
      println(i);
      background(); 
      p.showPattern();
      p.createPattern();
      p.getShape();
      p.constructTrainingData();
      NN.train(p.inputs, p.answers);
    }
    train = false;
  } else if (!train && test) {
    float totalError = 0;
    for (int j = 0; j <trainingSetSize/100; j++) {
      frameRate(20);
      background(); 
      p.showPattern();
      p.createPattern();
      p.getShape();
      p.constructTrainingData();
      double[] networkGuess = NN.guess(p.inputs);

      for (int k = 0; k < 3; k++) {
        totalError += (float)p.answers[k] - (float)networkGuess[k];

        println(totalError);
      }
    }
    test = false;
  } else {
  }
}

void background() {
  background(255); 

  b1.show();
      b2.show();
  if (mousePressed && b1.mouseIsOnButton() && !test) {
    train  = true;
  }else if(mousePressed && b2.mouseIsOnButton() && !train) {
    test  = true;
  }
}
