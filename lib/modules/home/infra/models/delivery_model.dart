import 'package:flutter_clean_architeture/modules/home/domain/entities/delivery.dart';
import 'package:flutter_clean_architeture/modules/home/infra/models/delivery_events_model.dart';
import 'package:hive/hive.dart';

part 'delivery_model.g.dart';

@HiveType(typeId: 0)
class DeliveryModel extends HiveObject {
  @HiveField(1)
  final String code;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final List<DeliveryEventsModel> events;

  DeliveryModel({required this.code, required this.events, this.title});

  DeliveryModel copyWith({
    String? code,
    List<DeliveryEventsModel>? events,
    String? title,
  }) =>
      DeliveryModel(
        code: code ?? this.code,
        events: events ?? this.events,
        title: title ?? this.title,
      );

  Delivery mapToDomain() => Delivery(
        code: code,
        events: events.map((e) => e.mapToDomain()).toList(),
        title: title,
      );
}
