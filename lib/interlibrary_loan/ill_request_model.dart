class IllRequestModel {
  String illRequestStatusRecordId;
  String statusDateTime;
  String statusName;
  String title;
  String organisation;

  IllRequestModel({
    this.illRequestStatusRecordId,
    this.statusDateTime,
    this.statusName,
    this.title,
    this.organisation,
  });

  factory IllRequestModel.fromJson(Map<String, dynamic> json) => new IllRequestModel(
    illRequestStatusRecordId: json['statusRecordId'],
    statusDateTime: json['dateTime'],
    statusName: json['status'],
    title: json['title'],
    organisation: json['organisation'],
  );

  @override
  String toString() {
    return 'IllRequestModel{illRequestStatusRecordId: $illRequestStatusRecordId, statusDateTime: $statusDateTime, statusName: $statusName, title: $title, organisation: $organisation}';
  }
}