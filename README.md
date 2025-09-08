 A really small utility function to retrieve CPU load and other process related info.

 It can be used to augment pg_stat_activity.

```
 create or replace view pg_stat_activity_ext as
    select
           sys_info(pid) sys_info,
           *
           from pg_stat_activity
```
