USE practice;

-- 연산자 : 비교 연산자
/*
= : 같음
성별이 남자인 데이터 찾기
*/
SELECT *
FROM customer
WHERE gender = "man";

/*
<> : 같지 않음
성별이 남자가 아닌 데이터 찾기
*/
SELECT *
FROM customer
WHERE gender <> "man";

/*
>= : ~보다 크거나 같음
년도가 2020보다 크거나 같은 데이터 찾기
*/
SELECT *
FROM customer
WHERE year(join_date) >= 2020;

/*
<= : ~보다 작거나 같음
2020년보다 작거나 같은 데이터 찾기
*/
SELECT *
FROM customer
WHERE year(join_date) <= 2020;

/*
> : ~보다 큼
< : ~보다 작음
2019년보다 큰 데이터 찾기, 2020년보다 작은 데이터 찾기
*/
SELECT *
FROM customer
WHERE year(join_date) > 2019;

SELECT *
FROM customer
WHERE year(join_date) < 2020;

-- 논리 연산자
/*
AND : 앞, 뒤 조건 모두 만족
NOT : 뒤에 오는 조건과 반대
OR : 하나라도 만족

1. 남자이고 경기도에 사는 데이터 찾기
2. 남자가 아니고 경기도에 사는 데이터
3. 남자이거나 경기도에 사는 손님 데이터
*/
SELECT *
FROM customer
WHERE (gender = "man") AND (addr = "Gyeonggi");

-- 괄호가 있어야 not이 전체 조건에 적용된다.
SELECT *
FROM customer
WHERE NOT gender = "man" AND addr = "Gyeonggi";

SELECT *
FROM customer
WHERE (gender = "man") or (addr = "Gyeonggi");

-- 특수 연산자
/*
between A and B : a와 b의 값 사이
not between A and B : a와 b의 값 사이가 아님
in (list) : 리스트 값
not in (list) : 리스트 값이 아님
like "비교문자열" : ~로 시작, ~로 끝, ~를 포함, ~를 제외
is null, is not null

1. 생일년도가 2010와 2011 사이인 손님 데이터
2. 생일년도가 1950와 2020 사이가 아닌 손님 데이터
3. 셍일년도가 2010, 2011인 손님 데이터
4. 생일년도가 2010, 2011이 아닌 손님 데이터
*/
SELECT *
FROM customer
WHERE year(birthday) BETWEEN 2010 AND 2011;

SELECT *
FROM customer
WHERE year(birthday) NOT BETWEEN 1950 AND 2020;

SELECT *
FROM customer
WHERE YEAR(birthday) IN (2010, 2011);

SELECT *
FROM customer
WHERE YEAR(birthday) NOT IN (2010, 2011);

SELECT *
FROM customer
WHERE addr LIKE "D%";

SELECT *
FROM customer
WHERE addr LIKE "%N";

SELECT *
FROM customer
WHERE addr LIKE "%EO%";

SELECT *
FROM customer
WHERE addr NOT LIKE "%EO%";

SELECT *
FROM customer AS A
LEFT JOIN sales AS B
ON A.mem_no = B.mem_no
WHERE B.mem_no IS NULL;

SELECT *
FROM sales
WHERE mem_no = "1001738";

SELECT *
FROM customer AS A
LEFT JOIN sales AS B
ON A.mem_no = B.mem_no
WHERE B.mem_no is not null;

-- 산술 연산자

SELECT *,
	   A.sales_qty * price AS 결제금액
FROM sales AS A
LEFT JOIN product AS B
ON A.product_code = B.product_code;

-- 집합 연산자

CREATE TEMPORARY TABLE sales_2019
SELECT *
FROM sales
WHERE YEAR(order_date) = "2019";

SELECT *
FROM sales_2019;

-- UNION : 2개 이상의 테이블 중복된 행 제거해서 집합 (열 개수와 데이터 타입이 일치해야 함.)
SELECT *
FROM sales_2019
UNION
SELECT *
FROM sales;

-- UNION ALL : 2개 이상 테이블 중복된 행 제거 없이 집합 (열 개수와 데이터 타입 일치)
SELECT *
FROM sales_2019
UNION ALL
SELECT *
FROM sales;

-- 단일 행 함수
-- 숫자형 함수
/*
ABS(숫자) : 절댓값 반환
ROUND(숫자, n) : n 가준으로 반올림 값 반환
SQRT(숫자) : 제곱근 값 반환
*/
SELECT ABS(-200);
SELECT ROUND(2.18, 1);
SELECT SQRT(9);

-- 문자형 함수
/*
LOWER(문자) / UPPER(문자) : 소문자 / 대문자 반환
LEFT(문자, n) / RIGHT(문자, n) : 왼쪽 / 오른쪽부터 n만큼 반환
LENGTH(문자) : 문자수 반환
*/
SELECT lower("AB");
SELECT upper("ab");
SELECT left("AB", 1);
SELECT right("AB", 1);
SELECT LENGTH("AB");

