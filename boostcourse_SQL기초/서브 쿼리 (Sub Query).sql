/****** SELECT절 서브 쿼리 ******/
/* SELECT 명령문 안에 SELECT 명령문 */
SELECT *, (SELECT GENDER FROM CUSTOMER WHERE A.MEM_NO = MEM_NO) AS GENDER
FROM SALES AS A ;
/* JOIN과 같은 기능을 하지만 속도가 느려서 잘 사용하지 않는다. */

SELECT *
FROM customer
where mem_no = '1000970' ;

/****** FROM절 서브 쿼리 ******/
/* FROM절 명령문 안에 SELECT 명령문 */
SELECT *
FROM (
	  SELECT MEM_NO, COUNT(ORDER_NO) AS 주문횟수
      FROM SALES
      GROUP BY MEM_NO) AS A ;
/* FROM절 서브쿼리 : 열 및 테이블 명 지정 */

/****** WHERE절 서브 쿼리 ******/
/* WHERE 명령문 안에 SELECT 명령문 */
SELECT COUNT(ORDER_NO) AS 주문횟수
FROM SALES
WHERE MEM_NO in (SELECT MEM_NO FROM CUSTOMER WHERE YEAR(JOIN_DATE) = 2019) ;
/* YEAR : 날짜형 함수 / 연도 변환 */

SELECT *, YEAR(JOIN_DATE)
FROM CUSTOMER ;

SELECT MEM_NO FROM CUSTOMER WHERE YEAR(JOIN_DATE) = 2019;

SELECT COUNT(A.ORDER_NO) AS 주문횟수
FROM SALES AS A
INNER JOIN CUSTOMER AS B
ON A.MEM_NO = B.MEM_NO
WHERE YEAR(B.JOIN_DATE) = 2019 ;

/****** 서브 쿼리(Sub Query) + 테이블 결합(join) ******/
CREATE TEMPORARY TABLE SALES_SUB_QUERY
SELECT A.구매횟수, B.*
FROM (
	  SELECT MEM_NO, COUNT(ORDER_NO) AS 구매횟수
      FROM SALES
      GROUP BY MEM_NO
      ) AS A
INNER JOIN CUSTOMER AS B
ON A.MEM_NO = B.MEM_NO ;

/* 임시 테이블 조회 */
SELECT *
FROM SALES_SUB_QUERY ;

/* 성별이 남성 조건으로 필터링 */
SELECT *
FROM SALES_SUB_QUERY
WHERE gender = 'man';

/* 거주지역별로 구매횟수 집계 */
SELECT ADDR, SUM(구매횟수) AS 구매횟수
FROM SALES_SUB_QUERY
WHERE gender = 'man'
GROUP BY ADDR ;

/* 구매횟수 100회 미만 조건으로 필터링 */
SELECT ADDR, SUM(구매횟수) AS 구매횟수
FROM SALES_SUB_QUERY
WHERE gender = 'man'
GROUP BY ADDR
HAVING SUM(구매횟수) < 100 ;

/* 구매횟수가 낮은 순 */
SELECT ADDR, SUM(구매횟수) AS 구매횟수
FROM SALES_SUB_QUERY
WHERE gender = 'man'
GROUP BY ADDR
HAVING SUM(구매횟수) < 100
ORDER BY SUM(구매횟수) ASC ;