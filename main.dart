import 'package:flutter/material.dart';

void main() {
  runApp(CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Penjualan Kopi',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> coffeeMenu = [
    {
      'name': 'Kopi Arabika',
      'price': 15000,
      'description': 'Kopi Arabika dengan rasa klasik',
      'imagePath': 'assets/arabika.webp',
    },
    {
      'name': 'Kopi Robusta',
      'price': 12000,
      'description': 'Kopi Robusta dengan rasa kuat',
      'imagePath': 'assets/robusta.webp',
    },
    {
      'name': 'Kopi Luwak',
      'price': 50000,
      'description': 'Kopi Luwak premium, eksotis',
      'imagePath': 'assets/luwak.webp',
    },
    {
      'name': 'Kopi House Blend',
      'price': 20000,
      'description': 'Campuran kopi spesial',
      'imagePath': 'assets/Kopi House Blend.webp',
    },
  ];

  List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> coffee) {
    setState(() {
      cart.add(coffee);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('${coffee['name']} ditambahkan ke keranjang'),
        ],
      ),
      backgroundColor: Colors.brown,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/kopi_bengkulu.webp', 
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text('Kopi Bengkulu'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: coffeeMenu.length,
        itemBuilder: (context, index) {
          final coffee = coffeeMenu[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoffeeDetailPage(
                  coffee: coffee,
                  onAddToCart: addToCart,
                ),
              ),
            ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        coffee['imagePath'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Overlay for text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // Text content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          coffee['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        IconButton(
                          icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                          onPressed: () => addToCart(coffee),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CoffeeDetailPage extends StatelessWidget {
  final Map<String, dynamic> coffee;
  final Function(Map<String, dynamic>) onAddToCart;

  CoffeeDetailPage({required this.coffee, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(coffee['name'])),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              coffee['imagePath'],
              fit: BoxFit.cover,
            ),
          ),
          // Overlay for text readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coffee['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  coffee['description'],
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onAddToCart(coffee);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text('Tambah ke Keranjang'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double getTotalPrice() {
    return widget.cart.fold(0, (total, item) => total + item['price']);
  }

  void removeFromCart(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
      ),
      body: widget.cart.isEmpty
          ? Center(child: Text('Keranjang kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final item = widget.cart[index];
                      return Card(
                        color: Colors.brown[50],
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item['name']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeFromCart(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Harga: Rp${getTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.cart.clear();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Pembelian berhasil!'),
                          ));
                        },
                        child: Text('Selesaikan Pembelian'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}