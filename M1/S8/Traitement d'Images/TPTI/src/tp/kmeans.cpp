#include "ocv_utils.hpp"

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <map>


using namespace cv;
using namespace std;


void printHelp(const string& progName)
{
    cout << "Usage:\n\t " << progName << " <image_file> <K_num_of_clusters> [<image_ground_truth>]" << endl;
}

void evaluer ( const Mat & bestLabels , const Mat & seg_ref , map < std :: string , float > & myMap ){

    int n = seg_ref.rows;
    int m = seg_ref.cols;
    int TP = 0 ;
    int FP = 0 ;
    int TN = 0 ;
    int FN = 0 ;
    for ( int i = 0 ; i < n ; i ++ ){
        for ( int j = 0 ; j < m ; j ++ ){
            if ( bestLabels . at <float> ( i , j ) == 0 ){
                if ( seg_ref . at <float> ( i , j ) == 0 ){
                    TP += 1 ;
                } else {
                    FP += 1 ;
                }
            } else {
                if ( seg_ref . at <float> ( i , j ) == 1 ){
                    TN += 1 ;
                } else {
                    FN += 1 ;
                }
            }
        }
    }

    myMap [ "P" ] = TP /(float) ( TP + FP );
    myMap [ "S" ] = TP / ( float )(TP + FN);
    myMap [ "DSC" ] = 2 * TP / ( float )( 2 * TP + FN + FP);
}

void kmeans_perso(const Mat& data, int k, Mat& bestLabels, int max_iter, int num_attempts)
{
    
    bestLabels.create(data.total(),1, CV_32FC1);
    
    const float DIST_MAX = 500;
    double best_compactness = 0;


    double compactness;
    Mat current_labels;
    current_labels.create(data.total(),1, CV_32FC1);

    for (int attempt = 0; attempt < num_attempts; attempt++) {
        compactness = 0.0;
        // 1) initialiser les centres des clusters
        Point3f centers[k];
        for (int i = 0; i < k; i++) {   
            centers[i] = Point3f(rand() % 256, rand() % 256, rand() % 256);  
        }
        
        for (int q = 0 ; q<max_iter ; q++){
            for (int i=0 ; i<data.rows ; i++){
                // 2) assigner chaque point au cluster le plus proche
                float min_dist = DIST_MAX;
                int best_cluster = -1;
                
                for (int j = 0; j < k; j++)
                {
                    float dist = norm(data.at<Point3f>(i) - centers[j]);
                    
                    if (dist < min_dist)
                    {
                        min_dist = dist;
                        best_cluster = j;
                    }
                }
                current_labels.at<float>(i) = best_cluster;

                // Update compactness
                if (q == max_iter-1) {
                    compactness += min_dist * min_dist;
                }
            }

            // 3) recalculer les centres des clusters
            
            Point3f new_centers[k];

            for ( int i =0; i<k;i++){
                new_centers[i] =Point3f(0, 0, 0);
            }

            int count[k];
            for (int l = 0; l<k; l++){
                count[l] = 0;
            }

            for (int j = 0; j < data.rows; j++)
            {
                for (int i = 0; i < k; i++)
                {
                    if (current_labels.at<float>(j) == i)
                    {
                        new_centers[i] += data.at<Point3f>(j);
                        count[i]++;
                    }
                }
            }

            for (int i = 0; i < k; i++) {
                if (count[i] > 0)
                {
                    new_centers[i] /= count[i];
                    centers[i] = new_centers[i];
                }
            }
        }

        // Compare compactness with the best compactness obtained so far
        if (compactness < best_compactness || attempt == 0)
        {
            best_compactness = compactness;
            current_labels.copyTo(bestLabels);
        }
    }
            
}    


