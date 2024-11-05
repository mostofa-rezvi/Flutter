import 'package:flutter/material.dart';

class HotelProfilePage extends StatelessWidget {
  final String hotelName;
  final String hotelImageUrl;
  final String address;
  final String rating;
  final int minPrice;
  final int maxPrice;

  HotelProfilePage({
    required this.hotelName,
    required this.hotelImageUrl,
    required this.address,
    required this.rating,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$hotelName Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              hotelImageUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              hotelName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Address: $address',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Rating: $rating ⭐',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Price Range: \$${minPrice.toString()} - \$${maxPrice.toString()}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('View Rooms Clicked');
              },
              icon: Icon(Icons.room_service),
              label: Text('View Rooms'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Book Now Clicked');
              },
              icon: Icon(Icons.book_online),
              label: Text('Manage Bookings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Edit Profile Clicked');
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
