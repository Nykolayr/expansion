-- Platform admin: game settings, guests, monetization events

CREATE TABLE IF NOT EXISTS game_settings (
  game_slug VARCHAR(32) NOT NULL PRIMARY KEY,
  ads_enabled TINYINT(1) NOT NULL DEFAULT 1,
  donations_enabled TINYINT(1) NOT NULL DEFAULT 1,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO game_settings (game_slug, ads_enabled, donations_enabled)
VALUES ('expansion', 1, 1)
ON DUPLICATE KEY UPDATE game_slug = game_slug;

CREATE TABLE IF NOT EXISTS guest_devices (
  device_id VARCHAR(64) NOT NULL PRIMARY KEY,
  game_slug VARCHAR(32) NOT NULL DEFAULT 'expansion',
  profile_json JSON NOT NULL,
  first_seen TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_guest_devices_game (game_slug),
  KEY idx_guest_devices_last_seen (last_seen)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS purchase_events (
  id CHAR(36) NOT NULL PRIMARY KEY,
  game_slug VARCHAR(32) NOT NULL DEFAULT 'expansion',
  device_id VARCHAR(64) NOT NULL,
  user_id CHAR(36) NULL,
  product_id VARCHAR(128) NOT NULL,
  store VARCHAR(32) NOT NULL DEFAULT 'unknown',
  price_rub DECIMAL(10, 2) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_purchase_game_created (game_slug, created_at),
  KEY idx_purchase_device (device_id),
  KEY idx_purchase_user (user_id),
  CONSTRAINT fk_purchase_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ad_events (
  id CHAR(36) NOT NULL PRIMARY KEY,
  game_slug VARCHAR(32) NOT NULL DEFAULT 'expansion',
  device_id VARCHAR(64) NOT NULL,
  event_type ENUM('banner', 'interstitial', 'rewarded') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ad_game_created (game_slug, created_at),
  KEY idx_ad_device (device_id),
  KEY idx_ad_type (event_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
