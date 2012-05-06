import java.text.DecimalFormat;
import java.text.NumberFormat;

//import org.junit.Test;

public class Perceptron {
	
	int[][] patterns = { 
	    { 0, 0, 0, 0 }, 
	    { 0, 0, 0, 1 }, 
	    { 0, 0, 1, 0 },
	    { 0, 0, 1, 1 }, 
	    { 0, 1, 0, 0 }, 
	    { 0, 1, 0, 1 }, 
	    { 0, 1, 1, 0 },
	    { 0, 1, 1, 1 }, 
	    { 1, 0, 0, 0 }, 
	    { 1, 0, 0, 1 } };

	
	int[][] teachingOutput = { 
	    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, 
	    { 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
	    { 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 }, 
	    { 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
	    { 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 }, 
	    { 1, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	    { 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 }, 
	    { 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 } };

	

	int numberOfInputNeurons = patterns[0].length;
	int numberOfOutputNeurons = teachingOutput[0].length;
	int numberOfPatterns = patterns.length;
	double[][] weights;

	public Perceptron() {
	    weights = new double[numberOfInputNeurons][numberOfOutputNeurons];
	}

	public void deltaRule() {
		boolean allCorrect = false;
		boolean error = false;
		double learningFactor = 0.2;
		while (!allCorrect) {
			error = false;
			for (int i = 0; i < numberOfPatterns; i++) {
				
				int[] output = setOutputValues(i);
				for (int j = 0; j < numberOfOutputNeurons; j++) {
				    if (teachingOutput[i][j] != output[j]) {
				        for (int k = 0; k < numberOfInputNeurons; k++) {
				            weights[k][j] = weights[k][j] + learningFactor
				                    * patterns[i][k]
				                    * (teachingOutput[i][j] - output[j]);
				        }
				    }
				}
				for (int z = 0; z < output.length; z++) {
				    if (output[z] != teachingOutput[i][z])
				        error = true;
				}

			 }
			if (!error) {
				allCorrect = true;
			}
		}
	}
	
	int[] setOutputValues(int patternNo) {
		double bias = 0.7;
		int[] result = new int[numberOfOutputNeurons];
		int[] toImpress = patterns[patternNo];
		for (int i = 0; i < toImpress.length; i++) {
			
			for (int j = 0; j < result.length; j++) {
			    double net = weights[0][j] * toImpress[0] + weights[1][j]
			            * toImpress[1] + weights[2][j] * toImpress[2]
			            + weights[3][j] * toImpress[3];
			    if (net > bias)
			        result[j] = 1;
			    else
			        result[j] = 0;
			}

		}
		return result;
	}
	
	public void printMatrix(double[][] matrix) {
		
		for (int i = 0; i < matrix.length; i++) {
		    for (int j = 0; j < matrix[i].length; j++) {
		        NumberFormat f = NumberFormat.getInstance();
		        if (f instanceof DecimalFormat) {
		            DecimalFormat decimalFormat = ((DecimalFormat) f);
		            decimalFormat.setMaximumFractionDigits(1);
		            decimalFormat.setMinimumFractionDigits(1);
		            System.out.print("(" + f.format(matrix[i][j]) + ")");
		        }
		    }
		    System.out.println();
		}

	}
	

   public static void main(String[] args) {
		
		Perceptron p = new Perceptron();
		System.out.println("Weights before training: ");
		p.printMatrix(p.weights);
		p.deltaRule();
		System.out.println("Weights after training: ");
		p.printMatrix(p.weights);

	}
}

