
The run_analysis.R script reads input data sets (x,y, features, labels) from train and test directories provided in the data set zip archive.

readFeatures function read feature names from a given feature file and creates an object providing character vectors for all features 
or those filtered (std meaen only).
The returned list is used for proper naming of X sets.

getLabels function reads activity names from a given activity file. Created vector is used for resolving activity identifier 
in input Y sets. 

readSubjcets function read subjects from an input file. The output vector is bound to the "final" data frame.

readXSet, readYSet function are used for reading both training and test measurements files and trainig and test Y classification result files. 
Both function mentioned above need features object to properly name columns and ratain std and mean.

Thes cript benefits from plyr package to compute means across all varialbles grouping by subject, and activity name.