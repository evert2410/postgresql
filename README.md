 A really small utility function to retrieve CPU load and other process related info.

 It can be used to augment pg_stat_activity.

 create or replace view pg_stat_activity_ext as
    select
           sys_info(pid) sys_info,
           case
             when state = 'idle' then state_change - query_start
             else now() - state_change
           end query_duration,
           *
           from pg_stat_activity

