USE practice;

SELECT *
FROM customer;

SELECT *
FROM customer
WHERE gender = "man";

SELECT addr, COUNT(MEM_NO) AS 회원수
FROM customer
WHERE gender = "man"
GROUP BY addr ;

SELECT addr, COUNT(MEM_NO) AS 회원수
FROM customer
WHERE gender = "man"
GROUP BY addr
HAVING COUNT(MEM_NO) < 100 ;

SELECT addr, COUNT(MEM_NO) AS 회원수
FROM customer
WHERE gender = "man"
GROUP BY addr
HAVING COUNT(MEM_NO) < 100
ORDER BY COUNT(MEM_NO) DESC ;

SELECT addr, COUNT(MEM_NO) AS 회원수
FROM customer
/* WHERE gender = "man" */
GROUP BY addr ;

/* 거주지역을 서울, 인천 조건으로 필터링 */
/* 거주지역 및 성별로 회원수 집계 */

SELECT ADDR, GENDER, COUNT(MEM_NO) AS 회원수
FROM customer
WHERE ADDR IN ('SEOUL', 'INCHEON')
GROUP BY ADDR, GENDER ;

/* SQL 명령어 작성법 */
/** 회원테이블(customer)을
    성별이 남성 조건으로 필터링해서
    거주지역별로 회원수 집계
    집계 회원수 100명 미만 조건으로 필터링
    모든 열 조회
    집계 회원수가 높은 순으로 **/
    
SELECT ADDR, COUNT(MEM_NO) AS 회원수
FROM customer
WHERE gender = "man"
GROUP BY ADDR
HAVING COUNT(MEM_NO) < 100
ORDER BY COUNT(MEM_NO) DESC ;

