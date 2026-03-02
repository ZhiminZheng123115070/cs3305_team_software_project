-- Seed diet, purchase, and weight data for admin (user_id=1) from Feb 15 to Feb 17, 2026
-- Run after schema and sys_user exist. Admin user_id = 1.

USE `ry-vue`;

-- 1) Ensure admin has app_user_info (current profile)
INSERT INTO app_user_info (user_id, nickname, weight, height, age, gender, bmi, bmr, status, created_at, updated_at)
VALUES (1, 'Admin', 71.0, 170.00, 30, 1, 24.57, 1471.50, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  weight = 71.0, height = 170.00, age = 30, gender = 1, bmi = 24.57, bmr = 1471.50, updated_at = NOW();

-- 2) Weight history (app_user_info_record) - Feb 15, 16, 17
-- Feb 15: 72kg, Feb 16: 71.5kg, Feb 17: 71kg
INSERT INTO app_user_info_record (user_id, nickname, weight, height, age, gender, bmi, bmr, status, created_at) VALUES
(1, 'Admin', 72.0, 170.00, 30, 1, 24.91, 1486.25, 1, '2026-02-15 08:00:00'),
(1, 'Admin', 71.5, 170.00, 30, 1, 24.74, 1479.00, 1, '2026-02-16 08:00:00'),
(1, 'Admin', 71.0, 170.00, 30, 1, 24.57, 1471.50, 1, '2026-02-17 08:00:00');

-- 3) Diet log (app_user_diet_log) - product_id refs app_products (1-50)
-- Feb 15
INSERT INTO app_user_diet_log (user_id, product_id, calories_kcal, consumption_rate, eaten_at) VALUES
(1, 5, 59.50, 0.5000, '2026-02-15 08:30:00'),   -- Müller Rice Chocolate 50%
(1, 8, 71.00, 0.5000, '2026-02-15 08:30:00'),   -- Müller Corner Chocolate 50%
(1, 11, 77.00, 1.0000, '2026-02-15 12:15:00'),  -- Danone Activia Natural
(1, 6, 179.00, 0.5000, '2026-02-15 19:00:00'),  -- Pasta Barilla 50%
(1, 22, 20.50, 1.0000, '2026-02-15 19:00:00');  -- Dolmio Sauce
-- Feb 16
INSERT INTO app_user_diet_log (user_id, product_id, calories_kcal, consumption_rate, eaten_at) VALUES
(1, 1, 47.00, 1.0000, '2026-02-16 08:00:00'),   -- Lactel Milk
(1, 46, 189.50, 0.5000, '2026-02-16 08:00:00'), -- Kellogg's Corn Flakes 50%
(1, 4, 245.50, 0.5000, '2026-02-16 12:30:00'),  -- Snickers 50%
(1, 14, 21.00, 1.0000, '2026-02-16 14:00:00'),  -- Coca-Cola Classic
(1, 49, 99.50, 0.5000, '2026-02-16 19:30:00');  -- Birds Eye Fish Fingers 50%
-- Feb 17
INSERT INTO app_user_diet_log (user_id, product_id, calories_kcal, consumption_rate, eaten_at) VALUES
(1, 32, 194.50, 0.5000, '2026-02-17 08:15:00'), -- Quaker Oats 50%
(1, 41, 28.00, 1.0000, '2026-02-17 08:15:00'),  -- Tropicana Orange Juice
(1, 8, 142.00, 1.0000, '2026-02-17 12:00:00'),  -- Müller Corner Chocolate
(1, 23, 237.00, 0.5000, '2026-02-17 18:00:00'), -- Oreo 50%
(1, 64, 122.00, 0.5000, '2026-02-17 20:00:00'); -- Ben & Jerry 50%

-- 4) Nutrition records (app_user_info_nutrition_record) - daily totals per add
-- Feb 15 total ~407 kcal
INSERT INTO app_user_info_nutrition_record (user_id, energy_kcal, fat, saturated_fat, carbohydrates, sugars, fiber, proteins, salt, record_date) VALUES
(1, 59.50, 1.60, 1.00, 9.75, 6.60, 0.15, 1.70, 0.06, '2026-02-15'),
(1, 71.00, 2.60, 1.70, 10.25, 8.60, 0.15, 1.90, 0.07, '2026-02-15'),
(1, 77.00, 3.10, 2.00, 9.50, 9.50, 0.00, 3.40, 0.12, '2026-02-15'),
(1, 179.00, 1.25, 0.25, 35.50, 1.60, 1.50, 6.25, 0.005, '2026-02-15'),
(1, 20.50, 0.25, 0.05, 3.90, 2.60, 0.60, 0.80, 0.33, '2026-02-15');
-- Feb 16 total ~524 kcal
INSERT INTO app_user_info_nutrition_record (user_id, energy_kcal, fat, saturated_fat, carbohydrates, sugars, fiber, proteins, salt, record_date) VALUES
(1, 47.00, 0.80, 0.50, 2.40, 2.40, 0.00, 1.60, 0.05, '2026-02-16'),
(1, 189.50, 0.45, 0.10, 42.00, 4.00, 1.20, 3.50, 0.55, '2026-02-16'),
(1, 245.50, 11.95, 4.10, 30.50, 25.50, 1.25, 3.80, 0.21, '2026-02-16'),
(1, 21.00, 0.00, 0.00, 5.30, 5.30, 0.00, 0.00, 0.005, '2026-02-16'),
(1, 99.50, 4.60, 0.40, 10.00, 0.40, 0.60, 5.50, 0.33, '2026-02-16');
-- Feb 17 total ~724 kcal
INSERT INTO app_user_info_nutrition_record (user_id, energy_kcal, fat, saturated_fat, carbohydrates, sugars, fiber, proteins, salt, record_date) VALUES
(1, 194.50, 3.45, 0.60, 33.00, 0.50, 5.30, 8.45, 0.005, '2026-02-17'),
(1, 28.00, 0.10, 0.00, 5.20, 5.20, 0.10, 0.35, 0.00, '2026-02-17'),
(1, 142.00, 5.20, 3.40, 20.50, 17.20, 0.30, 3.80, 0.14, '2026-02-17'),
(1, 237.00, 10.00, 2.60, 36.00, 21.00, 1.25, 2.50, 0.38, '2026-02-17'),
(1, 122.00, 6.50, 3.50, 15.00, 12.50, 0.00, 2.00, 0.13, '2026-02-17');

