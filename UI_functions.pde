//for background
String Cost = "unkown"; 
button b1;
button b2;

//for active network showing
boolean active = false;
boolean isCorrect = false;
double[] in;
float[] guess;

void showActiveNetwork() {

  boolean correct = false;
  p.constructTrainingData();

  double[] temp = NN.guess(p.inputs);
  float [] networkGuess = convertDoubleToFloat(temp);
  int index = indexOfArray(networkGuess, max(networkGuess));
  if (p.shape == index+1) {
    correct = true;
  }
  isCorrect = correct;
  in = p.inputs;
  guess = networkGuess;
  active = true;
}

void UI_Setup() {
  b1 = new button(new PVector(700, 10), 200, 75, "Hold to train the network", trainingSetSize+" samples");
  b2 = new button(new PVector(700, 110), 200, 75, "Press to test the network", testingSetSize+" samples");
}

void background() {
  background(255); 
  p.showPattern();
  b1.show();
  b2.show();
  showNueralNetwork(500, 350, 550, 200);
  fill(0);
  textSize(15);
  textAlign(LEFT);
  text("Line", 930, 407);
  text("Stair", 930, 457);
  text("Square", 930, 507);
  textAlign(CENTER); 
  text("The network has seen: ", 800, 210);
  text(trainedTimes + " training samples", 800, 235);
  text("The accumilated cost for the latest test was: ", 800, 270);
  text(Cost, 800, 290);
  text("During testing it guessed: ", 800, 325);
  text(correctAnswers + " of 100 correct", 800, 350);
  textSize(12);
  text("The network above is showing the current guess on the pattern", 800, 575);

  //buttonFunctionality
  if (mousePressed && b1.mouseIsOnButton() && !test) {
    train  = true;
  } else if (mousePressed && b2.mouseIsOnButton() && !train) {
    test  = true;
  }
}
void showNueralNetwork(int x, int y, int Width, int Height) {

  int []dimensions =  NN.getDimensions();
  IntList NueralNetworkNeurons = new IntList(); // List of neurons 

  NueralNetworkNeurons.append(dimensions[0]); // add inputneurons
  int hiddenLayers = dimensions[1];
  for (int i = 0; i < hiddenLayers; i++) {
    NueralNetworkNeurons.append( dimensions[2]); // add the hiddenlayers
  }
  NueralNetworkNeurons.append(dimensions[3]); // add outputNeurons

  SimpleMatrix[] weightMatrix = NN.getWeights(); // get the weights
  SimpleMatrix[] biasMatrix = NN.getBiases(); // get the weights
  pushMatrix();
  translate(x, y);

  for (int j = 0; j < NueralNetworkNeurons.size(); j++) { // for each layer

    int numNeurons = NueralNetworkNeurons.get(j);
    for (int k = 0; k < numNeurons; k++) {
      ellipseMode(CENTER);
      float Ny = map((30+30*k), 0, (30+30*numNeurons), 0, Height);
      float Nx = map((30+30*j), 0, (30+30*NueralNetworkNeurons.size()), 0, Width);

      if (j != NueralNetworkNeurons.size()-1) {
        int num2Neurons = NueralNetworkNeurons.get(j+1);
        for (int l = 0; l < num2Neurons; l++) {
          float N2y = map((30+30*(l)), 0, (30+30*num2Neurons), 0, Height);
          float N2x = map((30+30*(j+1)), 0, (30+30*NueralNetworkNeurons.size()), 0, Width);
          SimpleMatrix layerWeightMatrix = weightMatrix[j];
          double[][] layerWeights = changeMatrixToArray(layerWeightMatrix); // the weights between layer j and j+1
          float weight = (float)layerWeights[l][k];
          if (weight < 0) {
            stroke(200, 0, 0);
            strokeWeight(-1 * weight);
          } else {
            stroke(0, 200, 0);
            strokeWeight(weight);
          }


          line(Nx, Ny, N2x, N2y);
          stroke(0);
          strokeWeight(1);
        }
      }
      if (!active) {
        fill(0);
      } else {
        fill(0);
        if (j == 0 && k < 4) {
          float value = (float)in[k];
          if (value == 0) {
            fill(255);
          } else {
            fill(0);
          }
        } else {

          double[] Inputs = new double[]{in[0], in[1], in[2], in[3]};
          int mappedActivationFills = floor(map((float)getActivation(Inputs, j, k, weightMatrix, biasMatrix), 0, 1, 0, 510));
          //println(mappedActivationFills);
          if (mappedActivationFills > 255) {
            fill(0, mappedActivationFills/2, 0);
          } else {
            fill(255-mappedActivationFills, 0, 0);
          }
        }
      }
      ellipse(Nx, Ny, 20, 20);
    }
  }
  popMatrix();
}
