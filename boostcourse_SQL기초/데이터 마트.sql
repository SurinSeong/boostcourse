/*
데이터 마트
: 분석에 필요한 데이터를 가공한 분석용 데이터
- 요약변수 : 수집된 데이터를 분석에 맞게 종합한 변수
- 파생변수 : 사용자가 특정 조건 또는 함수로 의미를 부여한 변수
*/

USE practice;

/*
회원 분석용 데이터 마트
- 회원 구매 정보
*/
-- 회원 구매 정보
SELECT A.mem_no, A.gender, A.birthday, A.addr, A.join_date,
	   SUM(B.sales_qty * C.price) AS 구매금액,
       COUNT(B.order_no) AS 구매횟수,
       SUM(B.sales_qty) AS 구매수량
FROM customer AS A
LEFT JOIN sales AS B
ON A.mem_no = B.mem_no
LEFT JOIN product AS C
ON B.product_code = C.product_code
GROUP BY A.mem_no, A.gender, A.birthday, A.addr, A.join_date;

-- 회원 구매정보 임시테이블
CREATE TEMPORARY TABLE customer_pur_info AS
SELECT A.mem_no, A.gender, A.birthday, A.addr, A.join_date,
	   SUM(B.sales_qty * C.price) AS 구매금액,
       COUNT(B.order_no) AS 구매횟수,
       SUM(B.sales_qty) AS 구매수량
FROM customer AS A
LEFT JOIN sales AS B
ON A.mem_no = B.mem_no
LEFT JOIN product AS C
ON B.product_code = C.product_code
GROUP BY A.mem_no, A.gender, A.birthday, A.addr, A.join_date;

-- 확인
SELECT *
FROM customer_pur_info;

/*
회원 연령대
생년월일 -> 나이 -> 연령대
*/
SELECT *,
	   2021-YEAR(birthday) + 1 AS 나이
FROM customer;

SELECT *,
	   CASE WHEN 나이 < 10 THEN "10대 미만"
			WHEN 나이 < 20 THEN "10대"
            WHEN 나이 < 30 THEN "20대"
            WHEN 나이 < 40 THEN "30대"
            WHEN 나이 < 50 THEN "40대"
            ELSE "50대 이상"
		END AS 연령대
FROM (SELECT *,
			 2021-YEAR(birthday) + 1 AS 나이
	  FROM customer) AS A;
-- case when 함수 사용시 주의점 (순차적)

-- 회원 연령대 임시 테이블
CREATE TEMPORARY TABLE customer_ageband AS
SELECT A.*,
	   CASE WHEN 나이 < 10 THEN "10대 미만"
			WHEN 나이 < 20 THEN "10대"
            WHEN 나이 < 30 THEN "20대"
            WHEN 나이 < 40 THEN "30대"
            WHEN 나이 < 50 THEN "40대"
            ELSE "50대 이상"
		END AS 연령대
FROM (SELECT *,
			 2021-YEAR(birthday) + 1 AS 나이
	  FROM customer) AS A;
      
-- 확인
SELECT *
FROM customer_ageband;

-- 회원 구매정보 + 연령대 임시 테이블
CREATE TEMPORARY TABLE customer_pur_info_ageband AS
SELECT A.*,
	   B.연령대
FROM customer_pur_info AS A
LEFT JOIN customer_ageband AS B
ON A.mem_no = B.mem_no;

-- 확인
SELECT *
FROM customer_pur_info_ageband;

-- 회원 선호 카테고리
-- 회원 및 카테고리별 구매횟수 순위
SELECT A.mem_no,
	   B.category,
       COUNT(A.order_no) AS 구매횟수,
       ROW_NUMBER() OVER(PARTITION BY A.mem_no ORDER BY COUNT(A.order_no) DESC) AS 구매횟수_순위
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code
GROUP BY A.mem_no, B.category;

-- 회원 및 카테고리별 구매횟수 순위 + 구매횟수 순위 1위만 필터링
SELECT *
FROM (SELECT A.mem_no,
	   B.category,
       COUNT(A.order_no) AS 구매횟수,
       ROW_NUMBER() OVER(PARTITION BY A.mem_no ORDER BY COUNT(A.order_no) DESC) AS 구매횟수_순위
	  FROM sales AS A
      LEFT JOIN product AS B
      ON A.product_code = B.product_code
      GROUP BY A.mem_no, B.category) AS A