int main(int argc, char** argv)
{
    if (argc != 3 && argc != 4)
    {
        cout << " Incorrect number of arguments." << endl;
        printHelp(string(argv[0]));
        return EXIT_FAILURE;
    }

    const auto imageFilename = string(argv[1]);
    const string groundTruthFilename = (argc == 4) ? string(argv[3]) : string();
    const int k = stoi(argv[2]);

    // just for debugging
    {
        cout << " Program called with the following arguments:" << endl;
        cout << " \timage file: " << imageFilename << endl;
        cout << " \tk: " << k << endl;
        if(!groundTruthFilename.empty()) cout << " \tground truth segmentation: " << groundTruthFilename << endl;
    }

    

    // load the color image to process from file
    Mat m;
    // for debugging use the macro PRINT_MAT_INFO to print the info about the matrix, like size and type
    PRINT_MAT_INFO(m);

    // 1) in order to call kmeans we need to first convert the image into floats (CV_32F)
    // see the method Mat.convertTo()
    m = imread(imageFilename, cv::IMREAD_COLOR);
    m.convertTo(m, CV_32F);


    // 2) kmeans asks for a mono-dimensional list of "points". Our "points" are the pixels of the image that can be seen as 3D points
    // where each coordinate is one of the color channel (e.g. R, G, B). But they are organized as a 2D table, we need
    // to re-arrange them into a single vector.
    // see the method Mat.reshape(), it is similar to matlab's reshape
    Mat m_reshaped;
    m.reshape(3, {m.total(),1}).copyTo(m_reshaped);


    srand(std::time(nullptr));
    // now we can call kmeans(...)
    Mat bestLabels, centers;
    Mat bestLabels_opencv;
    kmeans(m_reshaped, k, bestLabels_opencv, TermCriteria(TermCriteria::EPS+TermCriteria::COUNT, 100, 1), 1, KMEANS_PP_CENTERS, centers);
    kmeans_perso(m_reshaped, k, bestLabels,100,3);
    bestLabels = bestLabels.reshape(1, m.rows);
    bestLabels.convertTo(bestLabels, CV_32F);
    PRINT_MAT_INFO(bestLabels);
    
    bestLabels_opencv = bestLabels_opencv.reshape(1, m.rows);
    bestLabels_opencv.convertTo(bestLabels_opencv, CV_32F);
    namedWindow("kmeans_opencv", WINDOW_AUTOSIZE);
    imshow("kmeans_opencv", bestLabels_opencv);

    map < string , float >  myMap ;
    

    namedWindow("kmeans", WINDOW_AUTOSIZE);
    imshow("kmeans", bestLabels);
    if (argc == 4) {
        Mat seg_ref = imread(groundTruthFilename, cv::IMREAD_GRAYSCALE);
        seg_ref = seg_ref / 255.0;
        seg_ref.convertTo(seg_ref, CV_32F);
        imshow("sol", seg_ref);
        waitKey(500);
        string choix;
        cout << "**************************************************************" << endl;
        cout << "Veuillez Chosir si vouz voulez inverser la classification de kmeans_perso (o/n)" << endl;
        
        cin >> choix;
        if (choix == "o"){
            bestLabels = 1 - bestLabels;
            namedWindow("kmeans_inversee", WINDOW_AUTOSIZE);
            imshow("kmeans_inversee", bestLabels);
        }
    
        evaluer(bestLabels, seg_ref, myMap );
        cout << "**************************************************************" << endl;
        cout << " evaluation des resultats "<< endl;
        cout << " P : " << myMap["P"] << endl;
        cout << " S : " << myMap["S"] << endl;
        cout << " DSC : " << myMap["DSC"] << endl;
        
        
        cout << "**************************************************************" << endl;
        cout << "Veuillez Chosir si vouz voulez inverser la classification de kmeans openCV (o/n)" << endl;
        string choix2;
        cin >> choix2;
        if (choix2 == "o"){
            bestLabels_opencv = 1 - bestLabels_opencv;
            namedWindow("kmeansOpenCV_inversee", WINDOW_AUTOSIZE);
            imshow("kmeansOpenCV_inversee", bestLabels_opencv);
        }
        evaluer(bestLabels_opencv, seg_ref, myMap );
        cout << "**************************************************************" << endl;
        cout << " evaluation des resultats Kmeans OpenCV"<< endl;
        cout << " P : " << myMap["P"] << endl;
        cout << " S : " << myMap["S"] << endl;
        cout << " DSC : " << myMap["DSC"] << endl;
    }
    
    


    waitKey(0);



    return EXIT_SUCCESS;
}
