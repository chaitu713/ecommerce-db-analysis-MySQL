/* User Level Analysis */

	/*
		User analysis helps us to understand user behavior and identify some of our most 
        valuable customers. It includes analyzing repeat behavior activity and which channel 
        they use when they come back.
	*/
    
    SELECT
		CASE
			WHEN utm_source IS NULL AND http_referer IN('https://www.gsearch.com', 'https://www.bsearch.com') THEN 'organic_search'
            WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
            WHEN utm_campaign = 'brand' THEN 'paid_brand'
            WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
            WHEN utm_source = 'socialbook' THEN 'paid_social'
		END AS channel_group,
        COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
        COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
	FROM website_sessions
    WHERE website_sessions.created_at >= '2014-01-01' -- Arbitrary
		AND website_sessions.created_at < '2014-11-05'
	GROUP BY 1;
    
    -- As we can see, orgainc_search, paid_brand & direct_type_in are giving more repeat_sessions.