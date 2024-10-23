# ShinyCC: A Shiny App for Cell-Cell Communication Analysis

## Introduction

**ShinyCC** is a Shiny app built on top of the [CellChat](https://github.com/jinworks/CellChat) package by **Songqi Jin**. This app provides an interactive interface for analyzing cell-cell communication from single-cell RNA-seq data. The app simplifies the process of comparing interactions across different conditions and visualizing communication networks, making it easier for users to interpret their results.

### Key Features
- **Visualization of Cell-Cell Communication**: Generate plots to visualize the number of interactions or interaction strength across different conditions.
- **Comparison Between Conditions**: Easily compare cell-cell communication across multiple samples or conditions.
- **Customizable Plots**: Adjust plot dimensions, label sizes, and more to suit your needs.
- **Real-Time Memory Monitoring**: Ensure smooth app performance by monitoring memory usage and receiving warnings when memory is critically high.

## Reference

This Shiny app is built using the **CellChat** package by Songqi Jin. For more details on the original package, please visit the [CellChat GitHub repository](https://github.com/jinworks/CellChat).

## Package Dependencies

To run this Shiny app, you'll need the following R packages installed:

- **shiny**
- **shinycssloaders**
- **dplyr**
- **shinythemes**
- **shinyWidgets**
- **pryr**
- **CellChat** (v2)

You can install these packages using the following commands:

```r
install.packages(c("shiny", "shinycssloaders", "dplyr", "shinythemes", "shinyWidgets", "pryr"))
# Install CellChat from GitHub
devtools::install_github("sqjin/CellChat")
```
Note that when building the shiny app for Shiny Server or shinyapps.io, you will need to delete the "*.o" files in /src/ because they will prevent the package from correctly compiling. To do so, you may either fork the original repository and delete those files yourself, or install my forked version through `devtools::install_github("mianaz/CellChat")`. A locally installed version will not work for shinyapps.io.

## Input Requirements
The app requires a **pre-processed** CellChat object that includes the results of cell-cell communication analysis. The CellChat object should be merged if multiple conditions/samples are to be compared. 

