# E-commerce Data Analysis Project

A comprehensive data engineering and analysis project focusing on e-commerce transaction data using Python, PostgreSQL, and modern data analysis tools.

## 🎯 Project Overview

This project implements a complete data pipeline for processing and analyzing e-commerce transaction data, including order patterns, product relationships, and customer behavior analysis. It demonstrates proficiency in data engineering, SQL database management, and Python-based data analysis.

## 🛠️ Technologies Used

- **Python 3.11**
- **PostgreSQL**
- **Pandas**
- **SQLAlchemy**
- **Psycopg2**
- **Jupyter Notebook**

## 📊 Data Structure

The project works with five main datasets:

### 1. Orders
```python
order_df columns:
- order_id
- user_id
- order_number
- order_dow
- order_hour_of_day
- days_since_prior_order
```

### 2. Products
```python
products_df columns:
- product_id
- product_name
- aisle_id
- department_id
```

### 3. Order Products
```python
order_products_df columns:
- order_id
- product_id
- add_to_cart_order
- reordered
```

### 4. Aisles
```python
aisles_df columns:
- aisle_id
- aisle
```

### 5. Departments
```python
departments_df columns:
- department_id
- department
```

## 🔄 Data Pipeline

### 1. Database Connection Setup
```python
engine = create_engine('postgresql+psycopg2://postgres:password@localhost/ecom_analysis')
conn = psycopg2.connect(dbname="ecom_analysis", user='postgres', password='password', port='5432')
```

### 2. Table Creation
- Implements proper schema with primary and foreign keys
- Handles data type specifications
- Manages cascading dependencies

### 3. Data Loading Process
```python
# Example of data loading pattern
aisles_df.to_sql('aisles', con=engine, if_exists='append', index=False)
departments_df.to_sql('departments', con=engine, if_exists='append', index=False)
products_df.to_sql('products', con=engine, if_exists='append', index=False)
```

### 4. Data Validation
- Checks for duplicate entries
- Validates foreign key constraints
- Ensures data integrity

## 📈 Analysis Features

### 1. Order Analysis
- Temporal patterns in ordering
- Day of week analysis
- Hour of day distribution

### 2. Product Analytics
- Product reorder patterns
- Category-wise analysis
- Department performance

### 3. Customer Behavior
- Order frequency analysis
- Cart size patterns
- Reorder behavior

## 🔍 Key SQL Queries

### Department Order Summary
```sql
CREATE TEMPORARY TABLE department_order_summary AS
    SELECT department_id, 
           COUNT(*) AS total_products_purchased,
           COUNT(DISTINCT product_id) AS total_unique_products_purchased,
           COUNT(CASE WHEN order_dow < 6 THEN 1 ELSE NULL END) AS total_weekday_purchases,
           COUNT(CASE WHEN order_dow >= 6 THEN 1 ELSE NULL END) AS total_weekend_purchases,
           AVG(order_hour_of_day) AS avg_order_time
    FROM order_info
    GROUP BY department_id
```

### Product Behavior Analysis
```sql
CREATE TEMPORARY TABLE product_behavior_analysis AS
    SELECT pi.product_id, pi.product_name, pi.department_id, 
           d.department, pi.aisle_id, a.aisle,
           pos.total_orders, pos.total_reorders, pos.avg_add_to_cart,
           dos.total_products_purchased, dos.total_unique_products_purchased,
           dos.total_weekday_purchases, dos.total_weekend_purchases, 
           dos.avg_order_time
    FROM product_order_summary AS pos
    JOIN products AS pi ON pos.product_id = pi.product_id
    JOIN departments AS d ON pi.department_id = d.department_id
    JOIN aisle AS a ON pi.aisle_id = a.aisle_id
    JOIN department_order_summary AS dos ON pi.department_id = dos.department_id
```

## 🎓 Learning Outcomes

This project demonstrates proficiency in:
- Database design and implementation
- ETL pipeline development
- Data validation and cleaning
- Complex SQL query writing
- Python data analysis
- Performance optimization
- Data integrity management

## 🚀 Future Enhancements

1. **Performance Optimization**
   - Implement database indexing
   - Optimize query performance
   - Add batch processing for large datasets

2. **Analysis Extensions**
   - Add time series analysis
   - Implement customer segmentation
   - Create predictive models for product demand

3. **Infrastructure Improvements**
   - Add data validation frameworks
   - Implement automated testing
   - Create CI/CD pipeline

## 📝 Usage

1. **Setup Database**
```bash
# Create PostgreSQL database
createdb ecom_analysis
```

2. **Install Dependencies**
```bash
pip install -r requirements.txt
```

3. **Run Analysis**
```bash
jupyter notebook Ecommerce_Data_Analysis_BV.ipynb
```

## 🔧 Configuration

Update the database connection parameters in the notebook:
```python
engine = create_engine('postgresql+psycopg2://postgres:your_password@localhost/ecom_analysis')
```

## 📄 License
This project is available for educational purposes and demonstrates data engineering and analysis concepts.

## 👥 Contributing
Feel free to fork this repository and submit pull requests for any improvements.
