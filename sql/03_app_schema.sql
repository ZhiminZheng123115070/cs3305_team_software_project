USE `ry-vue`;


-- 1) Products (Open Food Facts cache + simple MVP price)
-- Drop tables that reference app_products first (foreign key dependency)
DROP TABLE IF EXISTS app_purchase_items;
DROP TABLE IF EXISTS app_cart_items;
DROP TABLE IF EXISTS app_scan_logs;

DROP TABLE IF EXISTS app_products;

CREATE TABLE app_products (
  product_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Product ID',
  barcode VARCHAR(32) NOT NULL COMMENT 'Barcode (EAN/UPC)',
  name VARCHAR(255) NOT NULL COMMENT 'Product name',
  brand VARCHAR(255) DEFAULT NULL COMMENT 'Brand name',
  image_url TEXT DEFAULT NULL COMMENT 'Image URL',

  -- MVP price model (single current price per product)
  price DECIMAL(7,2) DEFAULT NULL COMMENT 'Current price (MVP: single price)',
  currency CHAR(3) NOT NULL DEFAULT 'EUR' COMMENT 'Currency code',

  -- Nutrition total 100g (for filtering/sorting)
  energy_kcal DECIMAL(6,2) DEFAULT NULL COMMENT 'kcal',
  fat DECIMAL(5,2) DEFAULT NULL COMMENT 'g',
  saturated_fat DECIMAL(5,2) DEFAULT NULL COMMENT 'g',
  carbohydrates DECIMAL(5,2) DEFAULT NULL COMMENT 'g',
  sugars DECIMAL(5,2) DEFAULT NULL COMMENT 'g',
  fiber DECIMAL(5,2) DEFAULT NULL COMMENT 'g',
  proteins DECIMAL(5,2) DEFAULT NULL COMMENT 'g',
  salt DECIMAL(5,2) DEFAULT NULL COMMENT 'g',

  nutri_score CHAR(1) DEFAULT NULL COMMENT 'OFF Nutri-Score A–E (optional)',

  -- Cache metadata
  source VARCHAR(32) NOT NULL DEFAULT 'OFF' COMMENT 'Data source',
  source_url TEXT DEFAULT NULL COMMENT 'Product page/API url',
  product_status VARCHAR(16) NOT NULL DEFAULT 'FOUND' COMMENT 'FOUND / NOT_FOUND / PARTIAL',
  last_fetched_at DATETIME DEFAULT NULL COMMENT 'Last fetch time from OFF',

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_products_barcode (barcode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Products cache (Open Food Facts + MVP price)';

-- 50 mock products (optimized for cart pagination, search, and sorting)
-- Price range: 0.99-15.99 EUR (for price sorting)
-- Multiple brands: 15+ brands (for brand sorting)
-- Nutrition values: wide ranges (for kcal, fat, sugars, fiber, proteins, carbohydrates, salt sorting)
-- Nutri-Score: A, B, C, D, E distribution (for nutriScore sorting)
INSERT INTO app_products (barcode, name, brand, image_url, price, currency, energy_kcal, fat, saturated_fat, carbohydrates, sugars, fiber, proteins, salt, nutri_score, source, product_status) VALUES
('3017620422001', 'Lactel Semi-Skimmed Milk', 'Lactel', 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop', 0.99, 'EUR', 47.00, 1.60, 1.00, 4.80, 4.80, 0.00, 3.20, 0.10, 'A', 'OFF', 'FOUND'),
('3017620422002', 'Müller Light Strawberry', 'Müller', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 1.09, 'EUR', 62.00, 0.10, 0.10, 10.20, 8.80, 0.30, 5.20, 0.18, 'A', 'OFF', 'FOUND'),
('3017620422003', 'Evian Natural Spring Water', 'Evian', 'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400&h=400&fit=crop', 1.19, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'A', 'OFF', 'FOUND'),
('3017620422004', 'Snickers Chocolate Bar', 'Mars', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 1.19, 'EUR', 491.00, 23.90, 8.20, 61.00, 51.00, 2.50, 7.60, 0.42, 'E', 'OFF', 'FOUND'),
('3017620422005', 'Müller Rice Chocolate', 'Müller', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 1.19, 'EUR', 119.00, 3.20, 2.00, 19.50, 13.20, 0.30, 3.40, 0.12, 'B', 'OFF', 'FOUND'),
('3017620422006', 'Pasta Barilla Spaghetti', 'Barilla', 'https://images.unsplash.com/photo-1551462147-5e923c7a0a3a?w=400&h=400&fit=crop', 1.29, 'EUR', 358.00, 2.50, 0.50, 71.00, 3.20, 3.00, 12.50, 0.01, 'A', 'OFF', 'FOUND'),
('3017620422007', 'San Pellegrino Sparkling', 'San Pellegrino', 'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400&h=400&fit=crop', 1.29, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'A', 'OFF', 'FOUND'),
('3017620422008', 'Müller Corner Chocolate', 'Müller', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 1.29, 'EUR', 142.00, 5.20, 3.40, 20.50, 17.20, 0.30, 3.80, 0.14, 'C', 'OFF', 'FOUND'),
('3017620422009', 'Twix Chocolate Bar', 'Mars', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 1.29, 'EUR', 502.00, 24.00, 15.00, 64.00, 49.00, 0.00, 4.60, 0.38, 'E', 'OFF', 'FOUND'),
('3017620422010', 'Green Giant Sweet Corn', 'Green Giant', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&h=400&fit=crop', 1.29, 'EUR', 76.00, 1.20, 0.20, 14.50, 5.20, 2.70, 2.90, 0.35, 'A', 'OFF', 'FOUND'),
('3017620422011', 'Danone Activia Natural', 'Danone', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 1.39, 'EUR', 77.00, 3.10, 2.00, 9.50, 9.50, 0.00, 3.40, 0.12, 'B', 'OFF', 'FOUND'),
('3017620422012', 'Mountain Dew', 'PepsiCo', 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop', 1.39, 'EUR', 46.00, 0.00, 0.00, 11.60, 11.60, 0.00, 0.00, 0.03, 'E', 'OFF', 'FOUND'),
('3017620422013', 'McVitie''s Digestive', 'McVitie''s', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=400&fit=crop', 1.49, 'EUR', 486.00, 21.30, 10.10, 62.60, 16.60, 2.70, 7.10, 1.00, 'D', 'OFF', 'FOUND'),
('3017620422014', 'Coca-Cola Classic', 'Coca-Cola', 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop', 1.49, 'EUR', 42.00, 0.00, 0.00, 10.60, 10.60, 0.00, 0.00, 0.01, 'E', 'OFF', 'FOUND'),
('3017620422015', 'Coca-Cola Zero', 'Coca-Cola', 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop', 1.49, 'EUR', 1.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.02, 'B', 'OFF', 'FOUND'),
('3017620422016', 'Fage Total 0%', 'Fage', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 1.69, 'EUR', 59.00, 0.20, 0.10, 4.00, 4.00, 0.00, 10.20, 0.12, 'A', 'OFF', 'FOUND'),
('3017620422017', 'Nestle Kit Kat', 'Nestle', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 1.79, 'EUR', 518.00, 29.60, 18.00, 58.30, 51.00, 0.00, 6.20, 0.15, 'E', 'OFF', 'FOUND'),
('3017620422018', 'Knorr Chicken Stock', 'Knorr', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 1.79, 'EUR', 167.00, 8.20, 4.50, 15.00, 2.00, 0.50, 8.50, 18.00, 'D', 'OFF', 'FOUND'),
('3017620422019', 'Lipton Ice Tea Peach', 'Lipton', 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop', 1.79, 'EUR', 32.00, 0.00, 0.00, 7.80, 7.80, 0.00, 0.00, 0.02, 'D', 'OFF', 'FOUND'),
('3017620422020', 'Red Bull Energy Drink', 'Red Bull', 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop', 1.99, 'EUR', 45.00, 0.00, 0.00, 11.00, 11.00, 0.00, 0.00, 0.10, 'E', 'OFF', 'FOUND'),
('3017620422021', 'Alpro Soy Milk', 'Alpro', 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop', 1.99, 'EUR', 33.00, 1.90, 0.30, 0.60, 0.60, 0.60, 3.00, 0.10, 'A', 'OFF', 'FOUND'),
('3017620422022', 'Dolmio Pasta Sauce', 'Dolmio', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 1.99, 'EUR', 41.00, 0.50, 0.10, 7.80, 5.20, 1.20, 1.60, 0.65, 'A', 'OFF', 'FOUND'),
('3017620422023', 'Oreo Original', 'Mondelez', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 1.99, 'EUR', 474.00, 20.00, 5.20, 72.00, 42.00, 2.50, 5.00, 0.75, 'E', 'OFF', 'FOUND'),
('3017620422024', 'Ritter Sport Marzipan', 'Ritter Sport', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 1.99, 'EUR', 553.00, 35.00, 17.00, 49.00, 46.00, 0.00, 7.00, 0.15, 'E', 'OFF', 'FOUND'),
('3017620422025', 'Cadbury Dairy Milk', 'Cadbury', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 2.19, 'EUR', 534.00, 30.00, 18.00, 57.00, 56.00, 0.00, 7.50, 0.25, 'E', 'OFF', 'FOUND'),
('3017620422026', 'Alpro Oat Milk', 'Alpro', 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop', 2.19, 'EUR', 47.00, 1.50, 0.20, 6.80, 4.10, 0.80, 1.00, 0.08, 'A', 'OFF', 'FOUND'),
('3017620422027', 'Lays Classic Chips', 'Lays', 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=400&fit=crop', 2.29, 'EUR', 536.00, 34.60, 3.20, 49.70, 0.60, 4.20, 6.70, 1.20, 'E', 'OFF', 'FOUND'),
('3017620422028', 'Clif Bar Chocolate', 'Clif Bar', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 2.29, 'EUR', 353.00, 6.00, 1.50, 66.00, 21.00, 5.00, 12.00, 0.35, 'C', 'OFF', 'FOUND'),
('3017620422029', 'Philadelphia Light', 'Mondelez', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 2.29, 'EUR', 181.00, 11.00, 7.00, 4.00, 4.00, 0.00, 8.20, 0.75, 'B', 'OFF', 'FOUND'),
('3017620422030', 'Innocent Kids Smoothie', 'Innocent', 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop', 2.29, 'EUR', 52.00, 0.20, 0.00, 11.50, 10.80, 0.50, 0.50, 0.01, 'B', 'OFF', 'FOUND'),
('3017620422031', 'Innocent Coconut Water', 'Innocent', 'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400&h=400&fit=crop', 2.49, 'EUR', 19.00, 0.00, 0.00, 3.80, 3.60, 0.00, 0.00, 0.05, 'A', 'OFF', 'FOUND'),
('3017620422032', 'Quaker Oats Original', 'Quaker', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=400&fit=crop', 2.49, 'EUR', 389.00, 6.90, 1.20, 66.00, 1.00, 10.60, 16.90, 0.01, 'A', 'OFF', 'FOUND'),
('3017620422033', 'Philadelphia Original', 'Mondelez', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 2.49, 'EUR', 253.00, 21.00, 12.00, 4.00, 4.00, 0.00, 5.50, 0.70, 'D', 'OFF', 'FOUND'),
('3017620422034', 'Pringles Original', 'Pringles', 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=400&fit=crop', 2.49, 'EUR', 536.00, 33.30, 3.10, 51.00, 1.10, 2.80, 5.90, 1.50, 'E', 'OFF', 'FOUND'),
('3017620422035', 'Yeast Extract', 'Marmite', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 2.49, 'EUR', 221.00, 0.00, 0.00, 38.00, 0.00, 0.00, 38.00, 11.00, 'C', 'OFF', 'FOUND'),
('3017620422036', 'Innocent Apple Juice', 'Innocent', 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop', 2.49, 'EUR', 44.00, 0.10, 0.00, 10.30, 9.80, 0.10, 0.10, 0.01, 'B', 'OFF', 'FOUND'),
('3017620422037', 'Maltesers', 'Mars', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 2.59, 'EUR', 503.00, 24.50, 14.90, 62.00, 56.00, 0.00, 8.40, 0.42, 'E', 'OFF', 'FOUND'),
('3017620422038', 'Galaxy Smooth Milk', 'Galaxy', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 2.39, 'EUR', 522.00, 29.00, 18.00, 60.00, 59.00, 0.00, 5.50, 0.22, 'E', 'OFF', 'FOUND'),
('3017620422039', 'Weetabix Original', 'Weetabix', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=400&fit=crop', 2.79, 'EUR', 362.00, 2.00, 0.60, 69.00, 4.40, 10.00, 11.00, 0.28, 'B', 'OFF', 'FOUND'),
('3017620422040', 'Clover Spreadable', 'Clover', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 2.79, 'EUR', 588.00, 59.00, 15.00, 5.50, 0.50, 0.00, 0.50, 0.55, 'D', 'OFF', 'FOUND'),
('3017620422041', 'Tropicana Orange Juice', 'Tropicana', 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop', 2.79, 'EUR', 45.00, 0.20, 0.00, 10.40, 10.40, 0.20, 0.70, 0.00, 'B', 'OFF', 'FOUND'),
('3017620422042', 'M&Ms Peanut', 'Mars', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 2.79, 'EUR', 515.00, 26.00, 10.00, 59.00, 52.00, 0.00, 9.80, 0.12, 'E', 'OFF', 'FOUND'),
('3017620422043', 'Innocent Smoothie Mango', 'Innocent', 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop', 2.99, 'EUR', 56.00, 0.20, 0.00, 12.80, 12.20, 0.80, 0.60, 0.01, 'B', 'OFF', 'FOUND'),
('3017620422044', 'Heinz Tomato Ketchup', 'Heinz', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 2.99, 'EUR', 112.00, 0.10, 0.00, 25.80, 22.80, 0.80, 1.80, 2.70, 'D', 'OFF', 'FOUND'),
('3017620422045', 'Belvita Breakfast Biscuits', 'Belvita', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=400&fit=crop', 2.99, 'EUR', 448.00, 16.00, 4.50, 68.00, 24.00, 3.00, 7.80, 0.45, 'D', 'OFF', 'FOUND'),
('3017620422046', 'Kellogg''s Corn Flakes', 'Kellogg''s', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=400&fit=crop', 2.99, 'EUR', 379.00, 0.90, 0.20, 84.00, 8.00, 2.40, 7.00, 1.10, 'B', 'OFF', 'FOUND'),
('3017620422047', 'Kinder Bueno', 'Ferrero', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 3.29, 'EUR', 575.00, 37.60, 18.50, 47.30, 40.00, 0.00, 8.60, 0.25, 'E', 'OFF', 'FOUND'),
('3017620422048', 'Hellmann''s Mayo', 'Hellmann''s', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 3.29, 'EUR', 720.00, 79.00, 6.00, 2.70, 2.70, 0.00, 1.10, 1.30, 'E', 'OFF', 'FOUND'),
('3017620422049', 'Birds Eye Fish Fingers', 'Birds Eye', 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&h=400&fit=crop', 3.29, 'EUR', 199.00, 9.20, 0.80, 20.00, 0.80, 1.20, 11.00, 0.65, 'B', 'OFF', 'FOUND'),
('3017620422050', 'Bonne Maman Jam', 'Bonne Maman', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 3.29, 'EUR', 258.00, 0.10, 0.00, 60.00, 59.00, 0.50, 0.40, 0.02, 'D', 'OFF', 'FOUND'),
('3017620422051', 'Innocent Veg Pot', 'Innocent', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&h=400&fit=crop', 3.49, 'EUR', 52.00, 1.80, 0.30, 6.80, 2.80, 1.50, 2.80, 0.45, 'A', 'OFF', 'FOUND'),
('3017620422052', 'Nando''s Peri-Peri Sauce', 'Nando''s', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 3.49, 'EUR', 89.00, 0.50, 0.10, 18.00, 15.00, 0.50, 2.00, 2.80, 'C', 'OFF', 'FOUND'),
('3017620422053', 'Colgate Total Toothpaste', 'Colgate', 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop', 3.49, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('3017620422054', 'Lurpak Butter', 'Lurpak', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 3.99, 'EUR', 717.00, 81.00, 52.00, 0.60, 0.60, 0.00, 0.60, 0.02, 'D', 'OFF', 'FOUND'),
('3017620422055', 'Toblerone Milk', 'Toblerone', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 3.99, 'EUR', 525.00, 29.50, 18.00, 60.00, 59.00, 0.00, 5.60, 0.12, 'E', 'OFF', 'FOUND'),
('3017620422056', 'Marmite Yeast Extract', 'Marmite', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 3.99, 'EUR', 221.00, 0.00, 0.00, 38.00, 0.00, 0.00, 38.00, 11.00, 'C', 'OFF', 'FOUND'),
('3017620422057', 'Axe Body Spray', 'Axe', 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop', 3.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('3017620422058', 'Nutella Hazelnut Spread', 'Ferrero', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 4.99, 'EUR', 2250.00, 30.90, 10.60, 56.30, 56.30, 0.00, 6.30, 0.11, 'E', 'OFF', 'FOUND'),
('3017620422059', 'Nivea Creme', 'Nivea', 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop', 4.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('3017620422060', 'Benecol Spread', 'Benecol', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 4.29, 'EUR', 620.00, 60.00, 12.00, 0.00, 0.00, 0.00, 0.00, 0.60, 'C', 'OFF', 'FOUND'),
('3017620422061', 'Lindt Lindor Milk', 'Lindt', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 4.49, 'EUR', 598.00, 47.00, 35.00, 44.00, 42.00, 0.00, 5.90, 0.18, 'E', 'OFF', 'FOUND'),
('3017620422062', 'Carte Noire Coffee', 'Carte Noire', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=400&fit=crop', 4.49, 'EUR', 5.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.30, 0.02, 'A', 'OFF', 'FOUND'),
('3017620422063', 'Garnier Micellar Water', 'Garnier', 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop', 5.49, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('3017620422064', 'Ben & Jerry Cookie Dough', 'Ben & Jerry''s', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=400&fit=crop', 5.49, 'EUR', 244.00, 13.00, 7.00, 30.00, 25.00, 0.00, 4.00, 0.25, 'D', 'OFF', 'FOUND'),
('3017620422065', 'Häagen-Dazs Vanilla', 'Häagen-Dazs', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=400&fit=crop', 5.99, 'EUR', 249.00, 16.00, 10.00, 22.00, 20.00, 0.00, 3.60, 0.12, 'D', 'OFF', 'FOUND'),
('3017620422066', 'Nescafe Gold Blend', 'Nestle', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=400&fit=crop', 5.99, 'EUR', 18.00, 0.20, 0.00, 1.00, 0.00, 0.00, 2.40, 0.05, 'B', 'OFF', 'FOUND'),
('3017620422067', 'Olive Oil Extra Virgin', 'De Cecco', 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop', 6.99, 'EUR', 884.00, 100.00, 14.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'C', 'OFF', 'FOUND'),
('3017620422068', 'Persil Washing Liquid', 'Persil', 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop', 6.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('3017620422069', 'Ariel Laundry Powder', 'Ariel', 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop', 8.49, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('3017620422070', 'Gillette Fusion Razor', 'Gillette', 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop', 12.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('3017620422071', 'Premium Organic Honey', 'Manuka Health', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=400&fit=crop', 15.99, 'EUR', 304.00, 0.00, 0.00, 82.00, 82.00, 0.00, 0.30, 0.01, 'C', 'OFF', 'FOUND'),
('3017620422072', 'Innocent Orange Juice', 'Innocent', 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop', 2.79, 'EUR', 45.00, 0.20, 0.00, 10.40, 10.40, 0.20, 0.70, 0.00, 'B', 'OFF', 'FOUND'),
('3017620422073', 'Pringles Sour Cream', 'Pringles', 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=400&fit=crop', 2.49, 'EUR', 536.00, 33.30, 3.10, 51.00, 1.10, 2.80, 5.90, 1.50, 'E', 'OFF', 'FOUND'),
('3017620422074', 'Müller Corner Crunch', 'Müller', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 1.29, 'EUR', 152.00, 5.80, 3.60, 22.00, 18.00, 0.30, 4.00, 0.15, 'C', 'OFF', 'FOUND'),
('3017620422075', 'Innocent Smoothie Blueberry', 'Innocent', 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop', 2.99, 'EUR', 56.00, 0.20, 0.00, 12.80, 12.20, 0.80, 0.60, 0.01, 'B', 'OFF', 'FOUND');


DROP TABLE IF EXISTS app_scan_logs;

CREATE TABLE app_scan_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Scan log ID',
  user_id BIGINT NOT NULL COMMENT '-> sys_user.user_id',
  barcode VARCHAR(32) NOT NULL COMMENT '-> app_products.barcode',
  scanned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time of scan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Scan history';



-- 3) Temporary cart items (MVP cart)

DROP TABLE IF EXISTS app_cart;

CREATE TABLE app_cart(
  cart_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
	product_id BIGINT NOT NULL,
	quantity INT NOT NULL DEFAULT 1,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uq_cart_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Cart Table';


-- 4) Purchases (header) - purchase history sessions

DROP TABLE IF EXISTS app_orders;

CREATE TABLE app_orders (
  order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
	
	
  product_id BIGINT NOT NULL,
  name VARCHAR(255) NOT NULL COMMENT 'Product name',
  brand VARCHAR(255) DEFAULT NULL COMMENT 'Brand name',
  image_url TEXT DEFAULT NULL COMMENT 'Image URL',
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  line_total DECIMAL(10,2) DEFAULT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'EUR',
	
  energy_kcal DECIMAL(6,2) DEFAULT NULL,
  fat DECIMAL(5,2) DEFAULT NULL,
  saturated_fat DECIMAL(5,2) DEFAULT NULL,
  carbohydrates DECIMAL(5,2) DEFAULT NULL,
  sugars DECIMAL(5,2) DEFAULT NULL,
  fiber DECIMAL(5,2) DEFAULT NULL,
  proteins DECIMAL(5,2) DEFAULT NULL,
  salt DECIMAL(5,2) DEFAULT NULL,
	
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  KEY idx_user_created (user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='orders table';

-- 6) User storage/pantry inventory table

DROP TABLE IF EXISTS app_user_storage;

CREATE TABLE app_user_storage (
  storage_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  name VARCHAR(255) NOT NULL,
  brand VARCHAR(255) DEFAULT NULL,
  image_url TEXT DEFAULT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) DEFAULT NULL,
  line_total DECIMAL(10,2) DEFAULT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'EUR',
  energy_kcal DECIMAL(6,2) DEFAULT NULL,
  fat DECIMAL(5,2) DEFAULT NULL,
  saturated_fat DECIMAL(5,2) DEFAULT NULL,
  carbohydrates DECIMAL(5,2) DEFAULT NULL,
  sugars DECIMAL(5,2) DEFAULT NULL,
  fiber DECIMAL(5,2) DEFAULT NULL,
  proteins DECIMAL(5,2) DEFAULT NULL,
  salt DECIMAL(5,2) DEFAULT NULL,
  consumption DECIMAL(10,2) DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_storage_user_product (user_id, product_id),
  KEY idx_user_created (user_id, created_at),
  KEY idx_product (product_id),
  CONSTRAINT fk_storage_user FOREIGN KEY (user_id) REFERENCES sys_user(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_storage_product FOREIGN KEY (product_id) REFERENCES app_products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;





-- 5) Purchase items (line items in each purchase)

DROP TABLE IF EXISTS app_purchase_items;

CREATE TABLE app_purchase_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  purchase_id BIGINT NOT NULL,
  barcode VARCHAR(32) NOT NULL,

  quantity INT NOT NULL DEFAULT 1,
	fat DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  saturated_fat DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  carbohydrates DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  sugars DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  fiber DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  proteins DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  salt DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
	

  -- Snapshot the price at purchase time (so history stays correct)
  unit_price DECIMAL(7,2) DEFAULT NULL,
  line_total DECIMAL(9,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Purchase line items';


DROP TABLE IF EXISTS app_unknown_barcodes;

CREATE TABLE app_unknown_barcodes (
  barcode VARCHAR(32) PRIMARY KEY COMMENT 'Barcode not found in OFF',
  first_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  seen_count INT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Unknown barcodes (OFF not found cache)';
	
DROP TABLE IF EXISTS app_user;

CREATE TABLE app_user (
  user_id           BIGINT       NOT NULL PRIMARY KEY COMMENT '= sys_user.user_id',
  display_name      VARCHAR(64)  DEFAULT NULL COMMENT 'Display name (Mine screen)',
  gender            VARCHAR(8)   DEFAULT NULL COMMENT 'Male / Female / Other',
  age               TINYINT UNSIGNED DEFAULT NULL COMMENT 'Age',
  weight_kg         DECIMAL(5,2) DEFAULT NULL COMMENT 'Weight in kg',
  height_m          DECIMAL(3,2) DEFAULT NULL COMMENT 'Height in meters',
  bmi               DECIMAL(4,2) DEFAULT NULL COMMENT 'BMI = weight_kg / height_m²',
  avatar_url        VARCHAR(512) DEFAULT NULL COMMENT 'Avatar URL',

  daily_calorie_goal INT UNSIGNED DEFAULT 2000 COMMENT 'Daily calorie goal (kcal)',

  bind_phone        VARCHAR(20)  DEFAULT NULL COMMENT 'Bound phone number',
  bind_google       VARCHAR(128) DEFAULT NULL COMMENT 'Bound Google unique id',

  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_app_user_sys_user FOREIGN KEY (user_id) REFERENCES sys_user(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='App user profile (1:1 with sys_user)';