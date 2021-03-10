
// functions to process the  matrixes delivered by the Matrix Library
double[][] changeMatrixToArray(SimpleMatrix i) {
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

SimpleMatrix calculateLayer(SimpleMatrix weights, SimpleMatrix bias, SimpleMatrix input, ActivationFunction activationFunction) {
  // Calculate outputs of layer
  SimpleMatrix result = weights.mult(input);
  // Add bias to outputs
  result = result.plus(bias);
  // Apply activation function and return result
  return applyActivationFunction(result, false, activationFunction);
}

SimpleMatrix applyActivationFunction(SimpleMatrix input, boolean derivative, ActivationFunction activationFunction) {
  // Applies either derivative of activation function or regular activation function to a matrix and returns the result
  return derivative ? activationFunction.applyDerivativeOfActivationFunctionToMatrix(input)
    : activationFunction.applyActivationFunctionToMatrix(input);
}
