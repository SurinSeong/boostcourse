USE practice;

-- 제품 성장률 분석
/*
1. 성장률은 월, 분기, 년 중 어떤 기준으로 계산할까?
2. 구매 금액 성장률이 가능 높은 카테고리는 무엇인가? beauty
3. 가장 많이 성장한 카테고리의 브랜드별 구매지표는 어떠한가?
*/
-- 제품 성장률 분석용 데이터 마트 생성
-- sales : mem_no, product : category, brand, 요약 및 파생 변수 : 구매금액, 분기

CREATE TABLE PRODUCT_GROWTH AS
SELECT A.mem_no,
	   B.category,
       B.brand,
       A.sales_qty * B.price AS 구매금액,
       CASE WHEN DATE_FORMAT(order_date, "%Y-%m") BETWEEN "2020-01" AND "2020-03" THEN "2020_1분기"
			WHEN DATE_FORMAT(order_date, "%Y-%m") BETWEEN "2020-04" AND "2020-06" THEN "2020_2분기"
		END AS 분기
FROM SALES AS A
LEFT JOIN PRODUCT AS B
ON A.product_code = B.product_code
WHERE DATE_FORMAT(order_date, "%Y-%m") BETWEEN "2020-01" AND "2020-06";

-- 조회
SELECT * FROM product_growth;

-- 1. 성장률
SELECT category,
	   SUM(CASE WHEN 분기 = '2020_1분기' THEN 구매금액 END) AS '2020_1분기_구매금액',
       SUM(CASE WHEN 분기 = '2020_2분기' THEN 구매금액 END) AS '2020_2분기_구매금액'
FROM product_growth
GROUP BY category;

SELECT A.*,
	   (2020_2분기_구매금액 / 2020_1분기_구매금액) - 1 AS 성장률
FROM (
		SELECT category,
				SUM(CASE WHEN 분기 = '2020_1분기' THEN 구매금액 END) AS '2020_1분기_구매금액',
				SUM(CASE WHEN 분기 = '2020_2분기' THEN 구매금액 END) AS '2020_2분기_구매금액'
		FROM product_growth
		GROUP BY category
        ) AS A
ORDER BY 4 DESC;
      
-- 3. 가장 많이 성장한 카테고리 (beauty)의 브랜드별 구매지표 (구매자수, 구매금액 합계, 인당 구매금액)는 어떠한가?
SELECT brand,
	   COUNT(DISTINCT mem_no) AS 구매자수,
       SUM(구매금액) AS '구매금액 합계',
       SUM(구매금액) / COUNT(DISTINCT mem_no) AS '인당 구매금액'
FROM product_growth
WHERE category = 'beauty'
GROUP BY 1
ORDER BY 3 DESC;