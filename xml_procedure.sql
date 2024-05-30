CREATE OR REPLACE PROCEDURE generate_and_download_xml()
LANGUAGE plpgsql
AS 
$$
DECLARE
    sql_query TEXT;
    xml_data TEXT;
BEGIN
    -- Выполняем запрос на получение списка товаров с ненулевым остатком
    sql_query := 'SELECT r.id , p.product_name , r.quantity_in_stock  
FROM public.remaining_products r
join public.product p on p.id  = r.id_product 
WHERE quantity_in_stock > 0 ;';
    EXECUTE sql_query;

    -- Преобразуем результаты запроса в XML-формат
    SELECT xmlagg(xmlforest(
        id AS "id",
        product_name AS "product_name",
        quantity_in_stock AS "quantity"
    ))::xml into xml_data FROM generate_xml;

    -- Сохраняем XML-файл на сервере
    PERFORM lo_unlink('/tmp/products.xml'); -- Удаляем предыдущую версию файла
    PERFORM lo_import(xml_data::bytea, '/tmp/products.xml'); -- Создаем новый файл

    -- Загружаем XML-файл пользователю
    RAISE NOTICE 'Скачивание файла: /tmp/products.xml';
END;
$$