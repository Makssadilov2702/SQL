CREATE TABLE  t_temp (p1 integer, p2 text);
INSERT INTO t_temp
  SELECT i, md5(random()::text)
  FROM generate_series(1, 1000000) AS i;


EXPLAIN SELECT * FROM t_temp;

INSERT INTO t_temp
  SELECT i, md5(random()::text)
  FROM generate_series(1, 10) AS i;
  
ANALYZE t_temp;

EXPLAIN SELECT count(*) FROM t_temp WHERE  p2 like '%6cd' or p1>1500;
CREATE INDEX ON t_temp (p1 desc, p2);
drop index t_temp_p1_p2_idx
SET enable_seqscan = off;
SET enable_seqscan TO on;

EXPLAIN (ANALYZE,BUFFERS)  SELECT * FROM t_temp ORDER BY p1 desc;

alter table t_temp add constraint pk_t_int primary key(p1);
cluster test using pk_t_int;

select p1, count(p2) as c_p2 from t_temp group by p1 having count(p2)>1

delete from t_temp where p1>0 and p1<11


CREATE TABLE p_temp (p1 integer, p2 boolean);
INSERT INTO p_temp
  SELECT i, i%2=1
  FROM generate_series(1, 50) AS i;
SELECT * FROM p_temp;

ANALYZE t_temp;


EXPLAIN ANALYZE SELECT * FROM t_temp JOIN p_temp ON t_temp.p1=p_temp.p1;


CREATE INDEX ON t_temp(p1);
drop index t_temp_p1_idx


SHOW work_mem;