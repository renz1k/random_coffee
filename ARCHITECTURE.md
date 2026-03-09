# Random Coffee - Production Architecture

Это приложение с локальным кэшем (Hive) и синхронизацией с сервером. Корзина и меню хранятся локально и синхронизируются с сервером.

---

## Основные компоненты

### 1. **Local Storage (Hive)**

```
Hive Database
├── cart (CartModel)
│   └── cart_data: { items: [...], total: 0 }
├── categories (List<CategoryModel>)
│   └── categories_list: [...]
└── products (List<ProductModel>)
    └── products_list: [...]
```

### 2. **Network Layer (Dio)**

- **Timeout**: 15 сек (подключение, отправка, получение)
- **Retry**: 2 попытки при ошибке

### 3. **State Management (BLoC/Cubit)**

#### CartCubit
```dart
initializeCart()  → Загружает кэш, потом синхронизирует
loadCart()       → Полная загрузка с сервера
addProduct()     → Сохраняет локально, отправляет на сервер
updateQuantity() → Сохраняет локально, отправляет на сервер
removeProduct()  → Сохраняет локально, отправляет на сервер
clearCart()      → Сохраняет локально, отправляет на сервер
```

#### MenuBloc
```dart
_onLoadRequested() → Загружает локальное → показывает → синхрон. с сервером
```

---

## Поток синхронизации

### **При запуске приложения:**

```
main()
  ↓
Hive.initFlutter()      (инициализация БД)
  ↓
init() (DI)
  ↓
CartCubit.initializeCart()
  ├→ loadCartLocal()           (мгновенно)
  └→ _syncCartWithServer()     (в фоне, если есть интернет)
  ↓
MenuBloc._onLoadRequested()
  ├→ getCategoriesLocal()      (мгновенно)
  ├→ getProductsLocal()        (мгновенно)
  └→ getCategories() + getProducts() (в фоне)
```

### **Когда пользователь добавляет товар:**

```
addProduct(productId, quantity)
  ↓
CartRepository.addProduct()
  ├─ CartRemoteDataSource.addToCart()  (на сервер)
  │  ├─ Успех → CartLocalDataSource.saveCart()
  │  └─ Ошибка → Восстанавливает предыдущее состояние
  └─ emit(CartLoaded(newCart))
```

---

## Консистентность

### **1. Данные не потеряются**
- Даже если сервер не доступен - данные показываются
- При ошибке API - прежнее состояние восстанавливается

### **2. Автоматическая синхронизация**
- При успехе API - локальное обновляется
- При ошибке API - показывается сообщение пользователю
- Retry логика - 2 попытки при ошибке сети

### **3. Конфликты разрешаются в пользу сервера**
- Если в локальном есть 3 товара, а на сервере 5
- При синхронизации будет показано 5 (истина сервера)

---

## Мониторинг синхронизации

Все операции логируются через `SyncLogger`:

### **Уровни логирования:**

- Success
- Loading
- Error
- Initial
- Network error

---

## Обработка ошибок

### **Network Errors**
```
Timeout (15s) → Retry (2 attempts) → User message
Connection error → Load from cache → User message
Bad response (400, 404, 500) → Custom message → Load from cache
```