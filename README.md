# fNIRS Data Processing Using NIRS Toolbox

This repository contains different MATLAB scripts for fNIRS data processing pipelines. 

NOTE: You will need to first install NIRS toolbox in Matlab inorder to run these pipelines.

<img src="fNIRS-analysis-logo.webp" alt="Project Logo" width="400">

<p align="left">
  <img src="https://img.shields.io/badge/version-0.1-blue" alt="Version Badge">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License Badge">
  <img src="https://img.shields.io/badge/build-passing-brightgreen" alt="Build Badge">
</p>

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [NIRS Data Quality Control](#data-quality)
- [Analysis Workflow](#analysis-workflow)
- [Common Q&A](#q-and-a)
- [More Questions?](#questions)

## ✨ Features
✔️ First-level GLM analysis  
✔️ First-level FIR analysis  
✔️ Second-level (group-level) analysis  
✔️ GPU acceleration for first-level analysis  

## Installation

To run the full pipeline, ensure you have the following prerequisites:

1. Download the **NIRS Toolbox** from: [NIRS Toolbox GitHub](https://github.com/huppertt/nirs-toolbox.git)  
   - Option 1: Clone the repository using Git:  
     ```sh
     git clone https://github.com/huppertt/nirs-toolbox.git
     ```
   - Option 2: Download the repository manually by clicking the **Download** button on GitHub.

2. Add the **NIRS Toolbox** folder to the MATLAB path:  
   - For a **permanent** path addition, use **Set Path** in MATLAB.  
   - For a **temporary** path addition, right-click the folder in MATLAB and select **Add Selected Folders and Subfolders**.

## Usage

The following section provides a high-level overview of the analysis process.  
For detailed examples, refer to:  
- The example pipeline in this repository.  
- The **demo** folder in the **NIRS Toolbox**.

## NIRS Data Quality Control
1. Signal-to-noise-ratio (SNR)
2. Oxy-deoxy anti (cross) correlation check
   - Because deoxy is usually slower than oxy, thus a cross correlation with lags might be used
3. Cardiac response in the signal (maybe able to use scalp coupling index to check)
4. Motion artifact check
   - Wavelet
   - PCA
   - Spline interpolation 
   - TDDR 

## 📊 Analysis Workflow

The analysis of fNIRS data follows these steps:

1. **Subject-Level Analysis (First Level)**  
   - Perform individual-level analysis using:  
     - General Linear Model (GLM)  
     - Finite Impulse Response (FIR) analysis  

2. **Group-Level Analysis (Second Level)**  
   - Conduct group-level analysis using a **Linear Mixed Effects Model**  

3. **Statistical Tests**  
   - Within group-level analysis, statistical significance can be assessed using:  
     - **F-test**  
     - **t-test** with proper contrasts  

4. **Visualization**  
   - Finally, results can be plotted for interpretation and reporting.  

## Common Q&A
What is the differece between correlation and patial correlation?

## More Questions?

For any inquiries, please contact:  
**Frank Hu** – [xiaosuhu@umich.edu](mailto:xiaosuhu@umich.edu)