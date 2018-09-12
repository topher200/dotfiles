import datetime


SQL = 'SELECT c.id, c.name as campaign_name, ag.id, ag.name as ad_group_name, spr.offer_id, spr.device, spr.category_l1, spr.category_l2, spr.category_l3, spr.category_l4, spr.category_l5, spr.product_type_l1, spr.product_type_l2, spr.product_type_l3, spr.product_type_l4, spr.product_type_l5, SUM(spr.clicks)::bigint as clicks, SUM(spr.impressions)::bigint as imps, SUM(spr.cost)::bigint as cost, SUM(spr.conversion_value)::bigint as conv_value, SUM(spr.conversions_many_per_click)::bigint as conv_m_clicks, CASE WHEN SUM(spr.impressions) > 0 THEN SUM(spr.clicks) / SUM(spr.impressions) ELSE 0.0 END as ctr, CASE WHEN SUM(spr.clicks) > 0 THEN SUM(spr.cost) / SUM(spr.clicks) ELSE 0.0 END as avg_cpc, CASE WHEN SUM(spr.clicks) > 0 THEN SUM(spr.conversions_many_per_click) / SUM(spr.clicks) ELSE 0.0 END as conv_rate_m_clicks, CASE WHEN SUM(spr.conversions_many_per_click) > 0 THEN SUM(spr.cost) / SUM(spr.conversions_many_per_click) ELSE 0.0 END as cost_p_conv_m_clicks, CASE WHEN SUM(spr.conversions_many_per_click) > 0 THEN SUM(spr.conversion_value) / SUM(spr.conversions_many_per_click) ELSE 0.0 END as value_p_conv_m_clicks FROM shopping_performance_report spr JOIN campaign c ON c.account_id = spr.account_id JOIN adgroup ag ON ag.adgroup_id = spr.adgroup_g_id AND ag.campaign_id = c.id WHERE spr.account_id = %(account_id)s AND spr.date between %(start_date)s AND %(end_date)s  GROUP BY c.id, ag.id, spr.offer_id, spr.device, spr.category_l1, spr.category_l2, spr.category_l3, spr.category_l4, spr.category_l5, spr.product_type_l1, spr.product_type_l2, spr.product_type_l3, spr.product_type_l4, spr.product_type_l5 ORDER BY imps ASC LIMIT %(limit)s OFFSET %(offset)s'
DATA_DICT = {'start_date': datetime.date(2016, 9, 10), 'limit': 500, 'account_id': 186, 'end_date': datetime.date(2018, 9, 10), 'offset': 0}



new_string = SQL
for name, value in DATA_DICT.iteritems():
    new_string = new_string.replace('%({})s'.format(name), "'%s'" % str(value))
print('%s;' % new_string)
