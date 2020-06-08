# NU-BCI
This repository contains all relevant codes used for the implementation of an online cross-participant classification system for infants. It assists in the detection of a visual developmental biomarker (looming-related brain response) in the EEG. 
The project was part of a Master thesis in Neuroscience at the Norges teknisk-naturvitenskapelige universitet and was conducted at the [NU-LAB](https://www.ntnu.edu/psychology/nulab#/view/about) under the supervision of Prof. Audrey van der Meer. No participant data is uploaded due to the regulations of Norges teknisk-naturvitenskapelige universitet.

**BCI2000:**
The online classification is based on [BCI2000](https://www.bci2000.org/mediawiki/index.php/Main_Page). The BCI2000 folder contains the batch and parameter file needed for the correct initiation of BCI2000 in the environment of the NU-LAB. The AmpServer soruce module worked togehter with the EGI NA300 amplifier from revision 6050.

**E-PRIME:**
The E-Prime folder contains the upgraded stimulus paradigm programmed in E-Prime 2. It enables communication of the stimulus triggers to BCI2000 via UDP.

**MATLAB:**
The MATLAB folder contains all codes used for the training of the classification models and the final online classifier. For its execution, the [FieldTrip Toolbox](http://www.fieldtriptoolbox.org/), the MATLAB Signal Processing Toolbox, the MATLAB Statistics and Machine Learning Toolbox, and MATLAB Wavelet Toolbox are needed.

**1.**	The first folder contains code used for the training of the classifier:

- The first subfolder contains the GUI for the semi-automatic extraction of the looming-related brain response form in BESA pre-annotated data. 

- The second subfolder contains the code used for the feature extraction. By using the function Feature_Extraction_crossPCA.m or Feature_Extraction_crossPCA_fixedFilter.m the features of the data can be extracted for every speed condition and every subject. The function Converter.m balances and converts the data for the subsequent of the classifier. Converter.m balances and converts the data for the subsequent of the classifier

- The third subfolder contains the code used for the feature selection based on the NSGA-II algorithm. The used NSGA-II algorithm is based on its implementation by [Song Lin](https://se.mathworks.com/matlabcentral/fileexchange/31166-ngpm-a-nsga-ii-program-in-matlab-v1-4). The NSGA-II can be initiated by running feature_selection_test01.m. The used classifiers can be found in Accuracy_Features.m


**2.**	The second folder contains the final online classifiers. One only performing the pre-processing, one the classification of  3- to 6-month-old infants looming-related brain response and one the classification of  11- to 12-month-old infants looming-related brain response.

The public link to the thesis will be posted at a later point in time here. 
