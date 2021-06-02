class UserMessage {
  UserMessage({
    this.id,
    this.name,
    this.email,
  });

  factory UserMessage.fromMap(Map<String, dynamic> data) {
    return UserMessage(
        id: data['id'], name: data['name'], email: data['email']);
  }

  final String id;
  final String name;
  final String email;
}