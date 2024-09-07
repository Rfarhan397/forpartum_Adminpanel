import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constant.dart';
import '../../../provider/dropDOwn/dropdown.dart';
import '../../res/widgets/app_text.dart.dart';

class CustomDropdownWidget extends StatefulWidget {
  final int index;
  final List<String> items;
  final double dropdownHeight;
  final String dropdownType;

  CustomDropdownWidget({
    required this.index,
    required this.items,
    required this.dropdownType,
    this.dropdownHeight = 4.0,
  });

  @override
  _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  OverlayEntry? _overlayEntry;

  void _showDropdown(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;  // Ensure the overlay is nullified after being removed
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5, // Add extra space from the top
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor,
                  width: 1.0,
                ),
                color: Colors.white,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.items.map((item) {
                  return GestureDetector(
                    onTap: () {
                      _updateSelectedValue(context, item);
                      _hideDropdown();  // Close the dropdown after selection
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
                      child: AppTextWidget(
                        text: item,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,

                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateSelectedValue(BuildContext context, String item) {
    final dropdownProvider = Provider.of<DropdownProviderN>(context, listen: false);

    switch (widget.dropdownType) {
      case 'Category':
        dropdownProvider.setSelectedCategory(item);
        break;
      case 'Language':
        dropdownProvider.setSelectedLanguage(item);
        break;
      case 'TimeZone':
        dropdownProvider.setSelectedTimeZone(item);
        break;
      case 'Type':
        dropdownProvider.setSelectedType(item);
        break;
      case 'DietaryCategory':
        dropdownProvider.setSelectedDietaryCategory(item);
        break;
      case 'Status':
        dropdownProvider.setSelectedStatus(item);
        break;
      case 'MealPlanDuration':
        dropdownProvider.setSelectedMealPlanDuration(item);
        break;
      default:
        break;
    }

    dropdownProvider.toggleDropdownVisibility(widget.index); // Close the dropdown after selection
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Consumer<DropdownProviderN>(
        builder: (context, dropdownProvider, child) {
          String selectedItem = _getSelectedItem(dropdownProvider);
          bool isDropdownVisible = dropdownProvider.isDropdownVisible(widget.index);

          return GestureDetector(
            onTap: () {
              dropdownProvider.closeOtherDropdowns(widget.index);
              if (isDropdownVisible) {
                _hideDropdown();
              } else {
                _showDropdown(context);
              }
              dropdownProvider.toggleDropdownVisibility(widget.index);  // Ensure visibility toggles correctly
            },
            child: Container(
              height: widget.dropdownHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor,
                  width: 1.0,
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppTextWidget(
                      text: selectedItem,
                      color: Theme.of(context).primaryColor,
                    ),
                    Icon(
                      isDropdownVisible
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getSelectedItem(DropdownProviderN dropdownProvider) {
    switch (widget.dropdownType) {
      case 'Category':
        return dropdownProvider.selectedCategory;
      case 'Language':
        return dropdownProvider.selectedLanguage;
      case 'TimeZone':
        return dropdownProvider.selectedTimeZone;
      case 'Type':
        return dropdownProvider.selectedType;
      case 'DietaryCategory':
        return dropdownProvider.selectedDietaryCategory;
      case 'Status':
        return dropdownProvider.selectedStatus;
      case 'MealPlanDuration':
        return dropdownProvider.selectedMealPlanDuration;
      default:
        return 'Select Option'; // Default placeholder text
    }
  }
}
