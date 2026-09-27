class DiagnosticState {
  double monthlyUsageM3;
  List<String> usageHours;
  int fixtureCount;
  String primaryFixture;

  DiagnosticState({
    this.monthlyUsageM3 = 20,
    List<String>? usageHours,
    this.fixtureCount = 1,
    this.primaryFixture = '',
  }) : usageHours = usageHours ?? ['morning', 'evening'];

  Map<String, dynamic> toJson() {
    return {
      'monthly_usage_m3': monthlyUsageM3,
      'usage_hours': usageHours,
      'fixture_count': fixtureCount,
      'primary_fixture': primaryFixture,
    };
  }
}