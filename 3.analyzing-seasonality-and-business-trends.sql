/* Analyzing Seasonality & Business Patterns.
	
    -- We will see this concept through two hypothetical situations.
	/*
		Suppose 2012 was a great year for us. As we continue to grow, 
        we should take a look at 2012’s monthly volume patterns to see 
        if we can find any seasonal trend we should plan for the year 2013. 
        Your CEO wants to know session volume and order volume.
    */
    
	SELECT 
		MONTH(website_sessions.created_at) AS month,
        COUNT(website_sessions.website_session_id) AS sessions,
        COUNT(orders.order_id) AS orders
	FROM website_sessions
		LEFT JOIN orders
			ON website_sessions.website_session_id = orders.website_session_id
	WHERE website_sessions.created_at >= '2012-01-01'
		AND website_sessions.created_at <= '2012-12-31'
	GROUP BY MONTH(website_sessions.created_at);
    
    -- As we can see, November, December, and October had given the highest sales last year.
	-- We can use WEEK() for more analyzing more details.
    /*
		Suppose the CEO is considering adding live chat on the website to improve 
        customer satisfaction. He wants to analyze average session volume by an hour 
        of the day and by day week to allocate staff appropriately. 
        Avoid the holiday period and use a date range for sept15 to nov15, 2013.
	*/
    
    SELECT
		HOUR,
		AVG(CASE WHEN WEEKDAY = 0 THEN website_sessions ELSE NULL END) AS 'MONDAY',
        AVG(CASE WHEN WEEKDAY = 1 THEN website_sessions ELSE NULL END) AS 'TUESDAY',
        AVG(CASE WHEN WEEKDAY = 2 THEN website_sessions ELSE NULL END) AS 'WEDNESDAY',
        AVG(CASE WHEN WEEKDAY = 3 THEN website_sessions ELSE NULL END) AS 'THURSDAY',
        AVG(CASE WHEN WEEKDAY = 4 THEN website_sessions ELSE NULL END) AS 'FRIDAY',
        AVG(website_sessions) AS avg_of_all
	FROM
    (
		SELECT 
			hour(created_at) AS 'HOUR',
            COUNT(DISTINCT website_session_id) AS website_sessions,
            WEEKDAY(created_at) AS WEEKDAY
		FROM website_sessions
        WHERE created_at >= '2013-09-15'
			AND created_at <= '2013-11-15'
		GROUP BY 3, 1
	) AS hour
    GROUP BY 1
    ORDER BY 1;
	
