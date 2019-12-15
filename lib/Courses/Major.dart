class Major {
  int id;
  String name;
  var courses;

  Major(this.id, this.name);

  static List<Major> getMajors() {
    return <Major>[
      Major(1, 'Development'),
      Major(2, 'Design'),
      Major(3, 'Business'),
    ];
  }
}

