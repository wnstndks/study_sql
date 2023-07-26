그룹 함수
group by 절 : 소계를 구할 때 사용

형식: 
select 그룹칼럼명, 계산함수(),...from 테이블명 
where 조건 group by 그룹칼럼명 having 출력결과 조건

group by절에는 order by를 사용할 수 없다. 단, 출력결과에 대한 order by는 가능하다.
*/

SELECT *FROM jikwon ORDER BY jikwon_gen; -- 남자끼리, 여자끼리 뭉침
SELECT *FROM jikwon GROUP BY jikwon_gen; -- group by를 하면 order by를 쓰고 있는 것

-- 성별 연봉의 평균
SELECT AVG(jikwon_pay) FROM jikwon;
SELECT AVG(jikwon_pay) FROM jikwon WHERE jikwon_gen='남';
SELECT AVG(jikwon_pay) FROM jikwon WHERE jikwon_gen='여';
SELECT AVG(jikwon_pay) FROM jikwon GROUP BY jikwon_gen; -- 위 두 줄을 한줄로 표현 할 수 있음

SELECT jikwon_gen AS 성별,AVG(jikwon_pay) as 평균, COUNT(*) as 인원수 FROM jikwon GROUP BY jikwon_gen; 
-- jikwon_gen을 사용함으로서 평균이 누구것인지, count로 인원수가 몇명인지를 알수 있음


-- 부서별 연봉합
SELECT buser_num AS 부서, SUM(jikwon_pay) AS 연봉합, COUNT(*) AS 인원수 FROM jikwon GROUP BY buser_num;

-- 부서별 연봉합 : 연봉합이 3,5000 이상만 출력에 참여
SELECT buser_num AS 부서, SUM(jikwon_pay) AS 연봉합, COUNT(*) AS 인원수 FROM jikwon GROUP BY buser_num HAVING sum(jikwon_pay) >=35000;
-- sum으로 이미 되어있는 값에 대해서 having에 조건을 넣을 수 있다. 일반 jikwon_pay는 사용할 수 없음

SELECT buser_num AS 부서, SUM(jikwon_pay) AS 연봉합, COUNT(*) AS 인원수 FROM jikwon GROUP BY buser_num HAVING 연봉합 >=35000;
-- 별명으로 조건에 참여할 수도 있다.

-- 부서별 연봉합 : 여직원만 참여
SELECT buser_num AS 부서, SUM(jikwon_pay) AS 연봉합, COUNT(*) AS 인원수 FROM jikwon where jikwon_gen='여' GROUP BY buser_num;
-- where가 앞, group by는 뒤에

-- 부서별 연봉합 : 연봉합이 15000 이상인 여직원만 참여
SELECT buser_num AS 부서, SUM(jikwon_pay) AS 연봉합, COUNT(*) AS 인원수 FROM jikwon where jikwon_gen='여' GROUP BY buser_num HAVING 연봉합>15000;

-- 주의 : group by 전에 order by를 사용하면 안됨
SELECT buser_num, SUM(jikwon_pay) FROM jikwon ORDER BY buser_num;

-- sum하고 떨어졌는데 그냥 합을 구한다, 그래서 buser_num은 의미가 없어짐
-->
SELECT buser_num, SUM(jikwon_pay) FROM jikwon ORDER BY buser_num;

SELECT buser_num, SUM(jikwon_pay) FROM jikwon ORDER BY buser_num des GROUP BY buser_num; -- ERROR

SELECT buser_num, SUM(jikwon_pay) AS 합 FROM jikwon GROUP BY buser_num ORDER BY 합 DESC;
-- group by 결과에 대한 것은 가능하다.

SELECT*FROM jikwon;


-- 문1) 직급별 급여의 평균 (NULL인 직급 제외)
SELECT jikwon_jik AS 직급, AVG(jikwon_pay) AS 급여 FROM jikwon where not jikwon_jik is null GROUP BY jikwon_jik;

-- 선생님 풀이
/*HAVING 뒤에는 IS NOT NULL을 쓰면 안된다
WHERE 뒤에 쓰기
*/

-- 문2) 부장,과장에 대해 직급별 급여의 총합
SELECT jikwon_jik AS 직급, SUM(jikwon_pay) AS 급여 FROM jikwon GROUP BY jikwon_jik HAVING jikwon_jik='부장' or jikwon_jik='과장';

-- 선생님 풀이
SELECT jikwon_jik AS 직급, SUM(jikwon_pay) AS 급여 FROM jikwon where 직급 IN ('부장','과장') GROUP BY jikwon_jik;


-- 문3) 2015년 이전에 입사한 자료 중 년도별 직원수 출력
SELECT DATE_FORMAT(jikwon_ibsail,'%Y') AS 년도, COUNT(*) AS 직원수 FROM jikwon where jikwon_ibsail<'2015-1-1' GROUP BY 년도 order by 년도;

-- having은 group by 결과에 대해서 재끼는 것이지, 먼저 where에서 조건으로 값을 걸러야 한다.

-- 문4) 직급별 성별 인원수, 급여합 출력 (NULL인 직급은 임시직으로 표현)
SELECT nvl(jikwon_jik,'임시직') as 직급, count(case when jikwon_gen='남'then 1 end) AS '남',count(case when jikwon_gen='여' then 1 end) AS '여',sum(jikwon_pay) AS 급여합 
FROM jikwon GROUP BY jikwon_jik;

-- 선생님풀이
SELECT nvl(jikwon_jik,'임시직') AS 직급, jikwon_gen AS 성별, COUNT(*) AS 인원수, SUM(jikwon_pay) AS 급여합 FROM jikwon group by jikwon_jik, jikwon_gen ORDER BY jikwon_jik;

-- 문5) 부서번호 10,20에 대한 부서별 급여 합 출력

select buser_num AS 부서, SUM(jikwon_pay) as 급여총합 FROM jikwon GROUP BY 부서 HAVING 부서=10 or 부서=20;

-- 이건 왜 안될까?
select buser_num AS 부서, SUM(jikwon_pay) as 급여총합 FROM jikwon WHERE 부서=10 or 부서=20 GROUP BY 부서;

-- 문6) 급여의 총합이 7000 이상인 직급 출력(NULL인 직급은 임시직으로 표현)
SELECT nvl(jikwon_jik,'임시직') AS 직급, SUM(jikwon_pay) AS 급여총합 FROM jikwon GROUP BY jikwon_jik HAVING 급여총합>=7000;

-- 문7) 직급별 인원수, 급여합계를 구하되 인원수가 3명 이상인 직급만 출력
--        (NULL인 직급은 임시직으로 표현)
SELECT nvl(jikwon_jik,'임시직') AS 직급, SUM(jikwon_pay) AS 급여합계,COUNT(*) AS 인원수 FROM jikwon GROUP BY jikwon_jik HAVING 인원수>=3; 
