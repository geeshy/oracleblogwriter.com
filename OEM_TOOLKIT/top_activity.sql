-- TOP_ACTIVITY Y - 062719 - 1.3.1
set lines 200 pages 200
select * from (
select '14'||chr(27)||'[48;5;'|| 47||'m'|| '       CPU               '|| chr(27)||'[m' as "LEGEND" from dual union
select '13'||chr(27)||'[48;5;'||254||'m'|| '      Idle              ' || chr(27)||'[m'  from dual union
select '12'||chr(27)||'[48;5;'||195||'m'|| '      Scheduler         ' || chr(27)||'[m'  from dual union
select '11'||chr(27)||'[48;5;'|| 21||'m'|| '       User I/O          '|| chr(27)||'[m'  from dual union
select '10'||chr(27)||'[48;5;'|| 39||'m'|| '       System I/O        '|| chr(27)||'[m'  from dual union
select ' 9'||chr(27)||'[48;5;'||124||'m'|| '      Concurrency       ' || chr(27)||'[m'  from dual union
select ' 8'||chr(27)||'[48;5;'||196||'m'|| '      Application       ' || chr(27)||'[m'  from dual union
select ' 7'||chr(27)||'[48;5;'||208||'m'|| '      Commit            ' || chr(27)||'[m'  from dual union
select ' 6'||chr(27)||'[48;5;'|| 95||'m'|| '       Configuration     '|| chr(27)||'[m'  from dual union
select ' 5'||chr(27)||'[48;5;'||242||'m'|| '      Administrative    ' || chr(27)||'[m'  from dual union
select ' 4'||chr(27)||'[48;5;'||248||'m'|| '      Network           ' || chr(27)||'[m'  from dual union
select ' 3'||chr(27)||'[48;5;'||249||'m'|| '      Queueing          ' || chr(27)||'[m'  from dual union
select ' 2'||chr(27)||'[48;5;'||252||'m'|| '      Cluster           ' || chr(27)||'[m'  from dual union
select ' 1'||chr(27)||'[48;5;'||213||'m'|| '      Other             ' || chr(27)||'[m'  from dual) order by 1 asc;
column CNT format 999;
set lines 600 pages 50000;
column sample_time format a20 truncate;
column PLOTTED_VALUE format a300 truncate;
set heading off;
select /*+ oracleblogwriter.com TOP_ACTIVITY 1.3.1 */ CPU.sample_time,
chr(27)||'[1;37m'||chr(27)||'[0;22m'  ,
--CPU.CNT,  UIO.CNT,APP.CNT,  ADMN.CNT, CLSTR.CNT, CMT.CNT, CNCR.CNT, CNFG.CNT, IDL.CNT, NTWRK.CNT, OTHR.CNT, QNG.CNT, SCHDLR.CNT, SIO.CNT, UIO.CNT,
      --chr(27)||'[1;37m' ||
	  chr(27)||'[48;5;'||47 ||'m'||    CPU.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||195||'m'|| SCHDLR.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||21 ||'m'||    UIO.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||39 ||'m'||    SIO.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||124||'m'||   CNCR.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||196||'m'||    APP.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||208||'m'||    CMT.PLOTTED_VALUE||
	  chr(27)||'[48;5;'|| 95||'m'||   CNFG.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||242||'m'||   ADMN.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||248||'m'||  NTWRK.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||249||'m'||    QNG.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||252||'m'||  CLSTR.PLOTTED_VALUE||
	  chr(27)||'[48;5;'|| 96||'m'||    IDL.PLOTTED_VALUE||
	  chr(27)||'[48;5;'||213||'m'||   OTHR.PLOTTED_VALUE||
	  chr(27)|| '[0m' as PLOTTED_VALUE,
	  chr(27)||'[0;22m'  as TEST from 
(select a.sample_time, b.cnt, substr( rpad('CC',(b.CNT),'CC'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and  session_state = 'ON CPU' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) CPU, 
(select a.sample_time, b.cnt, substr( rpad('UU',(b.CNT),'UU'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'User I/O' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) UIO,
(select a.sample_time, b.cnt, substr( rpad('AA',(b.CNT),'AA'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Application' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) APP,
(select a.sample_time, b.cnt, substr( rpad('AA',(b.CNT),'AA'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Administrative' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) ADMN,
(select a.sample_time, b.cnt, substr( rpad('CC',(b.CNT),'CC'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Cluster' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) CLSTR,
(select a.sample_time, b.cnt, substr( rpad('CC',(b.CNT),'CC'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Commit' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) CMT,
(select a.sample_time, b.cnt, substr( rpad('CC',(b.CNT),'CC'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Concurrency' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) CNCR,
(select a.sample_time, b.cnt, substr( rpad('CC',(b.CNT),'CC'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Configuration' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) CNFG,
(select a.sample_time, b.cnt, substr( rpad('II',(b.CNT),'II'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Idle' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) IDL,
(select a.sample_time, b.cnt, substr( rpad('NN',(b.CNT),'NN'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Network' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) NTWRK,
(select a.sample_time, b.cnt, substr( rpad('OO',(b.CNT),'OO'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Other' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) OTHR,
(select a.sample_time, b.cnt, substr( rpad('Q' ,(b.CNT),'Q' ),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Queueing' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) QNG,
(select a.sample_time, b.cnt, substr( rpad('SS',(b.CNT),'SS'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'Scheduler' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) SCHDLR,
(select a.sample_time, b.cnt, substr( rpad('SS',(b.CNT),'SS'),1,350) PLOTTED_VALUE from (select distinct to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time from v$active_session_history where sample_time > sysdate - 1/24) A, (select to_char(sample_time,'DD-MON-YYYY HH24:MI:SS') sample_time, count(*) as CNT from v$active_session_history where sample_time > sysdate - 1/24 and sample_time is not null and WAIT_CLASS = 'System I/O' group by to_char(sample_time,'DD-MON-YYYY HH24:MI:SS')) B where a.sample_time = b.sample_time(+) order by a.sample_time) SIO
where
CPU.SAMPLE_TIME    = UIO.SAMPLE_TIME    and
APP.sample_time    = ADMN.sample_time   and
ADMN.sample_time   = CLSTR.sample_time  and
CLSTR.sample_time  = CMT.sample_time    and
CMT.sample_time    = CNCR.sample_time   and
CNCR.sample_time   = CNFG.sample_time   and
CNFG.sample_time   = IDL.sample_time    and
IDL.sample_time    = NTWRK.sample_time  and
NTWRK.sample_time  = OTHR.sample_time   and
OTHR.sample_time   = QNG.sample_time    and
QNG.sample_time    = SCHDLR.sample_time and
SCHDLR.sample_time = SIO.sample_time    and
SIO.sample_time    = UIO.sample_time 
order by CPU.SAMPLE_TIME;
set heading on;
