pattern p;
NeuralNetwork NN;

// Network Settings
int hiddenLayers = 1;
int neuronsInHiddenLayers = 8;

int trainingSetSize = 500;
int testingSetSize = 100;
float LearningRate = 0.5;

int correctAnswers = 0;
int trainedTimes = 0;

boolean test = false;
boolean train = false;


void setup() {
  size(1000, 600);
  p = new pattern();  
  p.createPattern();

  UI_Setup();

  NN = new NeuralNetwork(4, hiddenLayers, neuronsInHiddenLayers, 3);
  NN.setActivationFunction(ActivationFunction.SIGMOID);
  NN.setLearningRate(LearningRate);
}

void draw() {
  background();
  active = false;
  if (train && !test) {
    for (int i = 0; i < trainingSetSize; i++) { // train for one Epoch
      p.createPattern();
      p.constructTrainingData();
      NN.train(p.inputs, p.answers);
      trainedTimes++;
    }
    train = false;
    //test = true;

  } else if (!train && test) { // Test the networks by samples
    correctAnswers = 0;
    float cost = 0;

    for (int j = 0; j < testingSetSize; j++) {
      p.createPattern();
      p.constructTrainingData();

      double[] temp = NN.guess(p.inputs);  // funktion til at hente outputs
      float [] networkGuess = convertDoubleToFloat(temp); 
      int index = indexOfArray(networkGuess, max(networkGuess)); 
      if (p.shape == index+1) {
        correctAnswers++; // check if the answer is correct
      }

      for (int k = 0; k < 3; k++) {
        cost += pow(((float)p.answers[k] - networkGuess[k]), 2); // calculate the accumilated sum for the cost function
      }

      Cost = str(cost); // add this to the UI
    }
    //////print(trainedTimes);print(";");
    //print(cost/10);//print(";");
    //////print(correctAnswers);
    //println();
    test = false;
    //train = true;
    //if (trainedTimes == 10000){
    // exit(); 
    //}

  } else {
    showActiveNetwork(); // function to show a networks guess on the pattern on screen while waiting for user input
  }
}
