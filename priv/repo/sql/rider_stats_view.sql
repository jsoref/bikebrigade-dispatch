create
or replace view rider_stats as
select
  assigned_rider_id as rider_id,
  program_id,
  count(tasks.id) as task_count,
  sum(delivery_distance) as total_distance,
  count(distinct campaigns.id) as campaign_count,
  count(distinct program_id) as program_count
from
  tasks
  left join campaigns on campaigns.id = tasks.campaign_id
where
  tasks.assigned_rider_id IS NOT NULL
  and campaigns.delivery_start <= NOW()
group by
  ROLLUP(assigned_rider_id, program_id)