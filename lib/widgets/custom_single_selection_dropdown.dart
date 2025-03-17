import 'package:flutter/material.dart';

class SingleSelectionDropDown extends StatefulWidget {
  const SingleSelectionDropDown({
    required this.items,
    required this.onSelection,
    this.hitText,
    this.scrollController,
    this.maxHeight = 200,
    this.readOnly = false,
    this.emptyStateText = 'No items available',
    this.errorText,
    this.showError = false,
    this.isEnabled = true,
    this.onTap,
    this.initiallySelectedKey, // NEW PARAMETER
    super.key,
  });

  final double? maxHeight;
  final void Function(CustomDataItems selectedKey) onSelection;
  final List<CustomDataItems> items;
  final String? hitText;
  final bool readOnly;
  final ScrollController? scrollController;
  final String emptyStateText;
  final String? errorText;
  final bool showError;
  final bool isEnabled;
  final Function? onTap;
  final String? initiallySelectedKey; // NEW PARAMETER

  @override
  State<SingleSelectionDropDown> createState() =>
      _SingleSelectionDropDownState();
}

class _SingleSelectionDropDownState extends State<SingleSelectionDropDown> {
  final link = LayerLink();
  final _focusNode = FocusNode();
  final _searchFocusNode = FocusNode(canRequestFocus: true);
  final _key = LabeledGlobalKey("button_icon");
  OverlayEntry? _overlayEntry;
  bool isMenuOpen = false;
  String? selectedKey;
  late Size buttonSize;
  late Offset buttonPosition;
  final TextEditingController _searchController = TextEditingController();
  List<CustomDataItems> _filteredItems = [];
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);

    // Set initially selected value
    selectedKey = widget.initiallySelectedKey;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void didUpdateWidget(covariant SingleSelectionDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!areEqualItems(oldWidget.items, widget.items)) {
      setState(() {
        _filteredItems = widget.items;
        selectedKey = widget.initiallySelectedKey; // Update on widget update
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _overlayEntry?.dispose();
    _searchFocusNode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool areEqualItems(
      List<CustomDataItems> oldItems, List<CustomDataItems> newItems) {
    if (oldItems.length != newItems.length) return false;
    for (int i = 0; i < oldItems.length; i++) {
      if (oldItems[i].id != newItems[i].id) {
        return false;
      }
    }
    return true;
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

  void _handleTap(context) {
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
            onTap: widget.readOnly
                ? null
                : () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
              _handleTap(context);
            },
            child: Container(
              key: _key,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: widget.isEnabled
                    ? Color(0xFF0B111A)
                    : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (widget.showError && _hasInteracted)
                      ? Colors.red
                      : Color(0xFFA3AED0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: selectedKey == null ? widget.hitText ?? '' : '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA3AED0),
                      ),
                      children: selectedKey != null
                          ? [
                        TextSpan(
                          text: widget.items
                              .firstWhere(
                                  (e) => e.id == selectedKey,
                              orElse: () => CustomDataItems(id: '', name: ''))
                              .name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      ]
                          : [],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 30, color: Color(0xFFA3AED0)),
                ],
              ),
            ),
          ),
        ),
        if (widget.showError && _hasInteracted && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
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
              // left: buttonPosition.dx-40,
              // top: buttonPosition.dy + buttonSize.height,
              width: MediaQuery.sizeOf(context).width*0.4,
              child: CompositedTransformFollower(
                link: link,
                followerAnchor: Alignment.topRight,
                targetAnchor: Alignment.bottomRight,
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: widget.maxHeight ?? 200,
                    ),
                    child: ListView.builder(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedKey = item.id;
                            });
                            widget.onSelection(item);
                            closeMenu();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


class CustomDataItems {
  String? id;
  String name;
  String? icon;
  String? image;

  CustomDataItems({required this.name, this.icon, this.id, this.image});
}
