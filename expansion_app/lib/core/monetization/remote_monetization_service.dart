/// Remote flags монетизации с VPS (`GET /expansion/config`).
class RemoteMonetizationService {
  bool adsEnabled = true;
  bool donationsEnabled = true;

  void apply({required bool adsEnabled, required bool donationsEnabled}) {
    this.adsEnabled = adsEnabled;
    this.donationsEnabled = donationsEnabled;
  }

  void resetToDefaults() {
    adsEnabled = true;
    donationsEnabled = true;
  }
}
