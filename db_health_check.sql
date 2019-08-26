-- DB_HEALTH_CHECK H - 082619 - 3.0.0
set lines 500 pages 200;
column value                                                     format 999,999;
column METRIC_NAME                                               format a30;
column METRIC_UNIT                                               format a30;
column DB_WT_TM_RATIO   heading "DB |Wait|Time|Ratio"            format 999
column DB_CPU_TM_RATIO  heading "DB |CPU|Time|Ratio"             format 999
column HOST_CPU_UTIL    heading "Host|CPU|Util|(%)"              format 999
column RSP_PER_TXN_MS   heading "Response|Time per| Txn (ms)"    format 999,999
column SQL_RSP_TM_MS    heading "SQL|Response|Time (ms)"         format 9,999.99
column USR_TXN_PER_SEC  heading "User|Txn/s"                     format 999,999
column TOTAL_READS      heading "Total|Read|MB/s"                format 9,999.9;
column TOTAL_WRITES     heading "Total|Write|MB/s"               format 9,999.9;
column EXECS_PER_SEC    heading "Execs|Per Sec"                  format 999,999;
column DB_BLOCK_CHANGES heading "Block|Changes|Per Sec"          format 999,999;
column END_TIME         heading "Snap|End|Time"
column DB_HEALTH        heading "Database|Health"                format a35 truncate;
column event            heading "Top|Wait|Event"                 format a20 truncate;
column wait_class       heading "Top|Wait|Class"                 format a15 truncate;
column TET              heading " "                              format a5  truncate;
set timing on;
select /*+ kt034795 DB_HEALTH_CHECK_3_0_0 LEADING(@"SEL$21625BFF" "from$_subquery$_022"@"SEL$38" "X$KEWMDRMV"@"SEL$4" "X$KEWMDRMV"@"SEL$7"
   "X$KEWMDRMV"@"SEL$10" "X$KEWMDRMV"@"SEL$13" "X$KEWMDRMV"@"SEL$16" "X$KEWMDRMV"@"SEL$19" "D"@"SEL$1"
   "X$KEWMDRMV"@"SEL$25" "X$KEWMDRMV"@"SEL$22" "T"@"SEL$1") */ w.end_time, w.DB_WT_TM_RATIO, c.DB_CPU_TM_RATIO, h.HOST_CPU_UTIL, r.RSP_PER_TXN_MS, s.SQL_RSP_TM_MS, B.DB_BLOCK_CHANGES,  E.EXECS_PER_SEC,u.USR_TXN_PER_SEC,d.TOTAL_READS, t.TOTAL_WRITES, nvl(a.wait_class,'CPU') as wait_class,regexp_replace(a.event, 'enq: ', '') as event,
	CASE
		WHEN w.DB_WT_TM_RATIO > 70  THEN                            chr(27)||'[48;5;'|| 196||'m'||'UNHEALTHY - HIGH WAITS'|| chr(27)||'[m' 
		WHEN h.HOST_CPU_UTIL  > 90  THEN                            chr(27)||'[48;5;'|| 196||'m'||'UNHEALTHY - HIGH CPU  '|| chr(27)||'[m'   
		WHEN r.RSP_PER_TXN_MS > 100 AND  w.DB_WT_TM_RATIO > 50 THEN chr(27)||'[48;5;'|| 196||'m'||'UNHEALTHY - WAITS     '|| chr(27)||'[m'  
		WHEN r.RSP_PER_TXN_MS > 100 AND  h.HOST_CPU_UTIL  > 50 THEN chr(27)||'[48;5;'|| 196||'m'||'UNHEALTHY - CPU       '|| chr(27)||'[m'  
		WHEN s.SQL_RSP_TM_MS  >   1 AND  w.DB_WT_TM_RATIO > 50 THEN chr(27)||'[48;5;'|| 196||'m'||'UNHEALTHY - WAITS     '|| chr(27)||'[m'  
		WHEN s.SQL_RSP_TM_MS  >   1 AND  h.HOST_CPU_UTIL  > 50 THEN chr(27)||'[48;5;'|| 196||'m'||'UNHEALTHY - CPU       '|| chr(27)||'[m'  
		ELSE                                                        chr(27)||'[48;5;'||  47||'m'||'HEALTHY'|| chr(27)||'[m' 
	END as DB_HEALTH, chr(27)|| '[0m' as TET
from
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value as DB_WT_TM_RATIO    from V$SYSMETRIC_HISTORY where metric_name = 'Database Wait Time Ratio'  and group_id =  2 and intsize_csec > 3000 ) W,
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value as DB_CPU_TM_RATIO   from V$SYSMETRIC_HISTORY where metric_name = 'Database CPU Time Ratio'   and group_id =  2 and intsize_csec > 3000 ) C,
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value as HOST_CPU_UTIL     from V$SYSMETRIC_HISTORY where metric_name = 'Host CPU Utilization (%)'  and group_id =  2 and intsize_csec > 3000 ) H,
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value*10 as RSP_PER_TXN_MS from V$SYSMETRIC_HISTORY where metric_name = 'Response Time Per Txn'     and group_id =  2 and intsize_csec > 3000 ) R,
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value*10 as SQL_RSP_TM_MS  from V$SYSMETRIC_HISTORY where metric_name = 'SQL Service Response Time' and group_id =  2 and intsize_csec > 3000 ) S,
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value as USR_TXN_PER_SEC   from V$SYSMETRIC_HISTORY where metric_name = 'User Transaction Per Sec'  and group_id =  2 and intsize_csec > 3000 ) U,
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value as EXECS_PER_SEC     from V$SYSMETRIC_HISTORY where metric_name = 'Executions Per Sec'        and group_id =  2 and intsize_csec > 3000 ) E,
(select to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, value as DB_BLOCK_CHANGES  from V$SYSMETRIC_HISTORY where metric_name = 'DB Block Changes Per Sec'  and group_id =  2 and intsize_csec > 3000 ) B,
(select  to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, round(sum(SMALL_READ_MBPS  + LARGE_READ_MBPS),2)  as TOTAL_READS  from v$IOFUNCMETRIC_HISTORY group by to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI')) D,
(select  to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI') as end_time, round(sum(SMALL_WRITE_MBPS + LARGE_WRITE_MBPS),2) as TOTAL_WRITES from v$IOFUNCMETRIC_HISTORY group by to_char(trunc(end_time,'MI'), 'DD-MON-YYYY HH24:MI')) T,
(select end_time, event, wait_class from (WITH CTE as    (select to_char(sample_time,'DD-MON-YYYY HH24:MI') end_time, wait_class,nvl(event,'CPU') as event, count(*) CNT from   v$active_session_history where sample_time > sysdate - 1/23.5 group by to_char(sample_time,'DD-MON-YYYY HH24:MI'), event, wait_class order by 1, 3)
select rank( ) over (partition by end_time order by CNT desc) as rank, CTE.* from CTE) where rank=1 order by end_time) a
where W.end_time = c.end_time
and   C.end_time = H.end_time
and   H.end_time = R.end_time
and   R.end_time = S.end_time
and   S.end_time = U.end_time
and   U.end_time = D.end_time
and   D.end_time = T.end_time
and   T.end_time = A.end_time
and   A.end_time = W.end_time
and   W.end_time = D.end_time
and   W.end_time = T.end_time
and   E.end_time = B.end_time
and   B.end_time = D.end_time
and   D.end_time = U.end_time
order by 1;
