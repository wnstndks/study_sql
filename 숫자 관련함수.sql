숫자 함수
SELECT ROUND(45.6789), ROUND(45.6789,0), ROUND(45.6789,2), ROUND(45.6789,-1);

SELECT CEILING(4.7),FLOOR(4.7);
SELECT jikwon_name, jikwon_pay,ROUND(jikwon_pay*0.025,0) AS tex FROM jikwon;

SELECT TRUNCATE(45.6789,0),TRUNCATE(45.6789,1),TRUNCATE(45.6789,-1);
SELECT mod(15,2),15%2,15 MOD 2;

-- 날짜 함수
SELECT NOW(),SYSDATE(),CURDATE(),CURRENT_DATE(), CURRENT_DATE()+0;
SELECT ADDDATE(NOW(),3),SUBDATE(NOW(),3),ADDDATE(CURDATE(),500); -- 윤년 체크됨

SELECT NOW(),DATE_ADD(NOW(),INTERVAL 3 minute);
SELECT DATE_ADD(NOW(),INTERVAL 5 day);
SELECT DATE_ADD(NOW(),INTERVAL 2 MONTH);

SELECT NOW(),DATE_SUB(NOW(),INTERVAL 3 YEAR);
SELECT NOW(),DATE_SUB(NOW(),INTERVAL -3 YEAR);


SELECT DATEDIFF(NOW(),'2010-7-7'),DATEDIFF(NOW(),'2030-7-7');

SELECT TIMESTAMPDIFF(HOUR,'2022-1-1',NOW()),TIMESTAMPDIFF(QUARTER,'2022-1-1',NOW());


-- Date_format : 날짜형 자료 서식을 이용해 문자열로 출력 -> 날짜를 문자열로 출력하는 것

SELECT DATE_FORMAT(NOW(),'%y%m%d') AS a,DATE_FORMAT(NOW(),'%Y-%m-%d %H시 %i분 %S초') AS b;
SELECT date_format(NOW(),'%d'), DATE_FORMAT(NOW(),'%j'),DATE_FORMAT(NOW(),'%a'),DATE_FORMAT(NOW(),'%w');
select jikwon_name,jikwon_ibsail,DATE_FORMAT(jikwon_ibsail,'%w') FROM jikwon;

SELECT DATE_FORMAT(NOW(),FORMAT(NOW()-jikwon_ibsail) FROM jikwon;

-- STR_TO_DATE : 문자를 날짜형식으로 변환. oracle.의 to_DATE()와 유사
SELECT STR_TO_DATE('2023-03-12','%Y-%m-%d');

-- 숫자 format 함수
SELECT FORMAT(1234.567,2),FORMAT(1234.567,0),LPAD(56,7,0),RPAD(56,7,0);


-- 기타 함수
-- rank() 순위를 결정

SELECT jikwon_no,jikwon_name,jikwon_pay FROM jikwon ORDER BY jikwon_pay DESC;

SELECT jikwon_no,jikwon_name,jikwon_pay, jikwon_pay,rank() OVER (ORDER BY jikwon_pay),
DENSE_RANK() OVER(ORDER BY jikwon_pay) FROM jikwon; -- 오름차순

SELECT jikwon_no,jikwon_name,jikwon_pay, jikwon_pay,rank() OVER (ORDER BY jikwon_pay desc),
DENSE_RANK() OVER(ORDER BY jikwon_pay DESC ) FROM jikwon ; -- 내림차순

SELECT jikwon_no,jikwon_name,jikwon_ibsail, rank() OVER (ORDER BY jikwon_ibsail desc),
DENSE_RANK() OVER(ORDER BY jikwon_ibsail DESC ) FROM jikwon ;
-- RANK는 동점자를 포함하여 순위 계산을 하지만 dense는 동점자를 건너뛰고 순위계산을 함.


UPDATE jikwon SET jikwon_pay = NULL WHERE jikwon_no=6;

SELECT *FROM jikwon;

-- null 관련 함수
-- nvl(value1,value2) : value1이 null이면 value2를 사용.
SELECT jikwon_name, jikwon_jik,nvl(jikwon_jik, '임시직'),jikwon_pay, nvl(jikwon_pay,0) FROM jikwon;

-- nvl2(value1,value2,value3) : value1이 null인지 평가 후 null이면 value3을 아니면 value2를 취함
SELECT jikwon_name,nvl2(jikwon_jik,'정규직','임시직') AS jik, nvl2(jikwon_pay, jikwon_pay,0) AS pay FROM jikwon;

-- nullif(value1,value2) : 2개의 값이 일치하면 null을, 일치하지 않으면 value1을 취함
SELECT NULLIF(LENGTH('abcd'),LENGTH('123')) AS result;
SELECT NULLIF(LENGTH('abc'),LENGTH('123')) AS result;
SELECT jikwon_name, jikwon_jik, NULLIF(jikwon_jik, '대리') FROM jikwon;