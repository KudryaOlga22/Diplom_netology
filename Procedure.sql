--Добавление нового товара:
CREATE OR REPLACE PROCEDURE add_product(
    IN product_name VARCHAR(100),
    IN product_description TEXT,
    IN product_price NUMERIC,
    IN product_quantity INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO products (name, description, price, quantity)
    VALUES (product_name, product_description, product_price, product_quantity);
    
    COMMIT;
END;
$$;
--Обновление информации о товаре:
CREATE OR REPLACE PROCEDURE update_product(
    IN product_id INTEGER,
    IN new_name VARCHAR(100),
    IN new_description TEXT,
    IN new_price NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE products
    SET name = new_name, description = new_description, price = new_price
    WHERE id = product_id;
    
    COMMIT;
END;
$$;
--Удаление товара:
CREATE OR REPLACE PROCEDURE delete_product(
    IN product_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM products
    WHERE id = product_id;
    
    COMMIT;
END;
$$;
--Оформление заказа:
CREATE OR REPLACE PROCEDURE place_order(
    IN user_id INTEGER,
    IN products_list INTEGER[],
    IN quantities_list INTEGER[]
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Создание записи о заказе
    INSERT INTO orders (user_id)
    VALUES (user_id)
    RETURNING id INTO order_id;
    
    -- Добавление товаров в заказ
    FOR i IN 1..COALESCE(array_length(products_list, 1), 0)
    LOOP
        INSERT INTO order_details (order_id, product_id, quantity)
        VALUES (order_id, products_list[i], quantities_list[i]);
    END LOOP;

    COMMIT;
END;
$$;
--Подсчет общей стоимости заказа:
CREATE OR REPLACE FUNCTION calculate_order_total(order_id INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total_amount NUMERIC := 0;
BEGIN
    SELECT SUM(od.quantity * p.price)
    INTO total_amount
    FROM order_details od
    JOIN products p ON od.product_id = p.id
    WHERE od.order_id = order_id;
    
    RETURN total_amount;
END;
$$;

--Поиск товаров по ключевому слову:
CREATE OR REPLACE FUNCTION search_products(keyword VARCHAR)
RETURNS TABLE (
    id INTEGER,
    name VARCHAR,
    description TEXT,
    price NUMERIC,
    quantity INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT id, name, description, price, quantity
    FROM products
    WHERE name ILIKE '%' || keyword || '%';

    RETURN;
END;
$$;

--Получение информации о заказе:
CREATE OR REPLACE FUNCTION get_order_details(order_id INTEGER)
RETURNS TABLE (
    product_name VARCHAR,
    product_description TEXT,
    quantity INTEGER,
    price NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.name, p.description, od.quantity, p.price
    FROM order_details od
    JOIN products p ON od.product_id = p.id
    WHERE od.order_id = order_id;

    RETURN;
END;
$$;

--Обновление статуса заказа:
CREATE OR REPLACE PROCEDURE update_order_status(
    IN order_id INTEGER,
    IN new_status VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET status = new_status
    WHERE id = order_id;

    COMMIT;
END;
$$;

--Получение общего числа пользователей:
CREATE OR REPLACE FUNCTION get_total_users_count()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO total_count
    FROM users;

    RETURN total_count;
END;
$$;

--Получение списка заказов пользователя:
CREATE OR REPLACE FUNCTION get_user_orders(user_id INTEGER)
RETURNS TABLE (
    order_id INTEGER,
    order_date TIMESTAMP,
    status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT id AS order_id, order_date, status
    FROM orders
    WHERE user_id = user_id;

    RETURN;
END;
$$;

--Получение средней стоимости заказов за определенный период:
CREATE OR REPLACE FUNCTION get_average_order_cost(start_date DATE, end_date DATE)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    average_cost NUMERIC;
BEGIN
    SELECT AVG(total_cost)
    INTO average_cost
    FROM (
        SELECT SUM(od.quantity * p.price) AS total_cost
        FROM order_details od
        JOIN products p ON od.product_id = p.id
        JOIN orders o ON od.order_id = o.id
        WHERE o.order_date >= start_date AND o.order_date <= end_date
        GROUP BY od.order_id
    ) AS subquery;

    RETURN COALESCE(average_cost, 0);
END;
$$;

--Подсчет общего количества товаров:
CREATE OR REPLACE FUNCTION get_total_product_quantity()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_quantity INTEGER;
BEGIN
    SELECT SUM(quantity)
    INTO total_quantity
    FROM products;

    RETURN COALESCE(total_quantity, 0);
END;
$$;