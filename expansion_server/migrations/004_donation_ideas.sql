-- Идеи игроков к донату «Поддержка + Ваша идея» (tier3)

CREATE TABLE IF NOT EXISTS donation_ideas (
  id CHAR(36) NOT NULL PRIMARY KEY,
  game_slug VARCHAR(32) NOT NULL DEFAULT 'expansion',
  device_id VARCHAR(64) NOT NULL,
  user_id CHAR(36) NULL,
  email VARCHAR(255) NULL,
  idea_text TEXT NOT NULL,
  status ENUM('draft', 'paid', 'cancelled') NOT NULL DEFAULT 'draft',
  product_id VARCHAR(128) NULL,
  purchase_event_id CHAR(36) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  paid_at TIMESTAMP NULL,
  KEY idx_donation_ideas_game_status (game_slug, status, created_at),
  KEY idx_donation_ideas_device (device_id),
  KEY idx_donation_ideas_user (user_id),
  CONSTRAINT fk_donation_ideas_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
