## 2025-08-08
* Updated CHANGELOG again for better formatting
* Updated
* New CHANGELOG file with commit history
## 2025-08-07
* Updated changelog
* Added primary mineral production function to Section 2
* Added indexation for new variable (mineral stock) including upper and lower bounds
* Added indexation for new decision variables (labour share primary mineral sector, labour share secondary mineral sector) and their upper and lower bounds
* Added idea for including Chazel equation 10 & 11 into the model Section 2 Step 1: Compute implied energy inputs
* Create new noteboo, used for implementing Chazel adaptations to the baseline GHKT model
* Final model; Updated notes
* Final model; Updated notes
* Updated notebook with most recent changes I made in MATLAB (see folder matlab_files for latest versions)
* Updated comments and To Do's
## 2025-08-06
* Edited GHKT matlab code for proper replication PLUS matlab files for production function changes, as input for the respective model notebooks
* Added latest changes that I made within MATLAB; also uploaded most recent MATLAB files to local folder
* Updated replication model with latest changes that I made in MATLAB itself; also added those MATLAB files to local folder
## 2025-07-14
* Small changes to notes and ideas; Again attempted to remove final sections of raw code
* Tried to resolve matlab issues unsuccessfully; Removed last code block with raw model code
* Updated model after setting up environment; Made small changes to model code for clarification
## 2025-06-30
* Run GHKT with section 3 for graphs; Added new notebook for changing production function
## 2025-06-25
* Started cleaning and clarifying model based on Golosov; Added note
## 2025-06-23
* Remove .gitmodules from tracking
* Removed .gitmodules after removing submodule
## 2025-06-20
* Updated Changelog 20/06/2025
* Installed Optimization Toolbox; First successful run; Added to do's
* Added (old) repo with attempt at translating GHKT matlab code to python
* Removed submodule ghkt_translation
* First kind of successful run; Installing Optimization Toolbox from matlab before next run
* Debugging: Added Constraints.m and Objective.m in Solver cell as needed my matlab
* Debugged graph of coal emissions
* Fixed issues with matlab kernel; Deleted question
## 2025-06-19
* Changed initial guess from using previous result (x_sig1_g0_b985_d1) to neutral starting point
* Added constraints
* Copied objective function and solver; Added legend for questions/comments
* Added CHANGELOG.md to track project progress
* Start work: Continue copying GHKT matlab code in jupyter notebook, adding comments and questions - running it later
## 2025-06-18
* Started copying GHKT matlab code into Jupyter - not run yet
* Original GHKT matlab code as provided by Barrage (2014)
* Stop tracking .ipynb_checkoints
* Removed .txt extension to filename
* Remove nested git repo from ghkt_translation (previously chazel_model)
2025-08-11
- Implemented all changes and started debugging kernel issues
- Updated parameters in line with Chazel
- Started changing production functions Yt and Et with newly added labour share variables