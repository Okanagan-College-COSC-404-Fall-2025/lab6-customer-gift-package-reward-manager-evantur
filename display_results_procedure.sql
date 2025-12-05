CREATE OR REPLACE PROCEDURE DISPLAY_RESULTS AS
    i NUMBER;
    email VARCHAR2(255 CHAR);
    CURSOR res_cursor IS
        SELECT cr.GIFT_ID, gc.GIFTS, cr.CUSTOMER_EMAIL
        FROM CUSTOMER_REWARDS cr, GIFT_CATALOG gc
        WHERE cr.GIFT_ID = gc.GIFT_ID AND cr.CUSTOMER_EMAIL = email;
    res_record res_cursor%ROWTYPE;
BEGIN
    CUSTOMER_MANAGER.ASSIGN_GIFTS_TO_ALL;
    OPEN res_cursor;

    FOR i IN 1..5 LOOP
        FETCH res_cursor INTO res_record;
        EXIT WHEN res_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Gift ID: ' || res_record.GIFT_ID || ' Customer Email: ' || res_record.CUSTOMER_EMAIL || ' Gifts: ');
    END LOOP;
    CLOSE res_cursor;
END;
/

BEGIN DISPLAY_RESULTS; END;
/