USE practice;
/*
재구매율 및 구매주기 분석 기준
재구매자 : 최초 구매일 이후, +1일 후 구매자
구매주기 : 구매간격 (최근 구매일자 - 최초 구매일자) / (구매횟수 - 1)
*/
/*
재구매율 및 구매주기 분석용 데이터 마트 생성하기
- FROM절 서브 쿼리 테이블 (회원번호, 최초 및 최근 구매일자, 구매횟수, 재구매 여부, 구매 간격, 구매주기)
*/
-- 데이터 마트 만들기
CREATE TABLE RE_PUR_CYCLE AS
SELECT *,
	   CASE WHEN (DATE_ADD(최초구매일자, INTERVAL +1 DAY) <= 최근구매일자) THEN 'Y'
			ELSE 'N'
		END AS 재구매여부,
        DATEDIFF(최근구매일자, 최초구매일자) AS 구매간격,
        CASE WHEN (구매횟수 - 1 = 0) OR (DATEDIFF(최근구매일자, 최초구매일자) = 0) THEN 0
			 ELSE DATEDIFF(최근구매일자, 최초구매일자) / (구매횟수 - 1)
		END AS 구매주기
FROM (
		SELECT mem_no,
			   MIN(order_date) AS 최초구매일자,
               MAX(order_date) AS 최근구매일자,
               COUNT(order_date) AS 구매횟수
        FROM sales
        WHERE mem_no <> '999999' -- 비회원 제외
        GROUP BY mem_no
        ) AS A;

-- 조회
SELECT *
FROM RE_PUR_CYCLE;

-- 회원 1000021의 구매정보
SELECT *
FROM RE_PUR_CYCLE
WHERE mem_no = '1000021';

-- 재구매 회원수 비중 (%)
SELECT COUNT(distinct mem_no) AS 구매회원수,
	   COUNT(distinct CASE WHEN (재구매여부 = 'Y') THEN MEM_NO END) AS 재구매회원수
FROM re_pur_cycle;

-- 평균 구매주기 및 구매주기 구간별 회원수
SELECT avg(구매주기) AS '평균 구매주기'
FROM re_pur_cycle
WHERE 구매주기 > 0;

SELECT *,
	   CASE WHEN 구매주기 <= 7 THEN '일주일 이내'
			WHEN 구매주기 <= 14 THEN '2주 이내'
            WHEN 구매주기 <= 21 THEN '3주 이내'
            WHEN 구매주기 <= 28 THEN '4주 이내'
            ELSE '4주 이후'
	   END AS 구매주기_구간
FROM re_pur_cycle
WHERE 구매주기 > 0;

SELECT 구매주기_구간, COUNT(*) AS 회원수
FROM ( SELECT *,
	   CASE WHEN 구매주기 <= 7 THEN '일주일 이내'
			WHEN 구매주기 <= 14 THEN '2주 이내'
            WHEN 구매주기 <= 21 THEN '3주 이내'
            WHEN 구매주기 <= 28 THEN '4주 이내'
            ELSE '4주 이후'
	   END AS 구매주기_구간
	   FROM re_pur_cycle
	   WHERE 구매주기 > 0 ) AS A
GROUP BY 구매주기_구간 ;
		
