select 기본 형식
/* 

SELECT [DISTINCT] db명.소유자명.테이블명.칼럼명 [AS 별명], ... [INTO 테이블명] FROM 테이블명
WHERE 조건... ORDER BY 기준키 [ASC 또는 DESC], ...

*/

SELECT *FROM jikwon; -- 입력된 순서대로 칼럼의 이름들이 나옴 구조를 만들었을 때 그렇게 만들었기 때문
-- sql은 원래 랭귀지(자바, C 등) 안에 들어가면 무조건 문자열 maridb를 설치시 gui(그래픽 유저 인터페이스)를 지원 그래서 sql문을 연습할 수 있는 것

/*
윈도우 프로그램을 만들었어, 그럼 레이블에 표시를 하면 됨, html 을 통해서 브라우저에 보내주면 됨

db 서버가 거기 있고 직원자료가 100만개 내 컴퓨터로 부터 db 서버로 연결하면 100만개 모두가 넘어오지는 않음.
메모리 용량이 크기 때문에 SELECT 하면 일부만 읽어올수 있음

INSERT 내 컴퓨터의 임의의 공간에 넣는것 , db에 넣는 것이 아님, INSERT등 수정을  해서 LOG FILE내에 있는 내용들을 기억 하는 것
SELECT 디비 서버에서 읽어온 후 서버에 가지 않고 LOG FILE 저장된 것으로 사용, 내 컴퓨터에 있는 것만으로 기억하는 것
내컴퓨터에 있는 내용을 근거로 원본 데이터 내용을 갱신하고 싶을 때 COMMIT을 사용, 이것을 근거로 db가 수정되는 것
mariadb나 mysql에서는 오토커밋, 오라클은 내가 수정 후 커밋 명령어를 주어야 함

rollback은 내 컴퓨터에서 원래대로 돌아가고 싶을 때 사용, 버전 관리하듯이 사용
savepoint를 만들어두면 그 때까지로 돌아갈 수 있음

commit의 경우 수동으로 바꿔두고 작업하다가 commit을 함으로써 원본 데이터를 업데이트를 하고, 그걸 계속해서 사용해야 함

*/

DESC jikwon;
SELECT *FROM jikwon;
SELECT jikwon_no, jikwon_name, jikwon_pay FROM jikwon;
SELECT jikwon_name, jikwon_no, jikwon_pay FROM jikwon; 

-- 원본 테이블은 db에 있고, CLIENT에서 붙는 것 원래 순서는 구조를 짠 대로 되어있지만 내 컴퓨터에서 읽어오는 것이기에 내 컴퓨터에서 읽어오고 싶은 대로 할 수 있음
-- 램안에 가상의 테이블을 이용하여 테이블처럼 사용하는 것

SELECT jikwon.jikwon_no, jikwon.jikwon_name,jikwon.jikwon_pay FROM jikwon;

SELECT jikwon_no AS 사번, jikwon_name AS 직원명 FROM jikwon;
SELECT jikwon_no AS '사 번', jikwon_name AS 직원명 FROM jikwon; -- 별명을 주는데 별명에 공백이 있을때는 작은 따옴표를 주면 가능(권장하진 않음)
SELECT mytab.jikwon_no AS 사번, jikwon_name AS 직원명 FROM jikwon mytab;

SELECT 10,23+5,CONCAT('안녕',' 반가워')AS 메세지 FROM DUAL; -- select로 일시적으로 보여주는 것

SELECT jikwon_name AS 이름, jikwon_pay AS 연봉, jikwon_pay * 0.02 AS 세금 FROM jikwon;
-- 칼럼 명으로 연산이 가능

SELECT CONCAT(jikwon_name,'님') AS 이름 FROM jikwon;

SELECT distinct jikwon_jik FROM jikwon; -- 중복 배제


