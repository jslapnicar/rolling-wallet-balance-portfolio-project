
-- Change user_id and tx_id - drop text and change data type to int
UPDATE bank_transactions_1000
SET 
    user_id = REPLACE(user_id, 'USER_', ''),
    tx_id = REPLACE(tx_id, 'TX_', '')
WHERE user_id LIKE 'USER_%'
   OR tx_id LIKE 'TX_%';

ALTER TABLE bank_transactions_1000
MODIFY COLUMN user_id INT,
MODIFY COLUMN tx_id INT;

-- Track rolling wallet balances over time
WITH RunningBalances AS (
    SELECT 
        user_id,
        transaction_time,
        amount,
        SUM(amount) OVER (PARTITION BY user_id ORDER BY transaction_time) AS wallet_balance
    FROM bank_transactions_1000)
    SELECT * FROM RunningBalances
    WHERE wallet_balance > 1000; -- If sum is over 1.000, limit is exceeded