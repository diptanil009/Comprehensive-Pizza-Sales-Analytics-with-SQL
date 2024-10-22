-- Q>1.  Retrieve the total no of order placed

use pizzahut;
	
select count(order_id) as total_orders from orders;


-- Q>2. calculate total revenue generated from pizza sales 

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS tatal_sales
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;



-- Q>3.identify the highest price pizza 

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Q>4. identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        INNER JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;



-- Q>4. list the top 5 most ordered pizza types with their qunatities

SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total DESC
LIMIT 5;


-- Q>5. join the necessary tables to find the total quantity of each pizza category ordered

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC
LIMIT 5;



-- Q>6. determine the distribution of order by hour of the day 

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hour;



-- Q>7. join the relevent tables to find the category-wise distribution of pizzas 

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- Q>8. group the oredrs by date and calculate
-- the average number of pizzas ordered per day 


SELECT 
    ROUND(AVG(quantity), 0) as avg_pizzas_ordered_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    INNER JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY order_date) AS order_quantity;
    

-- determine the top 3 most ordered pizza types based on revenue 

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;



-- calculate the percentage contribution of each pizza type to tatal revenue 

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    SUM(order_details.quantity * pizzas.price)
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;






-- analyze the cumulative revenue generated over time 



select order_date , 
sum(revenue) over (order by order_date) as cum_revenue
from
(select orders.order_date , sum(order_details.quantity * pizzas.price) as revenue 
from  order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders 
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;




-- determine the top 3 most ordered pizza 
-- types based on revenue for each pizza category 



select category, name, revenue from
(select category,name, revenue ,
rank() over (partition by category order by revenue) as rn
from 
(select pizza_types.category, pizza_types.name ,
sum(order_details.quantity * pizzas.price) as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id 
group by category, name) as a ) as b
where rn<=3;









    


 












