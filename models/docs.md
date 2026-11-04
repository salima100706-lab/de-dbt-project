{% docs _overview_ %}
# Аналитический слой интернет-магазина

Проект dbt для построения витрин данных (схема "звезда") на основе сырой OLTP-базы магазина. 
Включает слои staging, intermediate и marts.
{% enddocs %}

{% docs confirmed_order %}
**Подтверждённый заказ** — это заказ, который не отменён (`order_status != 'cancelled'`), 
не является тестовым (`is_test_order = false`), и по которому есть успешная оплата.
{% enddocs %}