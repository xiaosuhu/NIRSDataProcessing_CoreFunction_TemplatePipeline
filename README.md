# fNIRS Data Processing Using NIRS Toolbox

This repository contains different MATLAB scripts for fNIRS data processing pipelines. 

NOTE: You will need to first install NIRS toolbox in Matlab inorder to run these pipelines.

<img src="fNIRS-analysis-logo.webp" alt="Project Logo" width="400">

<p align="left">
  <img src="https://img.shields.io/badge/version-0.1-blue" alt="Version Badge">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License Badge">
  <img src="https://img.shields.io/badge/build-building_inprogress-yellow" alt="Build Badge">
</p>

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [NIRS Data Quality Control](#nirs-data-quality-control)
- [Analysis Workflow](#analysis-workflow)
- [Group Level Formula](#group-level-formula)
- [Common Q&A](#common-qa)
- [More Questions?](#more-questions)

## Features
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
   - Because deoxy is usually slower than oxy (a few seconds), thus a cross correlation with lags might be used
   - Oxy response is usually 3-4 times larger in scale than de-oxy response 
3. Cardiac response in the signal (maybe able to use scalp coupling index to check)
4. Motion artifact check
   - Wavelet
   - PCA
   - Spline interpolation 
   - TDDR 

## Analysis Workflow

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

## Group Level Formula  

The group-level analysis uses **Wilkinson Notation** to represent equations in a compact form.  

🔗 **[Learn more about Wilkinson Notation](https://www.mathworks.com/help/stats/wilkinson-notation.html)**  

This notation is commonly used in statistical modeling to define relationships between variables concisely.

## Common Q&A

### **1. What is the difference between correlation and partial correlation?**  
**A:** Partial correlation measures the degree of association between two variables while controlling for the effect of one or more additional variables. It quantifies the direct relationship between the two variables of interest, removing the influence of confounding factors.

### **2. Should I do fNIRS and EEG simutaneously?
**A:** Only when there is information needs to be collected simutaneously, otherwise, EEG and fNIRS can be done separatly.

### **3. What if I have a out of memory (OOM) error during group level analysis?
**A:** You can use nirs.module.GroupAverage function instead of LME, but not having the reandom effects modeled.

### **4. Which condition to look at if I use derivatives with my HRF model?
**A:** Always look at the effect of the first term. e.g. if you have EASY and HARD conditions, look at EASY:01 and HARD:01.

### **5. What is an optimal downsampling rate for data analysis?
**A:** Since fNIRS data contain information mostly between 0-1 Hz, a 2 Hz rate is suggested, sometimes for faster processing first-level, you can do 1 Hz (Especially for hyperscanning).

### **6. When to do motion correction?
**A:** If you choose to do motion correction, you should do it before downsampling.

### **7. Should I run regular GLM after motion correction (e.g. TDDR)?
**A:** No, you should always run algorithms like AR-IRLS.

### **8. How do I know what can I do with my data or results?
**A:** You can use methods(), e.g. methods(SubjStats) or methods(Data).




## More Questions?

For any inquiries, please contact:  
**Frank Hu** – [xiaosuhu@umich.edu](mailto:xiaosuhu@umich.edu)