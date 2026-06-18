import 'package:flutter_test/flutter_test.dart';

import 'package:bist_maliyet_asistani/core/calc/cost_calculator.dart';
import 'package:bist_maliyet_asistani/data/models/lot_entry.dart';

void main() {
  const calculator = CostCalculator();

  group('CostCalculator', () {
    test('boş liste için sıfır sonuç döner', () {
      final result = calculator.calculate([]);
      expect(result.totalQuantity, 0);
      expect(result.totalAmount, 0);
      expect(result.averageCost, 0);
    });

    test('ortalama maliyeti doğru hesaplar', () {
      // 100 lot x 100 + 200 lot x 200 = 50000 / 300 ≈ 166.67
      final entries = [
        const LotEntry(id: '1', price: 100, quantity: 100),
        const LotEntry(id: '2', price: 200, quantity: 200),
      ];
      final result = calculator.calculate(entries);
      expect(result.totalQuantity, 300);
      expect(result.totalAmount, 50000);
      expect(result.averageCost, closeTo(166.67, 0.01));
    });

    test('geçersiz (0 veya negatif) satırları yok sayar', () {
      final entries = [
        const LotEntry(id: '1', price: 10, quantity: 5),
        const LotEntry(id: '2', price: 0, quantity: 100),
        const LotEntry(id: '3', price: -5, quantity: 10),
      ];
      final result = calculator.calculate(entries);
      expect(result.totalQuantity, 5);
      expect(result.totalAmount, 50);
      expect(result.averageCost, 10);
    });

    test('hedef ortalama için gereken lot miktarını hesaplar', () {
      final entries = [
        const LotEntry(id: '1', price: 20, quantity: 100),
      ];
      // 20 maliyetli 100 lot var; 10'dan alıp ortalamayı 15 yapmak için
      // (2000 + 10x)/(100+x) = 15 => x = 100
      final lots = calculator.lotsNeededForTargetAverage(
        currentEntries: entries,
        buyPrice: 10,
        targetAverage: 15,
      );
      expect(lots, closeTo(100, 0.001));
    });
  });
}
