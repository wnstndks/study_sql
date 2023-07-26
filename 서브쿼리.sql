서브쿼리: query 속에 query가 있는 형태(주로 안쪽 질의의 결과를 바깥쪽에서 참조)
SELECT *FROM jikwon;
-- '박치기' 직원과 직급이 같은 직원 출력
select jikwon_jik FROM jikwon WHERE jikwon_name='박치기'; -- 문1
SELECT *FROM jikwon WHERE jikwon_jik='사원'; -- 문2

-- 문1+ 문2
SELECT *FROM jikwon WHERE jikwon_jik=(select jikwon_jik FROM jikwon WHERE jikwon_name='박치기');

-- 직급이 대리 중 가장 먼저 입사한 대리는 누구?
SELECT *FROM jikwon WHERE jikwon_ibsail=(SELECT MIN(jikwon_ibsail) FROM jikwon WHERE jikwon_jik='대리'); 
SELECT *FROM jikwon WHERE jikwon_ibsail=(SELECT MIN(jikwon_ibsail) FROM jikwon WHERE jikwon_jik='대리'); 

SELECT *FROM jikwon WHERE jikwon_jik='대리' 
AND jikwon_ibsail=(SELECT MIN(jikwon_ibsail) FROM jikwon WHERE jikwon_jik='대리');


select *FROM buser;

-- 인천에 근무하는 직원 출력
SELECT *FROM jikwon WHERE buser_num=(SELECT buser_no FROM buser WHERE not buser_loc='인천'); -- 서브쿼리로 얻을 수 있다.
 
-- 인천 이외에 지역에서 근무하는 직원 출력
SELECT *FROM jikwon WHERE buser_num IN (SELECT buser_no FROM buser WHERE not buser_loc='인천'); -- in으로 25명을 얻음 반환값이 복수면 in으로 받아야 한다.

SELECT *FROM gogek;
-- '김혜순' 고객과 담당 직원이 일치하는 직원 자료를 출력
SELECT *FROM gogek WHERE gogek_damsano= (SELECT gogek_damsano FROM gogek WHERE gogek_name='김혜순'); -- 한명이면 '='를 사용

-- '이영희' 고객과 나이가 같은 고객자료를 출력
SELECT *FROM gogek WHERE SUBSTR(gogek_jumin,1,2)= (SELECT SUBSTR(gogek_jumin,1,2) FROM gogek
WHERE gogek_name='이영희');


-- JIKWON, BUSER, GOGEK 테이블을 사용한다.

-- 문1) 2010년 이후에 입사한 남자 중 급여를 가장 많이 받는 직원은?
SELECT *FROM jikwon 
WHERE jikwon_ibsail>='2010-1-1' AND jikwon_gen='남' 
AND jikwon_pay= (SELECT MAX(jikwon_pay) FROM jikwon WHERE jikwon_ibsail>='2010-1-1' AND jikwon_gen='남');

-- 타겟을 정확하게 찝어주어야 한다.
-- 엄한 곳을 찍지 말자

-- 문2)  평균급여보다 급여를 많이 받는 직원은?
SELECT *FROM jikwon WHERE jikwon_pay > (SELECT avg(jikwon_pay) from jikwon);
 

-- 문3) '이미라' 직원의 입사 이후에 입사한 직원은?
select *from jikwon where jikwon_ibsail>(select jikwon_ibsail from jikwon where jikwon_name='이미라' );

-- 문4) 2010 ~ 2015년 사이에 입사한 총무부(10),영업부(20),전산부(30) 직원 중 급여가 가장 적은 사람은?
-- (직급이 NULL인 자료는 작업에서 제외*)

SELECT *
FROM   jikwon
WHERE  buser_num IN ( 10, 20, 30 )
       AND jikwon_ibsail BETWEEN '2010-1-1' AND '2016-1-1'
       AND jikwon_pay = (SELECT Min(jikwon_pay) FROM jikwon
                         WHERE  jikwon_jik IS NOT NULL
                                AND jikwon_ibsail BETWEEN
                                    '2010-1-1' AND '2016-1-1'); 
 
