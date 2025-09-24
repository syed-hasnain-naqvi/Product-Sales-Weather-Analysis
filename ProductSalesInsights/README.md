# 🛒 Product Sales Insights – Weather Impact on Retail Sales

## 📌 Project Overview
This project analyzes the relationship between **weather conditions** and **product sales** for a retail dataset.  
We focus on **three top-selling products (Product 5, Product 9, Product 45)** and examine how factors like **temperature** and **weekends** influence demand.  

The project follows a structured **Data Science workflow**:
1. **SQL (Data Preparation)** – Extract and join sales with weather data.  
2. **R (Modeling & Analysis)** – Clean, feature engineer, and build predictive models.  
3. **Visualization & Reporting** – Interpret results with plots and provide business recommendations.  

---

## 📂 Project Structure


ProductSalesInsights/
│
├── data/
│ ├── product_5_sales_weather.csv
│ ├── product_9_sales_weather.csv
│ ├── product_45_sales_weather.csv
│
├── sql/
│ └── queries.sql # SQL queries to prepare datasets
│
├── r/
│ └── analysis.R # R script for data cleaning, modeling, and visualization
│
├── outputs/
│ ├── plots/ # Scatter, Line, Bar charts
│ └── model_results.txt # RMSE/MAE for each model
│
├── report/
│ └── Product_Sales_Insights.pdf # Final written analysis and recommendations
│
└── README.md # Project documentation


---

## ⚙️ Requirements
### SQL
- SQLite or any RDBMS to run the queries.  
- CSV export capability.  

### R
Install the following packages:
```R
install.packages(c(
  "tidyverse", "lubridate", "caret", 
  "rpart", "rpart.plot"
))

🚀 How to Run

Run SQL Queries

Use queries.sql to generate the three product datasets.

Export them as CSV files and place them inside the data/ folder.

Run R Analysis

Open analysis.R in RStudio.

Update file paths if needed.

Run the script step by step:

Data loading & cleaning

Feature engineering (is_weekend, month)

Model training (Linear Regression & Decision Tree)

Evaluation (RMSE, MAE)

Visualization

View Outputs

Plots will be saved in outputs/plots/.

Final report is in report/Product_Sales_Insights.pdf.

📊 Key Insights

Product 5: Strong weekend sales uplift; temperature positively correlated with demand.

Product 9: Sales sensitive to seasonal trends, especially colder months.

Product 45: More stable across seasons, but still influenced by weekends.

💡 Business Recommendations

Increase stock of Product 5 during warm weekends to capture higher demand.

Plan promotions for Product 9 in colder months as demand rises with temperature drops.

Maintain steady stock levels of Product 45 year-round, but boost slightly for weekends.

👨‍💻 Author

Your Name

Data Enthusiast | Process Optimization | Future Data Scientist

📧 Contact: tskloga@gmail.com

🌐 Portfolio: https://github.com/logatsk/logambigaiKuppusamy-project1

