function plot_superpixel_colors(superpixels)
[n,m_row] = size(superpixels);
% Define the number of classes
num_classes = max(superpixels(:));

% Create a color map for each class
color_map = rand(num_classes, 3); 

% Create an RGB image to represent the segmented result
segmented_image = zeros(n, m_row, 3);

% Assign colors to each class in the segmented image
for i = 1:n
    for j = 1:m_row
        idx = superpixels(i, j);
        segmented_image(i, j, :) = color_map(idx, :);
    end
end

% Plot the segmented image
imshow(segmented_image);
title('Segmented Image');
end


