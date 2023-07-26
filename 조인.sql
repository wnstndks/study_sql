원하는 레코드를 뽑아다가 가상의 테이블을 만들어낼수 있다. -> select의 join
-- 복수 테이블로 부터 원하는 열 원하는 행을 뽑아올수 있다. -> join

-- 두개의 테이블에 공통칼럼이 있어야만 join을 할 수 있다.

/* 
inner join 테이블에서 각각 뽑아오고 싶다.
일치하는 레코드만 나온다.
outer join은 한쪽 테이블은 무조건 다나오고 반대쪽은 나오거나 말거나임
full outer join은 양쪽 다 나오는 것
테이블은 두개씩 join할 수 있음
테이블은 공통 칼럼이 있는 상태에서 몇 개씩 해
세개가 한꺼번에 join하는 방법은 없다.
*/


-- join : 하나 이상의 테이블에서 원하는 행과 열을 참조하는 select 문
-- 두개의 테이블 간 조인을 할 경우 공통 칼럼이 있어야 한다.

-- 1. cross join
-- 두개의 테이블 간 조인으로 한 테이블의 모든 행이 다른 테이블의 행과 각각 1:1 대응한다.
-- 실행 총 결과는 두 테이블 행 간 행을 곱하기 한 갯수가 된다.
-- 현실에서는 cross join을 할 일은 많진 않다.

SELECT jikwon_name, buser_name FROM jikwon, buser; -- jikwon, buser을 가지고 실행
SELECT jikwon_name, buser_name FROM jikwon CROSS JOIN buser; 
SELECT a.jikwon_name,b.jikwon_jik FROM jikwon a, jikwon b; -- cross join 중 혼자 하고 있으므로 self join

-- 2. NON-EQUI join
CREATE TABLE paygrade(grade INT PRIMARY KEY, lpay INT, hpay INT);
INSERT INTO paygrade VALUES(1,0,1999);
INSERT INTO paygrade VALUES(2,2000,2999);
INSERT INTO paygrade VALUES(3,3000,3999);
INSERT INTO paygrade VALUES(4,4000,4999);
INSERT INTO paygrade VALUES(5,5000,9999);

SELECT j.jikwon_name, j.jikwon_pay,p.grade FROM jikwon j,paygrade p
WHERE j.jikwon_pay>=p.lpay AND j.jikwon_pay <=p.hpay;

-- 3. EQUI join
SELECT *FROM jikwon WHERE jikwon_no=1;
SELECT *FROM buser WHERE buser_no=10; -- jikwon.buser_num, buser.buser_no 공통 컬럼
SELECT j.jikwon_name, b.buser_name FROM jikwon j, buser b WHERE j.buser_num=b.buser_no; -- 좀 더 정확히 얘기하자면 test.j.jikwon_name이다.

SELECT jikwon_name, buser_name FROM jikwon, buser WHERE buser_num=buser_no;
SELECT jikwon_no,jikwon_name,jikwon_jik, buser_name FROM jikwon, buser WHERE buser_num=buser_no;
-- 같다로 비교하면 equi JOIN 아니라면 non-equi 조인

SELECT *FROM jikwon;
DESC jikwon;
ALTER TABLE jikwon MODIFY buser_num INT NULL;
UPDATE jikwon SET buser_num=NULL WHERE jikwon_no=6;

INSERT INTO buser(buser_no,buser_name) VALUES(50,'비서실');
SELECT *FROM buser;

-- inner join : 두 테이블을 조인할 때, 두 테이블에 모두 지정한 열의 데이터가 있어야 한다.
-- 조건에 맞는 자료가 한 테이블에만 있는 경우에는 출력에 참여하지 않는다.

-- 방법1)
SELECT jikwon_no, jikwon_name, buser_name FROM jikwon j, buser b WHERE buser_num=buser_no; -- oracle에서 많이 사용하고 있는 join
SELECT jikwon_no, jikwon_name, buser_name FROM jikwon j, buser b 
WHERE buser_num=buser_no AND jikwon_gen='남';

-- 방법2)
SELECT jikwon_no,jikwon_name,buser_name FROM jikwon INNER JOIN buser ON buser_num=buser_no; -- ansi join 표준 sql
SELECT jikwon_no,jikwon_name,buser_name FROM jikwon INNER JOIN buser ON buser_num=buser_no WHERE jikwon_gen='남';

/*
똑같은 이름의 칼럼이 존재한다면 별명. 이 포함되어야 한다.
똑같은 이름의 칼럼이 존재하지 않는 다면 별명. 을 할 필요는 없다.
조건에 맞는 자료가 한쪽 테이블만 있는 경우 참여해야 한다.
*/


