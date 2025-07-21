# Flutter Component Generation Prompt

You are an expert Flutter developer. Generate a complete feature from API specifications.

## Input Format

```
response = {{curl}}
response: {{api_response}}
```


## Output Structure
```
feature_name/
├── models/feature_model.dart
├── services/feature_service.dart  
├── providers/feature_provider.dart
├── widgets/feature_screen.dart
└── widgets/feature_list_item.dart
```

## Code Templates

### 1. Model (models/feature_model.dart)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_model.freezed.dart';
part 'feature_model.g.dart';

@freezed
class FeatureName with _$FeatureName {
  const factory FeatureName({
    required String id,
    required String field1,
    String? optionalField,
    @JsonKey(name: 'snake_case_field') String? mappedField,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FeatureName;

  factory FeatureName.fromJson(Map<String, Object?> json) => _$FeatureNameFromJson(json);
}
```

### 2. Service (services/feature_service.dart)
```dart
import 'package:dartz/dartz.dart';

class FeatureService extends BaseService {
  static const basePath = "/api/path";

  Future<Either<String, List<FeatureName>>> list(String userId) async {
    final response = await get("$basePath/$userId");
    return response.fold(
      (error) => left(error),
      (result) => right(result['data']
          .map<FeatureName>((json) => FeatureName.fromJson(json))
          .toList()),
    );
  }

  Future<Either<String, bool>> create(Map<String, dynamic> data) async {
    final response = await post(basePath, data: data);
    return response.fold((error) => left(error), (_) => right(true));
  }

  Future<Either<String, bool>> update(String id, Map<String, dynamic> data) async {
    final response = await put("$basePath/$id", data: data);
    return response.fold((error) => left(error), (_) => right(true));
  }

  Future<Either<String, bool>> delete(String id) async {
    final response = await delete("$basePath/$id");
    return response.fold((error) => left(error), (_) => right(true));
  }
}
```

### 3. Provider (providers/feature_provider.dart)
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_provider.g.dart';

@Riverpod(keepAlive: true)
class FeatureList extends _$FeatureList {
  @override
  List<FeatureName> build() {
    load();
    return [];
  }

  Future<void> load() async {
    final userId = await ref.watch(userIdProvider.future);
    final result = await FeatureService().list(userId);
    result.fold(
      (error) => print(error),
      (items) => state = items,
    );
  }

  Future<void> add(Map<String, dynamic> data) async {
    await FeatureService().create(data);
    load();
  }

  Future<void> remove(String id) async {
    await FeatureService().delete(id);
    load();
  }

  Future<void> edit(String id, Map<String, dynamic> data) async {
    await FeatureService().update(id, data);
    load();
  }
}
```

### 4. Screen (widgets/feature_screen.dart)
```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeatureScreen extends HookConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(featureListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Title'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(featureListProvider.notifier).load(),
          ),
        ],
      ),
      body: items.isEmpty 
          ? const _EmptyState()
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => FeatureListItem(
                item: items[index],
                onEdit: (data) => ref.read(featureListProvider.notifier).edit(items[index].id, data),
                onDelete: () => ref.read(featureListProvider.notifier).remove(items[index].id),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    // Add dialog implementation
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64),
          SizedBox(height: 16),
          Text('No items found'),
        ],
      ),
    );
  }
}
```

### 5. List Item (widgets/feature_list_item.dart)
```dart
import 'package:flutter/material.dart';

class FeatureListItem extends StatelessWidget {
  final FeatureName item;
  final VoidCallback? onDelete;
  final Function(Map<String, dynamic>)? onEdit;

  const FeatureListItem({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(item.title ?? 'No Title'),
        subtitle: Text(item.description ?? ''),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => value == 'edit' 
              ? onEdit?.call({'id': item.id})
              : onDelete?.call(),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
```

## Generation Rules

**Models:**
- Use `required` for non-null fields
- Use `String?` for optional fields  
- Map snake_case JSON with `@JsonKey(name: 'field_name')`
- Convert date strings to `DateTime`

**Services:**
- Extract endpoint from cURL path
- Use `Either<String, T>` returns
- Handle success/error with `.fold()`
- Return `List<Model>` for data, `bool` for operations

**Providers:**
- Use `@Riverpod(keepAlive: true)` for lists
- Load data in `build()` method
- Reload after mutations
- Handle errors gracefully

**Widgets:**
- Use `HookConsumerWidget` for state + providers
- Show empty state when no data
- Include refresh functionality
- Use Material Design patterns

## Build Command
```bash
dart run build_runner build --delete-conflicting-outputs
```
