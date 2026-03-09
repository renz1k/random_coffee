# Random Coffee - Flutter приложение

Flutter приложение для заказа кофе.

---

##  Описание проделанной работы

### Что реализовано:

**Каталог меню** — загрузка категорий и товаров с сервера, навигация по категориям, детальная информация о товаре  
**Корзина** — добавление/удаление товаров, изменение количества, подсчет суммы, синхронизация с сервером  
**Заказы** — создание заказа, обработка ответа сервера, уведомления пользователю  
**Локальный кэш (Hive)** — мгновенная загрузка данных, работа без интернета, фоновая синхронизация  
**Темная/светлая тема** — переключение с сохранением выбора через SharedPreferences  
**Обработка ошибок** — retry-логика, таймауты (15с), fallback на локальные данные  

### Технологический стек:

- **State Management:** `flutter_bloc` (BLoC/Cubit)
- **Dependency Injection:** `get_it`
- **Network:** `dio` + `retrofit` (кодогенерация API)
- **Local Storage:** `hive_ce` + `hive_ce_flutter`
- **Архитектура:** Clean Architecture (data/domain/presentation)
- **Code Generation:** `json_serializable`, `build_runner`

---

## Возможности

### Основной функционал

- **Корзина покупок**
  - Добавление/удаление товаров
  - Изменение количества
  - Подсчет суммы в реальном времени
  - Очистка корзины с подтверждением

- **Каталог товаров**
  - Просмотр по категориям
  - Поиск товаров
  - Детальная информация с изображениями
  - Плавная прокрутка интерфейса

- **Управление заказами**
  - Создание заказов
  - Подтверждение успешных операций

### Архитектура

- **Локальное хранилище (Hive)**
  - Мгновенная загрузка данных из кэша
  - Автоматическое сохранение
  - Обновление UI без задержки сети

- **Автоматическая синхронизация**
  - Фоновая синхронизация с сервером
  - Разрешение конфликтов (сервер - источник истины)
  - Повторные попытки с экспоненциальной задержкой

- **Работа без интернета**
  - Работает без подключения к интернету
  - Синхронизация при восстановлении соединения

### Производственное качество

- **Обработка ошибок**
  - Таймаут сети (15с) с повторными попытками
  - Сообщения об ошибках
  - Система логирования

- **Управление состоянием**
  - BLoC для меню
  - Cubit для корзины и заказов
  - Чистая архитектура со слоями

- **UI/UX**
  - Material Design 3
  - Интерфейс корзины в bottom sheet
  - Состояния загрузки и экран ошибки

---

## Ключевые компоненты

### **Система корзины**

| Компонент | Назначение |
|-----------|------------|
| `CartCubit` | Управление состоянием корзины |
| `CartLocalDataSource` | Операции Hive хранилища |
| `CartRemoteDataSource` | Взаимодействие с API |
| `CartRepository` | Бизнес-логика + синхронизация |

**Возможности:**
- Сохранение в локальное хранилище
- Синхронизация с сервером в фоне
- Восстановление состояния при ошибке
- Валидация количества (1-10 товаров)

### **Система меню**

| Компонент | Назначение |
|-----------|------------|
| `MenuBloc` | Управление состоянием меню |
| `MenuLocalDataSource` | Hive хранилище для товаров/категорий |
| `MenuRemoteDataSource` | Взаимодействие с API |
| `MenuRepository` | Кэширование + логика синхронизации |

**Возможности:**
- Загрузка из кэша (мгновенно)
- Синхронизация с сервером (в фоне)
- Fallback при отсутствии интернета

### **Уведомления**

- `OrderSnackBar` - Оверлейные уведомления поверх bottom sheet
- Сообщения об ошибках
- Подтверждение успешного заказа

---

## База данных Hive

## API Integration

### **Интеграция с API

### **Конфигурация эндпоинтов**

- **Base URL**: https://coffee-backend.caravanlabs.ru
- **Таймаут**: 15 секунд (все операции)
- **Повторные попытки**: 2 попытки при ошибке

### **API эндпоинты**

```
GET    /categories         → Список всех категорий
GET    /products           → Список всех товаров
GET    /cart               → Получить текущую корзину
POST   /cart/items         → Добавить товар в корзину
PATCH  /cart/items/{id}    → Обновить количество товара
DELETE /cart/items/{id}    → Удалить товар
DELETE /cart               → Очистить корзину
POST   /orders             → Создать заказ
```

## Зависимости

### **Основные**

- `flutter_bloc` - Управление состоянием
- `dio` - HTTP клиент
- `hive_ce` - Локальная база данных
- `dartz` - Функциональное программирование (Either)
- `get_it` - Service locator

### **UI**

- `flutter_bloc` - BLoC интеграция
- `scrollable_positioned_list` - Умная прокрутка

### **Генерация кода**

- `json_serializable` - JSON сериализация
- `retrofit` - Генерация API кода
- `hive_ce_generator` - Hive адаптеры
- `build_runner` - Build runner

---

## Скриншоты

<p align="center">
  <img src="screenshots/screenshot (2).png" width="250" alt="Screenshot 2"/>
  <img src="screenshots/screenshot (3).png" width="250" alt="Screenshot 3"/>
</p>

<p align="center">
  <img src="screenshots/screenshot (4).png" width="250" alt="Screenshot 4"/>
  <img src="screenshots/screenshot (5).png" width="250" alt="Screenshot 5"/>
  <img src="screenshots/screenshot (6).png" width="250" alt="Screenshot 6"/>
</p>

<p align="center">
  <img src="screenshots/screenshot (7).png" width="250" alt="Screenshot 7"/>
  <img src="screenshots/screenshot (8).png" width="250" alt="Screenshot 8"/>
  <img src="screenshots/screenshot (9).png" width="250" alt="Screenshot 9"/>
</p>

<p align="center">
  <img src="screenshots/screenshot (10).png" width="250" alt="Screenshot 10"/>
  <img src="screenshots/screenshot (11).png" width="250" alt="Screenshot 11"/>
  <img src="screenshots/screenshot (12).png" width="250" alt="Screenshot 12"/>
</p>

<p align="center">
  <img src="screenshots/screenshot (13).png" width="250" alt="Screenshot 13"/>
  <img src="screenshots/screenshot (14).png" width="250" alt="Screenshot 14"/>
  <img src="screenshots/screenshot (15).png" width="250" alt="Screenshot 15"/>
</p>

<p align="center">
  <img src="screenshots/screenshot (16).png" width="250" alt="Screenshot 16"/>
  <img src="screenshots/screenshot (1).png" width="250" alt="Screenshot 1"/>
  <img src="screenshots/screenshot (17).png" width="250" alt="Screenshot 17"/>
</p>

---