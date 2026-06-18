import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/cost_calculator.dart';
import '../../core/providers.dart';
import '../../core/utils/currency.dart';
import '../../data/models/calculation.dart';
import '../../data/models/lot_entry.dart';

const _calculator = CostCalculator();

/// Aktif olarak düzenlenen hesabın durumu.
class CalculatorState {
  /// Düzenlenmekte olan kayıtlı hesabın id'si (yeni hesapta null).
  final String? editingId;
  final String name;
  final String currencyCode;
  final List<LotEntry> entries;

  const CalculatorState({
    this.editingId,
    required this.name,
    required this.currencyCode,
    required this.entries,
  });

  factory CalculatorState.initial() => CalculatorState(
        name: '',
        currencyCode: AppCurrency.try_.code,
        entries: [LotEntry.empty(), LotEntry.empty()],
      );

  AppCurrency get currency => AppCurrency.byCode(currencyCode);
  CostResult get result => _calculator.calculate(entries);
  bool get hasUnsavedData =>
      entries.any((e) => e.price > 0 && e.quantity > 0);

  CalculatorState copyWith({
    String? editingId,
    bool clearEditingId = false,
    String? name,
    String? currencyCode,
    List<LotEntry>? entries,
  }) =>
      CalculatorState(
        editingId: clearEditingId ? null : (editingId ?? this.editingId),
        name: name ?? this.name,
        currencyCode: currencyCode ?? this.currencyCode,
        entries: entries ?? this.entries,
      );
}

class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() => CalculatorState.initial();

  void addEntry() {
    state = state.copyWith(entries: [...state.entries, LotEntry.empty()]);
  }

  void removeEntry(String id) {
    final next = state.entries.where((e) => e.id != id).toList();
    state = state.copyWith(
      entries: next.isEmpty ? [LotEntry.empty()] : next,
    );
  }

  void updateEntry(String id, {double? price, double? quantity}) {
    state = state.copyWith(
      entries: [
        for (final e in state.entries)
          if (e.id == id) e.copyWith(price: price, quantity: quantity) else e,
      ],
    );
  }

  void setCurrency(String code) =>
      state = state.copyWith(currencyCode: code);

  void setName(String name) => state = state.copyWith(name: name);

  void reset() => state = CalculatorState.initial();

  /// Kayıtlı bir hesabı düzenlemek için yükler.
  void loadFrom(Calculation calc) {
    state = CalculatorState(
      editingId: calc.id,
      name: calc.name,
      currencyCode: calc.currencyCode,
      entries: calc.entries.isEmpty
          ? [LotEntry.empty()]
          : List<LotEntry>.from(calc.entries),
    );
  }

  /// Mevcut durumu bir [Calculation] nesnesine dönüştürür.
  Calculation toCalculation(String name) {
    final cleanEntries =
        state.entries.where((e) => e.price > 0 && e.quantity > 0).toList();
    if (state.editingId != null) {
      return Calculation(
        id: state.editingId!,
        name: name,
        currencyCode: state.currencyCode,
        entries: cleanEntries,
        updatedAt: DateTime.now(),
      );
    }
    return Calculation.create(
      name: name,
      currencyCode: state.currencyCode,
      entries: cleanEntries,
    );
  }

  void markSaved(String id) => state = state.copyWith(editingId: id);
}

final calculatorProvider =
    NotifierProvider<CalculatorNotifier, CalculatorState>(
        CalculatorNotifier.new);

/// Kaydedilmiş hesapların listesi.
class SavedCalculationsNotifier extends Notifier<List<Calculation>> {
  @override
  List<Calculation> build() =>
      ref.watch(calculationRepositoryProvider).loadAll();

  Future<void> save(Calculation calc) async {
    state = await ref.read(calculationRepositoryProvider).save(calc);
  }

  Future<void> delete(String id) async {
    state = await ref.read(calculationRepositoryProvider).delete(id);
  }

  Future<int> import(String json, {bool merge = true}) async {
    final count = await ref
        .read(calculationRepositoryProvider)
        .importJson(json, merge: merge);
    state = ref.read(calculationRepositoryProvider).loadAll();
    return count;
  }

  String export() => ref.read(calculationRepositoryProvider).exportJson();
}

final savedCalculationsProvider =
    NotifierProvider<SavedCalculationsNotifier, List<Calculation>>(
        SavedCalculationsNotifier.new);
