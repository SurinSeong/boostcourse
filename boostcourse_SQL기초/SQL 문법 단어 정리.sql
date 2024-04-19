USE PRACTICE ;

/****** 데이터 조회 ******/
/* 1. customer 테이블의 가입연도별 및 지역별 회원수를 조회 */
/* FROM 절, GROUP 절, SELECT 절, YEAR 및 COUNT 함수 활용 */
SELECT YEAR(JOIN_DATE), ADDR, COUNT(MEM_NO)
FROM CUSTOMER
GROUP BY YEAR(join_date), addr ;

/* 2. (1) 명령어에서 성별이 남성회원 조건을 추가한 뒤, 회원수가 50명 이상인 조건을 추가 */
/* WHERE절, HAVING절 활용 */
SELECT YEAR(JOIN_DATE) AS 가입년도, ADDR, COUNT(MEM_NO) AS 회원수
FROM CUSTOMER
WHERE gender = 'man'
GROUP BY YEAR(join_date), addr
HAVING COUNT(MEM_NO) >= 50 ;

/* 3. (2) 명령어에서 회원수를 내림차순으로 정렬 */
/* ORDER BY절 활용 */
SELECT YEAR(JOIN_DATE) AS 가입년도, ADDR, COUNT(MEM_NO) AS 회원수
FROM CUSTOMER
WHERE gender = 'man'
GROUP BY YEAR(join_date), addr
HAVING COUNT(MEM_NO) >= 50
ORDER BY COUNT(MEM_NO) DESC ;

/****** 데이터 조회 (SELECT) + 테이블 결합 (JOIN) ******/
/* 1. sales 테이블 기준으로 product 테이블을 left join 하기 */
/* LEFT JOIN 활용 */
SELECT *
FROM SALES AS A
LEFT JOIN PRODUCT AS B
ON A.PRODUCT_CODE = B.PRODUCT_CODE ;

/* 2. (1)에서 결합된 테이블을 활용해서, 브랜드별 판매수량을 구하기 */
/* GROUP BY절, SUM 함수 활용 */
SELECT BRAND, SUM(sales_qty) AS 판매수량
FROM SALES AS A
LEFT JOIN PRODUCT AS B
ON A.PRODUCT_CODE = B.PRODUCT_CODE
GROUP BY BRAND ;

/* 3. customer 및 sales 테이블을 활용해서, 회원가입하고 주문이력이 없는 회원수를 구하기 */
/* LEFT JOIN */
SELECT COUNT(A.MEM_NO) AS 회원수
FROM CUSTOMER AS A
LEFT JOIN SALES AS B
ON A.MEM_NO = B.MEM_NO
WHERE B.MEM_NO IS NULL ;

/****** 데이터 조회 (SELECT) + 테이블 결합 (JOIN) + 서브 쿼리 (Sub Query) ******/
/* 1. FROM절 서브쿼리를 활용해서, SALES 테이블의 PRODUCT_CODE별 판매수량을 구하기 */
/* FROM절 서브쿼리, SUM 함수 활용 */
SELECT *
FROM (
		SELECT PRODUCT_CODE, SUM(SALES_QTY) AS 판매수량
		FROM SALES
		GROUP BY PRODUCT_CODE
		) AS A ;

/* 2. (1) 명령어를 활용해서 PRODUCT 테이블과 LEFT JOIN 하기 */
/* LEFT JOIN */
SELECT *
FROM (
		SELECT PRODUCT_CODE, SUM(SALES_QTY) AS 판매수량
		FROM SALES
		GROUP BY PRODUCT_CODE
		) AS A
LEFT JOIN PRODUCT AS B
ON A.PRODUCT_CODE = B.PRODUCT_CODE ;

/* 3. (2) 명령어를 활용해서, 카테고리 및 브랜드별 판매수량을 구하기 */
/* GROUP BY 절, SUM 함수 활용 */
SELECT category, brand, SUM(판매수량) AS 판매수량
FROM (
		SELECT PRODUCT_CODE, SUM(SALES_QTY) AS 판매수량
		FROM SALES
		GROUP BY PRODUCT_CODE
		) AS A
LEFT JOIN PRODUCT AS B
ON A.PRODUCT_CODE = B.PRODUCT_CODE
GROUP BY category, brand;