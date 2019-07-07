set lines 400 pages 200;
column SID               format 999999;
column serial            format 999999;
column P1                format 999999999999;
column P2                format 999999999999;
column P3                format 999999999999;
column EVENT             heading 'Wait|Event'    format a30;
column USERNAME          heading 'User|Name'     format a10 truncate;
column WAIT_CLASS        heading 'Wait|Class'    format a5  truncate;
column blocker_chain_id  heading 'Blkng|Chn|ID'  format 99;
column NUM_WAITERS       heading 'Blkd|Sess'     format a10;
column INST_ID           heading 'I_#'           format 99;
column IN_WAIT_SECS      heading 'Secs|in|Wait'  format 999,999;
column CHAIN_ID          heading 'Chn|ID'        format 99;
select /*+ oracleblogwriter.com OEM_TOOLKIT blocking_sessions */ lpad( '  ' , LEVEL, '    ' ) ||s.USERNAME as username,RPAD( '  ' , LEVEL , '        ' ) ||wc.num_waiters as num_waiters, wc.sid sid, wc.sess_serial# as SERIAL, s.INST_ID, s.sql_id, s.prev_sql_id, decode(s.wait_class,'Application','APPL', 'Other','OTHR', 'Idle','IDLE', 'Concurrency','CONCR', 'Cluster','CLSTR', 'Administrative','ADMN', 'User I/O','U_IO', 'System I/O','S_IO', 'Configuration','CONFIG') as wait_class, s.event, wc.P1, wc.P2, wc.P3, wc.IN_WAIT_SECS, blocker_chain_id, chain_id from 
v$wait_chains wc, gv$session s, gv$session bs, gv$instance i, gv$process p 
WHERE wc.instance = i.instance_number (+) AND (wc.instance = s.inst_id (+) and wc.sid = s.sid (+)  and wc.sess_serial# = s.serial# (+))  AND (s.final_blocking_instance = bs.inst_id (+) and s.final_blocking_session = bs.sid (+))  AND (bs.inst_id = p.inst_id (+) and bs.paddr = p.addr (+)) AND ( num_waiters > 0 OR ( blocker_osid IS NOT NULL AND in_wait_secs > 1 ))
CONNECT BY PRIOR wc.sid=wc.blocker_sid
AND PRIOR wc.sess_serial#=wc.blocker_sess_serial#
AND PRIOR wc.instance = wc.blocker_instance START WITH wc.blocker_is_valid='FALSE'
ORDER BY wc.chain_id, LEVEL;
