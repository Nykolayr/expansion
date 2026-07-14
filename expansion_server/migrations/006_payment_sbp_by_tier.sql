-- Отдельные СБП-ссылки по тарифам (идемпотентно)

SET @db = DATABASE();

SET @col := (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = @db AND table_name = 'game_settings' AND column_name = 'payment_sbp_url_tier1');
SET @sql := IF(@col = 0,
  'ALTER TABLE game_settings ADD COLUMN payment_sbp_url_tier1 VARCHAR(512) NULL DEFAULT NULL',
  'SELECT 1');
PREPARE s1 FROM @sql; EXECUTE s1; DEALLOCATE PREPARE s1;

SET @col := (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = @db AND table_name = 'game_settings' AND column_name = 'payment_sbp_url_tier2');
SET @sql := IF(@col = 0,
  'ALTER TABLE game_settings ADD COLUMN payment_sbp_url_tier2 VARCHAR(512) NULL DEFAULT NULL',
  'SELECT 1');
PREPARE s2 FROM @sql; EXECUTE s2; DEALLOCATE PREPARE s2;

SET @col := (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = @db AND table_name = 'game_settings' AND column_name = 'payment_sbp_url_tier3');
SET @sql := IF(@col = 0,
  'ALTER TABLE game_settings ADD COLUMN payment_sbp_url_tier3 VARCHAR(512) NULL DEFAULT NULL',
  'SELECT 1');
PREPARE s3 FROM @sql; EXECUTE s3; DEALLOCATE PREPARE s3;

SET @col := (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = @db AND table_name = 'game_settings' AND column_name = 'payment_sbp_url_remove_ads');
SET @sql := IF(@col = 0,
  'ALTER TABLE game_settings ADD COLUMN payment_sbp_url_remove_ads VARCHAR(512) NULL DEFAULT NULL',
  'SELECT 1');
PREPARE s4 FROM @sql; EXECUTE s4; DEALLOCATE PREPARE s4;
