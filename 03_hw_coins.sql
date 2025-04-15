CREATE TABLE IF NOT EXISTS coins(
    dt VARCHAR(16),
    avg_price NUMERIC,
    tx_cnt NUMERIC,
    tx_vol NUMERIC,
    active_addr_cnt NUMERIC,
    symbol VARCHAR(8),
    full_nm VARCHAR(128),
    open_price NUMERIC,
    high_price NUMERIC,
    low_price NUMERIC,
    close_price NUMERIC,
    vol NUMERIC,
    market NUMERIC
);

INSERT INTO public.coins (
    dt, 
    avg_price, 
    tx_cnt, 
    tx_vol, 
    active_addr_cnt, 
    symbol, 
    full_nm, 
    open_price, 
    high_price, 
    low_price, 
    close_price, 
    vol, 
    market
) VALUES 
    ('2023-01-01 12:00', 42250.75, 325000, 1250000000, 950000, 'BTC', 'Bitcoin', 42000.50, 42580.25, 41875.30, 42250.75, 2500000000, 820000000000),
    ('2023-01-02 12:00', 43520.30, 340200, 1350000000, 980000, 'BTC', 'Bitcoin', 42260.80, 43890.45, 42100.60, 43520.30, 2700000000, 845000000000),
    ('2023-01-03 12:00', 42875.60, 318000, 1100000000, 920000, 'BTC', 'Bitcoin', 43530.20, 43650.75, 42560.30, 42875.60, 2300000000, 835000000000),
    ('2023-01-01 12:00', 2300.45, 1120000, 450000000, 650000, 'ETH', 'Ethereum', 2280.75, 2325.60, 2275.30, 2300.45, 800000000, 280000000000),
    ('2023-01-02 12:00', 2350.80, 1150000, 480000000, 680000, 'ETH', 'Ethereum', 2305.20, 2375.40, 2298.75, 2350.80, 850000000, 290000000000),
    ('2023-01-03 12:00', 2335.25, 1100000, 430000000, 640000, 'ETH', 'Ethereum', 2355.60, 2368.90, 2310.45, 2335.25, 780000000, 285000000000);


select rank() over (order by sum(vol) desc)
	, dt
	, sum(vol) as vol
from coins
group by dt
LIMIT 10;
