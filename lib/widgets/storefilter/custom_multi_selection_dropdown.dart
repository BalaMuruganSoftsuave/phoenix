import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/utils.dart';



class MultiSelectionDropDown extends StatefulWidget {
   MultiSelectionDropDown({
    required this.items,
    required this.onSelection,
    this.hitText,
    this.scrollController,
    this.maxHeight = 300,
    this.readOnly = false,
    this.emptyStateText = 'No items available',
    this.errorText,
    this.showError = false,
    this.isEnabled = true,
     this.prevSelected,
    super.key, this.selectAll= true,
  });

  final double? maxHeight;
  final void Function(List<CustomDropDownMenuItem> selectedItems) onSelection;
  final List<CustomDropDownMenuItem> items;
  final String? hitText;
  final bool readOnly;
  final ScrollController? scrollController;
  final String emptyStateText;
  final String? errorText;
  final bool showError;
  final bool isEnabled;
   final bool? selectAll;
   final List<int>? prevSelected;

  @override
  State<MultiSelectionDropDown> createState() => _MultiSelectionDropDownState();
}

class _MultiSelectionDropDownState extends State<MultiSelectionDropDown> {
  final link = LayerLink();
  final _focusNode = FocusNode();
  final _searchFocusNode = FocusNode(canRequestFocus: true);
  final _key = LabeledGlobalKey("button_icon");
  OverlayEntry? _overlayEntry;
  bool isMenuOpen = false;
  Set<int> selectedKeys = {};
  List<int> selectionOrder = [];
  late Size buttonSize;
  late Offset buttonPosition;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredItems = [];
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
    if (widget.selectAll == true && widget.items.isNotEmpty) {
      setState(() {

        selectedKeys = widget.items.map((e) => e.id).toSet();
        selectionOrder = widget.items.map((e) => e.id).toList();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelection(widget.items);
      });
    } else {
      setState(() {
        selectedKeys = widget.prevSelected?.map((e) => e).toSet()??{};
        selectionOrder = widget.prevSelected?.map((e) => e).toList()??[];
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelection(widget.items
            .where((e) => selectedKeys.contains(e.id))
            .toList());
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  void findButton() {
    RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _searchController.clear();
    _filteredItems = List.from(widget.items);
    if (isMenuOpen) {
      _overlayEntry?.remove();
      isMenuOpen = false;
    }
    setState(() {
      _hasInteracted = false;
    });
  }

  void openMenu(BuildContext context) {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void didUpdateWidget(covariant MultiSelectionDropDown oldWidget) {
    if (oldWidget.items != widget.items) {
      setState(() {
        _filteredItems = widget.items;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleTap() {
    if (!widget.isEnabled) {
      setState(() {
        _hasInteracted = true;
      });
      return;
    }

    if (isMenuOpen) {
      closeMenu();
    } else {
      _focusNode.requestFocus();
      openMenu(context);
    }
  }

  void _handleItemSelection(CustomDropDownMenuItem item) {
    setState(() {
      if (item.id == -1) {
        // Handle "Select All" selection
        if (selectedKeys.contains(item.id)) {
          // Deselect all items
          selectedKeys.clear();
          selectionOrder.clear();
        } else {
          // Select all items
          selectedKeys = widget.items.map((e) => e.id).toSet();
          selectionOrder = widget.items.map((e) => e.id).toList();
        }
      } else {
        // Handle regular item selection
        if (selectedKeys.contains(item.id)) {
          selectedKeys.remove(item.id);
          selectionOrder.remove(item.id);
        } else {
          selectedKeys.add(item.id);
          selectionOrder.add(item.id);
        }

        final allSelected = widget.items
            .where((e) => e.id != -1)
            .every((e) => selectedKeys.contains(e.id));
        if (allSelected) {
          selectedKeys.add(-1); // Select "Select All"
          selectionOrder.add(-1);
        } else {
          selectedKeys.remove(-1); // Deselect "Select All"
          selectionOrder.remove(-1);
        }
      }
    });


    widget.onSelection(widget.items
        .where((e) => selectedKeys.contains(e.id))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: link,
          child: InkWell(
            splashColor: Colors.transparent,
            focusNode: _focusNode,
            onTap: widget.readOnly ? null : _handleTap,
            child: Container(
              key: _key,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: widget.isEnabled
                    ? Colors.white
                    : Colors.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: (widget.showError && _hasInteracted)
                        ?Colors.red
                        : Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: selectedKeys.isEmpty ? widget.hitText ?? '' : '',
                      style: getTextTheme().bodySmall?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      children: selectedKeys.isNotEmpty && widget.items.isNotEmpty
                          ? [
                        if (selectedKeys.contains(-1) && widget.items.length > 1)
                          TextSpan(
                            text: widget.items[1].name,
                            style: getTextTheme().bodySmall?.copyWith(fontSize: 14),
                          ),
                        if (!selectedKeys.contains(-1) && selectionOrder.isNotEmpty)
                          TextSpan(
                            text: widget.items
                                .firstWhere((e) => e.id == selectionOrder.first)
                                .name,
                            style: getTextTheme().bodySmall?.copyWith(fontSize: 14),
                          ),
                        if (selectedKeys.length > 1)
                          TextSpan(
                            text: !selectedKeys.contains(-1)
                                ? ' +${selectedKeys.length - 1}'
                                : ' +${selectedKeys.length - 2}',
                            style: getTextTheme().bodySmall?.copyWith(fontSize: 14),
                          ),
                      ]
                          : [],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 30, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        if (widget.showError && _hasInteracted && widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8, left: 16),
            child: Text(
              widget.errorText!,
              style: getTextTheme().bodySmall?.copyWith(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final availableHeight = screenHeight - keyboardHeight;

        final spaceBelow = availableHeight - buttonPosition.dy - buttonSize.height;
        final requiredSpace = math.min(widget.maxHeight ?? 300, availableHeight * 0.4);

        final showAbove = spaceBelow < requiredSpace && buttonPosition.dy > requiredSpace;

        final topPosition = showAbove
            ? buttonPosition.dy - requiredSpace
            : buttonPosition.dy + buttonSize.height;

        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: closeMenu,
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Positioned(
                  left: buttonPosition.dx,
                  top: topPosition,
                  width: buttonSize.width,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: requiredSpace,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              cursorColor: Colors.pink,
                              style:  getTextTheme().bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Search...",
                                hintStyle: getTextTheme().bodyMedium,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Icon(Icons.search),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color:AppColors.pink),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color:AppColors.grey2),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color:AppColors.grey2),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _filteredItems = widget.items.where((item) {
                                    return item.name
                                        .toLowerCase()
                                        .contains(value.toLowerCase());
                                  }).toList();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: _filteredItems.isEmpty
                                ? Center(
                              child: Text(
                                _searchController.text.isEmpty
                                    ? widget.emptyStateText
                                    : 'No matching items found',
                                style: getTextTheme().bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                                : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                return ListTile(
                                  key: ValueKey(item.id), // Unique key for each item
                                  leading: Checkbox(
                                    value: selectedKeys.contains(item.id),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _handleItemSelection(item);
                                      });
                                    },
                                    activeColor: AppColors.pink,
                                  ),
                                  title: Text(
                                    item.name,
                                    style: getTextTheme().bodySmall?.copyWith(fontSize: 14),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _handleItemSelection(item);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
class CustomDropDownMenuItem {
  int id;
  String name;

  CustomDropDownMenuItem({
    required this.id,
    required this.name,
  });
}