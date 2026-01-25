USE `ry-vue`;


-- 1) Products (Open Food Facts cache + simple MVP price)

DROP TABLE IF EXISTS app_products;

CREATE TABLE app_products (
  barcode VARCHAR(32) PRIMARY KEY COMMENT 'Barcode (EAN/UPC)',
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

  INDEX idx_products_name (name),
  INDEX idx_products_brand (brand),
  INDEX idx_products_price (price),
  INDEX idx_products_nutriscore (nutri_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Products cache (Open Food Facts + MVP price)';



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