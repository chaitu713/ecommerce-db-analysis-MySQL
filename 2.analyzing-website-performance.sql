/* 1. Analyzing Website Performance */

	-- 1 : Analyzing Top Website Pages.

	CREATE TEMPORARY TABLE first_pageview
	SELECT
		website_session_id,
		MIN(website_pageview_id) AS first_page_visited_id
	FROM website_pageviews
	WHERE website_pageview_id < 1000 -- Arbitrary
	GROUP BY website_session_id;

	SELECT 
		COUNT(DISTINCT(first_pageview.website_session_id)) AS sessions_hitting_this_lander,
		website_pageviews.pageview_url AS landing_page -- OR entry_page
	FROM first_pageview
	INNER JOIN website_pageviews
		ON first_pageview.first_page_visited_id = website_pageviews.website_pageview_id
	GROUP BY website_pageviews.pageview_url;
    
    /* 
		This shows that almost all users first land on the home page, 
		so it is necessary to make the home page as attractive as possible. 
    */
    
    -- Most Viewed website pages ranked by session volume.
    
    SELECT
		pageview_url,
        COUNT(DISTINCT website_pageview_id) AS most_visited_pages,
        COUNT(website_session_id) AS sessions
	FROM website_pageviews
    WHERE created_at < '2012-06-09' -- Arbitrary
    GROUP BY pageview_url
    ORDER BY sessions DESC;
    
    -- Analyzing and Testing conversion funnels.
    
    /*
		STEP 1 : Firstly we are going to have pageviews for required pages 
        like /lander-2, /products, /the-original-Mr-fuzzy, and /cart. For that, 
        we will join Website_pageviews with Website_sessions.
	*/
    
    SELECT
		website_pageviews.website_session_id,
        website_pageviews.pageview_url,
        website_sessions.created_at,
        CASE WHEN website_pageviews.pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
        CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mr_fuzzy_page,
        CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
	FROM website_pageviews
		INNER JOIN website_sessions
			ON website_pageviews.website_session_id = website_sessions.website_session_id
	WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- Arbitrary
		AND website_pageviews.pageview_url IN ('/products', '/lander-2', '/the-original-mr-fuzzy', '/cart')
	ORDER BY website_pageviews.website_session_id, website_pageviews.created_at;
    
    /*
		STEP 2 : Now we will identify each relevant pageview as the specific funnel steps. 
        For that, we will embed the whole above query as a subquery to find sessions 
        that have been made through for our pages.
	*/
    
    CREATE TEMPORARY TABLE session_level_made_it_flags
    SELECT
		website_session_id,
        MAX(products_page) AS products_made_it,
        MAX(mr_fuzzy_page) AS mr_fuzzy_made_t,
        MAX(cart_page) AS cart_made_it
	FROM (
		SELECT
			website_pageviews.website_session_id,
			website_pageviews.pageview_url,
			website_sessions.created_at,
			CASE WHEN website_pageviews.pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
			CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mr_fuzzy_page,
			CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
		FROM website_pageviews
			INNER JOIN website_sessions
				ON website_pageviews.website_session_id = website_sessions.website_session_id
		WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- Arbitrary
			AND website_pageviews.pageview_url IN ('/products', '/lander-2', '/the-original-mr-fuzzy', '/cart')
		ORDER BY website_pageviews.website_session_id, website_pageviews.created_at
	) AS pageview_level
	GROUP BY website_session_id;
    
    SELECT
		website_session_id,
        products_made_it,
        mr_fuzzy_made_t,
        cart_made_it
	FROM session_level_made_it_flags;
    
    -- STEP 3 : Create the session level conversion funnel view.
    
    SELECT
		COUNT(DISTINCT website_session_id) AS sessions,
        COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
        COUNT(DISTINCT CASE WHEN mr_fuzzy_made_t = 1 THEN website_session_id ELSE NULL END) AS to_mr_fuzzy,
        COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart
	FROM session_level_made_it_flags;
    
    /* 
		From the above result, we can say that from all 10630 sessions that made through lander_2
        page, 7780 made through products_page, and from 7780 sessions 4772 made through mr_fuzzy_page, 
        and from 4772 sessions 2892 made through cart_page
	*/