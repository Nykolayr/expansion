function defaultProfileJson(realName = '') {
  return {
    mapClassic: 1,
    scoreClassic: 0,
    difficulty: 'average',
    univerKind: 'classic',
    firstBattleCompleted: false,
    displayName: realName,
    defeatStreakSceneId: 0,
    defeatStreakCount: 0,
    asteroidTutorialSeen: false,
    debrisTutorialSeen: false,
    mission1TutorialCompleted: false,
    mapTutorialSeen: false,
    seenFeatureIntros: [],
    campaignStartedAtMillis: 0,
    adsRemoved: false,
    supporterTier: 0,
    meta: {
      enemyPowerLevel: 0,
      slots: [],
    },
  };
}

function mergeProfileJson(existing, patch) {
  const base =
    existing && typeof existing === 'object' ? existing : defaultProfileJson();
  const merged = {
    ...base,
    ...patch,
    meta: {
      ...(base.meta || {}),
      ...(patch.meta || {}),
    },
  };

  if (patch.seenFeatureIntros != null) {
    merged.seenFeatureIntros = patch.seenFeatureIntros;
  }

  return merged;
}

function parseProfileRow(row) {
  if (!row) return null;
  let profileJson = row.profile_json;
  if (typeof profileJson === 'string') {
    profileJson = JSON.parse(profileJson);
  }
  return {
    id: row.id,
    email: row.email,
    nick: row.nick,
    realName: row.real_name,
    emailVerified: Boolean(row.email_verified),
    createdAt: row.created_at,
    profile: profileJson,
  };
}

function publicUser(row) {
  return {
    id: row.id,
    email: row.email,
    nick: row.nick,
    realName: row.real_name,
    emailVerified: Boolean(row.email_verified),
  };
}

module.exports = {
  defaultProfileJson,
  mergeProfileJson,
  parseProfileRow,
  publicUser,
};