-- outer join : 한 개의 테이블에만 데이터가 있어도 결과가 나온다.
-- left outer join : 
SELECT jikown_no,jikwon_name,buser_name FROM jikwon, buser WHERE buser_num =buser_no(+); -- oracle join

SELECT jikwon_no,jikwon_name,buser_name FROM jikwon LEFT OUTER JOIN buser ON buser_num=buser_no; -- 6번은 나오나 buser_name에서 null값임

-- left outer join : 
SELECT jikown_no,jikwon_name,buser_name FROM jikwon, buser WHERE buser_num(+) =buser_no; -- oracle join

SELECT jikwon_no,jikwon_name,buser_name FROM jikwon Right OUTER JOIN buser ON buser_num=buser_no; -- 6번 직원은 작업에 참여하지 않음

-- full outer join : mariadb(mysql)은 지원하지 않음 
-- union을 이용해서 적용하기
SELECT jikown_no,jikwon_name,buser_name FROM jikwon FULL OUTER join buser WHERE buser_num =buser_no; -- oracle join

SELECT jikwon_no,jikwon_name,buser_name FROM jikwon LEFT OUTER JOIN buser ON buser_num=buser_no
UNION 
SELECT jikwon_no,jikwon_name,buser_name FROM jikwon RIGHT OUTER JOIN buser ON buser_num=buser_no

-- 공통 칼럼이 없다면 절대로 될수 없다.


-- 각 부서 내 근무자 목록(부서가 없는 직원은 제외)*
SELECT buser_name, jikwon_name, jikwon_jik, buser_tel FROM jikwon 
INNER JOIN buser ON jikwon.buser_num=buser.buser_no;

DESC jikwon;
SELECT *FROM gogek WHERE gogek_no=1; -- 고객 테이블의 goggek_damsano와 jikwon_jikwon_no 공통 칼럼

DESC gogek;
SELECT *FROM gogek WHERE gogek_no=1;

-- 관리 고객이 있는 직원만 출력
SELECT jikwon_no,jikwon_name,jikwon_jik,gogek_name,gogek_tel FROM jikwon INNER JOIN gogek
ON jikwon.jikwon_no=gogek.gogek_damsano ORDER BY jikwon_name;


-- 관리 고객에 상관없이 모든 직원 출력
SELECT jikwon_no,jikwon_name,jikwon_jik,gogek_name,gogek_tel FROM jikwon LEFT OUTER	JOIN gogek
ON jikwon.jikwon_no=gogek.gogek_damsano ORDER BY jikwon_name;

-- 부서별 급여합, 급여평균, 인원수, (부서가 없는 직원은 계약직으로 출력)*
SELECT nvl(buser_name,'계약직')as 부서, sum(jikwon_pay) AS 합, avg(jikwon_pay) as 평균, COUNT(*) as 인원수 FROM jikwon
LEFT OUTER JOIN FROM buser ON jikwon.buser_num=buser.buser_no GROUP BY buser_name; 



/*
문1) 직급이 '사원' 인 직원이 관리하는 고객자료 출력*
출력 ==>  사번   직원명   직급      고객명    고객전화    고객성별
            3     한국인   사원       우주인    123-4567       남

*/
select subSTR(gogek_jumin,8,1) FROM gogek;
select subSTR(gogek_jumin,8,1) FROM gogek;


SELECT jikwon_no AS 사번, jikwon_name AS 직원명,jikwon_jik AS 직급, 
gogek_name AS 고객명, gogek_tel AS 고객전화, 
case gogek_jumin when subSTR(gogek_jumin,8,1)=1 then '남' ELSE '여' END AS 고객성별
FROM jikwon JOIN gogek ON jikwon.jikwon_no=gogek.gogek_damsano WHERE jikwon_jik='사원' ;

case SUBSTRING(gogek_jumin,8,1) when 1

SELECT SUBSTRING(gogek_jumin,8,1) FROM gogek;

/*
문2) 직원별 고객 확보 수  -- GROUP BY 사용*
    - 모든 직원 참여
 */
 
-- 부서별 급여합, 급여평균, 인원수, (부서가 없는 직원은 계약직으로 출력)*
SELECT nvl(buser_name,'계약직')as 부서, sum(jikwon_pay) AS 합, avg(jikwon_pay) as 평균, COUNT(*) as 인원수 FROM jikwon
LEFT OUTER JOIN FROM buser ON jikwon.buser_num=buser.buser_no GROUP BY buser_name; 

 
SELECT *FROM jikwon;
SELECT *FROM gogek;

