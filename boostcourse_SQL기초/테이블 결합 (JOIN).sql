USE PRACTICE;

/*** INNER JOIN ***/
/* 두 테이블의 공통 값이 매칭되는 데이터만 결합 */

/* customer + sales (inner join 사용) */
SELECT *
FROM customer AS A
INNER JOIN SALES AS B
ON A.MEM_NO = B.MEM_NO ;

/* customer 및 sales 테이블이 mem_no 기준으로 1:N 관계인지 확인 */
SELECT *
FROM customer AS A
INNER JOIN sales AS B
ON A.MEM_NO = B.MEM_NO
WHERE A.MEM_NO = '1000970' ;

/*** LEFT JOIN ***/
/* 두 테이블의 공통 값이 매칭괴는 데이터만 결합 + 왼쪽 테이블의 매칭되지 않는 데이터는 NULL */

/* customer + sales (LEFT JOIN) */
SELECT *
FROM customer AS A
LEFT JOIN SALES AS B
ON A.MEM_NO = B.MEM_NO ;
/* 회원 가입 후, 주문 이력이 있는 회원 + 회원 가입 후, 주문 이력이 없는 회원 */

/*** RIGHT JOIN ***/
/* 두 테이블의 공통 값이 매칭괴는 데이터만 결합 + 오른쪽 테이블의 매칭되지 않는 데이터는 NULL */

/* customer + sales (RIGHT JOIN) */
SELECT *
FROM customer AS A
RIGHT JOIN SALES AS B
ON A.MEM_NO = B.MEM_NO ;
/* 회원 가입 후, 주문 이력이 있는 회원 + 비회원 */

/****** 테이블 결합 + 테이블 조회 ******/
/* customer + sales (inner join) */
SELECT *
FROM CUSTOMER AS A
INNER JOIN SALES AS B
ON A.MEM_NO = B.MEM_NO ;

/* 임시 테이블 생성 */
CREATE temporary TABLE CUSTOMER_SALES_INNER_JOIN
SELECT A.*, B.ORDER_NO
FROM CUSTOMER AS A
INNER JOIN SALES AS B
ON A.MEM_NO = B.MEM_NO ;
/** 임시 테이블 (temporary table)은 서버 연결 종료시 자동으로 삭제됨 **/

/* 임시 테이블 조회 */
SELECT *
FROM customer_sales_inner_join ;

/* 성별이 남성 조건으로 필터링 */
SELECT *
FROM customer_sales_inner_join
WHERE gender = 'man' ;

/* 거주지역별로 구매횟수 집계 */
SELECT ADDR, COUNT(ORDER_NO) AS 구매횟수
FROM customer_sales_inner_join
WHERE gender = 'man'
GROUP BY ADDR ;

/* 구매횟수 100회 미만 조건으로 필터링 */
SELECT ADDR, COUNT(ORDER_NO) AS 구매횟수
FROM customer_sales_inner_join
WHERE gender = 'man'
GROUP BY ADDR
HAVING COUNT(ORDER_NO) < 100 ;

/* 구매횟수가 낮은 순으로 */
SELECT ADDR, COUNT(ORDER_NO) AS 구매횟수
FROM customer_sales_inner_join
WHERE gender = 'man'
GROUP BY ADDR
HAVING COUNT(ORDER_NO) < 100
ORDER BY COUNT(ORDER_NO) ASC ;

/****** 3가지 이상 테이블 결합 ******/
/* sales + customer + product (left join 이용) */
SELECT *
FROM SALES AS A
LEFT JOIN CUSTOMER AS B
ON A.MEM_NO = B.MEM_NO
LEFT JOIN PRODUCT AS C
ON A.PRODUCT_CODE = C.PRODUCT_CODE ;
