class ProfileRepository {
  // This function simulates fetching profile data from an API or a local database
  Future<Map<String, dynamic>> getProfile() async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data (you can replace this with API call)
    return {
      'username': 'User01',
      'totalMoney': 32373.82,
    };
  }
}