SELECT jikwon_name AS 직원명, COUNT(gogek_damsano) AS 확보_고객수
FROM jikwon left outer JOIN gogek ON jikwon.jikwon_no=gogek.gogek_damsano GROUP BY jikwon_no;

SELECT jikwon_no AS 직원, COUNT(*) AS 곡개
 

 
/*
문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면,  담당직원 자료 출력  

        :    ~ WHERE GOGEK_NAME='강나루'
출력 ==>  직원명       직급
                한국인       사원
                
*/

SELECT jikwon_name AS 직원명, jikwon_jik AS 직급 FROM jikwon 
JOIN gogek ON jikwon.jikwon_no=gogek.gogek_damsano WHERE gogek_name='강나루';



/*


문4) 직원명을 입력하면 관리고객 자료 출력
       : ~ WHERE JIKWON_NAME='이순신'
출력 ==> 고객명   고객전화          주민번호           나이
               강나루   123-4567    700512-1234567      38
*/

SELECT gogek_name as 고객명, gogek_tel as 고객전화, gogek_jumin AS 주민번호, 
timestampdiff(YEAR,DATE_FORMAT(SUBSTR(gogek_jumin,1,6),'%y%m%d'),NOW()) as 나이 FROM gogek
JOIN jikwon ON jikwon.jikwon_no=gogek.gogek_damsano WHERE jikwon_name='이순신'; 


SELECT *FROM gogek WHERE gogek_no<=3;






SELECT DATE_FORMAT(NOW(),'%y%m%d');

DATE_FORMAT(NOW(),'%y%m%d')-SUBSTR(gogek_jumin,1,6)
timestampdiff(year,jikwon_ibsail,NOW())

SELECT SUBSTR(NOW(),1,8);


/*
문1) 직급이 '사원' 인 직원이 관리하는 고객자료 출력
출력 ==>  사번   직원명   직급      고객명    고객전화    고객성별
           3     한국인   사원       우주인    123-4567       남
*/
SELECT jikwon_no AS 사번, jikwon_name AS 직원명, jikwon_jik AS 직급, gogek_name AS 고객명, gogek_tel AS 고객전화, 
-- SUBSTRING(gogekjumin,8,1)
case 
when gogek_jumin LIKE '_______1%' then '남' 
when gogek_jumin LIKE '_______3%' then '남' 
when gogek_jumin LIKE '_______2%' then '여' 
ELSE '여' END AS 고객성별 
FROM jikwon INNER JOIN gogek ON jikwon.jikwon_no=gogek.gogek_damsano WHERE jikwon_jik='사원';
 
 -- 문2) 직원별 고객 확보 수  -- GROUP BY 사용 - 모든 직원 참여
 
SELECT jikwon_name AS 직원, COUNT(gogek_damsano) AS 고객확보수  FROM jikwon LEFT outer JOIN gogek ON jikwon.jikwon_no=gogek.gogek_damsano GROUP BY jikwon_no;

 

/*
문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면,  담당직원 자료 출력  :    ~ WHERE GOGEK_NAME='강나루'
출력 ==>  직원명       직급
          한국인       사원
*/

SELECT jikwon_name AS 직원명, jikwon_jik AS 사원 FROM jikwon INNER JOIN gogek ON jikwon_no=gogek_damsano WHERE gogek_name='강나루';

/*    
문4) 직원명을 입력하면 관리고객 자료 출력 : ~ WHERE JIKWON_NAME='이순신'
출력 ==> 고객명   고객전화      주민번호        나이
        강나루   123-4567    700512-1234567      38
*/

SELECT gogek_name AS 고객명, gogek_tel AS 고객전화, gogek_jumin AS 주민번호, (SUBSTR(NOW(), 1, 4) - SUBSTR(gogek_jumin, 1, 4))   FROM gogek INNER JOIN jikwon ON jikwon_no=gogek_damsano WHERE jikwon_name='이순신';

*/



-- 한꺼번에 다 만들지 말고 조금씩 살을 붙여가면서 만들기 
-- 꼭 검증하는 버릇 기르기



-- 세 개의 테이블 join, buser.buser_no=jikwon.buser_num, jikwon.jikwon_no=gogek.gogek_damsano
SELECT jikwon_name AS 직원명, buser_name AS 부서명, gogek_name AS 고객명 FROM jikwon,buser,gogek 
WHERE buser.buser_no=jikwon.jikwon_num AND jikwon.jikwon_no=gogek.gogek_damsano;

