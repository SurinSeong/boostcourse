USE practice;

-- VIEW : 하나 이상의 테이블들을 활용해서, 사용자가 정의한 가상의 테이블--
/*
테이블 결합 : 주문(sales) 테이블 기준, 상품(product) 테이블 LEFT JOIN 결합
*/

SELECT A.*,
	   A.sales_qty * B.price AS 결제금액
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code;

-- VIEW 생성
CREATE VIEW sales_product AS
SELECT A.*,
	   A.sales_qty * B.price AS 결제금액
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code;

-- VIEW 실행
SELECT *
FROM sales_product;

-- VIEW 수정
ALTER VIEW sales_product AS
SELECT A.*,
	   A.sales_qty * B.price AS 결제금액_수수료포함
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code;

-- 수정 확인
SELECT *
FROM sales_product;

-- view 삭제
DROP VIEW sales_product;

-- view 특징 (중복되는 열 저장되지 않음.)
CREATE view sales_product AS
SELECT *
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code;

-- PROCEDURE : 매개변수를 활용해, 사용자가 정의한 작업을 저장 --
-- IN 매개변수
DELIMITER //
CREATE PROCEDURE cst_gen_addr_in(IN input_a varchar(20),
									input_b varchar(20))
BEGIN
	SELECT *
    FROM customer
    WHERE gender = input_a
    AND addr = input_b;
END
//
DELIMITER ;
-- DELIMITER : 여러 명령어들을 하나로 묶어줄 때 사용함.

-- PROCEDURE 실행
CALL cst_gen_addr_in("MAN", "SEOUL");
CALL cst_gen_addr_in("WOMEN", "INCHEON");

-- PROCEDURE 삭제
DROP PROCEDURE cst_gen_addr_in;

-- OUT 매개변수
DELIMITER //
CREATE PROCEDURE cst_gen_addr_in_cnt_mem_out(IN input_a varchar(20),
												input_b varchar(20),
											 OUT cnt_mem INT)
BEGIN
	SELECT COUNT(MEM_NO)
    INTO cnt_mem
    FROM customer
    WHERE gender = input_a
    AND addr = input_b;
END
//
DELIMITER ;

-- PROCEDURE 실행
CALL cst_gen_addr_in_cnt_mem_out("WOMEN", "INCHEON", @CNT_MEM);
SELECT @CNT_MEM;

-- IN/OUT 매개변수
DELIMITER //
CREATE PROCEDURE in_out_parameter(INOUT count INT)
BEGIN
	SET COUNT = COUNT + 10;
END
//
DELIMITER ;

-- procedure 실행
SET @counter = 1;
CALL in_out_parameter(@counter);
SELECT @counter;