use sakila;

-- 1
DELIMITER //
CREATE PROCEDURE GetCustomersRentingCategory(IN categoryName VARCHAR(255))
BEGIN
    SELECT
        first_name,
        last_name,
        email
    FROM
        customer
    JOIN
        rental ON customer.customer_id = rental.customer_id
    JOIN
        inventory ON rental.inventory_id = inventory.inventory_id
    JOIN
        film ON film.film_id = inventory.film_id
    JOIN
        film_category ON film_category.film_id = film.film_id
    JOIN
        category ON category.category_id = film_category.category_id
    WHERE
        category.name = categoryName
    GROUP BY
        first_name, last_name, email;
END //
DELIMITER ;

-- 2
DELIMITER //
CREATE PROCEDURE CheckMoviesReleasedPerCategory(IN minMovieCount INT)
BEGIN
    SELECT
        category.name AS category_name,
        COUNT(film.film_id) AS movie_count
    FROM
        category
    LEFT JOIN
        film_category ON category.category_id = film_category.category_id
    LEFT JOIN
        film ON film_category.film_id = film.film_id
    GROUP BY
        category_name
    HAVING
        movie_count > minMovieCount;
END //
DELIMITER ;

-- 3
-- First call
CALL GetCustomersRentingCategory('Action');

-- Second call
CALL CheckMoviesReleasedPerCategory(10);