SELECT jikwon_name AS 직원명, buser_name AS 부서명, gogek_name AS 고객명 FROM jikwon
inner join buser on buser.buser_no=jikwon.jikwon_num inner join gogek on jikwon.jikwon_no= gogek.gogek_damsano;



-- 문1) 총무부에서 관리하는 고객수 출력 (고객 30살 이상만 작업에 참여)
SELECT buser_name AS 부서명, COUNT(gogek_no) AS 관리 고객수 FROM gogkek 
-- 부서에 대한 인원수를 썼기에 *을 쓰면 안된다. 
-- 테이블이 복수개가 되었을 때는 *을 쓰는 지 여부를 제대로 판단해야 한다. 
-- 고객의 칼럼 중 널이 있는지 여부를 판단해야 한다.
INNER JOIN jikwon ON jikwon.jikwon_no= gogek.gogek_damsano
INNER JOIN buser ON buser.buser_no=jikwon.buser_num
WHERE buser_name ='총무부' AND DATE_FORMAT(NOW(),'%Y')-(19011+SUBSTR(gogek_jumin,1,2))>=30
GROUP BY buser_name;

-- 선생님 풀이
-- 대상이 고객이므로 카운트 안에 고객의 칼럼명을 쓰자
SELECT buser_name AS 부서명, COUNT(gogek_no) AS 관리 고객수 FROM jikwon
INNER JOIN buser ON buser.buser_no= jikwon.buser_num
INNER JOIN gogek ON jikwon.jikwon_no=gogek.gogek_damsano
WHERE buser_name ='총무부' AND DATE_FORMAT(NOW(),'%Y')-(19011+SUBSTR(gogek_jumin,1,2))>=30
GROUP BY buser_name;

-- 이너를 쓰고 있나 아우터를 쓰는 지에 집중

-- 문2) 부서명별 고객 인원수 (부서가 없으면 "무소속")
SELECT nvl(buser_name,'무소속') AS 부서명, COUNT(gogek_no) AS 고객수
FROM jikwon
LEFT OUTER JOIN buser ON buser.buser_no=jikwon.buser_num
INNER JOIN gogek ON jikwon.jikwon_no=gogek.gogek_damsano
GROUP BY buser_name


-- 문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면  담당직원 자료 출력  

--        :    ~ WHERE GOGEK_NAME='강나루'
-- 출력 ==>  직원명    직급   부서명  부서전화    성별

SELECT j.jikwon_name AS 직원명, j.jikwon_jik AS 직급, b.buser_name AS 부서명, 
b.buser_tel AS 부서전화, j.jikwon_gen AS 성별
FROM jikwon j
INNER JOIN buser b ON b.buser_no=j.buser_num
INNER JOIN gogek g ON j.jikwon_no=g.gogek_damsano
WHERE g.gogek_name='강나루';

-- 순서에는 이너 조인이기 때문에 문제가 없다.


-- 문4) 부서와 직원명을 입력하면 관리고객 자료 출력
--        ~ WHERE BUSER_NAME='영업부' AND JIKWON_NAME='이순신'
-- 출력 ==>  고객명    고객전화      성별
--            강나루   123-4567       남

SELECT gogek_name AS 고객명, gogek_tel AS 고객전화,
case
when gogek_jumin LIKE '%-1%' then '남'
when gogek_jumin LIKE '%-2%' then '여'
when gogek_jumin LIKE '%-3%' then '남'
when gogek_jumin LIKE '%-4%' then '여'
ELSE '외국인' END AS 성별
FROM gogek
INNER JOIN jikwon ON jikwon.jikwon_no=gogek.gogek_damsano
INNER JOIN buser ON buser.buser_no=jikwon.buser_num
WHERE buser_name='영업부' AND jikwon_name='이순신';


-- union : 구조가 일치하는 두 개 이상의 테이블 자료 합쳐 보기, 원래의 테이블은 계속 유지
CREATE TABLE pum1(bun INT,pummok VARCHAR(20));
INSERT INTO pum1 VALUES(1,'귤');
INSERT INTO pum1 VALUES(2,'사과');
INSERT INTO pum1 VALUES(3,'한라봉');

SELECT *FROM pum1;

CREATE TABLE pum2(num INT,sangpum VARCHAR(20));
INSERT INTO pum2 VALUES(10,'수박');
INSERT INTO pum2 VALUES(20,'딸기');
INSERT INTO pum2 VALUES(30,'토마토');
INSERT INTO pum2 VALUES(40,'참외');
SELECT *FROM pum2;

SELECT bun AS 번호, pummok AS 상품명 FROM pum1 UNION SELECT num,sangpum FROM pum2;