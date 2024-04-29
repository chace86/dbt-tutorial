with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as amount
    from payments
    group by order_id
)

select
    op.order_id,
    o.customer_id,
    o.order_date,
    op.amount
from order_payments op
left join orders o using (order_id)
