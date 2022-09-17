E-Commerce Database Analysis using MySQL.

TOPICS COVERED IN THIS PROJECT ARE :
  1. Traffic Source Analysis, Bid Optimization and Trend Analysis.
  2. Analyzing Website Performance.
  3. Analyzing Seasonality & Business Patterns.
  4. Product Analysis.
  5. User Analysis.
  
  The Sample E-Commerce Database used for this project consists of the following tables :
  
    1. orders: 
      - The attributes/ columns in the table are order_id, created_at, website_session_id, user_id, primary_product_id, items_purchased, price_usd, cogs_usd.
      
    2. order_item_refunds: 
      - The attributes are order_item_refund_id, created_at, order_item_id, order_id, refund_amount_usd.
      
    3. order_items: 
      - Attributes are order_item_id, created_at, order_id, product_id, is_primary_item, price_usd, cogs_usd.
      
    4. products: 
      - Attributes are product_id, created_at, product_name.
      
    5. website_sessions: 
      - Attributes are website_session_id, created_at, user_id, is_repeat_session, utm_source, utm_campaign, utm_content, device_type, http_referer.
      
    6. website_pageviews:
      - Attributes are website_pageview_id, created_at, website_session_id, pageview_url.
      
                            -- This is how the typical E-Commerce Database looks like--  
                          
Now let's go through all the topics in detai:

  1. Traffic Source Analysis, Bid Optimization & Trend Analysis.
  
    - It is crucial to understand where your customers are coming from and which marketing channels are driving the highest traffic.
    - We will also find the conversion rates for each marketing campaign, it helps us shift our budget towards high-quality traffic, make informed decision making, eliminate wasted spending.
    - Paid traffic is identified by UTM parameters appended in URLs, and they allow us to tie website activity back to specific traffic sources and campaigns.
    - We are going to use UTM parameters stored in the website_sessions table in the database to recognize paid website sessions.
      STEP 1 : We will link website_sessions and orders table to know how much revenue our paid campaigns are driving and their conversion rates.
      STEP 2 : BID OPTIMIZATION is knowing the value of different paid traffic segments in order to optimize your marketing budget.
        - Conversion rate and revenue per click analysis are used to figure out how much is spent per click to acquire customers.
        - For now, we'll assume that gsearch nonbrand campaign performance of site in a mobile device is not great
          - So we'll find out the conversion rate from sessions to orders on the basis of device type. If the desktop performance is better than mobile, then we can bid up for desktop.
      STEP 3 : Trend analysis helps us see how far our business has come in the last two to five years. We can do trend analysis of sessions by week and year using date functions.

  2. Analyzing Website Performance.
  
    - Some of the ways of Analyzing a website performance are as follows:
    * ANALYZING TOP WEBSITE PAGES :
      - Website content is having a knowledge of pages that are seen the most by the users. It involves recognizing the most common entry pages(the landing page/ the first page user sees) and know how they perform for your business objectives.
      - We will create a temporary table first_pageview from website_pageviews and self-join them to get the most common entry page for a specific period.
    * ANALYZING AND TESTING CONVERSION FUNNELS :
      - Conversion Funnels aim to understand and improve each step of user's experience on their journey towards buying your products.
      - We are going to identify the most common paths users take before purchasing products and analyze how many users continue on each step in your conversion flow and how many users abandon at each step.
      - For simplicity, we will consider the path from /lander-2 to /cart and consider only one product that is Mr.Fuzzy.
      - There will be 3 steps to follow to get a conversion funnel:
        -> Firstly, we are going to have pageviews for required pages like /lander-2, /products, /the-original-mr-fuzzy, and /cart. For that, we will join website_pageviews with website_sessions.
        -> Next, Now we will identify each relevant pageview as the specific funnel steps. For that, we will embed the whole above query as a subquery to find sessions that have been made through for our pages.
        -> And last, Create the session level conversion funnel view.
        -- After the analysis, I got the below Output : 
            - we can say that from all 10630 sessions that made through lander_2 page, 7780 made through products_page, and from 7780 sessions 4772 made through mr_fuzzy_page, and from 4772 sessions 2892 made through cart_page --
        -- In this way, we can create conversion funnels from the home page(/lander-1) to the thank you page(/thank_you_page).
        
  3. Analyzing seasonality & Business Trends.
  
    - Business trends help in generating insights to help maximize efficieny, and predict future trends. 
    - Day-parting analysis helps us to understand how much support staff you should have at different times of the day or days of week.
    - Having knowledge of seasonality helps better prepare for upcoming spikes or slowdowns in demand. To dig deep into business patterns and seasonality, we will use date functions.
    - We'll see this concept through 2 hypothetical situations.
      * Suppose 2012 was a great year for us. As we continue to grow, we should take a look at 2012’s monthly volume patterns to see if we can find any seasonal trend we should plan for the year 2013. Your CEO wants to know session volume and order volume.
      * Suppose the CEO is considering adding live chat on the website to improve customer satisfaction. He wants to analyze average session volume by an hour of the day and by day week to allocate staff appropriately. Avoid the holiday period and use a date range for Sept 15 to Nov 15, 2013.

  4. Product Level Analysis.
    
    - Product Analysis helps us to understand how each product contributes to your business.
    - Suppose the CEO has launched the second product in jan6. She wants to see monthly order volume, overall conversion rate, revenue per session, and sales breakdown by product all for the time since April 1, 2012.
    - Let’s understand what cross-sell analysis is. It is about knowing which products users are likely to purchase together and provide smart product recommendations.
    - Let’s move to product refund analysis. It is analyzing refund rates for controlling quality and understand where you might have problems to address. Considering product refund rates and associated costs can give a gist of the overall performance of your business.
    
  5. User Level Analysis.
 
    - User analysis helps us to understand user behavior and identify some of our most valuable customers. It includes analyzing repeat behavior activity and which channel they use when they come back. 

-- These are the several aspects that help to make the data-driven decision for your Online Store --