-- 정렬
SELECT *FROM jikwon ORDER BY jikwon_pay ASC; -- 순서가 정해져 있기에 순서를 바꾸면 안됨
SELECT *FROM jikwon ORDER BY jikwon_pay DESC;
SELECT *FROM jikwon ORDER BY jikwon_gen;
SELECT *FROM jikwon ORDER BY jikwon_gen ASC, jikwon_jik ASC, jikwon_pay DESC; -- gen 별로 정렬이 되는데 jik 별로 높은 것 그리고 jik가 같을 때 pay 별로 나눔
-- order by-> 그룹별로 모을 수 있음

-- 연산자 사용: 우선순위() > 산술 > 관계 > 비교 > isnull, like, in > between, not > and > or
-- 비교 연산 : =, !=, > , < , >= , <= , <>
-- 논리 연산 : and, or, not, between
 
SELECT *FROM jikwon WHERE jikwon_jik = '대리'; -- 레코드 제한
SELECT *FROM jikwon WHERE jikwon_ibsail = '2014-3-2';
SELECT *FROM jikwon WHERE jikwon_no = '2';
SELECT *FROM jikwon WHERE jikwon_no = 2;

-- 날짜와 문자는 작은 따옴표를 꼭 둘러야 한다. 숫자는 둘러도 되고 안둘러도 됨
-- 어차피 파이썬이나 자바로 가면 SQL은 문자열이기 때문

SELECT *FROM jikwon WHERE jikwon_no = 2 OR jikwon_no =5;
SELECT *FROM jikwon WHERE jikwon_no <= 2 OR jikwon_no >=28;
SELECT *FROM jikwon WHERE jikwon_jik ='사원' AND jikwon_gen='남' AND jikwon_pay <=3500;
SELECT *FROM jikwon WHERE jikwon_jik ='사원' AND (jikwon_gen='여' AND jikwon_ibsail >= '2017-1-1');

SELECT *FROM jikwon WHERE jikwon_jik <> '대리';
-- <> 은 != 과 같은 표현

SELECT *FROM jikwon WHERE jikwon_no >= 5 AND jikwon_no<=10;
SELECT *FROM jikwon WHERE jikwon_no BETWEEN 5 AND 10;
SELECT *FROM jikwon WHERE jikwon_ibsail BETWEEN '2015-1-1' AND '2016-12-31';

SELECT *FROM jikwon WHERE jikwon_no< 5 OR jikwon_no > 10; -- 긍정적 형태의 조건 - 속도가 빠름
SELECT *FROM jikwon WHERE jikwon_no not BETWEEN 5 AND 25; -- 부정적 형태의 조건 

-- 조건을 줄때는 긍정형태의 조건을 주는 것이 좋다. sql은 빨라야 하기에 빠른 것을 사용하는 것이 좋다.

SELECT *FROM jikwon WHERE jikwon_no >= 3+20;
SELECT *FROM jikwon WHERE jikwon_name >= '홍길동';
SELECT *FROM jikwon WHERE jikwon_name >= '박';
SELECT ASCII('a'),ASCII('b'),ASCII('가'),ASCII('나') FROM DUAL;

SELECT *FROM jikwon WHERE jikwon_name BETWEEN '김' AND '최';
-- 아스키코드로 문자도 대소비교가 가능하다.

-- in 조건 연산

SELECT *FROM jikwon WHERE jikwon_jik='대리' OR jikwon_jik='과장' OR jikwon_jik='부장';
SELECT *FROM jikwon WHERE jikwon_jik IN('대리','과장','부장');
SELECT *FROM jikwon WHERE jikwon_no IN(1,3,5,7);
SELECT *FROM jikwon WHERE buser_num IN(10,30) ORDER BY buser_num;

-- like 조건 연산 : %(0개 이상의 문자열), _ : (한 문자)를 의미

