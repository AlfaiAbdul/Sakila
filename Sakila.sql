use sakila;


# 1)
-- a)
SELECT first_name, last_name, actor_id
FROM actor; 
-- b)
SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) as 'Actor Name'
FROM actor;
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------


# 2)
-- a)
SELECT first_name, last_name, actor_id 
FROM actor
WHERE first_name = 'Joe';

-- b)
SELECT first_name, last_name 
FROM actor
WHERE last_name  LIKE '%GEN%';

-- c)
SELECT first_name, last_name
FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- d)
SELECT county_id, country
from country 
WHERE  country IN 
(Afghanistan, Bangladesh, China);
-- -----------------------------------------------
-- -----------------------------------------------


# 3)
-- a)
ALTER TABLE actor
ADD middle_name VARCHAR(50) NULL
AFTER first_name;

-- b)
ALTER TABLE actor
MODIFY middle_name BLOB 	NULL;

-- c)
ALTER TABLE actor 
DROP COLUMN middle_name;
-- ----------------------------------------------------
-- ----------------------------------------------------


# 4)
-- a)
SELECT last_name, count(last_name)
FROM actor	
GROUP BY last_name
ORDER BY last_name;

-- b)
SELECT last_name, COUNT(last_name)
FROM actor 
GROUP BY last_name
HAVING  COUNT(last_name)  > 1
ORDER BY last_name;

-- c)
UPDATE actor
SET first_name = REPLACE(first_name, 'GROUCHO', 'HARPO')
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- d)
UPDATE actor
SET first_name = IF(first_name = 'HARPO' , 'GROUCHO', 'MUCHO GORUCHO')
WHERE actor_id = 172;
-- ----------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------


# 5)
SHOW CREATE TABLE  sakila.address;
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------


# 6)
-- a)
SELECT s.first_name, s.last_name, a.address
FROM address a
JOIN staff s
ON a.address_id = s.address_id;

-- b)
SELECT s.first_name, s.last_name, SUM(p.amount) AS gross
FROM payment p
JOIN staff s ON 
(
  s.staff_id = p.staff_id
)
GROUP BY s.staff_id, DATE_FORMAT(p.payment_date, '%2005%August');
    
-- c)
SELECT f.film_id, f.title, COUNT(fa.actor_id) as NumActors
FROM film as f
INNER JOIN film_actor as fa
ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
ORDER by f.title;

-- d)
SELECT COUNT(*)
FROM inventory
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = 'Hunchback Impossible'
);

-- e)
SELECT c.first_name, c.last_name, SUM(p.amount) AS gross 
FROM payment p 
JOIN customer c ON 
(
c.customer_id = p.customer_id
)
GROUP BY c.customer_id
ORDER BY c.last_name ASC;
-- ----------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------



# 7)
-- a)
SELECT title 
FROM film
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE (title LIKE 'Q%' OR title LIKE 'K%')
);

-- b)
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
 (
SELECT film_id
FROM film
WHERE title = 'ALONE TRIP'
  )
);

-- c)
CREATE TABLE cust_country
SELECT c.first_name, c.last_name, c.email
FROM customer c 
JOIN address a ON 
(
c.address_id = a.address_id
)
JOIN city ON 
(
a.city_id = city.city_id
)
JOIN country ON 
(
city.country_id = country.country_id
)
WHERE country.country = 'Canada';

-- d)
SELECT title
FROM film
WHERE film_id IN
(
SELECT film_id
FROM film_category
WHERE category_id IN
(
SELECT category_id
FROM category
WHERE name = 'FAMILY'
)
);

-- e)
SELECT f.title, COUNT(r.rental_date) as Count
FROM film f 
JOIN inventory i ON (f.film_id = i.film_id)
JOIN rental r ON (i.inventory_id = r.inventory_id)
GROUP BY f.title
ORDER BY Count desc;

-- f)
SELECT s.store_id, SUM(p.amount) as Amount
FROM store s
JOIN customer c ON 
(
s.store_id = c.store_id
)
JOIN payment p ON 
(
p.customer_id = c.customer_id
)
GROUP BY s.store_id;

-- g)
SELECT s.store_id, city.city, c.country
FROM store s 
JOIN address a ON 
(
s.address_id = a.address_id
)
JOIN city ON 
(
a.city_id = city.city_id
)
JOIN country c ON 
(
city.country_id = c.country_id
)
GROUP BY s.store_id;

-- h)
SELECT cat.name, SUM(p.amount) as Amount
FROM category cat 
JOIN film_category fc ON 
(
cat.category_id = fc.category_id
)
JOIN inventory i ON 
(
fc.film_id = i.film_id
)
JOIN rental r ON 
(
i.inventory_id = r.inventory_id
)
JOIN payment p ON 
(
p.rental_id = r.rental_id
)
GROUP BY cat.name
ORDER BY Amount desc
LIMIT 5;
-- ----------------------------------------
-- ----------------------------------------


# 8)
-- a)
CREATE VIEW top5_genres AS 
SELECT cat.name, SUM(p.amount) as Amount
FROM category cat 
JOIN film_category fc ON
(
cat.category_id = fc.category_id
)
JOIN inventory i ON 
(
fc.film_id = i.film_id
)
JOIN rental r ON 
(
i.inventory_id = r.inventory_id
)
JOIN payment p ON 
(
p.rental_id = r.rental_id
)
GROUP BY cat.name
ORDER BY Amount desc
LIMIT 5;

-- b)
SELECT * FROM top5_genres;

-- c)
DROP VIEW top5_genres;
-- ------------------------------------------
-- ------------------------------------------