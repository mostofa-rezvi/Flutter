import 'package:demo_flutter/model/Hotel.dart';
import 'package:demo_flutter/service/RoomService.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../model/Room.dart';

class RoomDetailsPage extends StatefulWidget {
  final Hotel hotel;

  RoomDetailsPage({required this.hotel});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  late Future<List<Room>> futureRooms;
  late Future<Hotel> futureHotel;

  @override
  void initState() {
    super.initState();

    futureHotel = RoomService().fetchHotelById(widget.hotel.id!);
    futureRooms = RoomService().fetchRoomsByHotelById(widget.hotel.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel and Room Details'),
      ),
      body: FutureBuilder<Hotel>(
          future: futureHotel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Hotel data not available'));
            } else {
              final hotel = snapshot.data!;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hotel.image != null && hotel.image!.isNotEmpty)
                          Image.network(
                            "http://localhost:8080/images/hotel/${hotel.image}",
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 16),
                        Text(
                          hotel.name.toString(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          hotel.address.toString(),
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        Text("Rating: ${hotel.rating}"),
                        Text(
                            "Price Range: \$${hotel.minPrice} - \$${hotel.maxPrice}"),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Room>>(
                        future: futureRooms,
                        builder: (context, roomSnapshot) {
                          if (roomSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (roomSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${roomSnapshot.error}'),
                            );
                          } else if (!roomSnapshot.hasData ||
                              roomSnapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No rooms are available'),
                            );
                          } else {
                            return ListView.builder(
                                itemCount: roomSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final room = roomSnapshot.data![index];

                                  return ListTile(
                                    title: Text(room.roomType.toString()),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price: \$${room.price?.toStringAsFixed(2)} \n'
                                          'Area: ${room.area} sq. ft. \n'
                                          'Adults: ${room.adultNo}, Children: ${room.childNo} \n'
                                          'Availability: ${room.availability ? "Available" : "Not available"}',
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Booking room: ${room.roomType}')),
                                            );
                                          },
                                          child: Text("Book Now"),
                                        ),
                                      ],
                                    ),
                                    trailing: Image.network(
                                      "http://localhost:8080/images/room/${room.image}",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                });
                          }
                        }),
                  ),
                ],
              );
            }
          }),
    );
  }
}