-- 5) Purchases (app_orders) - admin bought products Feb 15-17
INSERT INTO app_orders (user_id, product_id, name, brand, image_url, quantity, unit_price, line_total, currency, energy_kcal, fat, saturated_fat, carbohydrates, sugars, fiber, proteins, salt, created_at) VALUES
(1, 1, 'Lactel Semi-Skimmed Milk', 'Lactel', 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop', 2, 0.99, 1.98, 'EUR', 47.00, 1.60, 1.00, 4.80, 4.80, 0.00, 3.20, 0.10, '2026-02-15 09:00:00'),
(1, 6, 'Pasta Barilla Spaghetti', 'Barilla', 'https://images.unsplash.com/photo-1551462147-5e923c7a0a3a?w=400&h=400&fit=crop', 1, 1.29, 1.29, 'EUR', 358.00, 2.50, 0.50, 71.00, 3.20, 3.00, 12.50, 0.01, '2026-02-15 09:00:00'),
(1, 8, 'Müller Corner Chocolate', 'Müller', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 3, 1.29, 3.87, 'EUR', 142.00, 5.20, 3.40, 20.50, 17.20, 0.30, 3.80, 0.14, '2026-02-15 09:00:00'),
(1, 4, 'Snickers Chocolate Bar', 'Mars', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 2, 1.19, 2.38, 'EUR', 491.00, 23.90, 8.20, 61.00, 51.00, 2.50, 7.60, 0.42, '2026-02-16 10:30:00'),
(1, 49, 'Birds Eye Fish Fingers', 'Birds Eye', 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&h=400&fit=crop', 1, 3.29, 3.29, 'EUR', 199.00, 9.20, 0.80, 20.00, 0.80, 1.20, 11.00, 0.65, '2026-02-16 10:30:00'),
(1, 32, 'Quaker Oats Original', 'Quaker', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=400&fit=crop', 1, 2.49, 2.49, 'EUR', 389.00, 6.90, 1.20, 66.00, 1.00, 10.60, 16.90, 0.01, '2026-02-17 11:00:00'),
(1, 64, 'Ben & Jerry Cookie Dough', 'Ben & Jerry''s', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=400&fit=crop', 1, 5.49, 5.49, 'EUR', 244.00, 13.00, 7.00, 30.00, 25.00, 0.00, 4.00, 0.25, '2026-02-17 11:00:00');

-- 6) Storage (app_user_storage) - pantry items for admin
INSERT INTO app_user_storage (user_id, product_id, name, brand, image_url, quantity, unit_price, line_total, currency, energy_kcal, fat, carbohydrates, proteins, consumption, created_at, updated_at) VALUES
(1, 1, 'Lactel Semi-Skimmed Milk', 'Lactel', 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop', 2, 0.99, 1.98, 'EUR', 47.00, 1.60, 4.80, 3.20, 0.50, '2026-02-15 09:00:00', NOW()),
(1, 6, 'Pasta Barilla Spaghetti', 'Barilla', 'https://images.unsplash.com/photo-1551462147-5e923c7a0a3a?w=400&h=400&fit=crop', 1, 1.29, 1.29, 'EUR', 358.00, 2.50, 71.00, 12.50, 0.50, '2026-02-15 09:00:00', NOW()),
(1, 8, 'Müller Corner Chocolate', 'Müller', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 3, 1.29, 3.87, 'EUR', 142.00, 5.20, 20.50, 3.80, 0.17, '2026-02-15 09:00:00', NOW()),
(1, 11, 'Danone Activia Natural', 'Danone', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop', 1, 1.39, 1.39, 'EUR', 77.00, 3.10, 9.50, 3.40, 0, '2026-02-15 12:15:00', NOW()),
(1, 4, 'Snickers Chocolate Bar', 'Mars', 'https://images.unsplash.com/photo-1606312619070-d48b4e001c85?w=400&h=400&fit=crop', 2, 1.19, 2.38, 'EUR', 491.00, 23.90, 61.00, 7.60, 0.75, '2026-02-16 10:30:00', NOW()),
(1, 32, 'Quaker Oats Original', 'Quaker', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=400&fit=crop', 1, 2.49, 2.49, 'EUR', 389.00, 6.90, 66.00, 16.90, 0.50, '2026-02-17 11:00:00', NOW());
