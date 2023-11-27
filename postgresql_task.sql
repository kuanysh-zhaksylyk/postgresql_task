SELECT c.name, COUNT(*) as count_film
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY count DESC;

SELECT a.first_name, a.last_name, COUNT(*) as count
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.first_name, a.last_name
ORDER BY count DESC
LIMIT 10;



SELECT c.name, SUM(p.amount) as total_amount
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_amount DESC
LIMIT 5;


SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

SELECT a.first_name as actor_first_name, a.last_name as actor_last_name, COUNT(*) as count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE c.name = 'Children'
GROUP BY a.first_name, a.last_name
ORDER BY count DESC
LIMIT 3;


SELECT city,
       SUM(CASE WHEN active = 1 THEN 1 ELSE 0 END) as active_customers,
       SUM(CASE WHEN active = 0 THEN 1 ELSE 0 END) as inactive_customers
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city
ORDER BY inactive_customers DESC;


WITH film_cat_total_hours AS (
    SELECT address.city_id, fc.category_id, SUM(film.rental_duration) as total_rental_hours
    FROM film_category fc
    JOIN film ON fc.film_id = film.film_id
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN customer ON rental.customer_id = customer.customer_id
    JOIN address ON customer.address_id = address.address_id
    GROUP BY address.city_id, fc.category_id
)

SELECT city, category_id, total_rental_hours
FROM (
    SELECT city, category_id, total_rental_hours,
           ROW_NUMBER() OVER (PARTITION BY city ORDER BY total_rental_hours DESC) as num
    FROM film_cat_total_hours
    join city on film_cat_total_hours.city_id = city.city_id
    WHERE city LIKE 'a%' OR city LIKE '%-%'
) ranked
WHERE num = 1;





