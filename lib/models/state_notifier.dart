import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/models/classes.dart';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class ChatStateNotifier extends StateNotifier<List<Messages>> {
  ChatStateNotifier() : super([]);

  void addMessages(Messages messages) {
    state = [...state, messages];
  }
}
final chatProvider = StateNotifierProvider<ChatStateNotifier, List<Messages>>((ref) {
  return ChatStateNotifier();
});
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class ListViewItemGPT extends StateNotifier<List<Widget>> {
  ListViewItemGPT() : super([]);

  void addItem(Widget widget) {
    state = [...state, widget];
  }

  void removeLastOne() {
    state.removeLast();
  }
}
final listViewProviderGPT = StateNotifierProvider<ListViewItemGPT, List<Widget>>((ref) {
  return ListViewItemGPT();
});
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class ListViewItemNews extends StateNotifier<List<Widget>> {
  ListViewItemNews() : super([]);

  void addItem(Widget widget) {
    state = [...state, widget];
  }

  void removeAll() {
    state.clear();
  }
}
final listViewProviderNews = StateNotifierProvider<ListViewItemNews, List<Widget>>((ref) {
  return ListViewItemNews();
});
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class ListItemsYoutube extends StateNotifier<List<Widget>> {
  ListItemsYoutube() : super([]);

  void addItem(Widget widget) {
    state = [...state, widget];
  }

  void removeWidget(Widget widget) {
    state.remove(widget);
  }

  void removeAtIndex(int index) {
    state.removeAt(index);
  }

  void removeAll() {
    state.clear();
  }
}
final listItemsProviderYoutube = StateNotifierProvider<ListItemsYoutube, List<Widget>>((ref) {
  return ListItemsYoutube();
});
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class ListItemsTiktok extends StateNotifier<List<Widget>> {
  ListItemsTiktok() : super([]);

  void addItem(Widget widget) {
    state = [...state, widget];
  }

  void removeWidget(Widget widget) {
    state.remove(widget);
  }

  void removeAtIndex(int index) {
    state.removeAt(index);
  }

  void removeAll() {
    state.clear();
  }
}
final listItemsProviderTiktok = StateNotifierProvider<ListItemsTiktok, List<Widget>>((ref) {
  return ListItemsTiktok();
});
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class ListItemsKpops extends StateNotifier<List<Widget>> {
  ListItemsKpops() : super([]);

  void addItem(Widget widget) {
    state = [...state, widget];
  }

  void removeWidget(Widget widget) {
    state.remove(widget);
  }

  void removeAtIndex(int index) {
    state.removeAt(index);
  }

  void removeAll() {
    state.clear();
  }
}
final listItemsProviderKpops = StateNotifierProvider<ListItemsKpops, List<Widget>>((ref) {
  return ListItemsKpops();
});
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////