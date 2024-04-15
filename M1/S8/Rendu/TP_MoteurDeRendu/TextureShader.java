
import algebra.*;
import java.awt.*;

/**
 * Simple shader that just copy the interpolated color to the screen,
 * taking the depth of the fragment into acount.
 * @author: cdehais
 */
public class TextureShader extends Shader {
    
    DepthBuffer depth;
    Texture texture;
    boolean combineWithBaseColor;

    public TextureShader (GraphicsWrapper screen) {
        super (screen);
        depth = new DepthBuffer (screen.getWidth (), screen.getHeight ());
        texture = null;
    }

    public void setTexture (String path) {
        try {
            texture = new Texture (path);
        } catch (Exception e) {
            System.out.println ("Could not load texture " + path);
            e.printStackTrace ();
            texture = null;
        }
    }

    public void setCombineWithBaseColor (boolean combineWithBaseColor) {
        this.combineWithBaseColor = combineWithBaseColor;
    }

    public void shade (Fragment fragment) {
        if (depth.testFragment (fragment)) {
            /* The Fragment may not have texture coordinates */
            try {
                if (texture != null ) {
                    // Sample the texture at the fragment's texture coordinates
                    Color texColor = texture.sample( fragment.getAttribute(7), fragment.getAttribute(8));
                    // Combine with base color if necessary
                    if (combineWithBaseColor) {
                        texColor = new Color(
                            (int)(fragment.getColor().getRed() * texColor.getRed() / 255.0),
                            (int)(fragment.getColor().getGreen() * texColor.getGreen() / 255.0),
                            (int)(fragment.getColor().getBlue() * texColor.getBlue() / 255.0)
                        );
                    }
                    screen.setPixel(fragment.getX(), fragment.getY(), texColor);
                } else {
                    // If no texture or texture coordinates, just set the fragment color
                    screen.setPixel(fragment.getX(), fragment.getY(), fragment.getColor());
                }


            } catch (ArrayIndexOutOfBoundsException e) {
                screen.setPixel (fragment.getX (), fragment.getY (), fragment.getColor ());
            }
            depth.writeFragment (fragment);
        }
    }

    public void reset () {
        depth.clear ();
    }
}

