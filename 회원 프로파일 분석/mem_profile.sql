USE practice;

/* 회원 프로파일 분석 */
-- 데이터 마트 만들기
CREATE TABLE CUSTOMER_PROFILE AS
SELECT A.*,
	   DATE_FORMAT(JOIN_DATE, "%Y-%m") AS 가입년월,
       2021 - YEAR(birthday) + 1 AS 나이,
       CASE WHEN 2021 - YEAR(birthday) + 1 < 20 THEN "10대 이하"
			WHEN 2021 - YEAR(birthday) + 1 < 30 THEN "20대"
            WHEN 2021 - YEAR(birthday) + 1 < 40 THEN "30대"
            WHEN 2021 - YEAR(birthday) + 1 < 50 THEN "40대"
            ELSE "50대 이상"
		END AS 연령대,
        CASE WHEN B.mem_no IS NOT NULL THEN "구매"
			 ELSE "미구매"
		END AS 구매여부
FROM customer AS A
LEFT JOIN (
			SELECT DISTINCT mem_no
			FROM sales
			) AS B
ON A.mem_no = B.mem_no;

-- 테이블 확인
SELECT *
FROM customer_profile;

-- 1. 가입년월별 회원수
SELECT 가입년월, COUNT(*) AS 회원수
FROM customer_profile
GROUP BY 가입년월;

SELECT * FROM customer_profile;

-- 2. 성별 평균 연령
SELECT gender, AVG(나이) AS '평균나이'
FROM customer_profile
GROUP BY gender;

-- 3. 성별 및 연령대별 회원수
SELECT gender AS 성별,
	   연령대,
       COUNT(*) AS '회원수'
FROM customer_profile
GROUP BY gender, 연령대
ORDER BY gender, 연령대;

SELECT * FROM customer_profile;
-- 3. 성별 및 연령대별 회원수 + 구매여부
SELECT gender, 연령대, 구매여부, COUNT(*) AS '인원수'
FROM customer_profile
GROUP BY gender, 연령대, 구매여부
ORDER BY 구매여부, gender, 연령대;