-- 날짜형 함수
/*
YEAR / MONTH / DAY(날짜) : 연, 월, 일 반환
DATE_ADD(날짜, INTERVAL) : INTERVAL 만큼 더한 값 반환
DATEDIFF(날짜a, 날짜b) : 날짜a - 날짜b 일수 변환
*/
SELECT YEAR("2022-12-31");
SELECT MONTH("2022-12-31");
SELECT DAY ("2022-12-31");
SELECT DATE_ADD("2022-12-31", INTERVAL -1 MONTH);
SELECT DATEDIFF("2022-12-31", "2022-12-1");

-- 형 변환 함수
/*
DATE_FORMAT(날짜, 형식) : 날짜 형식으로 변환
CAST(형식a, 형식b) : 형식 a를 형식 b로 변환
*/
SELECT DATE_FORMAT("2022-12-31", "%m-%d-%y");
SELECT DATE_FORMAT("2022-12-31", "%M-%D-%Y");
SELECT CAST("2022-12-31 12:00:00" AS DATE);

-- 일반 함수
/*
IFNULL(A, B) : A가 NULL이면 B를 반환, 아니면 A 반환
CASE WHEN [조건1] THEN [반환1]
	 WHEN [조건2] THEN [반환2]
     ELSE [나머지] END
: 여러 조건별로 반환값 지정
*/
SELECT IFNULL(NULL, 0);
SELECT IFNULL("NULL이 아님", 0);
SELECT *,
	   CASE WHEN gender = "MAN" THEN "남성"
			ELSE "여성" END
FROM customer;

-- 함수 중첩 사용
SELECT *,
	   YEAR(JOIN_DATE) AS 가입연도,
       LENGTH(YEAR(JOIN_DATE)) AS 가입연도_문자수
FROM customer;

-- 복수 행 함수
-- 집계 함수
SELECT COUNT(order_no) AS 구매횟수,
	   -- distinct : 중복제거
	   COUNT(distinct mem_no) AS 구매지수,
       SUM(sales_qty) AS 구매수량,
       AVG(sales_qty) AS 평균구매수량,
       MIN(order_date) AS 최초구매일자
FROM sales;

-- 그룹 함수
/*
with rollup : group by 열들을 오른쪽에서 왼쪽 순으로 그룹 (소계, 합계)
*/
SELECT YEAR(join_date) as 가입연도,
	   ADDR,
       COUNT(mem_no) AS 회원수
FROM customer
GROUP BY YEAR(join_date),
		 addr
WITH ROLLUP;

-- 집계함수 + group by
SELECT mem_no,
	   SUM(sales_qty) AS 구매수량
FROM sales
GROUP BY mem_no;

SELECT *
FROM sales
WHERE mem_no = "1000970";

-- 윈도우 함수
/*
순위 함수
1. ROW_NUMBER : 동일한 값이라고 고유한 순위 반환 (1, 2, 3, 4, ...)
2. RANK : 동일한 값이면 동일한 순위 반환 (1, 2, 3, 3, 5, ...)
3. DENSE_RANK : 동일한 값이면 동일한 순위 반환(+ 하나의 등수로 취급) (1, 2, 3, 3, 4, ...)
*/
SELECT order_date,
	   ROW_NUMBER() OVER (ORDER BY order_date ASC) AS 고유한_순위_반환,
       RANK() OVER (ORDER BY order_date ASC) AS 동일한_순위_반환,
       DENSE_RANK() OVER (ORDER BY order_date ASC) AS 동일한_순위_반환_하나의등수
FROM sales;

-- 순위함수 + PARTITION BY : 그룹별 순위
SELECT mem_no,
	   order_date,
       ROW_NUMBER() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 고유한_순위_반환,
       RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 동일한_순위_반환,
       DENSE_RANK () OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 동일한_순위_반환_하나의등수
FROM sales;

-- 집계 함수(누적)
SELECT order_date,
	   sales_qty,
       "-" AS 구분,
       COUNT(order_no) OVER (ORDER BY order_date ASC) AS 누적_구매횟수,
       SUM(sales_qty) OVER (ORDER BY order_date ASC) AS 누적_구매수량,
       AVG(sales_qty) OVER (ORDER BY order_date ASC) AS 누적_평균구매수량,
       MAX(sales_qty) OVER (ORDER BY order_date ASC) AS 누적_가장낮은구매수량
FROM sales;

-- 집계함수(누적) + PARTITION BY : 그룹별 집계 함수(누적)
SELECT mem_no,
	   order_date,
       sales_qty,
       "-" AS 구분,
       COUNT(order_no) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적_구매횟수,
       SUM(sales_qty) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적_구매수량,
       AVG(sales_qty) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적_평균구매수량,
       MAX(sales_qty) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적_가장높은구매수량,
       MIN(sales_qty) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적_가장낮은구매수량
FROM sales;