--1. Show the actor's first_name and last_name with Nick, Ed and Jennifer as their first names.

SELECT first_name,
	last_name
FROM actor
WHERE first_name IN ('Nick', 'Ed', 'Jennifer');

--2. Show only last_name of an actor whose first names are Ed, Nick and Jennifer

SELECT last_name
FROM actor
WHERE first_name IN ('Ed', 'Nick', 'Jennifer');

/*3. From the film table, show the title, and film id. from the Inventory table, show inventory_id. Do 
this when the film_id on the film table match film_id on the inventory table.*/

SELECT title,
	   f.film_id,
	   i.inventory_id
FROM film f
JOIN inventory i
ON f.film_id = i.film_id

/*4. Show me first_name, and last_name of the actors whose first_name (Ed, Nick and Jennifer) are 
distinct*/

SELECT
	DISTINCT 
	first_name,
	last_name
FROM actor
WHERE first_name IN ('Ed', 'Nick', 'Jennifer');

--5. Show the top 5 rows from the inventory table and rental table.

SELECT * 
FROM inventory, rental
LIMIT 5;

/*6. Write a query to return 10 rows of rental_id, rental_date, and payment_id, ordered by the 
amount in descending order from the rental and payment table.*/

SELECT r.rental_id,
	   r.rental_date,
	   p.payment_id
FROM rental r 
JOIN payment p
ON r.rental_id = p.rental_id
ORDER BY p.amount DESC
LIMIT 10;

--7. Show all the other details in the actor table where actor_id is empty

SELECT *
FROM actor
WHERE actor_id IS NULL;

--8. Show all the other details in the actor table where actor_id is not empty

SELECT * 
FROM actor
WHERE actor_id IS NOT NULL;
/*9. Unlike count, the sum can only be used for numeric columns. Let’s see the sum of the amount 
from the payment table, let the output title be sum_amt.*/

SELECT 
	sum(amount) AS sum_amt
FROM payment;

--10. Extract both the Maximum and minimum amount in the payment table

SELECT
	max(amount),
	min(amount)
FROM payment;

--11. Show the sum of payment made by each payment_id

SELECT 
	payment_id,
	sum(amount) AS sum_of_payment
FROM payment
GROUP BY payment_id;

--12. Show the sum of the amount by each payment id that is greater than 5.99

SELECT 
	payment_id,
	sum(amount) AS sum_of_payment
FROM payment
WHERE amount > 5.99
GROUP BY payment_id;

--13. Show the sum of rental_rate of films by month

-- Return the average gap period between rental and return date for all the films

WITH table1 as (
	SELECT f.film_id, f.rental_rate, i.inventory_id, f.title
	FROM film f
	JOIN inventory i
	ON f.film_id = i.film_id 
	),
	table2 AS (
	SELECT rental_id,
		to_char(rental_date, 'Month') as rental_month, --using to_char() to get the name of month
		EXTRACT (epoch from(return_date - rental_date))/86400 as gap_period,
		inventory_id
	from rental
	)
select title, rental_month, Sum(rental_rate) as total_rental_rate, round(avg(gap_period)) || ' days' as average_gap
from table2 t2
join table1 t1
on t1.inventory_id = t2.inventory_id
group by rental_month, title;

/*14. Show film.id, film.title, film. description and film_length. categorize film.length
 into 4 categories(over 100, 86-100, 72-86 and under 72)*/
 
SELECT film_id,
	title,
	description,
	length,
CASE
	WHEN length <72 THEN 'under_72'
	WHEN length <86 THEN '72-86'
	WHEN length <100 THEN '86-100'
	ELSE 'over 100'
END AS length_category
FROM film;

--15. Show the COUNT of the four categories above

SELECT
CASE
	WHEN length <72 THEN 'under_72'
	WHEN length <86 THEN '72-86'
	WHEN length <100 THEN '86-100'
	ELSE 'over 100'
END AS length_category,
COUNT(*) AS film_count
FROM film
GROUP BY length_category

/*16. Separate the first three, and last 8 numbers of the phones in the address table into 
another column*/

SELECT
	phone,
	LEFT(phone, 3) AS first_three_numbers,
	RIGHT(phone, 8) AS last_eight_numbers
FROM address;

/*17. Split the email in the customer table to show the name in caps before the full stop 
(Repeat the task for Proper case)*/

SELECT email,
	split_part(email, '.', 1) AS name,
	--split_part(split_part(email, '.', 2), '@', 1) AS last_name,
	--replace(email, '.org', '.com')
	FROM customer;

/*18. View all the columns in the city and add two columns to show the city as upper 
and lowercase*/

SELECT *,
	UPPER(city) AS upper_case_city,
	LOWER(city) AS lower_case_city
FROM city;

--19. Combine first_name and last_name from the customer table to become full_name

SELECT first_name,
	last_name,
	CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;