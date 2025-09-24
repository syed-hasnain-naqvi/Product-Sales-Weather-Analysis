# =====================
# 0. Load Required Libraries
# =====================
library(ggplot2)
library(rpart)
library(rpart.plot)

# =====================
# 1. Load Data
# =====================
prod5  <- read.csv("product_5_sales_weather.csv", stringsAsFactors = FALSE)
prod9  <- read.csv("product_9_sales_weather.csv", stringsAsFactors = FALSE)
prod45 <- read.csv("product_45_sales_weather.csv", stringsAsFactors = FALSE)

# =====================
# 2. Data Cleaning & Feature Engineering
# =====================
# Convert date
prod5$Date  <- as.Date(prod5$Date, format = "%m/%d/%Y")
prod9$Date  <- as.Date(prod9$Date, format = "%m/%d/%Y")
prod45$Date <- as.Date(prod45$Date, format = "%m/%d/%Y")

# is_weekend: 1 if Saturday/Sunday, else 0
prod5$is_weekend  <- ifelse(weekdays(prod5$Date) %in% c("Saturday", "Sunday"), 1, 0)
prod9$is_weekend  <- ifelse(weekdays(prod9$Date) %in% c("Saturday", "Sunday"), 1, 0)
prod45$is_weekend <- ifelse(weekdays(prod45$Date) %in% c("Saturday", "Sunday"), 1, 0)

# is_rainy_day: placeholder (no precipitation column available in CSV)
prod5$is_rainy_day  <- 0
prod9$is_rainy_day  <- 0
prod45$is_rainy_day <- 0

# month: extract month and make it categorical
prod5$month  <- factor(format(prod5$Date, "%B"), levels = month.name)
prod9$month  <- factor(format(prod9$Date, "%B"), levels = month.name)
prod45$month <- factor(format(prod45$Date, "%B"), levels = month.name)

# Handle missing values in avg_temp
prod5$avg_temp[is.na(prod5$avg_temp)]   <- median(prod5$avg_temp, na.rm = TRUE)
prod9$avg_temp[is.na(prod9$avg_temp)]   <- median(prod9$avg_temp, na.rm = TRUE)
prod45$avg_temp[is.na(prod45$avg_temp)] <- median(prod45$avg_temp, na.rm = TRUE)

# =====================
# 3. Helper Function for Evaluation
# =====================
evaluate_model <- function(data, formula) {
  set.seed(123)
  n <- nrow(data)
  train_idx <- sample(1:n, size = 0.7*n)
  train <- data[train_idx, ]
  test  <- data[-train_idx, ]
  
  # Train model
  model <- lm(formula, data = train)
  
  # Predict
  pred <- predict(model, newdata = test)
  
  # Metrics
  rmse <- sqrt(mean((test$daily_units - pred)^2))
  mae  <- mean(abs(test$daily_units - pred))
  
  return(list(model = model, RMSE = rmse, MAE = mae))
}

# =====================
# 4. Linear Regression Models
# =====================
results_prod5  <- evaluate_model(prod5, daily_units ~ avg_temp + is_weekend + month)
results_prod9  <- evaluate_model(prod9, daily_units ~ avg_temp + is_weekend + month)
results_prod45 <- evaluate_model(prod45, daily_units ~ avg_temp + is_weekend + month)

cat("Product 5 - RMSE:", results_prod5$RMSE, " MAE:", results_prod5$MAE, "\n")
cat("Product 9 - RMSE:", results_prod9$RMSE, " MAE:", results_prod9$MAE, "\n")
cat("Product 45 - RMSE:", results_prod45$RMSE, " MAE:", results_prod45$MAE, "\n")

# =====================
# 5. Decision Tree Models
# =====================
tree_prod5  <- rpart(daily_units ~ avg_temp + is_weekend + month, data = prod5, method = "anova")
tree_prod9  <- rpart(daily_units ~ avg_temp + is_weekend + month, data = prod9, method = "anova")
tree_prod45 <- rpart(daily_units ~ avg_temp + is_weekend + month, data = prod45, method = "anova")

# Plot the trees
rpart.plot(tree_prod5,  main = "Decision Tree - Product 5")
rpart.plot(tree_prod9,  main = "Decision Tree - Product 9")
rpart.plot(tree_prod45, main = "Decision Tree - Product 45")

# Variable Importance
print(tree_prod5$variable.importance)
print(tree_prod9$variable.importance)
print(tree_prod45$variable.importance)

# =====================
# 6. Visualizations
# =====================
# --- Product 5 ---
ggplot(prod5, aes(x = avg_temp, y = daily_units)) +
  geom_point(alpha = 0.5, color = "blue") +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(title = "Product 5: Temperature vs Sales",
       x = "Average Temperature (°F)",
       y = "Daily Units Sold")

ggplot(prod5, aes(x = Date, y = daily_units)) +
  geom_line(color = "darkgreen") +
  labs(title = "Product 5: Daily Sales Trend Over Time",
       x = "Date", y = "Daily Units Sold")

ggplot(prod5, aes(x = factor(is_weekend), y = daily_units)) +
  geom_bar(stat = "summary", fun = "mean", fill = "orange") +
  scale_x_discrete(labels = c("0" = "Weekday", "1" = "Weekend")) +
  labs(title = "Product 5: Average Sales by Weekend/Weekday",
       x = "Day Type", y = "Average Units Sold")

# --- Product 9 ---
ggplot(prod9, aes(x = avg_temp, y = daily_units)) +
  geom_point(alpha = 0.6, color = "#2C7BB6") +
  geom_smooth(method = "lm", se = TRUE, color = "#D7191C") +
  labs(title = "Product 9: Impact of Temperature on Sales",
       x = "Average Temperature (°F)", y = "Units Sold")

ggplot(prod9, aes(x = Date, y = daily_units)) +
  geom_line(color = "#1B7837") +
  labs(title = "Product 9: Daily Sales Trend",
       x = "Date", y = "Daily Units Sold")

ggplot(prod9, aes(x = factor(is_weekend), y = daily_units, fill = factor(is_weekend))) +
  geom_bar(stat = "summary", fun = "mean") +
  scale_fill_manual(values = c("0" = "#80CDC1", "1" = "#01665E"),
                    labels = c("Weekday", "Weekend")) +
  labs(title = "Product 9: Average Sales by Day Type",
       x = "Day Type", y = "Average Units Sold") +
  theme(legend.position = "none")

# --- Product 45 ---
ggplot(prod45, aes(x = avg_temp, y = daily_units)) +
  geom_point(alpha = 0.6, color = "gray40") +
  geom_smooth(method = "lm", se = TRUE, color = "#004488") +
  labs(title = "Product 45: Temperature Effect on Sales",
       x = "Average Temperature (°F)", y = "Units Sold")

ggplot(prod45, aes(x = Date, y = daily_units)) +
  geom_line(color = "#117733") +
  labs(title = "Product 45: Daily Sales Trend",
       x = "Date", y = "Daily Units Sold")

ggplot(prod45, aes(x = factor(is_weekend), y = daily_units, fill = factor(is_weekend))) +
  geom_bar(stat = "summary", fun = "mean", width = 0.6) +
  scale_fill_manual(values = c("0" = "#CCCCCC", "1" = "#004488"),
                    labels = c("Weekday", "Weekend")) +
  labs(title = "Product 45: Average Sales by Day Type",
       x = "Day Type", y = "Average Units Sold") +
  theme(legend.position = "none")

# ======================================================
# End of Script
# ======================================================

