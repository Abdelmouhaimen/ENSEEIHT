#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <iostream>

using namespace cv;
using namespace std;

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        cout << " Usage: display_image ImageToLoadAndDisplay" << endl;
        return EXIT_FAILURE;
    }

    // Read the file
    Mat image = imread(argv[1], cv::IMREAD_COLOR);

    // Check for invalid input
    if(image.empty())
    {
        cout << "Could not open or find the image" << std::endl;
        return EXIT_FAILURE;
    }

    // Create a window for display.
    namedWindow("Display window", cv::WINDOW_AUTOSIZE);
    // Show our image inside it.
    imshow("Display window", image);

    Mat image2 = imread("../data/images/cat.jpg", cv::IMREAD_COLOR);
    if(image2.empty())
    {
        cout << "Could not open or find the image" << std::endl;
        return EXIT_FAILURE;
    }
    namedWindow("Display window", cv::WINDOW_AUTOSIZE);
    // Show our image inside it.
    imshow("Display window", image2);

    // Wait for a keystroke in the window
    waitKey(0);

    return EXIT_SUCCESS;
}