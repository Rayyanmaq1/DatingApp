class Gifts {
  String imageUrl;
  String coins;
  Gifts(this.imageUrl, this.coins);
}

List<Gifts> getGiftsList() {
  return [
    Gifts('assets/Gifts/Lolipop.png', '30'),
    Gifts('assets/Gifts/Chocolate.png', '70'),
    Gifts('assets/Gifts/Flowerbundle.png', '90'),
    Gifts('assets/Gifts/Bear.png', '280'),
    Gifts('assets/Gifts/Perfume.png', '500'),
    Gifts('assets/Gifts/champagne.png', '1000'),
    Gifts('assets/Gifts/Car.png', '10000'),
    Gifts('assets/Gifts/Donut.png', '120'),
  ];
}

List<Gifts> getlist() {
  return [
    Gifts('assets/Gifts/Heart.png', '300'),
    Gifts('assets/Gifts/Necklec.png', '400'),
    Gifts('assets/Gifts/Sigar.png', '750'),
    Gifts('assets/Gifts/Crown.png', '3000'),
    Gifts('assets/Gifts/Treasure.png', '800'),
    Gifts('assets/Gifts/Ring.png', '2000'),
    Gifts('assets/Gifts/RoyalCar.png', '5000'),
  ];
}
