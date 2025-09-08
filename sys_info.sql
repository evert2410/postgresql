-- © 2025 Evert Carton <evert@letshavealook.info>

create or replace function sys_info(pid int, psutil_interval float default 0.05) returns jsonb
as $$
  import psutil
  import json

  try:
    p = psutil.Process(pid)
  except:
    plpy.error(f"Process id {pid} does not exist.")
  
  if psutil_interval < 0:
    plpy.error("Invalid interv value. Value should be >=0.")

  try:

    io = p.io_counters()
    mem = p.memory_full_info()

    return json.dumps({ 
           "pid": pid,
           "global":{"cpu_count": psutil.cpu_count(),
                     "cpu_pct": psutil.cpu_percent()},
           "ppid": p.ppid(),
           "cpu_pct": p.cpu_percent(psutil_interval),
           "mem_pct": p.memory_percent(),
           "io_counters": { "read_count": io.read_count,
                            "write_count": io.write_count,
                            "read_bytes": io.read_bytes,
                            "write_bytes": io.write_bytes},
           "mem_info": {"data": mem.data,
                        "text": mem.text,
                        "rss": mem.rss,
                        "vms": mem.vms,
                        "shared": mem.shared,
                        "dirty": mem.dirty,
                        "uss": mem.uss,
                        "pss": mem.pss,
                        "swap": mem.swap}})
        
  except Exception as exc:
    return json.dumps({"error": repr(exc)})

$$ language plpython3u stable leakproof parallel safe;

