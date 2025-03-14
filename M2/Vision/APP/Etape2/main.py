from noise_generation import map_colored
import numpy as np
from drawer import draw_mesh
from draw_line import draw
import cv2

h = 500
w = 500

width, height, altitude_map, colors = map_colored(h,w)
#draw_mesh(width, height, altitude_map, colors)

texture_colored = draw(h, w,colors)
#cv2.imshow("texture", cv2.cvtColor(texture_colored, cv2.COLOR_RGB2BGR))
#transpose only the first two dimensions
texture_colored = np.transpose(texture_colored, (1, 0, 2))


texture_colored = texture_colored.reshape(colors.shape)


# combine colors and texture_colored where texture_colored is black
for i in range(len(texture_colored)):
    if texture_colored[i][0] != 0 or texture_colored[i][1] != 0 or texture_colored[i][2] != 0:
        colors[i][0] = texture_colored[i][0]/255
        colors[i][1] = texture_colored[i][1]/255
        colors[i][2] = texture_colored[i][2]/255
        

draw_mesh(width, height, altitude_map, colors)










