CREATE TEMPORARY TABLE order_info AS
    SELECT o.order_id, o.order_number, o.order_dow, o.order_hour_of_day, o.days_since_prior_order,
           op.product_id, op.add_to_cart_order, op.reordered,
           p.product_name, p.aisle_id, p.department_id
    FROM orders AS o
    JOIN order_products AS op ON o.order_id = op.order_id
    JOIN products AS p ON op.product_id = p.product_id

CREATE TEMPORARY TABLE department_order_summary AS
    SELECT department_id, COUNT(*) AS total_products_purchased,
           COUNT(DISTINCT product_id) AS total_unique_products_purchased,
           COUNT(CASE WHEN order_dow < 6 THEN 1 ELSE NULL END) AS total_weekday_purchases,
           COUNT(CASE WHEN order_dow >= 6 THEN 1 ELSE NULL END) AS total_weekend_purchases,
           AVG(order_hour_of_day) AS avg_order_time
    FROM order_info
    GROUP BY department_id

CREATE TEMPORARY TABLE aisle_order_summary AS
    SELECT aisle_id, COUNT(*) AS total_products_purchased,
           COUNT(DISTINCT product_id) AS total_unique_products_purchased
    FROM order_info
    GROUP BY aisle_id
    ORDER BY COUNT(*) DESC
    LIMIT 10

CREATE TEMPORARY TABLE product_behavior_analysis AS
    SELECT pi.product_id, pi.product_name, pi.department_id, d.department, pi.aisle_id, a.aisle,
           pos.total_orders, pos.total_reorders, pos.avg_add_to_cart,
           dos.total_products_purchased, dos.total_unique_products_purchased,
           dos.total_weekday_purchases, dos.total_weekend_purchases, dos.avg_order_time
    FROM product_order_summary AS pos
    JOIN products AS pi ON pos.product_id = pi.product_id
    JOIN departments AS d ON pi.department_id = d.department_id
    JOIN aisle AS a ON pi.aisle_id = a.aisle_id
    JOIN department_order_summary AS dos ON pi.department_id = dos.department_id
