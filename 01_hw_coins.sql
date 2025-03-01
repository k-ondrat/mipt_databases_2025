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

INSERT INTO coins (dt, avg_price, tx_cnt, tx_vol, active_addr_cnt, symbol, full_nm, open_price, high_price, low_price, close_price, vol, market)
VALUES
    ('2018-10-02', 45, 0, 5200000.80, 82000, 'DOGE', 'Bitcoin', 45200.00, 45800.00, 45100.00, 45600.00, 3100000000.00, 860000000000.00);


select *
from coins
where symbol = 'BTC' AND avg_price < 100;

SELECT dt, high_price, vol
FROM coins
WHERE 
	symbol = 'DOGE'
	AND dt BETWEEN '2018-01-01' AND '2018-12-31'
	AND avg_price > 0.001

SELECT DISTINCT
	UPPER(full_nm) AS full_name
FROM coins
ORDER by full_name;

delete from coins
where vol = 0 or tx_cnt = 0;
