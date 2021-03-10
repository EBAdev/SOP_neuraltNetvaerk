import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.ejml.*; 
import org.ejml.interfaces.decomposition.*; 
import org.ejml.interfaces.linsol.*; 
import org.ejml.ops.*; 
import org.ejml.data.*; 
import org.ejml.dense.fixed.*; 
import org.ejml.dense.row.*; 
import org.ejml.dense.row.decomposition.*; 
import org.ejml.dense.row.decomposition.qr.*; 
import org.ejml.dense.row.decomposition.hessenberg.*; 
import org.ejml.dense.row.decomposition.chol.*; 
import org.ejml.dense.row.decomposition.svd.*; 
import org.ejml.dense.row.decomposition.svd.implicitqr.*; 
import org.ejml.dense.row.decomposition.eig.*; 
import org.ejml.dense.row.decomposition.eig.symm.*; 
import org.ejml.dense.row.decomposition.eig.watched.*; 
import org.ejml.dense.row.decomposition.lu.*; 
import org.ejml.dense.row.decomposition.bidiagonal.*; 
import org.ejml.dense.row.misc.*; 
import org.ejml.dense.row.linsol.qr.*; 
import org.ejml.dense.row.linsol.*; 
import org.ejml.dense.row.linsol.chol.*; 
import org.ejml.dense.row.linsol.svd.*; 
import org.ejml.dense.row.linsol.lu.*; 
import org.ejml.dense.row.mult.*; 
import org.ejml.dense.row.factory.*; 
import org.ejml.dense.block.decomposition.qr.*; 
import org.ejml.dense.block.decomposition.hessenberg.*; 
import org.ejml.dense.block.decomposition.chol.*; 
import org.ejml.dense.block.decomposition.bidiagonal.*; 
import org.ejml.dense.block.*; 
import org.ejml.dense.block.linsol.qr.*; 
import org.ejml.dense.block.linsol.chol.*; 
import org.ejml.generic.*; 
import org.ejml.dense.row.decompose.*; 
import org.ejml.dense.row.decompose.qr.*; 
import org.ejml.dense.row.decompose.hessenberg.*; 
import org.ejml.dense.row.decompose.chol.*; 
import org.ejml.dense.row.decompose.lu.*; 
import org.ejml.sparse.*; 
import org.ejml.sparse.csc.*; 
import org.ejml.sparse.csc.decomposition.qr.*; 
import org.ejml.sparse.csc.decomposition.chol.*; 
import org.ejml.sparse.csc.decomposition.lu.*; 
import org.ejml.sparse.csc.misc.*; 
import org.ejml.sparse.csc.linsol.qr.*; 
import org.ejml.sparse.csc.linsol.chol.*; 
import org.ejml.sparse.csc.linsol.lu.*; 
import org.ejml.sparse.csc.mult.*; 
import org.ejml.sparse.csc.factory.*; 
import org.ejml.sparse.triplet.*; 
import org.ejml.equation.*; 
import org.ejml.simple.*; 
import org.ejml.simple.ops.*; 
import com.google.gson.*; 
import com.google.gson.util.*; 
import com.google.gson.stream.*; 
import com.google.gson.reflect.*; 
import com.google.gson.internal.*; 
import com.google.gson.internal.reflect.*; 
import com.google.gson.internal.bind.*; 
import com.google.gson.internal.bind.util.*; 
import com.google.gson.annotations.*; 
import basicneuralnetwork.*; 
import basicneuralnetwork.activationfunctions.*; 
import basicneuralnetwork.utilities.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SOP_V2 extends PApplet {

pattern p;
NeuralNetwork NN;

// Network Settings
int hiddenLayers = 1;
int neuronsInHiddenLayers = 8;

int trainingSetSize = 500;
int testingSetSize = 100;
float LearningRate = 0.5f;

int correctAnswers = 0;
int trainedTimes = 0;

boolean test = false;
boolean train = false;


public void setup() {
  
  p = new pattern();  
  p.createPattern();

  UI_Setup();

  NN = new NeuralNetwork(4, hiddenLayers, neuronsInHiddenLayers, 3);
  NN.setActivationFunction(ActivationFunction.SIGMOID);
  NN.setLearningRate(LearningRate);
}

public void draw() {
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

// functions to process the  matrixes delivered by the Matrix Library
public double[][] changeMatrixToArray(SimpleMatrix i) {
  double[][] array = new double[i.numRows()][i.numCols()];
  for (int j = 0; j < array.length; j++) {
    for (int k = 0; k < array[0].length; k++) {
      array[j][k] = i.get(j, k);
    }
  }
  return array;
}

public int indexOfArray(float[] list, float numberToIndex) {
  int index = 0;
  for (int i=0; i < list.length; i++) { 
    if (list[i] == numberToIndex ) {  
      index = i;
    }
  }
  return index;
}

public float[] convertDoubleToFloat(double[] list ) {
  float[] toReturn = new float[list.length];
  for (int i = 0; i < list.length; i++)
  {
    toReturn[i] = (float) list[i];
  }

  return toReturn;
}


////THE FOLLOWING CODE IS CODE I TOOK FROM A LIBRARY THAT WAS LABLED AS PRIVATE VARIABLES AND MADE THEM ACSSIBLE FOR MY PROGRAM.
public double getActivation(double[] inputArray, int layer, int neuron, SimpleMatrix[] W, SimpleMatrix[] B) {
  if (inputArray.length != p.inputs.length) {
    throw new WrongDimensionException(inputArray.length, p.inputs.length, "Input");
  } else {
    // Get ActivationFunction-object from the map by key
    ActivationFunction activationFunction = new SigmoidActivationFunction();

    // Transform array to matrix

    SimpleMatrix output = MatrixUtilities.arrayToMatrix(inputArray);

    SimpleMatrix layers[] = new SimpleMatrix[layer + 1];
    layers[0] = output;

    for (int j = 1; j < layer+1; j++) {

      layers[j] = calculateLayer(W[j - 1], B[j - 1], output, activationFunction);
      output = layers[j];
    }

    //output = calculateLayer(W[layer], B[layer], output, activationFunction);
    double [] outArray = MatrixUtilities.getColumnFromMatrixAsArray(output, 0);

    return outArray[neuron];
  }
}

public SimpleMatrix calculateLayer(SimpleMatrix weights, SimpleMatrix bias, SimpleMatrix input, ActivationFunction activationFunction) {
  // Calculate outputs of layer
  SimpleMatrix result = weights.mult(input);
  // Add bias to outputs
  result = result.plus(bias);
  // Apply activation function and return result
  return applyActivationFunction(result, false, activationFunction);
}

public SimpleMatrix applyActivationFunction(SimpleMatrix input, boolean derivative, ActivationFunction activationFunction) {
  // Applies either derivative of activation function or regular activation function to a matrix and returns the result
  return derivative ? activationFunction.applyDerivativeOfActivationFunctionToMatrix(input)
    : activationFunction.applyActivationFunctionToMatrix(input);
}
//for background
String Cost = "unkown"; 
button b1;
button b2;

//for active network showing
boolean active = false;
boolean isCorrect = false;
double[] in;
float[] guess;

public void showActiveNetwork() {

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

public void UI_Setup() {
  b1 = new button(new PVector(700, 10), 200, 75, "Hold to train the network", trainingSetSize+" samples");
  b2 = new button(new PVector(700, 110), 200, 75, "Press to test the network", testingSetSize+" samples");
}

public void background() {
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
  fill(255);
  textSize(12);
  text("Learning rate "+LearningRate, 800, 30);
  fill(0);
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
public void showNueralNetwork(int x, int y, int Width, int Height) {

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

  public void show() {
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

  public int buttonUpdate() { // #038BFF passive // #4DADFF hover // #95CEFF active
    if (mouseIsOnButton()) {
      if (mousePressed) {
        return  color(0xff95CEFF);
      } else {
        return color(0xff4DADFF);
      }
    } else {
      return color(0xff038BFF);
    }
  }

  public boolean mouseIsOnButton() {
    if (mouseX >= pos.x && mouseX <= pos.x+Width && mouseY >= pos.y && mouseY <=pos.y+Height) {
      return true;
    } else {
      return false;
    }
  }
}
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


  public void createPattern() {
    pattern.clear();
    for (int i = 0; i < matrixSize*matrixSize; i++) {
      int roll = floor(random(0, 2));
      pattern.append(roll);
    }
  }
  public void showPattern() {
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
  public void getShape() {
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

  public void constructTrainingData() {
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
  public void settings() {  size(1000, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SOP_V2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
