import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/models/permission_model.dart';

import '../../helper/dependency.dart';
import 'custom_multi_selection_dropdown.dart';

class ClientStoreFilterWidget extends StatefulWidget {
  final DashboardState state;
  final Function(List<int>, List<int>) onChanged;
  final bool? isDisabled;

  const ClientStoreFilterWidget(
      {super.key,
      required this.onChanged,
      required this.state,
      this.isDisabled = false});

  @override
  _ClientStoreFilterWidgetState createState() =>
      _ClientStoreFilterWidgetState();
}

class _ClientStoreFilterWidgetState extends State<ClientStoreFilterWidget> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();

  void _showOverlay(BuildContext context) {
    final RenderBox buttonRenderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonSize = buttonRenderBox.size;
    final buttonOffset = buttonRenderBox.localToGlobal(Offset.zero);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double spaceBelow =
        screenHeight - buttonOffset.dy - buttonSize.height;
    final double spaceAbove = buttonOffset.dy;

    final bool showBelow = spaceBelow > spaceAbove;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent GestureDetector to capture taps outside the overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideOverlay,
              behavior: HitTestBehavior.opaque,
              // Ensures taps anywhere are detected
              child: Container(),
            ),
          ),
          Positioned(
            top: showBelow
                ? buttonOffset.dy + buttonSize.height
                : buttonOffset.dy - screenHeight * 0.4,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: screenHeight * 0.37,
                child: StoreSelectionWidget(
                  onSubmit: handleSubmit,
                  clientList: (widget.state.permissions?.clientsList ?? []),
                  storeList: widget.state.permissions?.storesList ?? {},
                  onClose: _hideOverlay,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void handleSubmit(List<int> clientIds, List<int> storeIds) {
    print("${clientIds.length}--- ${storeIds.length}");

    widget.onChanged(clientIds, storeIds);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _buttonKey,
      onTap: widget.isDisabled == true
          ? () {
              CustomToast.show(
                  context: context,
                  message: "Hold on a moment, it's still loading.",
                  status: ToastStatus.warning);
            }
          : () {
              if (_overlayEntry == null) {
                _showOverlay(context);
              } else {
                _hideOverlay();
              }
            },
      child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: Responsive.screenW(context, 1)),
          padding: EdgeInsets.symmetric(
              vertical: Responsive.screenH(context, 1),
              horizontal: Responsive.screenW(context, 3)),
          decoration: BoxDecoration(
            color: Color(0xFF141E2D),
            borderRadius: BorderRadius.circular(Responsive.screenW(context, 4)),
            border: Border.all(color: Color(0xFFA3AED0).withValues(alpha: 0.4)),
          ),
          child: Icon(
            Icons.filter_alt_outlined,
            size: 30,
            color: AppColors.subText,
          )),
    );
  }
}

class StoreSelectionWidget extends StatefulWidget {
  final Function(List<int>, List<int>) onSubmit;
  final List<ClientsList> clientList;
  final Map<String, List<StoreData>> storeList;
  final VoidCallback onClose;

  const StoreSelectionWidget(
      {super.key,
      required this.onSubmit,
      required this.clientList,
      required this.storeList,
      required this.onClose});

  @override
  State<StoreSelectionWidget> createState() => _StoreSelectionWidgetState();
}

class _StoreSelectionWidgetState extends State<StoreSelectionWidget> {
  List<int> selectedClientID = [];

  List<int> selectedStoreID = [];

  List<StoreData> storesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final prevSelected =
        getCtx()?.read<DashBoardCubit>().state.prevSelected ?? [];

