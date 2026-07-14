-- Оплата СБП/QR: намерения + реквизиты в настройках игры (идемпотентно)

SET @db = DATABASE();

SET @col := (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = @db AND table_name = 'game_settings' AND column_name = 'payment_sbp_url');
SET @sql := IF(@col = 0,
  'ALTER TABLE game_settings ADD COLUMN payment_sbp_url VARCHAR(512) NULL DEFAULT NULL',
  'SELECT 1');
PREPARE s1 FROM @sql; EXECUTE s1; DEALLOCATE PREPARE s1;

SET @col := (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = @db AND table_name = 'game_settings' AND column_name = 'payment_qr_url');
SET @sql := IF(@col = 0,
  'ALTER TABLE game_settings ADD COLUMN payment_qr_url VARCHAR(512) NULL DEFAULT NULL',
  'SELECT 1');
PREPARE s2 FROM @sql; EXECUTE s2; DEALLOCATE PREPARE s2;

CREATE TABLE IF NOT EXISTS payment_intents (
  id CHAR(36) NOT NULL PRIMARY KEY,
  game_slug VARCHAR(32) NOT NULL DEFAULT 'expansion',
  device_id VARCHAR(64) NOT NULL,
  user_id CHAR(36) NULL,
  email VARCHAR(255) NULL,
  nick VARCHAR(64) NULL,
  product_id VARCHAR(128) NOT NULL,
  price_rub DECIMAL(10, 2) NOT NULL,
  payment_code VARCHAR(32) NOT NULL,
  idea_id CHAR(36) NULL,
  status ENUM('pending', 'paid', 'cancelled') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  paid_at TIMESTAMP NULL,
  UNIQUE KEY uq_payment_code (payment_code),
  KEY idx_payment_intents_status (game_slug, status, created_at),
  KEY idx_payment_intents_device (device_id),
  KEY idx_payment_intents_user (user_id),
  CONSTRAINT fk_payment_intents_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
  CONSTRAINT fk_payment_intents_idea FOREIGN KEY (idea_id) REFERENCES donation_ideas (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
