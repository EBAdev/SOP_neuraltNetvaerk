pattern p;
button b1;
button b2;
NeuralNetwork NN;

int trainingSetSize = 10000;
int testingSetSize = 100;
int correctAnswers = 0;

boolean test = false;
boolean train = false;

String Cost = "unkown"; 
void setup() {
  size(1000, 600);
  p = new pattern();  
  p.createPattern();
  p.showPattern();

  b1 = new button(new PVector(700, 10), 200, 75, "Train the network");
  b2 = new button(new PVector(700, 110), 200, 75, "Test the network");

  NN = new NeuralNetwork(4, 8, 3);
  NN.setActivationFunction(ActivationFunction.SIGMOID);

  background();
}

void draw() {
  background();
  p.showPattern();

  if (train && !test) {
    for (int i = 0; i < trainingSetSize; i++) {
      background(); 
      p.showPattern();
      p.createPattern();
      p.getShape();
      p.constructTrainingData();
      NN.train(p.inputs, p.answers);
    }
    train = false;
  } else if (!train && test) {
    correctAnswers = 0;
    float cost = 0;
    for (int j = 0; j < testingSetSize; j++) {
      background(); 
      p.showPattern();
      p.createPattern();
      p.getShape();

      p.constructTrainingData();
      double[] temp = NN.guess(p.inputs);
      float [] networkGuess = convertDoubleToFloat(temp);
      int index = indexOfArray(networkGuess, max(networkGuess));
     
      if (p.shape == index+1) {
        correctAnswers++;
      } else {
        println(" a :", (float)p.answers[0], " g: ", (float)networkGuess[0]);
        println(" a :", (float)p.answers[1], " g: ", (float)networkGuess[1]);
        println(" a :", (float)p.answers[2], " g: ", (float)networkGuess[2]);
        println(" ");
      }
      
      for (int k = 0; k < 3; k++) {
        cost += pow(((float)p.answers[k] - networkGuess[k]), 2);
      }

      Cost = str(cost);
    }
    test = false;
  } else {
  }
}



void background() {
  background(255); 
  b1.show();
  b2.show();
  showNueralNetwork(500, 350, 550, 200);
  fill(0);
  textAlign(LEFT);
  text("Line", 930, 407);
  text("Stair", 930, 457);
  text("Square", 930, 507);
  textAlign(CENTER);
  text("The current cost function is: ", 800, 225);
  text(Cost, 800, 250);
  text("During testing it got: ", 800, 290);
  text(correctAnswers + " of 100 correct", 800, 310);

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

  SimpleMatrix[] temp = NN.getWeights(); // get the weights

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
          SimpleMatrix layerWeightMatrix = temp[j];
          double[][] layerWeights = convertMatrixToArray(layerWeightMatrix); // the weights between layer j and j+1
          float weight = (float)layerWeights[l][k];
          if (weight < 0) {
            stroke(200, 0, 0);
            strokeWeight(-1 * weight);
          } else {
            stroke(0, 200, 0);
            strokeWeight(weight);
          }
          //println(weight);

          line(Nx, Ny, N2x, N2y);
          stroke(0);
          strokeWeight(1);
        }
      }
      fill(0);
      ellipse(Nx, Ny, 20, 20);
    }
  }


  popMatrix();
}

double[][] convertMatrixToArray(SimpleMatrix i) {
  double[][] array = new double[i.numRows()][i.numCols()];
  for (int j = 0; j < array.length; j++) {
    for (int k = 0; k < array[0].length; k++) {
      array[j][k] = i.get(j, k);
    }
  }
  return array;
}

int indexOfArray(float[] list, float numberToIndex) {
  int index = 0;
  for (int i=0; i < list.length; i++) { 
    if (list[i] == numberToIndex ) {  
      index = i;
    }
  }
  return index;
}

float[] convertDoubleToFloat(double[] list ) {
  float[] toReturn = new float[list.length];
  for (int i = 0; i < list.length; i++)
  {
    toReturn[i] = (float) list[i];
  }

  return toReturn;
}
