조건 표현식(conditional expression)
-- 형식1) case 표현식 when 비교값 1 then 결과값1 when 비교값2 then 결과값2 [else 결과값n] end as 별명
SELECT case 10/5 when 5 then '안녕' when 2 then 'hello' else '잘가' END AS 결과 FROM DUAL;

SELECT jikwon_name, 
case jikwon_pay 
when 3000 then '와우 연봉 3000' 
when 3500 then '허걱 연봉 3500' 
ELSE '기타연봉' END AS result 
FROM jikwon 
WHERE jikwon_jik='사원';

SELECT jikwon_name, jikwon_pay, jikwon_jik,
case jikwon_jik
when '이사' then jikwon_pay * 0.05
when '부장' then jikwon_pay * 0.04
when '과장' then jikwon_pay * 0.03
else jikwon_pay * 0.02 END donation
FROM jikwon;

-- 형식2) case when 조건 then ~
SELECT jikwon_name,
case when jikwon_gen='남' then 'M'
when jikwon_gen='여' then 'W'
END AS gender FROM jikwon;

-- 케이스 한다음에 표현식이 나오지만 밑에는 조건이 when 뒤에 나와야 하므로 약간 형식이 틀리다.

SELECT jikwon_name, jikwon_pay,
case
when jikwon_pay>=7000 then '우수'
when jikwon_pay>=5000 then '보통'
ELSE '저조' END AS result
FROM jikwon WHERE jikwon_jik IN('사원','대리','과장');

-- case 다음에 표현식이 있느냐 when 다음에 조건이 있느냐로 형식 1과 2를 구분한다.

-- if(조건) 참값, 거짓값 as 별명
SELECT jikwon_name, jikwon_pay, jikwon_jik, if(TRUNCATE(jikwon_pay/1000,0)>=5,'good','normal') AS result FROM jikwon;

-- truncate= 자르기, 1000으로 나누고 


SELECT *FROM jikwon;




/*
문제1) 5년 이상 근무하면 '감사합니다', 그 외는 '열심히' 라고 표현 ( 2010 년 이후 직원만 참여 )

        특별수당(pay를 기준) : 5년 이상 5%, 나머지 3% (정수로 표시:반올림)

출력 형태 ==>   직원명   근무년수      표현           특별수당
*/

SELECT jikwon_name AS '직원명' , timestampdiff(YEAR, jikwon_ibsail,NOW()) AS '근무년수',
case
when timestampdiff(year,jikwon_ibsail,NOW()) >=5 then '감사합니다'
ELSE '열심히'  END AS '표현',
case
when TIMESTAMPDIFF(YEAR,jikwon_ibsail,NOW())>=5 then round(jikwon_pay*0.05)
ELSE round(jikwon_pay*0.03) END AS '특별수당'
FROM jikwon WHERE jikwon_ibsail>='2010-01-01';

-- format을 써서 데이트를 계산할 수도 있음
-- case를 통해서 가상의 칼럼이 만들어짐
-- 실질테이블은 아님, 가상의 테이블로 읽어들인 것
-- 자바에서는 램에 있는 클래스를 통해 테이블을 불러오는 방법이 있다.

/*

문제2) 입사 후 8년 이상이면 왕고참, 5년 이상이면 고참, 3년 이상이면 보통, 나머지는 일반으로 표현
출력==>  직원명    직급    입사년월일    구분      부서

*/
SELECT jikwon_name AS '직원명' , jikwon_jik AS '직급', jikwon_ibsail AS '입사년월일',
case
when timestampdiff(year,jikwon_ibsail,NOW()) >=8 then '왕고참'
when timestampdiff(year,jikwon_ibsail,NOW()) >=5 then '고참'
when timestampdiff(year,jikwon_ibsail,NOW()) >=3 then '보통'
ELSE '일반'  END AS '구분',
case 
when buser_num=10 then '총무부'
when buser_num=20 then '영업부'
when buser_num=30 then '전산부'
when buser_num=40 then '관리부'
END AS '부서'
FROM jikwon;

-- 연도만 뽑아서 써도 괜찮다.
-- timestampdiff만 있는 것이 아님
-- 


/*문제3)
문제3) 각 부서번호별로 실적에 따라 급여를 다르게 인상하려 한다. 

     pay를 기준으로 10번은 10%, 30번은 20% 인상하고 나머지 부서는 동결한다.

     8년 이상 장기근속을 O,X로 표시

     금액은 정수만 출력(반올림)

출력==>   사번    직원명   부서    연봉    인상연봉    장기근속
*/

SELECT jikwon_no AS '사번', jikwon_name AS '직원명' , buser_num AS '부서',round(jikwon_pay) AS '연봉',
case 
when buser_num= 10 then round(jikwon_pay+ jikwon_pay*0.1)
when buser_num= 30 then round(jikwon_pay+ jikwon_pay*0.2)
ELSE '동결' END AS '인상연봉',
case
when timestampdiff(year,jikwon_ibsail,NOW()) >=8 then 'o'
ELSE 'x'  END AS '장기근속'
FROM jikwon;

-- 복수행 함수(집계 함수): 전체 자료를 그룹별로 구분하여 통계 결과를 얻음

SELECT sum(jikwon_pay) AS 합, round(AVG(jikwon_pay)) AS 평균 FROM jikwon; 
-- 칼럼이 숫자일때는 합, 평균을 구할 수 있다, 전체를 대상으로 하고 있음

SELECT sum(jikwon_pay) AS 남자 합, round(AVG(jikwon_pay)) AS 남자평균 FROM jikwon WHERE jikwon_gen = '남';

SELECT MAX(jikwon_pay) AS 최고연봉, MIN(jikwon_pay) AS 최소연봉, 
STD(jikwon_pay), VAR_SAMP(jikwon_pay) AS 분산 as 표준편차 FROM jikwon;
-- 표준편차를 통해 평균을 기준으로 어떤 형태를 띄고 있는지를 알 수 있다.
-- 분산, 평균, 표준편차를 알고 있으면 딥러닝까지는 일사천리


SELECT AVG(jikwon_pay), AVG(nvl(jikwon_pay,0)) FROM jikwon; -- 5386.2069, 5206.6667
SELECT SUM(jikwon_pay)/29,SUM(jikwon_pay)/30 FROM jikwon; -- 5386.2069, 5206.6667

-- nvl을 통해 NULL일때는  0
-- 복수행 함수는 NULL은 작업에서 빠진다.
-- 인위적으로 nvl을 통해 pay를 0으로 주어서 컬럼의 개수를 작업에 포함

SELECT COUNT(jikwon_no) AS 건수, COUNT(*), COUNT(jikwon_pay) FROM jikwon; 
-- count는 null인 녀석과 상관없이 건수를 세는 것
-- 괄호안에 argument로 *을 주면 된다.

SELECT COUNT(*) FROM jikwon WHERE jikwon_gen='여';


-- 과장은 몇명?
SELECT COUNT(*) AS 인원수 FROM jikwon WHERE jikwon_jik='과장';

-- 2010 이전에 입사한 남직원은 몇명?
SELECT COUNT(*) AS 인원수 FROM jikwon WHERE jikwon_ibsail<'2010-1-1' AND jikwon_gen='남';

-- 2015년 이후 입사한 여직원의 연봉합, 평균, 인원수는?
SELECT SUM(jikwon_pay) AS 연봉합, round(AVG(jikwon_pay)) AS 평균, COUNT(*) AS 인원수 FROM jikwon WHERE jikwon_gen='여' AND jikwon_ibsail>'2015-1-1';