USE practice;
/*
SQL 활용 단원 정리
연산자 - 비교, 논리, 특수, 산술, 집합 연산자
함수 - 단일, 복수, 윈도우 함수
view 및 procedure
데이터 마트
*/

-- 연산자 및 함수 --
-- 1. customer 테이블을 활용해서, 가입일자가 2019년이며 생일이 4~6월 생인 회원수를 조회
SELECT COUNT(mem_no)
FROM customer
WHERE YEAR(join_date) = 2019
AND MONTH(birthday) BETWEEN 4 and 6;

-- 2. sales 및 product 테이블을 활용해, 1회 주문시 평균 구매금액을 구하기 (비회원 9999999 제외)
-- 1회 주문시 구매금액
SELECT AVG(A.sales_qty * B.price) AS 평균_구매금액,
       SUM(A.sales_qty * B.price) / COUNT(A.order_no) AS 1회_주문시_구매금액
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code
WHERE A.mem_no <> "9999999";

-- 3. sales 테이블을 활용해, 구매수량이 높은 상위 10명을 조회하기(비회원 9999999 제외)
-- 회원별 구매수량 순위
SELECT mem_no,
	   SUM(sales_qty) AS 구매수량,
       ROW_NUMBER() OVER (ORDER BY SUM(sales_qty) DESC) AS 고유한_순위_반환,
       RANK() OVER (ORDER BY SUM(sales_qty) DESC) AS 동일한_순위_반환,
       DENSE_RANK() OVER (ORDER BY SUM(sales_qty) DESC) AS 동일한_순위_반환_하나의함수
FROM sales
WHERE mem_no <> "9999999"
GROUP BY mem_no;

-- 회원별 구매수량 순위 + 상위 10위 이하 필터링
SELECT *
FROM (SELECT mem_no,
			 SUM(sales_qty) AS 구매수량,
             ROW_NUMBER() OVER (ORDER BY SUM(sales_qty) DESC) AS 순위
	  FROM sales
      WHERE mem_no <> "9999999"
      GROUP BY mem_no) AS A
WHERE 순위 <= 10;

-- View 및 Procedure
/*
1. View를 활용해, Sales 테이블을 기준으로 CUSTOMER 및 PRODUCT 테이블을 LEFT JOIN 결합한 가상 테이블을 생성
열 = SALES 테이블의 모든 열 + CUSTOMER 테이블의 GENDER + PRODUCT 테이블의 BRAND
*/
CREATE VIEW SALES_GENDER_BRAND AS
SELECT A.*,
	   B.gender,
       C.brand
FROM SALES AS A
LEFT JOIN CUSTOMER AS B
ON A.mem_no = B.mem_no
LEFT JOIN PRODUCT AS C
ON A.product_code = C.product_code;

-- 조회
SELECT *
FROM SALES_GENDER_BRAND;

/*
2. Procedure를 활용해, CUSTOMER의 x월부터 y월까지의 생일인 회원을 조회하는 작업 저장
*/
DELIMITER //
CREATE procedure CST_BIRTH_MONTH_IN(IN input_a INT, input_b INT)
BEGIN
	SELECT *
    FROM customer
    WHERE MONTH(birthday) BETWEEN input_a AND input_b;
END
//
DELIMITER ;

-- 조회
CALL cst_birth_month_in(4, 6);

-- 데이터 마트
/*
1. SALES 및 PRODUCT 테이블을 활용해, SALES 테이블을 기준으로 PRODUCT 테이블을 LEFT JOIN 결합할 테이블 생성
열 = SALES 테이블의 모든 열 + product 테이블의 category, type + sales_qty * price 구매금액
*/
CREATE TABLE SALES_MART AS
SELECT A.*,
	   B.category,
       B.type,
       A.sales_qty * B.price AS 구매금액
FROM SALES AS A
LEFT JOIN PRODUCT AS B
ON A.product_code = B.product_code;

-- 조회
SELECT *
FROM sales_mart;

/*
2. (1)에서 생성한 데이터 마트를 활용해, category 및 type별 구매금액 합계를 구하기
*/
SELECT category,
	   type,
       SUM(구매금액) AS 구매금액_합계
FROM sales_mart
GROUP BY category, type;