WHERE 구매횟수_순위 = 1;

-- 회원 선호 카테고리 임시테이블
CREATE temporary TABLE customer_pre_category AS
SELECT *
FROM (SELECT A.mem_no,
	   B.category,
       COUNT(A.order_no) AS 구매횟수,
       ROW_NUMBER() OVER(PARTITION BY A.mem_no ORDER BY COUNT(A.order_no) DESC) AS 구매횟수_순위
	  FROM sales AS A
      LEFT JOIN product AS B
      ON A.product_code = B.product_code
      GROUP BY A.mem_no, B.category) AS A
WHERE 구매횟수_순위 = 1;

SELECT *
FROM customer_pre_category;

-- 회원 구매정보 + 연령대 + 선호 카테고리 임시테이블
CREATE TEMPORARY TABLE customer_pur_info_ageband_pre_category AS
SELECT A.*,
	   B.category AS pre_category
FROM customer_pur_info_ageband AS A
LEFT JOIN customer_pre_category AS B
ON A.mem_no = B.mem_no;

-- 확인
SELECT *
FROM customer_pur_info_ageband_pre_category;

-- 회원 분석용 데이테 마트 생성 (회원 구매정보 + 연령대 + 선호 카테고리 임시테이블)
CREATE TABLE customer_mart AS
SELECT *
FROM customer_pur_info_ageband_pre_category;

-- 확인
SELECT *
FROM customer_mart;

-- 데이터 정합성 : 데이터가 서로 모순 없이 일관되게 일치함을 나타낼 때 사용
/*
1. 데이터 마트의 회원 수의 중복은 없는가?
2. 데이터 마트의 요약 및 파생변수의 오류는 없는가?
3. 데이터 마트의 구매자 비중(%)의 오류는 없는가?
*/
-- 1
SELECT *
FROM customer_mart;

SELECT COUNT(mem_no),
	   COUNT(DISTINCT mem_no)
FROM customer_mart;
-- 중복 없는 것 확인 !

-- 2
SELECT *
FROM customer_mart;
/*
회원 : 1000005 의 구매정보
구매금액 : 408000 / 구매횟수 : 3 / 구매수량 : 14
*/
SELECT SUM(A.sales_qty * B.price) AS 구매금액,
	   COUNT(A.order_no) AS 구매횟수,
       SUM(A.sales_qty) AS 구매수량
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code
WHERE mem_no = "1000005";

-- 회원 (1000005)의 선호 카테고리
-- pre_category : home
SELECT *
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code
WHERE mem_no = "1000005";

-- 3
-- 회원(customer) 테이블 기준, 주문(sales) 테이블 구매 회원번호 LEFT JOIN 결합
SELECT *
FROM customer AS A
LEFT JOIN (SELECT DISTINCT mem_no
		   FROM sales) AS B
ON A.mem_no = B.mem_no;

-- 구매여부 추가
SELECT *,
	   CASE WHEN B.mem_no IS NOT NULL THEN "구매"
			ELSE "미구매"
		END AS 구매여부
FROM customer AS A
LEFT JOIN (SELECT DISTINCT mem_no
		   FROM sales) AS B
ON A.mem_no = B.mem_no;

-- 구매여부별 회원수
SELECT 구매여부,
	   COUNT(mem_no) AS 회원수
FROM (SELECT A.*,
			 CASE WHEN B.mem_no IS NOT NULL THEN "구매"
				  ELSE "미구매"
			  END AS 구매여부
	  FROM customer AS A
      LEFT JOIN(SELECT DISTINCT mem_no
				FROM sales) AS B
	  ON A.mem_no = B.mem_no) AS A
GROUP BY 구매여부;

-- 확인 (미구매 : 1459 / 구매 : 1202)
SELECT *
FROM customer_mart
WHERE 구매금액 is null;

SELECT *
FROM customer_mart
WHERE 구매금액 is not null;