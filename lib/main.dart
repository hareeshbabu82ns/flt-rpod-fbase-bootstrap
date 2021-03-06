import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flt_bootstrap/controllers/auth_controller.dart';
import 'package:flt_bootstrap/controllers/item_list_controller.dart';
import 'package:flt_bootstrap/firebase_options.dart';
import 'package:flt_bootstrap/general_providers.dart';
import 'package:flt_bootstrap/models/item_model.dart';
import 'package:flt_bootstrap/repositories/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const providerConfigs = [
      GoogleProviderConfiguration(
        clientId:
            '127411722371-k4vcqsrq7ppn35sav99dafv7t1e7pvuv.apps.googleusercontent.com',
      ),
      AppleProviderConfiguration(),
      EmailProviderConfiguration(),
    ];

    return MaterialApp(
      title: 'FbasePod Demo',
      debugShowCheckedModeBanner: false,
      theme: ref.watch(themeDataProvider),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providerConfigs: providerConfigs,
            showAuthActionSwitch: false, // to disable reigistration
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providerConfigs: providerConfigs,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
        '/home': (context) {
          if (FirebaseAuth.instance.currentUser == null) {
            return SignInScreen(
              providerConfigs: providerConfigs,
              showAuthActionSwitch: false,
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
              ],
            );
          } else {
            return const HomeScreen();
          }
        },
      },
    );
  }
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);
    final itemListFilter = ref.watch(itemListFilterProvider);
    final isObtainedFilter = itemListFilter == ItemListFilter.obtained;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        leading: authControllerState != null
            ? IconButton(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
                icon: const Icon(Icons.logout))
            : null,
        actions: [
          IconButton(
            onPressed: () => ref
                .read(itemListControllerProvider.notifier)
                .retrieveItems(isRefreshing: true),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => ref.read(itemListFilterProvider.state).state =
                isObtainedFilter ? ItemListFilter.all : ItemListFilter.obtained,
            icon: Icon(
              isObtainedFilter
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            onPressed: () => ref
                .read(themeColorSeedProvider.notifier)
                .update((state) => const Color(0xFF9B640C)),
            icon: const Icon(Icons.color_lens_outlined),
          ),
          IconButton(
            onPressed: () =>
                ref.read(themeModeControllerProvider.notifier).toggle(),
            icon: HookConsumer(
              builder: (context, ref, child) {
                final mode = ref.watch(themeModeControllerProvider);
                return Icon(mode == Brightness.dark
                    ? Icons.wb_sunny_outlined
                    : Icons.dark_mode_outlined);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => AddItemDialog.show(context, Item.empty())),
        child: const Icon(Icons.add),
      ),
      body: const ListItemsPage(),
    );
  }
}

class ListItemsPage extends HookConsumerWidget {
  const ListItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<StateController<CustomException?>>(
        itemListExceptionProvider.notifier, (previous, next) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(next.state!.message!),
        ),
      );
    });
    return const ItemList();
  }
}

final currentItem = Provider<Item>((_) => throw UnimplementedError());

class ItemList extends HookConsumerWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemListState = ref.watch(itemListControllerProvider);
    final filteredItemList = ref.watch(filteredItemListProvider);

    return itemListState.when(
        data: (items) => items.isEmpty
            ? const Center(
                child: Text(
                  'Tap + to add an item',
                  style: TextStyle(fontSize: 20.0),
                ),
              )
            : ListView.builder(
                itemCount: filteredItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = filteredItemList[index];
                  return ProviderScope(
                      overrides: [currentItem.overrideWithValue(item)],
                      child: const ItemTile());
                },
              ),
        error: (e, _) => ItemListError(
            message:
                e is CustomException ? e.message! : 'something went wrong!'),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}

class ItemTile extends HookConsumerWidget {
  const ItemTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(currentItem);
    return ListTile(
      key: ValueKey(item.id),
      title: Text(item.name),
      trailing: Checkbox(
        value: item.obtained,
        onChanged: (val) => ref
            .read(itemListControllerProvider.notifier)
            .updateItem(updatedItem: item.copyWith(obtained: !item.obtained)),
      ),
      onTap: () => AddItemDialog.show(context, item),
      onLongPress: () => ref
          .read(itemListControllerProvider.notifier)
          .deleteItem(itemId: item.id!),
    );
  }
}

class ItemListError extends HookConsumerWidget {
  final String message;
  const ItemListError({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () => ref
                .read(itemListControllerProvider.notifier)
                .retrieveItems(isRefreshing: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class AddItemDialog extends HookConsumerWidget {
  static void show(BuildContext context, Item item) {
    showDialog(
        context: context, builder: (context) => AddItemDialog(item: item));
  }

  final Item item;

  const AddItemDialog({Key? key, required this.item}) : super(key: key);

  bool get isUpdating => item.id != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(text: item.name);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Item name'),
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  isUpdating
                      ? ref
                          .read(itemListControllerProvider.notifier)
                          .updateItem(
                              updatedItem: item.copyWith(
                            name: textController.text.trim(),
                            obtained: item.obtained,
                          ))
                      : ref
                          .read(itemListControllerProvider.notifier)
                          .addItem(name: textController.text.trim());

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text(isUpdating ? 'Update' : 'Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
