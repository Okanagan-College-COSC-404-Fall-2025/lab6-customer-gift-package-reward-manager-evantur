CREATE OR REPLACE PACKAGE BODY CUSTOMER_MANAGER AS 
    FUNCTION GET_TOTAL_PURCHASE(customer_id IN NUMBER) RETURN NUMBER AS
        v_sum NUMBER;
        v_temp NUMBER;
        CURSOR my_cursor IS
            SELECT ORDER_ID 
            FROM ORDERS
            WHERE CUSTOMER_ID = customer_id;
        my_record my_cursor%ROWTYPE;
    BEGIN
        v_sum := 0;
        OPEN my_cursor;
        LOOP
            FETCH my_cursor INTO my_record;
            EXIT WHEN my_cursor%NOTFOUND;
            SELECT SUM(UNIT_PRICE) INTO v_temp
            FROM ORDER_ITEMS
            WHERE ORDER_ID = my_record.ORDER_ID;
            v_sum := v_sum + v_temp;
        END LOOP;
        CLOSE my_cursor;
        RETURN v_sum;
    END GET_TOTAL_PURCHASE;

    FUNCTION CHOOSE_GIFT_PACKAGE(p_total_purchase IN NUMBER) RETURN NUMBER AS
        x NUMBER := p_total_purchase;
    BEGIN
        CASE
            WHEN x >= 300 THEN RETURN 3;
            WHEN x >= 150 THEN RETURN 2;
            WHEN x >= 50 THEN RETURN 1;
            ELSE RETURN NULL;
        END CASE;
    END CHOOSE_GIFT_PACKAGE;

    PROCEDURE ASSIGN_GIFTS_TO_ALL IS
        CURSOR my_cursor IS
            SELECT CUSTOMER_ID, EMAIL_ADDRESS
            FROM CUSTOMERS;
        my_record my_cursor%ROWTYPE;
        id NUMBER;
    BEGIN
        OPEN my_cursor;
        LOOP
            FETCH my_cursor INTO my_record;
            EXIT WHEN my_cursor%NOTFOUND;
            id := CHOOSE_GIFT_PACKAGE(GET_TOTAL_PURCHASE(my_record.CUSTOMER_ID));
            IF id != NULL THEN
                INSERT INTO CUSTOMER_REWARDS (CUSTOMER_EMAIL, GIFT_ID, REWARD_DATE) 
                VALUES (my_record.EMAIL_ADDRESS, id, SYSDATE);
            END IF;
        END LOOP;
        CLOSE my_cursor;
    END ASSIGN_GIFTS_TO_ALL;
END;