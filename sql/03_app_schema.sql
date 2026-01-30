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

  -- Nutrition per 100g (for filtering/sorting)
  energy_kcal DECIMAL(6,2) DEFAULT NULL COMMENT 'kcal per 100g',
  fat DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  saturated_fat DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  carbohydrates DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  sugars DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  fiber DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  proteins DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',
  salt DECIMAL(5,2) DEFAULT NULL COMMENT 'g per 100g',

  nutri_score CHAR(1) DEFAULT NULL COMMENT 'OFF Nutri-Score A–E (optional)',

  -- Cache metadata
  source VARCHAR(32) NOT NULL DEFAULT 'OFF' COMMENT 'Data source',
  source_url TEXT DEFAULT NULL COMMENT 'Product page/API url',
  product_status VARCHAR(16) NOT NULL DEFAULT 'FOUND' COMMENT 'FOUND / NOT_FOUND / PARTIAL',
  last_fetched_at DATETIME DEFAULT NULL COMMENT 'Last fetch time from OFF',

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_products_barcode (barcode),
  INDEX idx_products_name (name),
  INDEX idx_products_brand (brand),
  INDEX idx_products_price (price),
  INDEX idx_products_nutriscore (nutri_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Products cache (Open Food Facts + MVP price)';

-- 50 mock products
INSERT INTO app_products (barcode, name, brand, image_url, price, currency, energy_kcal, fat, saturated_fat, carbohydrates, sugars, fiber, proteins, salt, nutri_score, source, product_status) VALUES
('3017620422003', 'Nutella', 'Ferrero', NULL, 4.99, 'EUR', 2250.00, 30.90, 10.60, 56.30, 56.30, 0.00, 6.30, 0.11, 'E', 'OFF', 'FOUND'),
('8076809518951', 'Pasta Barilla Spaghetti', 'Barilla', NULL, 1.29, 'EUR', 358.00, 2.50, 0.50, 71.00, 3.20, 3.00, 12.50, 0.01, 'A', 'OFF', 'FOUND'),
('5449000000996', 'Coca-Cola Classic', 'Coca-Cola', NULL, 1.49, 'EUR', 42.00, 0.00, 0.00, 10.60, 10.60, 0.00, 0.00, 0.01, 'E', 'OFF', 'FOUND'),
('3017620422004', 'Kinder Bueno', 'Ferrero', NULL, 3.29, 'EUR', 575.00, 37.60, 18.50, 47.30, 40.00, 0.00, 8.60, 0.25, 'E', 'OFF', 'FOUND'),
('8076809518952', 'Olive Oil Extra Virgin', 'De Cecco', NULL, 6.99, 'EUR', 884.00, 100.00, 14.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'C', 'OFF', 'FOUND'),
('3017620422005', 'Lactel Semi-Skimmed Milk', 'Lactel', NULL, 0.99, 'EUR', 47.00, 1.60, 1.00, 4.80, 4.80, 0.00, 3.20, 0.10, 'A', 'OFF', 'FOUND'),
('5449000000997', 'Evian Natural Spring Water', 'Evian', NULL, 1.19, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'A', 'OFF', 'FOUND'),
('3017620422006', 'Philadelphia Original', 'Mondelez', NULL, 2.49, 'EUR', 253.00, 21.00, 12.00, 4.00, 4.00, 0.00, 5.50, 0.70, 'D', 'OFF', 'FOUND'),
('8076809518953', 'Heinz Tomato Ketchup', 'Heinz', NULL, 2.99, 'EUR', 112.00, 0.10, 0.00, 25.80, 22.80, 0.80, 1.80, 2.70, 'D', 'OFF', 'FOUND'),
('5449000000998', 'Nestle Kit Kat', 'Nestle', NULL, 1.79, 'EUR', 518.00, 29.60, 18.00, 58.30, 51.00, 0.00, 6.20, 0.15, 'E', 'OFF', 'FOUND'),
('3017620422007', 'Danone Activia Natural', 'Danone', NULL, 1.39, 'EUR', 77.00, 3.10, 2.00, 9.50, 9.50, 0.00, 3.40, 0.12, 'B', 'OFF', 'FOUND'),
('8076809518954', 'Lays Classic Chips', 'Lays', NULL, 2.29, 'EUR', 536.00, 34.60, 3.20, 49.70, 0.60, 4.20, 6.70, 1.20, 'E', 'OFF', 'FOUND'),
('5449000000999', 'Müller Corner Strawberry', 'Müller', NULL, 1.29, 'EUR', 142.00, 5.20, 3.40, 20.50, 17.20, 0.30, 3.80, 0.14, 'C', 'OFF', 'FOUND'),
('3017620422008', 'Lindt Lindor Milk', 'Lindt', NULL, 4.49, 'EUR', 598.00, 47.00, 35.00, 44.00, 42.00, 0.00, 5.90, 0.18, 'E', 'OFF', 'FOUND'),
('8076809518955', 'Marmite Yeast Extract', 'Marmite', NULL, 3.99, 'EUR', 221.00, 0.00, 0.00, 38.00, 0.00, 0.00, 38.00, 11.00, 'C', 'OFF', 'FOUND'),
('5449000010000', 'Red Bull Energy Drink', 'Red Bull', NULL, 1.99, 'EUR', 45.00, 0.00, 0.00, 11.00, 11.00, 0.00, 0.00, 0.10, 'E', 'OFF', 'FOUND'),
('3017620422009', 'Weetabix Original', 'Weetabix', NULL, 2.79, 'EUR', 362.00, 2.00, 0.60, 69.00, 4.40, 10.00, 11.00, 0.28, 'B', 'OFF', 'FOUND'),
('8076809518956', 'Ben & Jerry Cookie Dough', 'Ben & Jerry''s', NULL, 5.49, 'EUR', 244.00, 13.00, 7.00, 30.00, 25.00, 0.00, 4.00, 0.25, 'D', 'OFF', 'FOUND'),
('5449000010001', 'Innocent Smoothie Mango', 'Innocent', NULL, 2.99, 'EUR', 56.00, 0.20, 0.00, 12.80, 12.20, 0.80, 0.60, 0.01, 'B', 'OFF', 'FOUND'),
('3017620422010', 'Cadbury Dairy Milk', 'Cadbury', NULL, 2.19, 'EUR', 534.00, 30.00, 18.00, 57.00, 56.00, 0.00, 7.50, 0.25, 'E', 'OFF', 'FOUND'),
('8076809518957', 'Quaker Oats Original', 'Quaker', NULL, 2.49, 'EUR', 389.00, 6.90, 1.20, 66.00, 1.00, 10.60, 16.90, 0.01, 'A', 'OFF', 'FOUND'),
('5449000010002', 'San Pellegrino Sparkling', 'San Pellegrino', NULL, 1.29, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'A', 'OFF', 'FOUND'),
('3017620422011', 'Müller Rice Chocolate', 'Müller', NULL, 1.19, 'EUR', 119.00, 3.20, 2.00, 19.50, 13.20, 0.30, 3.40, 0.12, 'B', 'OFF', 'FOUND'),
('8076809518958', 'Hellmann''s Mayo', 'Hellmann''s', NULL, 3.29, 'EUR', 720.00, 79.00, 6.00, 2.70, 2.70, 0.00, 1.10, 1.30, 'E', 'OFF', 'FOUND'),
('5449000010003', 'Tropicana Orange Juice', 'Tropicana', NULL, 2.79, 'EUR', 45.00, 0.20, 0.00, 10.40, 10.40, 0.20, 0.70, 0.00, 'B', 'OFF', 'FOUND'),
('3017620422012', 'Belvita Breakfast Biscuits', 'Belvita', NULL, 2.99, 'EUR', 448.00, 16.00, 4.50, 68.00, 24.00, 3.00, 7.80, 0.45, 'D', 'OFF', 'FOUND'),
('8076809518959', 'Pringles Original', 'Pringles', NULL, 2.49, 'EUR', 536.00, 33.30, 3.10, 51.00, 1.10, 2.80, 5.90, 1.50, 'E', 'OFF', 'FOUND'),
('5449000010004', 'Alpro Soy Milk', 'Alpro', NULL, 1.99, 'EUR', 33.00, 1.90, 0.30, 0.60, 0.60, 0.60, 3.00, 0.10, 'A', 'OFF', 'FOUND'),
('3017620422013', 'McVitie''s Digestive', 'McVitie''s', NULL, 1.49, 'EUR', 486.00, 21.30, 10.10, 62.60, 16.60, 2.70, 7.10, 1.00, 'D', 'OFF', 'FOUND'),
('8076809518960', 'Mountain Dew', 'PepsiCo', NULL, 1.39, 'EUR', 46.00, 0.00, 0.00, 11.60, 11.60, 0.00, 0.00, 0.03, 'E', 'OFF', 'FOUND'),
('5449000010005', 'Green Giant Sweet Corn', 'Green Giant', NULL, 1.29, 'EUR', 76.00, 1.20, 0.20, 14.50, 5.20, 2.70, 2.90, 0.35, 'A', 'OFF', 'FOUND'),
('3017620422014', 'Maltesers', 'Mars', NULL, 2.59, 'EUR', 503.00, 24.50, 14.90, 62.00, 56.00, 0.00, 8.40, 0.42, 'E', 'OFF', 'FOUND'),
('8076809518961', 'Knorr Chicken Stock', 'Knorr', NULL, 1.79, 'EUR', 167.00, 8.20, 4.50, 15.00, 2.00, 0.50, 8.50, 18.00, 'D', 'OFF', 'FOUND'),
('5449000010006', 'Innocent Coconut Water', 'Innocent', NULL, 2.49, 'EUR', 19.00, 0.00, 0.00, 3.80, 3.60, 0.00, 0.00, 0.05, 'A', 'OFF', 'FOUND'),
('3017620422015', 'Häagen-Dazs Vanilla', 'Häagen-Dazs', NULL, 5.99, 'EUR', 249.00, 16.00, 10.00, 22.00, 20.00, 0.00, 3.60, 0.12, 'D', 'OFF', 'FOUND'),
('8076809518962', 'Colgate Total Toothpaste', 'Colgate', NULL, 3.49, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('5449000010007', 'Clif Bar Chocolate', 'Clif Bar', NULL, 2.29, 'EUR', 353.00, 6.00, 1.50, 66.00, 21.00, 5.00, 12.00, 0.35, 'C', 'OFF', 'FOUND'),
('3017620422016', 'Toblerone Milk', 'Toblerone', NULL, 3.99, 'EUR', 525.00, 29.50, 18.00, 60.00, 59.00, 0.00, 5.60, 0.12, 'E', 'OFF', 'FOUND'),
('8076809518963', 'Nivea Creme', 'Nivea', NULL, 4.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('5449000010008', 'Birds Eye Fish Fingers', 'Birds Eye', NULL, 3.29, 'EUR', 199.00, 9.20, 0.80, 20.00, 0.80, 1.20, 11.00, 0.65, 'B', 'OFF', 'FOUND'),
('3017620422017', 'Twix', 'Mars', NULL, 1.29, 'EUR', 502.00, 24.00, 15.00, 64.00, 49.00, 0.00, 4.60, 0.38, 'E', 'OFF', 'FOUND'),
('8076809518964', 'Dolmio Pasta Sauce', 'Dolmio', NULL, 1.99, 'EUR', 41.00, 0.50, 0.10, 7.80, 5.20, 1.20, 1.60, 0.65, 'A', 'OFF', 'FOUND'),
('5449000010009', 'Innocent Veg Pot', 'Innocent', NULL, 3.49, 'EUR', 52.00, 1.80, 0.30, 6.80, 2.80, 1.50, 2.80, 0.45, 'A', 'OFF', 'FOUND'),
('3017620422018', 'Snickers', 'Mars', NULL, 1.19, 'EUR', 491.00, 23.90, 8.20, 61.00, 51.00, 2.50, 7.60, 0.42, 'E', 'OFF', 'FOUND'),
('8076809518965', 'Philadelphia Light', 'Mondelez', NULL, 2.29, 'EUR', 181.00, 11.00, 7.00, 4.00, 4.00, 0.00, 8.20, 0.75, 'B', 'OFF', 'FOUND'),
('5449000010010', 'Ritter Sport Marzipan', 'Ritter Sport', NULL, 1.99, 'EUR', 553.00, 35.00, 17.00, 49.00, 46.00, 0.00, 7.00, 0.15, 'E', 'OFF', 'FOUND'),
('3017620422019', 'M&Ms Peanut', 'Mars', NULL, 2.79, 'EUR', 515.00, 26.00, 10.00, 59.00, 52.00, 0.00, 9.80, 0.12, 'E', 'OFF', 'FOUND'),
('8076809518966', 'Nescafe Gold Blend', 'Nestle', NULL, 5.99, 'EUR', 18.00, 0.20, 0.00, 1.00, 0.00, 0.00, 2.40, 0.05, 'B', 'OFF', 'FOUND'),
('5449000010011', 'Kellogg''s Corn Flakes', 'Kellogg''s', NULL, 2.99, 'EUR', 379.00, 0.90, 0.20, 84.00, 8.00, 2.40, 7.00, 1.10, 'B', 'OFF', 'FOUND'),
('3017620422020', 'Gillette Fusion Razor', 'Gillette', NULL, 12.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('8076809518967', 'Ariel Laundry Powder', 'Ariel', NULL, 8.49, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('5449000010012', 'Bonne Maman Jam', 'Bonne Maman', NULL, 3.29, 'EUR', 258.00, 0.10, 0.00, 60.00, 59.00, 0.50, 0.40, 0.02, 'D', 'OFF', 'FOUND'),
('3017620422021', 'Lurpak Butter', 'Lurpak', NULL, 3.99, 'EUR', 717.00, 81.00, 52.00, 0.60, 0.60, 0.00, 0.60, 0.02, 'D', 'OFF', 'FOUND'),
('8076809518968', 'Fage Total 0%', 'Fage', NULL, 1.69, 'EUR', 59.00, 0.20, 0.10, 4.00, 4.00, 0.00, 10.20, 0.12, 'A', 'OFF', 'FOUND'),
('5449000010013', 'Innocent Apple Juice', 'Innocent', NULL, 2.49, 'EUR', 44.00, 0.10, 0.00, 10.30, 9.80, 0.10, 0.10, 0.01, 'B', 'OFF', 'FOUND'),
('3017620422022', 'Carte Noire Coffee', 'Carte Noire', NULL, 4.49, 'EUR', 5.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.30, 0.02, 'A', 'OFF', 'FOUND'),
('8076809518969', 'Axe Body Spray', 'Axe', NULL, 3.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('5449000010014', 'Müller Light Strawberry', 'Müller', NULL, 1.09, 'EUR', 62.00, 0.10, 0.10, 10.20, 8.80, 0.30, 5.20, 0.18, 'A', 'OFF', 'FOUND'),
('3017620422023', 'Garnier Micellar Water', 'Garnier', NULL, 5.49, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('8076809518970', 'Persil Washing Liquid', 'Persil', NULL, 6.99, 'EUR', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 'OFF', 'FOUND'),
('5449000010015', 'Benecol Spread', 'Benecol', NULL, 4.29, 'EUR', 620.00, 60.00, 12.00, 0.00, 0.00, 0.00, 0.00, 0.60, 'C', 'OFF', 'FOUND'),
('3017620422024', 'Clover Spreadable', 'Clover', NULL, 2.79, 'EUR', 588.00, 59.00, 15.00, 5.50, 0.50, 0.00, 0.50, 0.55, 'D', 'OFF', 'FOUND'),
('8076809518971', 'Yeast Extract', 'Marmite', NULL, 2.49, 'EUR', 221.00, 0.00, 0.00, 38.00, 0.00, 0.00, 38.00, 11.00, 'C', 'OFF', 'FOUND'),
('5449000010016', 'Innocent Kids Smoothie', 'Innocent', NULL, 2.29, 'EUR', 52.00, 0.20, 0.00, 11.50, 10.80, 0.50, 0.50, 0.01, 'B', 'OFF', 'FOUND'),
('3017620422025', 'Oreo Original', 'Mondelez', NULL, 1.99, 'EUR', 474.00, 20.00, 5.20, 72.00, 42.00, 2.50, 5.00, 0.75, 'E', 'OFF', 'FOUND'),
('8076809518972', 'Coca-Cola Zero', 'Coca-Cola', NULL, 1.49, 'EUR', 1.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.02, 'B', 'OFF', 'FOUND'),
('5449000010017', 'Müller Rice Strawberry', 'Müller', NULL, 1.19, 'EUR', 119.00, 3.20, 2.00, 19.50, 13.20, 0.30, 3.40, 0.12, 'B', 'OFF', 'FOUND'),
('3017620422026', 'Pringles Sour Cream', 'Pringles', NULL, 2.49, 'EUR', 536.00, 33.30, 3.10, 51.00, 1.10, 2.80, 5.90, 1.50, 'E', 'OFF', 'FOUND'),
('8076809518973', 'Lipton Ice Tea Peach', 'Lipton', NULL, 1.79, 'EUR', 32.00, 0.00, 0.00, 7.80, 7.80, 0.00, 0.00, 0.02, 'D', 'OFF', 'FOUND'),
('5449000010018', 'Alpro Oat Milk', 'Alpro', NULL, 2.19, 'EUR', 47.00, 1.50, 0.20, 6.80, 4.10, 0.80, 1.00, 0.08, 'A', 'OFF', 'FOUND'),
('3017620422027', 'Müller Corner Chocolate', 'Müller', NULL, 1.29, 'EUR', 142.00, 5.20, 3.40, 20.50, 17.20, 0.30, 3.80, 0.14, 'C', 'OFF', 'FOUND'),
('8076809518974', 'Nando''s Peri-Peri Sauce', 'Nando''s', NULL, 3.49, 'EUR', 89.00, 0.50, 0.10, 18.00, 15.00, 0.50, 2.00, 2.80, 'C', 'OFF', 'FOUND'),
('5449000010019', 'Innocent Orange Juice', 'Innocent', NULL, 2.79, 'EUR', 45.00, 0.20, 0.00, 10.40, 10.40, 0.20, 0.70, 0.00, 'B', 'OFF', 'FOUND'),
('3017620422028', 'Galaxy Smooth Milk', 'Galaxy', NULL, 2.39, 'EUR', 522.00, 29.00, 18.00, 60.00, 59.00, 0.00, 5.50, 0.22, 'E', 'OFF', 'FOUND'),
('8076809518975', 'Müller Corner Crunch', 'Müller', NULL, 1.29, 'EUR', 152.00, 5.80, 3.60, 22.00, 18.00, 0.30, 4.00, 0.15, 'C', 'OFF', 'FOUND'),
('5449000010020', 'Innocent Smoothie Blueberry', 'Innocent', NULL, 2.99, 'EUR', 56.00, 0.20, 0.00, 12.80, 12.20, 0.80, 0.60, 0.01, 'B', 'OFF', 'FOUND');

-- 2) Scan logs (history of scans/lookups)

DROP TABLE IF EXISTS app_scan_logs;

CREATE TABLE app_scan_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Scan log ID',
  user_id BIGINT NOT NULL COMMENT 'FK -> sys_user.user_id',
  barcode VARCHAR(32) NOT NULL COMMENT 'FK -> app_products.barcode',
  scanned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time of scan',

  CONSTRAINT fk_scan_user
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id),

  CONSTRAINT fk_scan_product
    FOREIGN KEY (barcode) REFERENCES app_products(barcode),

  INDEX idx_scan_user_time (user_id, scanned_at),
  INDEX idx_scan_barcode_time (barcode, scanned_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Scan history';



-- 3) Temporary cart items (MVP cart)

DROP TABLE IF EXISTS app_cart_items;

CREATE TABLE app_cart_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  barcode VARCHAR(32) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_cart_user
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id),

  CONSTRAINT fk_cart_product
    FOREIGN KEY (barcode) REFERENCES app_products(barcode),

  UNIQUE KEY uq_cart_user_product (user_id, barcode),
  INDEX idx_cart_user (user_id),
  INDEX idx_cart_added (added_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Temporary cart items (MVP)';


-- 4) Purchases (header) - purchase history sessions

DROP TABLE IF EXISTS app_purchases;

CREATE TABLE app_purchases (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  purchased_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  total_price DECIMAL(10,2) DEFAULT NULL COMMENT 'Optional cached total',
  currency CHAR(3) NOT NULL DEFAULT 'EUR',

  CONSTRAINT fk_purchase_user
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id),

  INDEX idx_purchases_user_time (user_id, purchased_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Purchase records (headers)';



-- 5) Purchase items (line items in each purchase)

DROP TABLE IF EXISTS app_purchase_items;

CREATE TABLE app_purchase_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  purchase_id BIGINT NOT NULL,
  barcode VARCHAR(32) NOT NULL,

  quantity INT NOT NULL DEFAULT 1,

  -- Snapshot the price at purchase time (so history stays correct)
  unit_price DECIMAL(7,2) DEFAULT NULL,
  line_total DECIMAL(9,2) DEFAULT NULL,

  CONSTRAINT fk_purchaseitems_purchase
    FOREIGN KEY (purchase_id) REFERENCES app_purchases(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_purchaseitems_product
    FOREIGN KEY (barcode) REFERENCES app_products(barcode),

  INDEX idx_purchaseitems_purchase (purchase_id),
  INDEX idx_purchaseitems_barcode (barcode)
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