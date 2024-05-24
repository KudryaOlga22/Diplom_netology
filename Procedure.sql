--Добавление нового товара: +
CREATE OR REPLACE PROCEDURE add_product(
	IN id INTEGER,
    IN product_name VARCHAR(255),
    IN product_category VARCHAR(100),
    IN product_price NUMERIC(10, 2),
    IN product_quantity INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO product (id, product_name, product_category, price, quantity)
    VALUES (id, product_name, product_category, product_price, product_quantity);
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
    UPDATE product
    SET product_name = new_name, product_category = new_description, price = new_price
    WHERE id = product_id;
    
    COMMIT;
END;
$$;
--Удаление товара:+
CREATE OR REPLACE PROCEDURE delete_product(
    IN product_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM product
    WHERE id = product_id;
    
    commit;
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
DECLARE
order_id INTEGER;
BEGIN
-- Создание записи о заказе
INSERT INTO orders (user_id, "order date", "order status")
VALUES (user_id, CURRENT_DATE, 'Pending')
RETURNING id INTO order_id;

-- Добавление товаров в заказ
FOR i IN 1..COALESCE(array_length(products_list, 1), 0)
LOOP
    INSERT INTO order_details (order_id, product_id, quantity)
    VALUES (order_id, products_list[i], quantities_list[i]);
END LOOP;

COMMIT;
END;
$$