-- 문5) 한송이, 이순신과 직급이 같은 사람은 누구인가?

select *from jikwon 
where jikwon_jik=(select jikwon_jik from jikwon where jikwon_name='한송이') 
or jikwon_jik=(select jikwon_jik from jikwon where jikwon_name='이순신');

SELECT *FROM jikwon WHERE jikwon_jik IN (SELECT jikwon_jik FROM jikwon WHERE jikwon_name IN ('한송이','이순신')) ORDER BY jikwon_jik;

-- 서브쿼리는 무조건 안에것을 돌려본 후에 전체를 돌려야 한다.
 
-- 문6) 과장 중에서 최대급여, 최소급여를 받는 사람은?
select *from jikwon where jikwon_pay=(select min(jikwon_pay) from jikwon where jikwon_jik='과장')
OR jikwon_pay=(select max(jikwon_pay) from jikwon where jikwon_jik='과장');
 
SELECT *FROM jikwon WHERE jikwon_jik='과장' AND
jikwon_pay=(select min(jikwon_pay) from jikwon where jikwon_jik='과장')
OR jikwon_pay=(select max(jikwon_pay) from jikwon where jikwon_jik='과장');

-- 내가 한 것으로만 한다면 연봉이 똑같은 사람이 나올 수 있기 때문에 서브 쿼리 내 뿐만이 아니라 밖에서도 조건을 주어야 한다.

-- 문7) 10번 부서의 최소급여보다 많은 사람은?
select *from jikwon where jikwon_pay > (select min(jikwon_pay) from jikwon where buser_num=10);
 

-- 문8) 30번 부서의 평균급여보다 급여가 많은 '대리' 는 몇명인가?
select COUNT(*) as 인원수 from jikwon 
where jikwon_pay > (select avg(jikwon_pay) from jikwon where buser_num=30 and jikwon_jik='대리') 
AND jikwon_jik='대리';
 

-- 문9) 고객을 확보하고 있는 직원들의 이름, 직급, 부서명을 입사일 별로 출력하라.
 
select jikwon_name AS 이름, jikwon_jik AS 직급, buser_name AS 부서명, jikwon_ibsail AS 입사일 
from jikwon 
left outer JOIN buser ON buser.buser_no=jikwon.buser_num
where jikwon_no IN (select distinct gogek_damsano from gogek);


/* 문10) 이순신과 같은 부서에 근무하는 직원과 해당 직원이 관리하는 고객 출력

(고객은 나이가 30 이하면 '청년', 50 이하면 '중년', 그 외는 '노년'으로 표시하고, 고객 연장자 부터 출력)

출력 ==>  직원명    부서명     부서전화     직급      고객명    고객전화    고객구분

          한송이    총무부     123-1111    사원      백송이    333-3333    청년   
*/
 
SELECT jikwon_name AS 직원명, buser_name AS 부서명, buser_tel AS 부서전화, 
jikwon_jik as 직급, gogek_name as 고객명,gogek_tel AS 고객전화, 
		case	when	substr(now(),1,4) - (substr(gogek_jumin,1,2) + 1900 ) <= 30	then	'청년'
				when	substr(now(),1,4) - (substr(gogek_jumin,1,2) + 1900 ) <= 50 then	'중년'
				ELSE	'노년'	END	AS	고객구분
FROM gogek
INNER JOIN jikwon ON jikwon.jikwon_no=gogek.gogek_damsano
INNER JOIN buser ON buser.buser_no=jikwon.buser_num
WHERE buser_num = (SELECT buser_num FROM jikwon WHERE jikwon_name='이순신');

SELECT buser_num FROM jikwon;
-- DATE_FORMAT(NOW(),'%Y')-(1900+SUBSTR(gogek_jumin,1,2)) => 나이 구하는 방법