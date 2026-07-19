# Adult Income Prediction using Machine Learning

## Project Overview

This project aims to predict whether an individual's annual income exceeds **$50K** based on demographic and employment-related attributes. The project follows a complete end-to-end data science workflow, starting with data analysis and cleaning in **MySQL** and concluding with machine learning model development and evaluation in **Google Colab (Python)**.

---

## Problem Statement

Accurately predicting an individual's income category can help organizations and researchers better understand the relationship between demographic characteristics and earning potential.

The objective of this project is to build a binary classification model that predicts whether an individual's annual income is:

- **<=50K**
- **>50K**

---

## Dataset

- **Dataset:** Adult Income Dataset
- **Records after cleaning:** 45,985
- **Target Variable:** Income

---

## Technologies Used

### Database
- MySQL Workbench

### Programming Language
- Python

### Libraries
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- XGBoost

### Development Environment
- Google Colab

---

# Project Workflow

## Phase 1 – SQL

### Database Setup
- Created the project database.
- Imported the Adult Income dataset.

### Data Understanding
- Explored dataset structure.
- Checked missing values.
- Identified duplicate records.
- Analyzed target variable distribution.

### Business Analysis
Performed SQL-based analysis to understand the relationship between income and:
- Education
- Occupation
- Workclass
- Marital Status
- Age
- Working Hours
- Capital Gain

Advanced SQL concepts used:
- GROUP BY
- Aggregate Functions
- CASE Statements
- Common Table Expressions (CTE)
- Subqueries
- Window Functions (RANK)

### Data Cleaning
- Created a working copy of the dataset.
- Removed records with missing Workclass and Occupation.
- Replaced missing Native Country values with "Unknown".
- Removed duplicate records.
- Generated the final cleaned dataset for machine learning.

---

## Phase 2 – Machine Learning

### Data Loading

- Imported the cleaned dataset into Google Colab.

### Exploratory Data Analysis

- Income Distribution
- Age Distribution
- Education Distribution
- Correlation Analysis

### Data Preprocessing

- Label Encoding
- Feature Selection
- Train-Test Split (80:20)

### Machine Learning Models

- Logistic Regression
- Random Forest
- XGBoost

---

# Model Performance

| Model | Accuracy |
|--------|----------|
| Logistic Regression | 80.24% |
| Random Forest | 84.99% |
| XGBoost | **87.15%** |

---

# Best Model

Among the three evaluated models, **XGBoost** achieved the highest predictive performance.

### Final Accuracy

**87.15%**

XGBoost produced the highest accuracy while also achieving the best precision, recall, and F1-score, making it the most suitable model for predicting annual income.

---

# Key Skills Demonstrated

- SQL Data Analysis
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Feature Engineering
- Data Preprocessing
- Classification Algorithms
- Model Evaluation
- Machine Learning
- Data Visualization

---
