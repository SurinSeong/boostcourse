USE practice;
SELECT * FROM customer;
/*
RFM : 고객의 가치를 분석할 때 사용되는 고객가치 평가 모형
Recency - 최근성
Frequency - 구매빈도
Monetary - 구매금액
==> RFM 분석용 데이터 마트 생성하기 : customer 테이블 + 구매금액, 구매횟수 (주문일자 : 2020년)
*/
-- 데이터 마트 만들기
CREATE TABLE RFM AS
SELECT A.*,
	   B.구매금액,
       B.구매횟수
FROM customer AS A
LEFT JOIN (
			SELECT A.mem_no,
				   SUM(A.sales_qty * B.price) AS '구매금액', -- Monetary : 구매금액
                   COUNT(A.order_no) AS '구매횟수' -- Frequency : 구매빈도
            FROM SALES AS A
            LEFT JOIN PRODUCT AS B
            ON (A.product_code = B.product_code)
            WHERE year(A.order_date) = "2020" -- Recency : 최근성
            GROUP BY A.mem_no
            ) AS B
ON (A.mem_no = B.mem_no);

-- 테이블 확인
SELECT * FROM RFM;

-- 세분화별 회원수
/*
VIP : 5000000 초과
우수회원 : 1000000 초과 또는 구매횟수 3번 넘는 경우
일반회원 : 0 초과
잠재회원 : 가입만 한 사람
*/
SELECT *,
	   CASE WHEN 구매금액 > 5000000 THEN 'VIP'
			WHEN (구매금액 > 1000000) OR (구매횟수 > 3) THEN '우수회원'
            WHEN 구매금액 > 0 THEN '일반회원'
            ELSE '잠재회원'
		END AS 회원세분화
FROM RFM;

SELECT 회원세분화, COUNT(*) AS 회원수
FROM (
		SELECT *,
			CASE WHEN 구매금액 > 5000000 THEN 'VIP'
				 WHEN (구매금액 > 1000000) OR (구매횟수 > 3) THEN '우수회원'
				 WHEN 구매금액 > 0 THEN '일반회원'
				 ELSE '잠재회원'
			END AS 회원세분화
		FROM RFM
        ) AS A
GROUP BY 회원세분화
ORDER BY 회원세분화;

-- 세분화별 매출액
SELECT 회원세분화, SUM(구매금액) AS 구매금액
FROM (
		SELECT *,
			CASE WHEN 구매금액 > 5000000 THEN 'VIP'
				 WHEN (구매금액 > 1000000) OR (구매횟수 > 3) THEN '우수회원'
				 WHEN 구매금액 > 0 THEN '일반회원'
				 ELSE '잠재회원'
			END AS 회원세분화
		FROM RFM
        ) AS A
GROUP BY 회원세분화
order by 1;

-- 세분화별 인당 구매금액
SELECT 회원세분화, AVG(구매금액) AS '인당 구매금액'
FROM (
		SELECT *,
			CASE WHEN 구매금액 > 5000000 THEN 'VIP'
				 WHEN (구매금액 > 1000000) OR (구매횟수 > 3) THEN '우수회원'
				 WHEN 구매금액 > 0 THEN '일반회원'
				 ELSE '잠재회원'
			END AS 회원세분화
		FROM RFM
        ) AS A
GROUP BY 회원세분화
order by 1;