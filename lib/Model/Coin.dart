enum Offer { SALE, HOT, BEST, NONE }

class BuyCoin {
  String imageUrl;
  String coins;
  String price;
  String title;
  Offer offer;
  BuyCoin({this.imageUrl, this.title, this.coins, this.offer, this.price});
}

List<BuyCoin> getCoinData() {
  return [
    BuyCoin(
        imageUrl: 'assets/buyCoins/SaleBanner.png',
        title: 'Once Only',
        coins: '300',
        price: '0.71',
        offer: Offer.SALE),
    BuyCoin(
        imageUrl: 'assets/Coin.png',
        title: 'Basic',
        coins: '300',
        price: '1.69',
        offer: Offer.NONE),
    BuyCoin(
        imageUrl: 'assets/buyCoins/FewCoins.png',
        title: '10 % OFF',
        coins: '1200',
        price: '5.99',
        offer: Offer.BEST),
    BuyCoin(
        imageUrl: 'assets/buyCoins/Chest.png',
        title: 'Basic',
        coins: '250',
        price: '5.99',
        offer: Offer.NONE),
    BuyCoin(
        imageUrl: 'assets/buyCoins/CoinBag1.png',
        title: '20 % OFF',
        coins: '7000',
        price: '30.38',
        offer: Offer.NONE),
    BuyCoin(
        imageUrl: 'assets/buyCoins/CoinBag2.png',
        title: '30 % OFF',
        coins: '15000',
        price: '61.22',
        offer: Offer.NONE),
    BuyCoin(
        imageUrl: 'assets/buyCoins/CoinBag3.png',
        title: '35 % OFF',
        coins: '35000',
        price: '134.62',
        offer: Offer.HOT),
  ];
}
