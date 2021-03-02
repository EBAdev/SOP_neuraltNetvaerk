pattern p;
NeuralNetwork NN;
int trainingSetSize = 10000;
boolean testing = false;
void setup() {
  size(1000, 600);
  p = new pattern();
  p.createPattern();
  NN = new NeuralNetwork(4, 4, 3);
  NN.setActivationFunction(ActivationFunction.SIGMOID);
}

void draw() {

  if (!testing) {
    frameRate(60);
    background(255); 
    p.showPattern();
    p.createPattern();
    p.getShape();
    p.constructTrainingData();
    NN.train(p.inputs, p.answers);
    text("The NN is currently training", 700, 50);
  } else {
    float totalError = 0;
    for (int j = 0; j <trainingSetSize/100; j++) {
      frameRate(20);
      background(255); 
      p.showPattern();
      p.createPattern();
      p.getShape();
      p.constructTrainingData();
      double[] networkGuess = NN.guess(p.inputs);
      text("The NN is currently testing", 700, 50);
      for (int k = 0; k < 3; k++) {
        totalError += (float)p.answers[k] - (float)networkGuess[k];

        println(totalError);
      }
    }
  }
}
void mouseReleased() {
  testing = !testing;
}
