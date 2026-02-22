# Mekanism — Переработка руды

Руду нужно добывать с **Silk Touch** (Digital Miner или кирка с зачарованием), чтобы получить блок руды целиком и пропустить через цепочку переработки.

---

## x2 — Обогащение

Самый простой уровень. Удваивает выход.

```
Руда → [Enrichment Chamber] → 2 пыли → [Печь] → 2 слитка
```

**Что нужно построить:**
- Enrichment Chamber
- Печь (любая)

---

## x3 — Очистка

Утроение выхода. Требует кислород.

```
Руда → [Purification Chamber + кислород] → 3 комка
  → [Crusher] → 3 грязных пыли
  → [Enrichment Chamber] → 3 чистых пыли
  → [Печь] → 3 слитка
```

**Что нужно построить:**
- Purification Chamber
- Crusher
- Enrichment Chamber
- Печь
- Electrolytic Separator (кислород из воды)

**Откуда кислород:**
Electrolytic Separator + вода → кислород + водород

---

## x5 — Кристаллизация

Максимальный уровень. 5 слитков с 1 руды.

```
Руда → [Chemical Dissolution Chamber + серная кислота] → раствор
  → [Chemical Washer + вода] → чистый раствор
  → [Chemical Crystallizer] → 5 кристаллов
  → [Chemical Injection Chamber + HCl] → 5 осколков
  → [Purification Chamber + кислород] → 5 комков
  → [Crusher] → 5 грязных пылей
  → [Enrichment Chamber] → 5 чистых пылей
  → [Печь] → 5 слитков
```

**Что нужно построить:**
- Chemical Dissolution Chamber
- Chemical Washer
- Chemical Crystallizer
- Chemical Injection Chamber
- Purification Chamber
- Crusher
- Enrichment Chamber
- Печь
- Electrolytic Separator (кислород + водород из воды)
- Chemical Infuser (HCl из водорода и хлора)
- Rotary Condensentrator (серная кислота)

**Откуда химикаты:**
- Кислород: Electrolytic Separator + вода
- Водород: Electrolytic Separator + вода (побочный продукт)
- Хлор: Electrolytic Separator + солевой раствор (соль + вода)
- HCl: Chemical Infuser (водород + хлор)
- Серная кислота: Rotary Condensentrator из газообразной серной кислоты

---

## Рекомендуемый порядок

| Этап игры | Уровень | Приоритет |
|-----------|---------|-----------|
| Ранний    | x2      | Enrichment Chamber — первая машина |
| Средний   | x3      | Добавить Purification Chamber + Crusher |
| Поздний   | x5      | Полная цепочка из 8 машин + химия |
