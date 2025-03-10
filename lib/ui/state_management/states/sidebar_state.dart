class SidebarState {
  final int selectedIndex;
  final bool opened;
  SidebarState({required this.selectedIndex, this.opened = true});

  factory SidebarState.initial() => SidebarState(selectedIndex: 0);

  SidebarState copyWith({int? selectedIndex, bool? opened}) => SidebarState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        opened: opened ?? this.opened,
      );
}
