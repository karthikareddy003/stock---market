DROP TABLE IF EXISTS
transactions;
DROP TABLE IF EXISTS
stock_prices;
DROP TABLE IF EXISTS stocks;
CREATE TABLE stocks (
    stock_id SERIAL PRIMARY 
KEY,
	stock_name VARCHAR(50),
	sector VARCHAR(50)
);
CREATE TABLE stock_prices (
    price_id SERIAL PRIMARY
KEY,
	stock_id INT REFERENCES
stocks(stock_id),
    trade_date DATE,
	open_price DECIMAL(10,2),
	close_price
DECIMAL(10,2),
    volume BIGINT
);
CREATE TABLE transactions (
    transaction_id SERIAL
PRIMARY KEY,
    stock_id INT REFERENCES
stocks(stock_id),
    transaction_type
VARCHAR(10),
    quantity INT,
	price DECIMAL(10,2),
	transaction_date DATE
);
INSERT INTO stocks
(stock_name, sector) VALUES
('Tata Motors',
'Automobile'),
('Infosys', 'IT'),
('Reliance', 'Energy'),
('HDFC Bank', 'Banking');
INSERT INTO stock_prices
(stock_id, trade_date,
open_price, close_price,
volume) VALUES
(1, '2025-09-01', 600, 620,
1200000),
(2, '2025-09-01', 1500, 1525,
800000),
(3, '2025-09-01', 2400, 2425,
600000),
(4, '2025-09-01', 1700, 1715,
500000),
(1, '2025-09-02', 620, 615,
1100000),
(2, '2025-09-02', 1525, 1540,
850000);
INSERT INTO transactions
(stock_id, transaction_type,
quantity, price,
transaction_date) VALUES
(1, 'BUY', 100, 600,
'2025-09-01'),
(1, 'SELL', 50, 620,
'2025-09-02'),
(2, 'BUY', 200, 1500,
'2025-09-01');
SELECT s.stock_name,
SUM(sp.volume) AS
total_volume
FROM stocks s
JOIN stock_prices sp ON 
s.stock_id = sp.stock_id
GROUP BY s.stock_name
ORDER BY total_volume DESC
LIMIT 3;
SELECT s.stock_name,
ROUND(AVG(sp.close_price),2)
AS avg_closing_price
FROM stocks s
JOIN stock_prices sp ON
s.stock_id = sp.stock_id
GROUP BY s.stock_name;
SELECT s.stock_name,
       SUM(CASE WHEN
t.transaction_type = 'SELL'
THEN t.price*t.quantity
                WHEN
t.transaction_type = 'BUY'
THEN -t.price*t.quantity
           END) AS net_profit
FROM transactions t
JOIN stocks s ON t.stock_id = s.stock_id
GROUP BY s.stock_name;
SELECT s.stock_name,
sp.trade_date, sp.open_price,
sp.close_price
FROM stock_prices sp
JOIN stocks s ON sp.stock_id
= s.stock_id
WHERE sp.close_price >
sp.open_price;