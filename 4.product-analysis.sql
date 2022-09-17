/* 4.Product Analysis */

	-- Initially, let's analyze sales & revenue by product available in our Database.
    
	SELECT
		primary_product_id,
        COUNT(order_id) AS orders,
        SUM(price_usd) AS revenue,
        SUM(price_usd - cogs_usd) AS margin,
        AVG(price_usd) AS average
	FROM orders
    WHERE order_id BETWEEN 10000 AND 11000 -- Arbitrary
    GROUP BY 1
    ORDER BY orders DESC;
    
    -- Let's consider 2 hypothetical situations again
	/* Suppose the CEO has launched the second product in jan6. 
    She wants to see monthly order volume, overall conversion rate, 
    revenue per session, and sales breakdown by product 
    all for the time since April 1, 2012.
    */
    
    SELECT 
		YEAR(website_sessions.created_at) AS year,
        MONTH(website_sessions.created_at) AS month,
        COUNT(orders.order_id) AS orders,
        (COUNT(orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id))*100 AS session_to_order_conv,
        SUM(price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,
        COUNT(DISTINCT CASE WHEN orders.primary_product_id = 1 THEN orders.order_id ELSE NULL END) AS product_1_orders,
        COUNT(DISTINCT CASE WHEN orders.primary_product_id = 2 THEN orders.order_id ELSE NULL END) AS product_2_orders
	FROM website_sessions
		LEFT JOIN orders
			ON website_sessions.website_session_id = orders.website_session_id
	WHERE website_sessions.created_at < '2013-04-01'
		AND website_sessions.created_at > '2012-04-01'
	GROUP BY 1, 2;
        
    /*
		As we can see, the second product hasn’t performed well in 2012 
        and started picking the sales from 2013.
	*/
    
    /*
		Let’s understand what cross-sell analysis is. It is about knowing which products 
        users are likely to purchase together and provide smart product recommendations. 
        For that, we will join Orders and Order_items tables.
	*/
    
    SELECT 
		orders.primary_product_id,
        COUNT(DISTINCT orders.order_id) AS orders,
        COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END) AS cross_sell_product1,
        COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END) AS cross_sell_product2,
        COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END) AS cross_sell_product3
	FROM orders
		LEFT JOIN order_items
			ON order_items.order_id = orders.order_id
			AND order_items.is_primary_item = 0 -- Cross Sell Only
	WHERE orders.order_id BETWEEN 10000 AND 11000 -- Arbitrary
    GROUP BY 1;
    
    -- As we can see, product 1 is cross-selling very well with product 2 and 3.
    
    /*
		Let’s move to product refund analysis. It is analyzing refund rates 
        for controlling quality and understand where you might have problems to address. 
        Considering product refund rates and associated costs can give a gist of the overall 
        performance of your business.
	*/
    
    SELECT
		YEAR(order_items.created_at) AS year,
        MONTH(order_items.created_at) AS month,
        COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_items.order_item_id ELSE NULL END) AS product1_orders,
        COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_item_refunds.order_item_refund_id ELSE NULL END) AS product1_refund_orders,
        (COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_item_refunds.order_item_refund_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_items.order_item_id ELSE NULL END))* 100 AS product1_refund_rates
	FROM order_items
		LEFT JOIN order_item_refunds
			ON order_items.order_item_id = order_item_refunds.order_item_id
	WHERE order_items.created_at < '2014-10-15' -- Arbitrary
 	GROUP BY 1, 2;
    
    -- Similary, we can find refund rates for remaining products.