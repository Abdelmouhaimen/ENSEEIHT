

import java.lang.Double;

/**
 * The DepthBuffer class implements a DepthBuffer and its pass test.
 */ 
public class DepthBuffer {
    private double[] buffer;
    int width;
    int height;

    /**
     * Constructs a DepthBuffer of size width x height.
     * The buffer is initially cleared.
     */
    public DepthBuffer (int width, int height) {
        buffer = new double[width * height];
        this.width = width;
        this.height = height;
        clear ();
    }

    /**
     * Clears the buffer to infinite depth for all fragments.
     */
    public void clear () {
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                buffer[i * width + j] = Double.POSITIVE_INFINITY;
            }
        }

    }

    /**
     * Test if a fragment passes the DepthBuffer test, i.e. is the fragment the
     * closest at its position.
     */
    public boolean testFragment (Fragment fragment) {
        if ((fragment.getX () >= 0) && (fragment.getX () < width) && (fragment.getY () >= 0) && (fragment.getY () < height)) {

            int index = fragment.getY() * width + fragment.getX();
            double fragmentDepth = fragment.getAttribute(0);
            if (fragmentDepth < buffer[index]) {
                return true; // Le fragment est plus proche que ce qui est déjà enregistré
            } else {
                return false; // Le fragment est plus éloigné, ne doit pas être affiché
            }
        } else {
            return false;
        }
    }

    /**
     * Writes the fragment depth to the buffer 
     */
    public void writeFragment (Fragment fragment) {
        if ((fragment.getX () >= 0) && (fragment.getX () < width) && (fragment.getY () >= 0) && (fragment.getY () < height)) {

            int index = fragment.getY() * width + fragment.getX();
            double fragmentDepth = fragment.getAttribute(0);
            buffer[index] = fragmentDepth;

        }
    }

    
}
	
	
