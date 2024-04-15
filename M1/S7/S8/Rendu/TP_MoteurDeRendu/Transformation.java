
import algebra.*;

/**
 * author: cdehais
 */
public class Transformation  {

    Matrix worldToCamera;
    Matrix projection;
    Matrix calibration;

    public Transformation () {
        try {
            worldToCamera = new Matrix ("W2C", 4, 4);
            projection = new Matrix ("P", 3, 4);
            calibration = Matrix.createIdentity (3);
            calibration.setName ("K");
        } catch (InstantiationException e) {
            /* should not reach */
        }
    }

    public void setLookAt (Vector3 cam, Vector3 lookAt, Vector3 up) {
        try {
        // compute rotation
        // La matrice de Projection N Avec lignes ec1 ec2 et ec3
        Vector3 ec3 = new Vector3(lookAt);
        ec3.subtract(cam);
        ec3.normalize();
        Vector3 ec1 = up.cross(ec3);
        ec1.normalize();
        Vector3 ec2 = ec3.cross(ec1);
        Matrix N = new Matrix (3, 3);
        N.setCol (0, ec1);
        N.setCol (1, ec2);
        N.setCol (2, ec3);
        Matrix N_T = N.transpose();


	/* A COMPLETER */


        // compute translation
        Vector3 t = new Vector3 (cam);
        t.scale (-1.0);
        Vector t2 = N_T.multiply(t);
        /* A COMPLETER */
        worldToCamera.setCol (3, t2);
        worldToCamera.setSubMatrix(0, 0, N_T);
        worldToCamera.setRow(3, new Vector3(0, 0, 0));
        worldToCamera.set(3, 3, 1.0);
        
        

        } catch (Exception e) { /* unreached */e.printStackTrace(); };
        
        System.out.println ("Modelview matrix:\n" + worldToCamera);
    }

    public void setProjection () {
        try {
            Vector zero3 = new Vector(3);
            zero3.zeros();
            projection.setCol(0, zero3);
            projection.setCol(1, zero3);
            projection.setCol(2, zero3);
            projection.setCol(3, zero3);

            projection.set (0, 0, 1.0);
            projection.set (1, 1, 1.0);
            projection.set (2, 2 , 1.0);
        } catch (Exception e) {
            e.printStackTrace();
            /* unreached */
        }
        


	/* A COMPLETER */

        System.out.println ("Projection matrix:\n" + projection);
    }

    public void setCalibration (double focal, double width, double height) {
        try {
            calibration.setRow (0, new Vector3 (focal, 0, width/2.0));
            calibration.setRow (1, new Vector3 (0, focal, height/2.0));
            calibration.setRow (2, new Vector3 (0, 0, 1.0));
        } catch (InstantiationException e) {
            /* unreached */ e.printStackTrace();
        }
        
        


	/* à compléter */

	System.out.println ("Calibration matrix:\n" + calibration);
    }

    /**
     * Projects the given homogeneous, 4 dimensional point onto the screen.
     * The resulting Vector as its (x,y) coordinates in pixel, and its z coordinate
     * is the depth of the point in the camera coordinate system.
     */  
    public Vector3 projectPoint (Vector p)
        throws SizeMismatchException, InstantiationException {
	    Vector ps = new Vector(3);
        /* à compléter */
        
        ps = projection.multiply(worldToCamera.multiply(p));
        double z = ps.get(2);
        ps.scale(1.0/ ps.get(2));
        ps = calibration.multiply(ps);
        ps.set(2, z);
        return new Vector3 (ps);
    }
    
    /**
     * Transform a vector from world to camera coordinates.
     */
    public Vector3 transformVector (Vector3 v)
        throws SizeMismatchException, InstantiationException {
        /* Doing nothing special here because there is no scaling */
        Matrix R = worldToCamera.getSubMatrix (0, 0, 3, 3);
        Vector tv = R.multiply (v);
        return new Vector3 (tv);
    }
    
}

