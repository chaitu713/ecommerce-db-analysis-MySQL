/* E-COMMERCE DATABASE ANALYSIS USING MySQL */

	/* 1. Traffic Source Analysis, Bid Optimization and Trend Analysis */
    
    /* 
		Step 1 : Linking session data (website_sessions) with order data (orders) to know how much revenue our paid campaigns 
        are driving and their conversion rates.
	*/
    
    USE mavenfuzzyfactory;
    
    SELECT
		website_sessions.utm_source,
        website_sessions.utm_campaign,
        website_sessions.http_referer,
        COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
        COUNT(DISTINCT orders.order_id) AS orders,
        (COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id))*100 AS sessions_to_orders_conv_rate
	FROM website_sessions
		LEFT JOIN orders
			ON website_sessions.website_session_id = orders.website_session_id
	GROUP BY utm_source, utm_campaign, http_referer
    ORDER BY sessions DESC;
    
    /* 
		utm_source -> Tracks from where the traffic originated from.
        utm_campaign -> to add unit (nonbrand/ brand).
	*/
    
    /*
		Step 2 : Conversion Rate from sessions to orders by device type.
    */
    
    SELECT
		website_sessions.device_type,
        COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
        COUNT(DISTINCT orders.order_id) AS orders,
        (COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id))*100 AS sessions_to_orders_conv_rate
	FROM website_sessions
		LEFT JOIN orders
			ON website_sessions.website_session_id = orders.website_session_id
	WHERE utm_source = 'gsearch'
		AND utm_campaign = 'nonbrand'
        AND website_sessions.created_at < '2012-05-11'
	GROUP BY website_sessions.device_type
    ORDER BY sessions_to_orders_conv_rate DESC;
    
    /* 
		Step 3 : Trend Analysis helps us see how far our business has come in the last two to five years,
        we can do trend analysis of sessions by week and year using DATE functions.
	*/
    
    SELECT 
		YEAR(created_at) AS year,
        WEEK(created_at) AS week,
        MIN(DATE(created_at)) AS week_starts,
        COUNT(DISTINCT website_session_id) AS sessions
	FROM website_sessions
    WHERE website_session_id BETWEEN 100000 AND 200000 -- Arbitrary
    GROUP BY YEAR(created_at), WEEK(created_at);
    
    