    // Check if prevSelected is not empty and update the store list
    if (prevSelected.isNotEmpty) {
      setState(() {
        updateStoreList(prevSelected, context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.darkBg2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.subText)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: widget.onClose,
                  icon: Icon(
                    Icons.cancel,
                    color: AppColors.subText,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<DashBoardCubit, DashboardState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      MultiSelectionDropDown(
                        selectAll: state.selectAll,
                        prevSelected: state.prevSelected ?? [],
                        items:getSortedClientItems(widget.clientList),
                        onSelection: (selectedItems, isFirst) {
                          selectedClientID.clear();
                          for (var e in selectedItems) {
                            selectedClientID.add(e.id);
                          }

                          setState(() {
                            updateStoreList(selectedClientID, context);
                            if ((getCtx()!
                                        .read<DashBoardCubit>()
                                        .state
                                        .prevSelected ??
                                    [])
                                .isNotEmpty) {
                              getCtx()!
                                  .read<DashBoardCubit>()
                                  .updateBoolean(false);
                            }
                          });
                          if (!isFirst) {
                            getCtx()!
                                .read<DashBoardCubit>()
                                .updateStoreItems(<int>[]);
                          }
                        },
                        hitText: 'Select Clients',
                        emptyStateText: 'No clients available',
                        errorText: 'Please select at least one client',
                        showError: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MultiSelectionDropDown(
                        selectAll: state.selectAllStore,
                        prevSelected: state.prevSelectedStore ?? [],
                        key: ValueKey(storesList.length),
                        items: getSortedStoreItems(),
                        onSelection: (selectedItems, isFirst) {
                          selectedStoreID.clear();
                          for (var i in selectedItems) {
                            selectedStoreID.add(i.id);
                          }
                          if ((getCtx()!
                                      .read<DashBoardCubit>()
                                      .state
                                      .prevSelectedStore ??
                                  [])
                              .isNotEmpty) {
                            getCtx()!
                                .read<DashBoardCubit>()
                                .updateStoreAll(false);
                          }
                        },
                        hitText: 'Select Stores',
                        emptyStateText: 'No clients available',
                        errorText: 'Please select at least one client',
                        showError: selectedClientID.isEmpty,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.pink)),
                onPressed: () {
                  if (selectedClientID.isNotEmpty &&
                      selectedStoreID.isNotEmpty) {
                    getCtx()!.read<DashBoardCubit>().updateBoolean(false);
                    getCtx()!.read<DashBoardCubit>().updateStoreAll(false);
                    getCtx()!
                        .read<DashBoardCubit>()
                        .updateStoreItems(selectedStoreID);

                    getCtx()!
                        .read<DashBoardCubit>()
                        .updateItems(selectedClientID);
                    widget.onSubmit(selectedClientID, selectedStoreID);
                    widget.onClose();
                  } else {
                    CustomToast.show(
                        context: context,
                        message: "Please select both fields",
                        status: ToastStatus.warning);
                  }
                },
                child: Text(
                  "Apply",
                  style: getTextTheme().bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontHelper.semiBold,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<CustomDropDownMenuItem> getSortedStoreItems() {
    final allItems = storesList
        .map((i) => CustomDropDownMenuItem(id: i.storeId!, name: i.storeName!))
        .toList();

    // Separate "Select All" item (assumed to have id == -1)
    final selectAllItem =
    allItems.firstWhere((item) => item.id == -1, orElse: () => CustomDropDownMenuItem(id: -999, name: ''));

    final filteredItems = allItems.where((item) => item.id != -1).toList();

    // Sort all except "Select All"
    filteredItems.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // Add "Select All" at the beginning if it exists
    if (selectAllItem.id != -999) {
      filteredItems.insert(0, selectAllItem);
    }

    return filteredItems;
  }
  List<CustomDropDownMenuItem> getSortedClientItems(List<ClientsList> clientList) {
    final items = clientList
        .map((e) => CustomDropDownMenuItem(id: e.clientId!, name: e.clientName!))
        .toList();

    // Separate "Select All" if it exists (id == -1)
    final selectAllItem =
    items.firstWhere((item) => item.id == -1, orElse: () => CustomDropDownMenuItem(id: -999, name: ''));

    final filteredItems = items.where((item) => item.id != -1).toList();

    // Sort alphabetically by name
    filteredItems.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // Add "Select All" back to the top
    if (selectAllItem.id != -999) {
      filteredItems.insert(0, selectAllItem);
    }

    return filteredItems;
  }
  updateStoreList(List<int> selectedClientID, BuildContext context) {
    storesList.clear();
    if (selectedClientID.any((item) => item == -1) && storesList.isEmpty) {
      storesList.add(StoreData(storeId: -1, storeName: "Select All"));
      widget.storeList.forEach((clientId, stores) {
        storesList.addAll(stores);
      });
    } else {
      if (!storesList
              .contains(StoreData(storeId: -1, storeName: "Select All")) &&
          selectedClientID.isNotEmpty) {
        storesList.add(StoreData(storeId: -1, storeName: "Select All"));
      }
      var stores = context.read<DashBoardCubit>().state.permissions?.storesList;
      for (var item in selectedClientID) {
        final clientIdString = item.toString();
        if (widget.storeList.containsKey(clientIdString)) {
          storesList.addAll(stores?[clientIdString] ?? []);
        }
      }
    }
  }
}
