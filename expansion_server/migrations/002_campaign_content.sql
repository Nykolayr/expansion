-- OTA campaign content (JSON pack per version)

CREATE TABLE IF NOT EXISTS campaign_content (
  content_version INT NOT NULL PRIMARY KEY,
  payload_json LONGTEXT NOT NULL,
  published_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