select *FROM jikwon WHERE jikwon_name LIKE '이%';
select *FROM jikwon WHERE jikwon_name LIKE '%라';
select *FROM jikwon WHERE jikwon_name LIKE '%순%'; -- 가운데 글자는 순이라는 글자가 포함되어있어야 함
select *FROM jikwon WHERE jikwon_name LIKE '이%라'; --가운데 글자는 몇 자이든 상관없이 첫번째 이, 마지막 라면 된다.
select *FROM jikwon WHERE jikwon_name LIKE '이_라'; -- 총 세글자로 한정이 됨

SELECT *FROM gogek WHERE gogek_name LIKE '이%'; -- 첫글짜만 이 뒤에는 아무거나 
SELECT *FROM gogek WHERE gogek_name LIKE '이_'; -- 두 글자짜리 밖에 안됨, 자릿수 확보
SELECT *FROM gogek WHERE gogek_name LIKE '__';
SELECT *FROM gogek WHERE gogek_jumin LIKE '_______1%';
SELECT *FROM gogek WHERE gogek_jumin LIKE '%-2%';

SELECT *FROM jikwon WHERE jikwon_pay LIKE '5%';
 

SELECT *FROM jikwon;
UPDATE jikwon SET jikwon_jik=NULL WHERE jikwon_no=5;
-- 업데이트가 내컴퓨터에서 되고 원본 데이터가 바로 커밋이 된것

SELECT *FROM jikwon;
SELECT *FROM jikwon WHERE jikwon_jik =NULL; -- 주의
SELECT *FROM jikwon WHERE jikwon_jik IS NULL; -- is null로 물어보기
SELECT *FROM jikwon WHERE jikwon_jik IS NOT NULL;


SELECT *FROM jikwon LIMIT 5;
SELECT *FROM jikwon LIMIT 5,3; 
SELECT *FROM jikwon WHERE jikwon_jik ='사원' LIMIT 2;  

-- 다양한 연산자 조합
SELECT jikwon_no AS 사번, jikwon_name AS 직원명, jikwon_jik AS 직급, jikwon_pay AS 연봉,
jikwon_pay/12 AS 보너스, jikwon_ibsail AS 입사일 FROM jikwon
WHERE jikwon_jik IN ('과장' '사원') AND
((jikwon_pay>=4000 AND jikwon_ibsail BETWEEN '2015-1-1' AND '2019-12-31') OR 
(jikwon_name LIKE '이%' AND jikwon_ibsail BETWEEN '2015-1-1' AND '2019-12-31'))
ORDER BY jikwon_jik ASC, jikwon_pay DESC LIMIT 3;

-- json data 형태로 출력
SELECT JSON_OBJECT('jikwon_no',jikwon_no,'jikwon_name',jikwon_name) AS 'jsondata'
FROM jikwon WHERE jikwon_jik='대리';

-- 내장 함수: 데이터 아이템 조작의 효율성 증진이 목표
-- 단일 행 함수 : 각 행 단위로 함수 결과가 진행
-- 문자 함수
SELECT LOWER('Hello'),UPPER('Hello'),CONCAT('hello','world') FROM DUAL;
SELECT substr('Hello World',3),substr('Hello world',3,2),substr('hello world',-3,2); 
SELECT LENGTH('Hello World'),INSTR('Hello World','e');
SELECT LOCATE('o','Hello World');
SELECT TRIM(' aabb bbaa '), LTRIM(' aabb bbaa '),RTRIM(' aabb bbaa '); -- TRIM 은 양쪽에 있는 공백을, LTRIM은 좌측, RTIM은 우측 공백을 없애는 것
SELECT REPLACE('010.111.1234','.','-');


-- 문> jikwon 테이블에서 이름에 '이'가 포함되는 직원이 있으면 '이'부터 두 글자만 출력.
-- 마지막에 '이가 있으면 '이 한글자만 출력

select jikwon_name,substr(jikwon_name,instr(jikwon_name,'이'),2) FROM jikwon WHERE jikwon_name LIKE '%이%';