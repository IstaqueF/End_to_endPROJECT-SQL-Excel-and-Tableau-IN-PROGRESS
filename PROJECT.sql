/*
# I have joined 12 tables and created a table called new_table in order to answer the questions required to complete the Project
Only relevant columns have been selected so the analysis can be carried out in a simplified manner using only 1 table.  
There are only 2 stores in USA of this Video store so the analysis will be focused on only 2 cities (Lethbridge and Woodridge) of USA
# 
*/
CREATE TABLE new_table as 
(SELECT r.rental_id,r.rental_date,r.inventory_id,r.customer_id,r.return_date,r.staff_id,f.film_id,f.rental_duration,f.rental_rate,f.length,f.rating,c.category_id,c.name,l.name as Language, 
a.actor_id,a.first_name,a.last_name,s.store_id,ci.city
FROM film f 
JOIN film_category fc
     ON f.film_id = fc.film_id
JOIN category c
     ON fc.category_id = c.category_id
JOIN language l
     ON f.language_id = l.language_id
JOIN film_actor fa
     ON f.film_id = fa.film_id
JOIN actor a 
     ON fa.actor_id = a.actor_id
JOIN inventory i
     ON f.film_id = i.film_id
JOIN store s
     ON i.store_id = s.store_id
JOIN address ad 
     ON s.address_id = ad.address_id
JOIN city ci 
     ON ad.city_id = ci.city_id
JOIN rental r
     ON i.inventory_id = r.inventory_id);
     
# the name new_table can be confusing so let's change it to Project_table
ALTER TABLE new_table RENAME TO Project_table;

#Find the time spent between rental date and return_date in terms of hours and append new column  
SELECT *, TIMESTAMPDIFF(hour,rental_date,return_date) as rental_time_in_hours
FROM Project_table;

# Question 1: Top 5 actor's movies that have been rented the most during the period of the analysis 
SELECT first_name,last_name,count(distinct film_id) as number_of_movies
FROM project_table
GROUP BY first_name,last_name
ORDER BY number_of_movies DESC
LIMIT 5;



# Question 2 : Top 5 popular categories 
SELECT name, COUNT(category_id) as Famous_category
FROM project_table
GROUP BY name
ORDER BY Famous_category DESC
LIMIT 5;
#Notes : The top 3 categories are Sports,Animation and Action. From this we can deduct the majority of the customers are of younger age so in case of promotion this client base should be targeted. 
# If we had the customer age in the Customer table we would be able to indicate the age range of the most active customers as well. 

#  Question 3: find the list of rental rate per category
SELECT name, rental_rate
FROM project_table
GROUP BY name
ORDER BY rental_rate;

# Top 5 categories that generated the most revenue 
SELECT name, category_id,rental_rate, COUNT(category_id)*rental_rate as revenue
FROM project_table
GROUP BY name 
ORDER BY revenue DESC
LIMIT 5;
# By increasing the number of video tapes/CDs from these top 5 categories we can increase the revenue in future.
# Pricing team can further analyse the price of these categories to check if a change in price can further enhance the revenue in future. 

# Question 4 : Find the difference in price between most expensive and least expensive categories 
SELECT (MAX(rental_rate) - MIN(rental_rate)) as Difference_in_value
FROM project_table;

# Question 5 : Select the average rental hours per category 
SELECT name , avg(difference) as Average_rental_time
FROM (SELECT *, TIMESTAMPDIFF(hour,rental_date,return_date) as difference FROM project_table) as S
GROUP BY name
ORDER BY Average_rental_time DESC
LIMIT 5;
# Notes: The top category is dominated by customer of younger age. 

#Question 6: Now let's find out if rental time changes between two stores
SELECT name , store_id , avg(difference) as avg_rental_hours
FROM (SELECT *, TIMESTAMPDIFF(hour,rental_date,return_date) as difference FROM project_table) as S
WHERE store_id IN ("1","2")
GROUP BY name
ORDER BY avg_rental_hours DESC
#Notes: No data to particularly suggest that any of the store has a longer rental time on average than other. 


# Question 1: Top 5 actor's movies that have been rented the most during the period of the analysis 
# Question 2 : Top 5 popular categories 
# Question 3: find the list of rental rate per category
# Question 4 : Find the difference in price between most expensive and least expensive categories 
# Question 5 : Select the average rental hours per category 
# Question 6: Now let's find out if rental time changes between two stores






 
     
     